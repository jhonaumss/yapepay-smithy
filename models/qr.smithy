$version: "2"

namespace com.yapepay.api

// ─────────────────────────────────────────────
//  ESTRUCTURA
// ─────────────────────────────────────────────

structure QRCode {
    @required
    qrId: UUID
    @required
    userId: UUID
    amount: Amount
    currency: CurrencyCode
    @length(max: 200)
    description: String
    @required
    qrData: String
    @required
    expiresAt: Timestamp
    @required
    used: Boolean
}

// ─────────────────────────────────────────────
//  OPERACIONES
// ─────────────────────────────────────────────

/// Genera QR de cobro. amount=null → QR abierto (pagador ingresa monto).
@http(method: "POST", uri: "/v1/qr", code: 201)
operation GenerateQROperation {
    input: GenerateQRInput
    output: GenerateQROutput
    errors: [ValidationException, UnauthorizedException]
}

structure GenerateQRInput {
    amount: Amount
    currency: CurrencyCode
    @length(max: 200) description: String
    @range(min: 1, max: 1440) ttlMinutes: Integer
}

structure GenerateQROutput {
    @required
    qrCode: QRCode
}

/// Estado de un QR generado. Solo accesible por el propietario.
@http(method: "GET", uri: "/v1/qr/{qrId}", code: 200)
@readonly
operation GetQROperation {
    input: GetQRInput
    output: GetQROutput
    errors: [UnauthorizedException, ForbiddenException, ResourceNotFoundException]
}

structure GetQRInput {
    @httpLabel
    @required
    qrId: UUID
}

structure GetQROutput {
    @required
    qrCode: QRCode
}



