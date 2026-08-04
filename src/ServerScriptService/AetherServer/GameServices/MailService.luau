local MailService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)

MailService.Mailboxes = {}

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
            if type(targetUserId) ~= "number" or type(subject) ~= "string" then
                return
            end
            local target = game.Players:GetPlayerByUserId(targetUserId)
            if not target then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, "Recipient not found")
                end
                return
            end
            MailService.SendMail(player, target, subject, message or "", attachments or {})
        end)
    end

    -- ReadMail: mark mail as read and claim attachments
    local ReadMail = Remotes:FindFirstChild("ReadMail")
    if ReadMail then
        ReadMail.OnServerEvent:Connect(function(player, mailId)
            if type(mailId) ~= "string" then
                return
            end
            MailService.ReadMail(player, mailId)
        end)
    end

    -- DeleteMail: remove mail from the mailbox
    local DeleteMail = Remotes:FindFirstChild("DeleteMail")
    if DeleteMail then
        DeleteMail.OnServerEvent:Connect(function(player, mailId)
            if type(mailId) ~= "string" then
                return
            end
            MailService.DeleteMail(player, mailId)
        end)
    end

    print("[MailService] Initialized")
end

function MailService.SendMail(fromPlayer, toPlayer, subject, message, attachments)
    local toData = PlayerDataService.GetData(toPlayer)
    if not toData then
        return false, "Player not found"
    end

    if not toData.Mailbox then
        toData.Mailbox = {}
    end

    local mail = {
        Id = "MAIL_" .. os.time() .. "_" .. math.random(1000, 9999),
        From = fromPlayer.Name,
        FromId = fromPlayer.UserId,
        Subject = subject,
        Message = message,
        Attachments = attachments or {},
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
            mail.Read = true

            -- Claim attachments
            if mail.Attachments then
                for _, attachment in ipairs(mail.Attachments) do
                    if attachment.ItemId then
                        PlayerDataService.AddItem(player, attachment.ItemId, attachment.Amount or 1)
                    end
                    if attachment.Currency then
                        for currency, amount in pairs(attachment.Currency) do
                            PlayerDataService.AddCurrency(player, currency, amount)
                        end
                    end
                end
                mail.Attachments = {}
            end

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
