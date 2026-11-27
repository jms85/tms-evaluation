import assert from 'node:assert/strict';
import test from 'node:test';
import { signIn } from './auth.mjs';

const options = { simulateRegression: process.env.DEMO_REGRESSION === '1' };

test('El usuario activo puede iniciar sesión', () => {
  assert.equal(signIn('activa@example.test', 'demo-pass', options), true);
});

test('Las credenciales inválidas se rechazan', () => {
  assert.equal(signIn('activa@example.test', 'incorrecta', options), false);
  assert.equal(signIn('desconocida@example.test', 'demo-pass', options), false);
});

test('Una cuenta bloqueada no puede iniciar sesión', () => {
  assert.equal(signIn('bloqueada@example.test', 'demo-pass', options), false,
    'La cuenta bloqueada recibió acceso; se esperaba que se denegara.');
});

test('Una cuenta activa sin contraseña no puede iniciar sesión', () => {
  assert.equal(signIn('activa@example.test', '', options), false);
});

test('Una solicitud sin correo no puede iniciar sesión', () => {
  assert.equal(signIn('', 'demo-pass', options), false);
});

test('Una cuenta bloqueada con contraseña incorrecta no puede iniciar sesión', () => {
  assert.equal(signIn('bloqueada@example.test', 'incorrecta', options), false);
});
