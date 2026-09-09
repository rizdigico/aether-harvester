local MailService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local AntiCheatService = require(game.ServerScriptService.AetherServer.GameServices.AntiCheatService)
local ItemsData = require(game.ReplicatedStorage.AetherShared.Data.Items)

MailService.Mailboxes = {}

local MAX_ATTACHMENTS = 10
local MAX_ATTACHMENT_AMOUNT = 9999
local MAX_SUBJECT_LENGTH = 80
local MAX_MESSAGE_LENGTH = 1000
local ALLOWED_CURRENCIES = {
    AetherShards = true,
    AetherGems = true,
    EventTokens = true,
    FamePoints = true,
}

local function isPositiveInteger(value)
    return type(value) == "number"
        and value == value
        and value >= 1
        and value <= MAX_ATTACHMENT_AMOUNT
        and value == math.floor(value)
end

local function rollbackEscrow(player, removedItems, removedCurrencies)
    for itemId, amount in pairs(removedItems) do
        PlayerDataService.AddItem(player, itemId, amount)
    end
    for currency, amount in pairs(removedCurrencies) do
        PlayerDataService.AddCurrency(player, currency, amount)
    end
end

-- Validate and escrow attachments before creating a mail record. The sender's
-- inventory/currency is the authority; client-provided grant data is never
-- trusted. The normalized result is safe to persist and claim later.
local function escrowAttachments(player, attachments)
    if type(attachments) ~= "table" then
        return nil, "Invalid attachments"
    end

    local normalized = {}
    local requiredItems = {}
    local requiredCurrencies = {}
    local count = 0

    for index, attachment in pairs(attachments) do
        if type(index) ~= "number" or index < 1 or index > MAX_ATTACHMENTS or index ~= math.floor(index) then
            return nil, "Invalid attachments"
        end
        if type(attachment) ~= "table" then
            return nil, "Invalid attachment"
        end

        count += 1
        if count > MAX_ATTACHMENTS then
            return nil, "Too many attachments"
        end

        if attachment.ItemId ~= nil then
            if
                type(attachment.ItemId) ~= "string"
                or attachment.ItemId == ""
                or not ItemsData.GetItem(attachment.ItemId)
                or not isPositiveInteger(attachment.Amount)
            then
                return nil, "Invalid item attachment"
            end
            requiredItems[attachment.ItemId] = (requiredItems[attachment.ItemId] or 0) + attachment.Amount
            if requiredItems[attachment.ItemId] > MAX_ATTACHMENT_AMOUNT then
                return nil, "Item attachment too large"
            end
            table.insert(normalized, { ItemId = attachment.ItemId, Amount = attachment.Amount })
        elseif attachment.Currency ~= nil then
            if type(attachment.Currency) ~= "table" then
                return nil, "Invalid currency attachment"
            end
            local currencyAttachment = {}
            local currencyCount = 0
            for currency, amount in pairs(attachment.Currency) do
                if type(currency) ~= "string" or not ALLOWED_CURRENCIES[currency] or not isPositiveInteger(amount) then
                    return nil, "Invalid currency attachment"
                end
                requiredCurrencies[currency] = (requiredCurrencies[currency] or 0) + amount
                if requiredCurrencies[currency] > MAX_ATTACHMENT_AMOUNT then
                    return nil, "Currency attachment too large"
                end
                currencyAttachment[currency] = amount
                currencyCount += 1
            end
            if currencyCount == 0 then
                return nil, "Empty currency attachment"
            end
            table.insert(normalized, { Currency = currencyAttachment })
        else
            return nil, "Invalid attachment"
        end
    end

    for itemId, amount in pairs(requiredItems) do
        if PlayerDataService.GetItemCount(player, itemId) < amount then
            return nil, "You don't own the attached item"
        end
    end

    local data = PlayerDataService.GetData(player)
    if not data or type(data.Currency) ~= "table" then
        return nil, "Player data not found"
    end
    for currency, amount in pairs(requiredCurrencies) do
        if type(data.Currency[currency]) ~= "number" or data.Currency[currency] < amount then
            return nil, "Insufficient currency for attachment"
        end
    end

    local removedItems = {}
    local removedCurrencies = {}
    for itemId, amount in pairs(requiredItems) do
        if not PlayerDataService.RemoveItem(player, itemId, amount) then
            rollbackEscrow(player, removedItems, removedCurrencies)
            return nil, "Could not escrow item attachment"
        end
        removedItems[itemId] = amount
    end
    for currency, amount in pairs(requiredCurrencies) do
        if not PlayerDataService.RemoveCurrency(player, currency, amount) then
            rollbackEscrow(player, removedItems, removedCurrencies)
            return nil, "Could not escrow currency attachment"
        end
        removedCurrencies[currency] = amount
    end

    return normalized
end

function MailService.Initialize()
    print("[MailService] Initializing...")

    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if not Remotes then
        return
    end

    -- SendMail: send mail to a target player by user id
    local SendMail = Remotes:FindFirstChild("SendMail")
    if SendMail then
        SendMail.OnServerEvent:Connect(function(player, targetUserId, subject, message, attachments)
            if
                type(targetUserId) ~= "number"
                or targetUserId ~= targetUserId
                or targetUserId < 1
                or targetUserId ~= math.floor(targetUserId)
                or type(subject) ~= "string"
                or subject == ""
            then
                return
            end
            if not RateLimiter.Check(player, "SendMail", 2) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            local target = game.Players:GetPlayerByUserId(targetUserId)
            if not target then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, "Recipient not found")
                end
                return
            end
            local success, sendMessage = MailService.SendMail(player, target, subject, message or "", attachments or {})
            if not success then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, sendMessage or "Mail failed")
                end
            end
        end)
    end

    -- GetMailbox: expose only the requesting player's own mailbox.
    local GetMailbox = Remotes:FindFirstChild("GetMailbox")
    if GetMailbox then
        GetMailbox.OnServerInvoke = function(player)
            if not RateLimiter.Check(player, "GetMailbox", 0.5) then
                return {}
            end
            return MailService.GetMailbox(player)
        end
    end

    -- ReadMail: mark mail as read and claim attachments
    local ReadMail = Remotes:FindFirstChild("ReadMail")
    if ReadMail then
        ReadMail.OnServerEvent:Connect(function(player, mailId)
            if type(mailId) ~= "string" then
                return
            end
            if not RateLimiter.Check(player, "ReadMail", 0.5) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            local success, message = MailService.ReadMail(player, mailId)
            if not success then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, message or "Mail could not be read")
                end
            end
        end)
    end

    -- DeleteMail: remove mail from the mailbox
    local DeleteMail = Remotes:FindFirstChild("DeleteMail")
    if DeleteMail then
        DeleteMail.OnServerEvent:Connect(function(player, mailId)
            if type(mailId) ~= "string" then
                return
            end
            if not RateLimiter.Check(player, "DeleteMail", 0.5) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            local success, message = MailService.DeleteMail(player, mailId)
            if not success then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, message or "Mail could not be deleted")
                end
            end
        end)
    end

    print("[MailService] Initialized")
end

function MailService.SendMail(fromPlayer, toPlayer, subject, message, attachments)
    if type(subject) ~= "string" or subject == "" or #subject > MAX_SUBJECT_LENGTH then
        return false, "Invalid subject"
    end
    if type(message) ~= "string" or #message > MAX_MESSAGE_LENGTH then
        return false, "Invalid message"
    end

    local toData = PlayerDataService.GetData(toPlayer)
    if not toData then
        return false, "Player not found"
    end

    if not toData.Mailbox then
        toData.Mailbox = {}
    end
    if #toData.Mailbox >= 100 then
        return false, "Recipient mailbox is full"
    end

    local normalizedAttachments, attachmentError = escrowAttachments(fromPlayer, attachments or {})
    if not normalizedAttachments then
        return false, attachmentError or "Invalid attachments"
    end

    local mail = {
        Id = "MAIL_" .. os.time() .. "_" .. math.random(1000, 9999),
        From = fromPlayer.Name,
        FromId = fromPlayer.UserId,
        Subject = subject,
        Message = message,
        Attachments = normalizedAttachments,
        SentAt = os.time(),
        Read = false,
    }

    table.insert(toData.Mailbox, mail)

    -- Notify recipient
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local MailReceived = Remotes:FindFirstChild("MailReceived")
        if MailReceived then
            MailReceived:FireClient(toPlayer, mail)
        end
    end

    print("[MailService] Mail sent from " .. fromPlayer.Name .. " to " .. toPlayer.Name)
    return true, "Mail sent"
end

function MailService.GetMailbox(player)
    local data = PlayerDataService.GetData(player)
    if not data then
        return {}
    end
    return data.Mailbox or {}
end

function MailService.ReadMail(player, mailId)
    local data = PlayerDataService.GetData(player)
    if not data or not data.Mailbox then
        return false
    end

    for _, mail in ipairs(data.Mailbox) do
        if mail.Id == mailId then
            -- Claim attachments
            if mail.Attachments then
                local claimedItems = {}
                local claimedCurrencies = {}
                for _, attachment in ipairs(mail.Attachments) do
                    if attachment.ItemId then
                        local amount = attachment.Amount
                        if type(attachment.ItemId) ~= "string" or not isPositiveInteger(amount) then
                            return false, "Invalid stored attachment"
                        end
                        if not PlayerDataService.AddItem(player, attachment.ItemId, amount) then
                            for itemId, itemAmount in pairs(claimedItems) do
                                PlayerDataService.RemoveItem(player, itemId, itemAmount)
                            end
                            for currency, currencyAmount in pairs(claimedCurrencies) do
                                PlayerDataService.RemoveCurrency(player, currency, currencyAmount)
                            end
                            return false, "Could not claim item attachment"
                        end
                        claimedItems[attachment.ItemId] = (claimedItems[attachment.ItemId] or 0) + amount
                    end
                    if attachment.Currency then
                        for currency, amount in pairs(attachment.Currency) do
                            if
                                not isPositiveInteger(amount)
                                or not PlayerDataService.AddCurrency(player, currency, amount)
                            then
                                for itemId, itemAmount in pairs(claimedItems) do
                                    PlayerDataService.RemoveItem(player, itemId, itemAmount)
                                end
                                for claimedCurrency, currencyAmount in pairs(claimedCurrencies) do
                                    PlayerDataService.RemoveCurrency(player, claimedCurrency, currencyAmount)
                                end
                                return false, "Could not claim currency attachment"
                            end
                            claimedCurrencies[currency] = (claimedCurrencies[currency] or 0) + amount
                        end
                    end
                end
                mail.Attachments = {}
            end
            mail.Read = true

            -- Notify client
            local Remotes = game.ReplicatedStorage.AetherShared.Remotes
            if Remotes then
                local MailUpdated = Remotes:FindFirstChild("MailUpdated")
                if MailUpdated then
                    MailUpdated:FireClient(player, mailId, mail)
                end
            end

            return true, "Mail read"
        end
    end

    return false, "Mail not found"
end

function MailService.DeleteMail(player, mailId)
    local data = PlayerDataService.GetData(player)
    if not data or not data.Mailbox then
        return false
    end

    for i, mail in ipairs(data.Mailbox) do
        if mail.Id == mailId then
            table.remove(data.Mailbox, i)

            -- Notify client
            local Remotes = game.ReplicatedStorage.AetherShared.Remotes
            if Remotes then
                local MailDeleted = Remotes:FindFirstChild("MailDeleted")
                if MailDeleted then
                    MailDeleted:FireClient(player, mailId)
                end
            end

            return true, "Mail deleted"
        end
    end

    return false, "Mail not found"
end

function MailService.GetUnreadCount(player)
    local data = PlayerDataService.GetData(player)
    if not data or not data.Mailbox then
        return 0
    end

    local count = 0
    for _, mail in ipairs(data.Mailbox) do
        if not mail.Read then
            count += 1
        end
    end
    return count
end

return MailService
