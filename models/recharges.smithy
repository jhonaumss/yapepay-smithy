$version: "2"

namespace com.yapepay.api

// ─────────────────────────────────────────────
//  OPERACIONES
// ─────────────────────────────────────────────

/// Recarga desde cuenta bancaria vinculada. Idempotente.
@http(method: "POST", uri: "/v1/recargas", code: 201)
@tags(["Recargas"])
operation CreateRechargeOperation {
    input: CreateRechargeInput
    output: CreateRechargeOutput
    errors: [
        ValidationException
        UnauthorizedException
        ForbiddenException
        ResourceNotFoundException
        ConflictException
    ]
}

structure CreateRechargeInput {
    @required
    bankAccountId: UUID

    @required
    amount: Amount

    @required
    idempotencyKey: UUID
}

structure CreateRechargeOutput {
    @required
    transaction: Transaction

    @required
    @range(min: 0, max: 3600)
    estimatedCreditSeconds: Integer
}