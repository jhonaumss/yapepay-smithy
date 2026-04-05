$version: "2"

namespace com.yapepay.api

use aws.protocols#restJson1

/// YapePay API — Pagos Móviles P2P
/// AuthN: OIDC Bearer Token (Keycloak)
@restJson1
@httpBearerAuth
@title("YapePay API")
service YapePayService {
    version: "2025-01-01"
    operations: [
        LoginOperation
        RefreshTokenOperation
        GetCurrentUserOperation
        UpdateCurrentUserOperation
        CreateTransactionOperation
        ListTransactionsOperation
        GetTransactionOperation
        GetMyWalletOperation
    ]
    errors: [UnauthorizedException, InternalServerException]
}