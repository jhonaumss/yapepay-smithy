plugins {
    `java-library`
    id("software.amazon.smithy.gradle.smithy-jar")
}

repositories {
    mavenLocal()
    mavenCentral()
}

dependencies {
    val smithyVersion: String by project

    smithyCli("software.amazon.smithy:smithy-cli:$smithyVersion")
    implementation("software.amazon.smithy:smithy-model:$smithyVersion")
    implementation("software.amazon.smithy:smithy-aws-traits:$smithyVersion")
    smithyCli("software.amazon.smithy:smithy-model:$smithyVersion")
    smithyCli("software.amazon.smithy:smithy-openapi:$smithyVersion")
    smithyCli("software.amazon.smithy:smithy-aws-traits:$smithyVersion")
    smithyCli("software.amazon.smithy:smithy-aws-apigateway-openapi:$smithyVersion")

    // TypeScript SSDK codegen plugin
    smithyCli("software.amazon.smithy.typescript:smithy-aws-typescript-codegen:0.21.1")
}