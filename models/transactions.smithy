$version: "2"

namespace com.yapepay.api

// ─────────────────────────────────────────────
//  ESTRUCTURA
// ─────────────────────────────────────────────

structure Transaction {
    @required txId: UUID
    @required senderId: UUID
    @required receiverId: UUID
    @required amount: Amount
    @required currency: CurrencyCode
    @required type: TransactionType
    @required status: TransactionStatus
    @length(max: 200) description: String
    @required createdAt: Timestamp
    completedAt: Timestamp
}

list TransactionList {
    member: Transaction
}

// ─────────────────────────────────────────────
//  OPERACIONES
// ─────────────────────────────────────────────

/// Transferencia P2P. senderId del token (sub). Requiere idempotencyKey.
@http(method: "POST", uri: "/v1/transacciones", code: 201)
@tags(["Transacciones"])
operation CreateTransactionOperation {
    input: CreateTransactionInput
    output: CreateTransactionOutput
    errors: [
        ValidationException
        UnauthorizedException
        ForbiddenException
        ResourceNotFoundException
        InsufficientFundsException
        ConflictException
    ]
}

structure CreateTransactionInput {
    @required
    receiverPhone: PhoneNumber

    @required
    amount: Amount

    currency: CurrencyCode

    @length(max: 200)
    description: String

    @required
    idempotencyKey: UUID
}

structure CreateTransactionOutput {
    @required
    transaction: Transaction
}

/// Historial paginado. userId del token — el usuario solo ve SUS transacciones.
@http(method: "GET", uri: "/v1/transacciones", code: 200)
@readonly
@tags(["Transacciones"])
@paginated(inputToken: "cursor", outputToken: "nextCursor", pageSize: "pageSize")
operation ListTransactionsOperation {
    input: ListTransactionsInput
    output: ListTransactionsOutput
    errors: [ValidationException, UnauthorizedException]
}

structure ListTransactionsInput {
    @httpQuery("cursor")   cursor: String
    @httpQuery("pageSize") @range(min: 1, max: 50) pageSize: Integer
    @httpQuery("type")     type: TransactionType
    @httpQuery("status")   status: TransactionStatus
    @httpQuery("fromDate") fromDate: Timestamp
    @httpQuery("toDate")   toDate: Timestamp
}

structure ListTransactionsOutput {
    @required transactions: TransactionList
    nextCursor: String
    @required total: Integer
}

/// Detalle de transacción. Solo accesible para remitente o receptor.
@http(method: "GET", uri: "/v1/transacciones/{txId}", code: 200)
@readonly
@tags(["Transacciones"])
operation GetTransactionOperation {
    input: GetTransactionInput
    output: GetTransactionOutput
    errors: [UnauthorizedException, ForbiddenException, ResourceNotFoundException]
}

structure GetTransactionInput {
    @httpLabel
    @required
    txId: UUID
}

structure GetTransactionOutput {
    @required
    transaction: Transaction
}
