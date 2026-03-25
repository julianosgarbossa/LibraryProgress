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
    private let bookService: BookServiceProtocol

    init(bookService: BookServiceProtocol) {
        self.bookService = bookService
    }

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
        books = apply(filter: selectedFilter, books: bookService.fetchBooks())
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
        bookService.deleteBook(bookId: bookId)
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
