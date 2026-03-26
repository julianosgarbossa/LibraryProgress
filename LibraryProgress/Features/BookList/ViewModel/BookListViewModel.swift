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

final class BookListViewModel {
    private weak var delegate: BookListViewModelDelegate?
    private let bookService: BookServiceProtocol

    init(bookService: BookServiceProtocol) {
        self.bookService = bookService
    }

    func setDelegate(_ delegate: BookListViewModelDelegate) {
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

    private(set) var books: [Book] = []
    private(set) var selectedFilter: Filter = .all
    private(set) var searchText: String = ""
    
    // Aplica o filtro em duas etapas:
    // 1) status do livro
    // 2) texto de busca no título
    private func apply(filter: Filter, to books: [Book]) -> [Book] {
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
        let normalizedSearch = normalized(searchText)

        return filteredByStatus.filter { book in
            
            // Busca tolerante a acento e diferença de caixa (maiúsculo/minúsculo).
            normalized(book.title).contains(normalizedSearch)
        }
    }

    // Mensagem exibida apenas quando a lista está vazia.
    // Prioriza contexto de busca; sem busca, mostra contexto do filtro.
    var emptyStateMessage: String {
        if books.isEmpty == false {
            return ""
        }

        if searchText.isEmpty == false {
            return "Nenhum livro encontrado para \"\(searchText)\"."
        }

        switch selectedFilter {
        case .all:
            return "Nenhum livro cadastrado."
        case .toRead, .reading, .finished:
            return "Nenhum livro no filtro \"\(selectedFilter.title)\"."
        }
    }

    func numberOfItems() -> Int {
        books.count
    }

    func loadBooks() {
        // Fonte única da lista vem do service; filtro e busca são aplicados localmente.
        books = apply(filter: selectedFilter, to: bookService.fetchBooks())
        delegate?.didUpdateBooks()
    }

    func book(at index: Int) -> Book {
        books[index]
    }

    func cellViewModel(at index: Int) -> BookTableViewCellViewModel {
        BookTableViewCellViewModel(book: books[index])
    }

    func deleteBook(at index: Int) {
        guard books.indices.contains(index) else { return }
        let bookId = books[index].id
        bookService.deleteBook(bookId: bookId)
        // Recarrega para refletir remoção + estado atual de filtro/busca.
        loadBooks()
    }

    func setFilter(at index: Int) {
        guard let filter = Filter(rawValue: index) else { return }
        selectedFilter = filter
        loadBooks()
    }

    func setSearchText(_ text: String) {
        searchText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        loadBooks()
    }

    private func normalized(_ text: String) -> String {
        text.folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
    }
}
