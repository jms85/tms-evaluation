Feature: Inicio de sesión en la demo

  @smoke @requirement-1
  Scenario: El usuario activo puede iniciar sesión
    Given la opción Simular regresión está desactivada
    When intento iniciar sesión con "activa@example.test" y "demo-pass"
    Then veo el mensaje "Acceso concedido"

  @requirement-2
  Scenario: Las credenciales inválidas se rechazan
    Given la opción Simular regresión está desactivada
    When intento iniciar sesión con "activa@example.test" y "incorrecta"
    Then veo el mensaje "Acceso denegado"
    When intento iniciar sesión con "desconocida@example.test" y "demo-pass"
    Then veo el mismo mensaje "Acceso denegado"

  @requirement-3
  Scenario: Una cuenta bloqueada no puede iniciar sesión
    Given existe una cuenta bloqueada "bloqueada@example.test"
    When intento iniciar sesión con "bloqueada@example.test" y "demo-pass"
    Then veo el mensaje "Acceso denegado"
