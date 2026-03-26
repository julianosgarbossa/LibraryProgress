//
//  InMemoryBookService.swift
//  LibraryProgress
//
//  Created by Juliano Sgarbossa on 25/03/26.
//

import Foundation

final class InMemoryBookService: BookServiceProtocol {
    private var books: [Book]

    init(initialBooks: [Book] = InMemoryBookService.defaultBooks()) {
        self.books = initialBooks
    }

    func fetchBooks() -> [Book] {
        books
    }

    func addBook(_ book: Book) {
        books.append(book)
    }

    func updateProgress(bookId: UUID, currentPage: Int) {
        guard let index = books.firstIndex(where: { $0.id == bookId }) else { return }
        books[index].setCurrentPage(page: currentPage)
    }

    func deleteBook(bookId: UUID) {
        books.removeAll { $0.id == bookId }
    }

    private static func defaultBooks() -> [Book] {
        [Book(title: "Arquitetura Limpa",
              author: "Robert C. Martin",
              totalPages: 432,
              currentPage: 0,
              status: .toRead),
         Book(title: "O Programador Pragmático",
              author: "Andrew Hunt & David Thomas",
              totalPages: 352,
              currentPage: 52,
              status: .reading),
         Book(title: "Engenharia de Software Moderna",
              author: "Marco Tulio Valente",
              totalPages: 368,
              currentPage: 0,
              status: .toRead),
         Book(title: "Código Limpo",
              author: "Robert C. Martin",
              totalPages: 464,
              currentPage: 0,
              status: .toRead),
         Book(title: "Entendendo Algoritmos",
              author: "Aditya Y. Bhargava",
              totalPages: 264,
              currentPage: 0,
              status: .toRead),
         Book(title: "Entendendo Estruturas de Dados",
              author: "Marcello La Rocca",
              totalPages: 300,
              currentPage: 0,
              status: .toRead),
         Book(title: "Introdução à Linguagem SQL",
              author: "Thomas Nield",
              totalPages: 300,
              currentPage: 150,
              status: .reading),
         Book(title: "O Codificador Limpo",
              author: "Robert C. Martin",
              totalPages: 256,
              currentPage: 0,
              status: .toRead),
         Book(title: "Implementando Domain-Driven Design",
              author: "Vaughn Vernon",
              totalPages: 656,
              currentPage: 0,
              status: .toRead),
         Book(title: "Padrões de Projeto",
              author: "Erich Gamma, Richard Helm, Ralph Johnson & John Vlissides",
              totalPages: 395,
              currentPage: 395,
              status: .finished)]
    }
}
