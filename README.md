# LibraryProgress

Aplicativo iOS para gerenciamento de leitura de livros, com foco em organização por status e acompanhamento de progresso.

## Screenshots
<p align="center">
  <img src="Assets/01 - Home_AllBooks.png" width="150"/>
  <img src="Assets/02 - Home_Reading.png" width="150"/>
  <img src="Assets/03 - Home_Search.png" width="150"/>
  <img src="Assets/04 - New_Book.png" width="150"/>
  <img src="Assets/05 - Book_Detail.png" width="150"/>
  <img src="Assets/06 - Book_Edit.png" width="150"/>
</p>

## Funcionalidades
- Listagem de livros.
- Filtro por status (`Todos`, `Vou Ler`, `Lendo`, `Finalizados`).
- Busca por título.
- Cadastro de novo livro.
- Edição de livro existente.
- Remoção de livro.
- Atualização de progresso de leitura.

## Arquitetura
- `UIKit` com telas programáticas.
- Padrão `MVVM` nas features principais.
- Injeção de dependência via `BookServiceProtocol`.
- Serviço atual: `InMemoryBookService` (dados em memória).

## Tecnologias
- Swift 5
- UIKit
- XCTest

## Como executar
1. Abra o arquivo `LibraryProgress.xcodeproj` no Xcode.
2. Selecione o scheme `LibraryProgress`.
3. Escolha um simulador iOS.
4. Execute com `Cmd + R`.

## Testes
Atualmente o projeto possui testes unitários para regras de negócio do model `Book`.

Para rodar:
1. No Xcode, use `Cmd + U`.
2. Para ver cobertura, abra o `Report Navigator` (`Cmd + 9`) e selecione a execução de testes.
