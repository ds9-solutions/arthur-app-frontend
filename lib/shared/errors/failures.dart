/// Deve ser usada apenas dentro da camada de providers/usecases.
/// Cada feature pode estender [Failure] com falhas mais específicas.
///
/// Como a classe é `sealed`, toda subclasse precisa ficar neste arquivo.
sealed class Failure {
  final String message;
  const Failure(this.message);

  String getInterMsg() => message;
}

class ActionFailure extends Failure {
  const ActionFailure([super.message = 'Erro ao executar a ação']);
}

class GeneralFailure extends Failure {
  const GeneralFailure([super.message = 'Erro interno']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Não encontrado']);
}

class LoadDataFailure extends Failure {
  const LoadDataFailure([super.message = 'Falha de carregamento']);
}

class ValidateFailure extends Failure {
  const ValidateFailure([super.message = 'Validação falhou']);
}

class ConnectivityFailure extends Failure {
  const ConnectivityFailure([super.message = 'Falha de conexão']);
}

class HttpFailure extends Failure {
  const HttpFailure([super.message = 'Falha na chamada externa']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Falha na autenticação']);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure([super.message = 'Credenciais inválidas']);
}

class UserDisabledFailure extends Failure {
  const UserDisabledFailure([super.message = 'Esta conta está desativada. Fale com o suporte']);
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure([super.message = 'Este e-mail já tem conta']);
}

class InvalidEmailFailure extends Failure {
  const InvalidEmailFailure([super.message = 'E-mail inválido']);
}

class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure([
    super.message = 'Senha fraca. Use ao menos 8 caracteres, com letras e números',
  ]);
}

class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure([super.message = 'Muitas tentativas. Aguarde alguns minutos']);
}
