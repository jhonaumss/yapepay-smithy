$version: "2"

namespace com.yapepay.api

// ─────────────────────────────────────────────
//  OPERACIONES
// ─────────────────────────────────────────────

/// Recarga desde cuenta bancaria vinculada. Idempotente.
@http(method: "POST", uri: "/v1/recargas", code: 201)
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

structure Transaction {
    @required
    id: UUID

    @required
    amount: Amount

    @required
    status: TransactionStatus

    @required
    createdAt: Timestamp

    bankAccountId: UUID
}



