$version: "2"

namespace com.yapepay.api

// ─────────────────────────────────────────────
//  ESTRUCTURA
// ─────────────────────────────────────────────

structure UserProfile {
    @required
    userId: UUID
    @required
    phoneNumber: PhoneNumber
    @required
    @length(min: 2, max: 100)
    fullName: String
    @required
    email: String
    @required
    kycStatus: KycStatus
    @required
    createdAt: Timestamp
}

// ─────────────────────────────────────────────
//  OPERACIONES
// ─────────────────────────────────────────────

/// Perfil del usuario autenticado. userId derivado del Bearer token.
@http(method: "GET", uri: "/v1/usuarios/me", code: 200)
@readonly
operation GetCurrentUserOperation {
    output: GetCurrentUserOutput
    errors: [UnauthorizedException]
}

structure GetCurrentUserOutput {
    @required
    user: UserProfile
}

/// Actualiza perfil propio. userId del token, nunca del body.
@idempotent
@http(method: "PATCH", uri: "/v1/usuarios/me", code: 200)
operation UpdateCurrentUserOperation {
    input: UpdateCurrentUserInput
    output: UpdateCurrentUserOutput
    errors: [ValidationException, UnauthorizedException]
}

structure UpdateCurrentUserInput {
    @required
    updates: UpdateUserPayload
}

structure UpdateUserPayload {
    @length(min: 2, max: 100)
    fullName: String
    @pattern("^[^@]+@[^@]+\\.[^@]+$")
    email: String
}

structure UpdateCurrentUserOutput {
    @required
    user: UserProfile
}