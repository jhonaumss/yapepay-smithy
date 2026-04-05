$version: "2"

namespace com.yapepay.api

use aws.protocols#restJson1

// ─────────────────────────────────────────────
//  OPERACIONES
// ─────────────────────────────────────────────

/// Login con celular + PIN.
/// Devuelve access_token (15min) y refresh_token (30d).
/// El userId NUNCA va en el body — se devuelve en el JWT (claim sub).
@http(method: "POST", uri: "/v1/auth/login", code: 200)
@auth([])
@tags(["Auth"])
operation LoginOperation {
    input: LoginInput
    output: LoginOutput
    errors: [ValidationException, UnauthorizedException]
}

/// Renueva access_token. El refresh_token rota en cada llamada.
@http(method: "POST", uri: "/v1/auth/refresh", code: 200)
@auth([])
@tags(["Auth"])
operation RefreshTokenOperation {
    input: RefreshTokenInput
    output: RefreshTokenOutput
    errors: [ValidationException, UnauthorizedException]
}

// ─────────────────────────────────────────────
//  ESTRUCTURAS
// ─────────────────────────────────────────────

structure LoginInput {
    @required
    phoneNumber: PhoneNumber

    @required
    @length(min: 64, max: 64)
    @pattern("^[0-9a-f]{64}$")
    pinHash: String
}

structure LoginOutput {
    @required accessToken: String
    @required refreshToken: String
    @required @range(min: 1, max: 86400) expiresIn: Integer
    @required tokenType: String
}

structure RefreshTokenInput {
    @required
    refreshToken: String
}

structure RefreshTokenOutput {
    @required accessToken: String
    @required refreshToken: String
    @required @range(min: 1, max: 86400) expiresIn: Integer
}