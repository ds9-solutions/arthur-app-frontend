/// Centraliza os paths da API consumidos pelo app.
/// Cada grupo de rotas ganha uma classe privada própria — ver exemplo abaixo.
class Endpoints {
  const Endpoints._();

  static const health = _Health();
}

// HEALTH
//
// Exemplo de grupo de rotas. Adicione novos grupos conforme as features
// forem consumindo a API (ex: static const users = _Users();).
class _Health {
  const _Health();

  String get check => '/health';
}
