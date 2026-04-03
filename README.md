# YapePay Smithy API

Modelo REST de la aplicación de pagos móviles YapePay, definido con [Smithy](https://smithy.io).

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
│   ├── main.smithy          ← servicio principal
│   ├── common.smithy        ← tipos comunes (UUID, Amount, enums)
│   ├── errors.smithy        ← errores HTTP
│   ├── auth.smithy          ← login, refresh token
│   ├── users.smithy         ← perfil de usuario
│   ├── wallets.smithy       ← billetera
│   ├── transactions.smithy  ← transacciones P2P
│   ├── recharges.smithy     ← recargas
│   └── qr.smithy            ← códigos QR
├── smithy-build.json        ← configuración de build y generación OpenAPI
└── README.md
```
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