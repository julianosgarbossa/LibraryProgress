//
//  BookListViewModel.swift
//  LibraryProgress
//
//  Created by Juliano Sgarbossa on 24/03/26.
//

import Foundation

protocol BookListViewModelDelegate: AnyObject {
    func didUpdateBooks()
}

class BookListViewModel {
    private weak var delegate: BookListViewModelDelegate?

    func delegate(delegate: BookListViewModelDelegate) {
        self.delegate = delegate
    }

    enum Filter: Int {
        case all
        case toRead
        case reading
        case finished

        var title: String {
            switch self {
            case .all:
                return "Todos"
            case .toRead:
                return "Vou Ler"
            case .reading:
                return "Lendo"
            case .finished:
                return "Finalizados"
            }
        }
    }

    private var allBooks: [Book] = [Book(title: "Arquitetura Limpa",
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

    private(set) var books: [Book] = []
    private(set) var selectedFilter: Filter = .all
    private(set) var searchText: String = ""
    
    private func apply(filter: Filter, books: [Book]) -> [Book] {
        let filteredByStatus: [Book]

        switch filter {
        case .all:
            filteredByStatus = books
        case .toRead:
            filteredByStatus = books.filter { $0.status == .toRead }
        case .reading:
            filteredByStatus = books.filter { $0.status == .reading }
        case .finished:
            filteredByStatus = books.filter { $0.status == .finished }
        }

        guard !searchText.isEmpty else { return filteredByStatus }

        return filteredByStatus.filter { book in
            book.title.localizedCaseInsensitiveContains(searchText)
        }
    }

    var numberOfItems: Int {
        books.count
    }

    func loadBooks() {
        books = apply(filter: selectedFilter, books: allBooks)
        delegate?.didUpdateBooks()
    }

    func book(index: Int) -> Book {
        books[index]
    }

    func cellViewModel(index: Int) -> BookTableViewCellViewModel {
        BookTableViewCellViewModel(book: books[index])
    }

    func deleteBook(at index: Int) {
        guard books.indices.contains(index) else { return }
        let bookId = books[index].id
        allBooks.removeAll { $0.id == bookId }
        loadBooks()
    }

    func setFilter(index: Int) {
        guard let filter = Filter(rawValue: index) else { return }
        selectedFilter = filter
        loadBooks()
    }

    func setSearchText(text: String) {
        searchText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        loadBooks()
    }
}
