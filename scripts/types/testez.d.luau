-- TestEZ global definitions for luau-lsp (describe/it/expect).
-- Load via: luau-lsp analyze --defs=scripts/types/testez.d.luau

declare function describe(name: string, callback: () -> ()): ()

declare function it(name: string, callback: () -> ()): ()

declare function expect(value: any): {
    to: {
        equal: (other: any) -> (),
        be: (other: any) -> (),
        beTruthy: () -> (),
        beFalsy: () -> (),
        beCloseTo: (other: number, margin: number?) -> (),
        beInstanceOf: (classType: any) -> (),
        beLessThan: (other: number) -> (),
        beGreaterThan: (other: number) -> (),
        beLessThanOrEqual: (other: number) -> (),
        beGreaterThanOrEqual: (other: number) -> (),
        beNull: () -> (),
        beUndefined: () -> (),
        exist: () -> (),
        never: () -> (),
        equalToIgnoringCase: (other: string) -> (),
        include: (expected: any) -> (),
        throw: () -> (),
    },
}

export type TestEZGlobals = nil
