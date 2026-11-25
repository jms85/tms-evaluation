const users = new Map([
  ['activa@example.test', { locked: false }],
  ['bloqueada@example.test', { locked: true }],
]);

export function signIn(email, password, { simulateRegression = false } = {}) {
  const user = users.get(email);
  return Boolean(user && password === 'demo-pass' && (!user.locked || simulateRegression));
}
