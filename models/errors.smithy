$version: "2"

namespace com.yapepay.api

// ─────────────────────────────────────────────
//  ERRORES DE CLIENTE (4xx)
// ─────────────────────────────────────────────

@error("client") @httpError(400)
structure ValidationException {
    @required
    message: String

    fieldErrors: FieldErrorList
}

list FieldErrorList {
    member: FieldError
}

structure FieldError {
    @required
    field: String

    @required
    message: String
}

@error("client") @httpError(401)
structure UnauthorizedException {
    @required
    message: String
}

@error("client") @httpError(403)
structure ForbiddenException {
    @required
    message: String

    requiredScope: String
}

@error("client") @httpError(404)
structure ResourceNotFoundException {
    @required
    message: String

    resourceType: String
    resourceId: String
}

@error("client") @httpError(409)
structure ConflictException {
    @required
    message: String

    existingTxId: UUID
}

@error("client") @httpError(422)
structure InsufficientFundsException {
    @required
    message: String

    currentBalance: Amount
    requiredAmount: Amount
}

// ─────────────────────────────────────────────
//  ERRORES DE SERVIDOR (5xx)
// ─────────────────────────────────────────────

@error("server") @httpError(500)
structure InternalServerException {
    @required
    message: String

    traceId: String
}