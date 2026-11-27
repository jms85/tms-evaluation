Feature: Casos límite de inicio de sesión en la demo

  @requirement-2
  Scenario: Una cuenta activa sin contraseña no puede iniciar sesión
    Given una solicitud de acceso para "activa@example.test"
    When la lógica de la demo evalúa la solicitud con la contraseña vacía
    Then la lógica de la demo deniega el acceso

  @requirement-2
  Scenario: Una solicitud sin correo no puede iniciar sesión
    Given una solicitud de acceso con la contraseña ficticia "demo-pass"
    When la lógica de la demo evalúa la solicitud con el correo vacío
    Then la lógica de la demo deniega el acceso

  @requirement-3
  Scenario: Una cuenta bloqueada con contraseña incorrecta no puede iniciar sesión
    Given existe una cuenta bloqueada "bloqueada@example.test"
    When intento iniciar sesión con "bloqueada@example.test" y "incorrecta"
    Then veo el mensaje "Acceso denegado"
