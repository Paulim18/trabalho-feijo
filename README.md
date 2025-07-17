# TaskList

##  App de Lista de Tarefas (To-do List) com Filtros - Flutter

Este é um **aplicativo Flutter** de lista de tarefas (**To-do List**) desenvolvido como projeto acadêmico, com funcionalidades completas de **CRUD**, filtros e **persistência local** utilizando `shared_preferences`.

---

##  Funcionalidades

- ✅ Cadastro de tarefas com **título**, **descrição** e **data**
- ✅ Marcar tarefas como **concluídas**
- ✅ Editar tarefas cadastradas
- ✅ Excluir tarefas
- ✅ Filtrar tarefas por:
  - Todas
  - Pendentes
  - Concluídas
- ✅ Logout para voltar à tela de login
- ✅ Persistência local com `shared_preferences`

---


---

## Tecnologias e Pacotes

| Tecnologia                   | Uso                                     |
|------------------------------|-----------------------------------------|
| [Flutter](https://flutter.dev) | Construção da interface e navegação     |
| [Dart](https://dart.dev)     | Linguagem principal do app              |
| `shared_preferences`         | Armazenamento local de tarefas          |

---


##  Estrutura do Projeto

```plaintext
TaskList/
├── lib/
│   ├── main.dart           👈 Ponto de entrada do app (configuração principal)
│   ├── login_page.dart     👈 Tela de Login
│   ├── home_page.dart      👈 Tela Home 
│   ├── todo_page.dart      👈 Tela principal de tarefas (CRUD, filtros, logout)
│   ├── theme/
│   │   └── app_theme.dart  👈 Tema global com Material 3 e estilização
├── pubspec.yaml            👈 Dependências e configurações do projeto
```
---
## Execução

1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/trabalho-feijo.git
   ```

2. Entre na pasta do projeto:
   ```bash
   cd trabalho-feijo
   ```

3. Instale as dependências:
   ```bash
   flutter pub get
   ```
4. Rode o app:
   ```bash
   flutter run
   ```
---
## Conhecimentos trabalhados

- ✔️ Widgets personalizados
- ✔️ Persistência local de dados
- ✔️ Navegação entre telas
- ✔️ Boas práticas de UI/UX
---

##  Licença  
### Este projeto está licenciado sob a [MIT License](LICENSE).  
---

##  **Agradecimentos**
###
- **Pedro Henrique Feijó de Sousa**: Orientador do projeto e professor da disciplina de Desenvolvimento de Aplicativos Móveis na UFC Itapajé
###
- **Equipe do Projeto:** Carlos Kaique Rosa Silva ([Kaique Silva](https://github.com/hoyalles)) e Paulo Matheus Cardoso Viana ([Paulo Cardoso](https://github.com/Paulim18))
