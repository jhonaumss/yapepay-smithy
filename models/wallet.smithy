$version: "2"

namespace com.yapepay.api

// ─────────────────────────────────────────────
//  ESTRUCTURA
// ─────────────────────────────────────────────

structure Wallet {
    @required walletId: UUID
    @required userId: UUID
    @required balance: Amount
    @required currency: CurrencyCode
    @required status: WalletStatus
    @required updatedAt: Timestamp
}

// ─────────────────────────────────────────────
//  OPERACIONES
// ─────────────────────────────────────────────

/// Saldo de la billetera. walletId resuelto desde userId del token.
@http(method: "GET", uri: "/v1/billeteras/me", code: 200)
@readonly
operation GetMyWalletOperation {
    output: GetMyWalletOutput
    errors: [UnauthorizedException, ResourceNotFoundException]
}

structure GetMyWalletOutput {
    @required
    wallet: Wallet
}