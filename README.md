# blood_donor_app

Aplicativo Flutter para visualização e análise de dados de doadores de sangue, totalmente integrado a uma API Spring Boot.

## Pré-requisitos
- Flutter SDK instalado ([instalação](https://docs.flutter.dev/get-started/install))
- Java 17+ e Maven para rodar a API backend
- API backend disponível em: https://github.com/seu-usuario/blood-donor-api (ajuste para o repositório real)

## Passos para rodar a aplicação

### 1. Clone o projeto Flutter
```sh
git clone https://github.com/seu-usuario/blood_donor_app.git
cd blood_donor_app
```

### 2. Instale as dependências do Flutter
```sh
flutter pub get
```

### 3. Clone e rode a API backend
```sh
git clone https://github.com/seu-usuario/blood-donor-api.git
cd blood-donor-api
mvn spring-boot:run
```
A API deve rodar por padrão em `http://localhost:8080`.

### 4. Execute o app Flutter
- **Android/iOS:**
  - Certifique-se que o emulador/simulador está rodando.
  - Execute:
    ```sh
    flutter run
    ```
- **Web:**
  - Execute:
    ```sh
    flutter run -d chrome
    ```
  - Acesse `http://localhost:5000` (ou porta exibida no terminal).

### 5. Configuração de rede
- **Android Emulator:** usa automaticamente `10.0.2.2` para acessar o backend local.
- **Dispositivo físico:** altere o IP no arquivo `api_service.dart` para o IP da sua máquina na rede local.
- **Web:** aponte sempre para o endereço real do backend e garanta que o CORS está habilitado na API.

### 6. Geração de código
Se modificar modelos anotados com json_serializable, rode:
```sh
flutter pub run build_runner build --delete-conflicting-outputs
```

## Funcionalidades
- Listagem de doadores
- Estatísticas por estado, faixa etária, tipo sanguíneo, gênero, etc.
- Integração total com endpoints REST da API

## Observações
- Certifique-se de que a API está rodando antes de abrir o app Flutter.
- Para dúvidas sobre a API, consulte a documentação do projeto backend.

---

> Projeto desenvolvido para fins de estudo e demonstração de integração Flutter + Spring Boot.