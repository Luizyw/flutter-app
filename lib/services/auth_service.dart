class AuthService {
  // 🔐 Cadastro
  Future<bool> cadastrarUsuario(Map<String, dynamic> dados) async {
    await Future.delayed(const Duration(seconds: 2)); // simula API

    print("Dados enviados: $dados");

    return true;
  }

  // 🔑 Login
  Future<bool> login(String email, String senha) async {
    await Future.delayed(const Duration(seconds: 2));

    if (email == "teste@email.com" && senha == "123456Aa!") {
      return true;
    }

    return false;
  }
}