# YapePay Smithy API

Modelo REST de la aplicación de pagos móviles YapePay, definido con [Smithy](https://smithy.io). Es la fuente de verdad del contrato API: de aquí se genera tanto la documentación OpenAPI como el SDK TypeScript (`typescript-ssdk-codegen`) que consumen los microservicios Node.

## Repositorios relacionados

| Repo | Descripción |
|------|-------------|
| yapepay-smithy | Modelos Smithy — fuente de verdad del contrato API (este repo) |
| [yapepay-services](https://github.com/jhonaumss/yapepay-services) | Microservicios (Node.js + Python/FastAPI para credit-service) |
| [yapepay-infra](https://github.com/jhonaumss/yapepay-infra) | Infraestructura AWS CDK |

## Dominios cubiertos

El servicio `YapePayService` (`main.smithy`) agrupa las operaciones en 7 dominios, cada uno con su propio archivo y tag de OpenAPI (`smithy-build.json`):

| Dominio | Archivo | Tag OpenAPI | Operaciones |
|---|---|---|---|
| Auth | `auth.smithy` | `Auth` | Login, RefreshToken |
| Usuarios | `users.smithy` | `Usuarios` | GetCurrentUser, UpdateCurrentUser |
| Billeteras | `wallet.smithy` | `Billeteras` | GetMyWallet |
| Transacciones | `transactions.smithy` | `Transacciones` | CreateTransaction, ListTransactions, GetTransaction |
| Recargas | `recharges.smithy` | `Recargas` | CreateRecharge |
| QR | `qr.smithy` | `QR` | GenerateQR, GetQR |
| **Créditos** | **`credits.smithy`** | **`Creditos`** | **SubmitCreditApplication, GetCreditEvaluation, ListCreditEvaluations** |

## Requisitos

- [Smithy CLI](https://smithy.io/2.0/guides/smithy-cli/cli_installation.html)
- [Node.js](https://nodejs.org) (para swagger-ui-watcher)

## Instalación (una sola vez)

### 1. Instalar Smithy CLI

**Windows:**
Descarga e instala el `.msi` desde:
https://smithy.io/2.0/guides/smithy-cli/cli_installation.html

Verifica la instalación:
```bash
smithy --version
```

### 2. Instalar swagger-ui-watcher
```bash
npm install -g swagger-ui-watcher
```

## Uso

### 1. Clonar el repositorio
```bash
git clone https://github.com/jhonaumss/yapepay-smithy.git
cd yapepay-smithy
```

### 2. Generar el OpenAPI
```bash
smithy build
```

El archivo generado queda en:

build/smithy/openapi/openapi/YapePayService.openapi.json

### 3. Ver la documentación en el navegador
```bash
swagger-ui-watcher build/smithy/openapi/openapi/YapePayService.openapi.json
```

Abre **http://localhost:8000** en tu navegador.

> Cada vez que modifiques un archivo `.smithy` y corras `smithy build`,
> el navegador se actualiza automáticamente.

## Estructura del proyecto
```bash
yapepay-smithy/
├── models/
│   ├── main.smithy          ← servicio principal, lista todas las operaciones
│   ├── common.smithy        ← tipos comunes (UUID, Amount, enums)
│   ├── errors.smithy        ← errores HTTP
│   ├── auth.smithy          ← login, refresh token
│   ├── users.smithy         ← perfil de usuario
│   ├── wallet.smithy        ← billetera
│   ├── transactions.smithy  ← transacciones P2P
│   ├── recharges.smithy     ← recargas
│   ├── qr.smithy            ← códigos QR
│   └── credits.smithy       ← evaluación de crédito (ML) — ver detalle abajo
├── smithy-build.json        ← configuración de build y generación OpenAPI + SSDK
└── README.md
```

## credits.smithy — evaluación de crédito

Modela el dominio consumido por `credit-service` (Python/FastAPI + XGBoost en `yapepay-services`), el único microservicio del backend respaldado por un modelo de Machine Learning. Es el dominio más reciente y el más grande del modelo en número de enums/estructuras.

### Operaciones

| Operación | HTTP | Idempotente | Notas |
|---|---|---|---|
| `SubmitCreditApplicationOperation` | `POST /v1/creditos` (201) | Sí, vía `idempotencyKey` en el input | Envía la solicitud y recibe el resultado del scoring en la misma respuesta |
| `GetCreditEvaluationOperation` | `GET /v1/creditos/{evaluationId}` (200) | — | `@readonly`. Solo accesible por el usuario titular |
| `ListCreditEvaluationsOperation` | `GET /v1/creditos` (200) | — | `@readonly`, `@paginated` (cursor + pageSize) |

### Estructuras principales

- **`CreditApplication`** — input declarado por el usuario: datos personales/laborales (`age` 18–75, `educationLevel`, `employmentStatus`, `monthlyIncome`, `employmentYears`), carga financiera opcional (`existingDebt`, `monthlyDebtPayments`, `hadPreviousDefault`, `estimatedAssetsValue`) y datos de la solicitud (`requestedAmount`, `termMonths` 3–36, `purpose`).
- **`CreditEvaluation`** — resultado persistido: `probabilityOfDefault`, `score` (0–1000), `riskCategory`, `decision`, `userSegment`, `confidenceLevel`, `explanationFactors` (lista de `ExplanationFactor`, top factores SHAP con `impact` y `direction`) y `modelVersion`.
- **Enums de dominio:** `EducationLevel`, `EmploymentStatus`, `CreditPurpose`, `RiskCategory` (BAJO/MEDIO/ALTO), `CreditDecision` (APROBADO/RECHAZADO), `UserSegment` (NUEVO/EN_TRANSICION/ESTABLECIDO — segmentación por antigüedad de historial transaccional, cold start), `ConfidenceLevel`, `FactorDirection`.

Estos tipos son la fuente de verdad que consumen tanto el SDK TypeScript (usado por `wallet-service` y por `yapepay-web`) como el schema `CreditApplication`/`CreditEvaluation` en Python de `credit-service` — si se agrega o cambia un campo aquí, debe reflejarse manualmente en `credit-service/src/schemas.py` (no hay generación de código Python desde Smithy).

## Agregar un nuevo endpoint

1. Abre el archivo `.smithy` del dominio correspondiente
2. Define la operación con `@http`
3. Agrégala al bloque `operations` en `main.smithy`
4. Corre `smithy build` para validar
5. Verifica el resultado en el navegador

## Convención de ramas

main          ← código estable

develop       ← integración del equipo

feature/xxx   ← trabajo individual

Ejemplos:
```bash
git checkout -b feature/auth-endpoints
git checkout -b feature/payment-endpoints
```