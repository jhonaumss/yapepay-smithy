$version: "2"

namespace com.yapepay.api

// ─────────────────────────────────────────────
//  ENUMS
// ─────────────────────────────────────────────

enum EducationLevel {
    SECUNDARIA
    TECNICO
    UNIVERSITARIO
    POSGRADO
}

enum EmploymentStatus {
    DEPENDIENTE
    INDEPENDIENTE
    DESEMPLEADO
}

enum CreditPurpose {
    NEGOCIO
    EDUCACION
    EMERGENCIA
    CONSUMO
    OTRO
}

enum RiskCategory {
    BAJO
    MEDIO
    ALTO
}

enum CreditDecision {
    APROBADO
    RECHAZADO
}

/// Segmentación por antigüedad/volumen de historial transaccional (perfil 2.2, cold start).
enum UserSegment {
    NUEVO
    EN_TRANSICION
    ESTABLECIDO
}

enum ConfidenceLevel {
    ALTA
    MEDIA
    BAJA
}

enum FactorDirection {
    POSITIVO
    NEGATIVO
}

// ─────────────────────────────────────────────
//  ESTRUCTURAS
// ─────────────────────────────────────────────

structure CreditApplication {
    // Personales/laborales
    @required
    @range(min: 18, max: 75)
    age: Integer

    @required
    educationLevel: EducationLevel

    @required
    employmentStatus: EmploymentStatus

    @required
    monthlyIncome: Amount

    /// Requerido si employmentStatus != DESEMPLEADO (validado en servidor, ver ValidationException.fieldErrors).
    employmentYears: Float

    // Carga financiera (opcionales, default 0 / false)
    existingDebt: Amount
    monthlyDebtPayments: Amount
    hadPreviousDefault: Boolean
    estimatedAssetsValue: Amount

    // Solicitud
    @required
    requestedAmount: Amount

    @required
    @range(min: 3, max: 36)
    termMonths: Integer

    purpose: CreditPurpose
}

structure ExplanationFactor {
    @required
    factor: String

    /// Peso relativo del factor en la decisión (SHAP value normalizado).
    @required
    impact: Float

    @required
    direction: FactorDirection
}

list ExplanationFactorList {
    member: ExplanationFactor
}

structure CreditEvaluation {
    @required
    evaluationId: UUID

    @required
    userId: UUID

    @required
    application: CreditApplication

    /// Probabilidad de incumplimiento estimada por el modelo (0-1).
    @required
    probabilityOfDefault: Float

    @required
    @range(min: 0, max: 1000)
    score: Integer

    @required
    riskCategory: RiskCategory

    @required
    decision: CreditDecision

    @required
    userSegment: UserSegment

    @required
    confidenceLevel: ConfidenceLevel

    @required
    explanationFactors: ExplanationFactorList

    @required
    modelVersion: String

    @required
    createdAt: Timestamp
}

list CreditEvaluationList {
    member: CreditEvaluation
}

// ─────────────────────────────────────────────
//  OPERACIONES
// ─────────────────────────────────────────────

/// Solicita una evaluación crediticia. userId del token (sub). Combina la solicitud
/// declarada con features transaccionales derivadas de transaction-service (perfil 5.3).
@http(method: "POST", uri: "/v1/creditos", code: 201)
@tags(["Creditos"])
operation SubmitCreditApplicationOperation {
    input: SubmitCreditApplicationInput
    output: SubmitCreditApplicationOutput
    errors: [
        ValidationException
        UnauthorizedException
        ForbiddenException
        ConflictException
    ]
}

structure SubmitCreditApplicationInput {
    @required
    application: CreditApplication

    @required
    idempotencyKey: UUID
}

structure SubmitCreditApplicationOutput {
    @required
    evaluation: CreditEvaluation
}

/// Consulta una evaluación previamente realizada. Solo accesible por el usuario titular.
@http(method: "GET", uri: "/v1/creditos/{evaluationId}", code: 200)
@readonly
@tags(["Creditos"])
operation GetCreditEvaluationOperation {
    input: GetCreditEvaluationInput
    output: GetCreditEvaluationOutput
    errors: [UnauthorizedException, ForbiddenException, ResourceNotFoundException]
}

structure GetCreditEvaluationInput {
    @httpLabel
    @required
    evaluationId: UUID
}

structure GetCreditEvaluationOutput {
    @required
    evaluation: CreditEvaluation
}

/// Historial paginado de evaluaciones del usuario autenticado (trazabilidad, perfil RF6).
@http(method: "GET", uri: "/v1/creditos", code: 200)
@readonly
@tags(["Creditos"])
@paginated(inputToken: "cursor", outputToken: "nextCursor", pageSize: "pageSize")
operation ListCreditEvaluationsOperation {
    input: ListCreditEvaluationsInput
    output: ListCreditEvaluationsOutput
    errors: [ValidationException, UnauthorizedException]
}

structure ListCreditEvaluationsInput {
    @httpQuery("cursor")   cursor: String
    @httpQuery("pageSize") @range(min: 1, max: 50) pageSize: Integer
}

structure ListCreditEvaluationsOutput {
    @required evaluations: CreditEvaluationList
    nextCursor: String
    @required total: Integer
}
