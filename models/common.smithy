$version: "2"

namespace com.yapepay.api

// ─────────────────────────────────────────────
//  TIPOS PRIMITIVOS
// ─────────────────────────────────────────────

@pattern("^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$")
string UUID

@pattern("^(\\+51)?9[0-9]{8}$")
@length(min: 9, max: 12)
string PhoneNumber

@range(min: 1, max: 999999)
bigDecimal Amount

@length(min: 3, max: 3)
@pattern("^[A-Z]{3}$")
string CurrencyCode

// ─────────────────────────────────────────────
//  ENUMS
// ─────────────────────────────────────────────

enum TransactionStatus {
    PENDING
    COMPLETED
    FAILED
    REVERSED
}

enum TransactionType {
    P2P_TRANSFER
    RECHARGE
    PAYMENT_QR
    REVERSAL
}

enum KycStatus {
    PENDING
    BASIC_VERIFIED
    FULL_VERIFIED
    REJECTED
}

enum WalletStatus {
    ACTIVE
    SUSPENDED
    CLOSED
}