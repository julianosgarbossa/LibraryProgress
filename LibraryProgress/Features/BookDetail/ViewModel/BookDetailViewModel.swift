//
//  BookDetailViewModel.swift
//  LibraryProgress
//
//  Created by Juliano Sgarbossa on 26/03/26.
//

import Foundation

protocol BookDetailViewModelDelegate: AnyObject {
    func didUpdateBook(book: Book)
}

class BookDetailViewModel {
    private weak var delegate: BookDetailViewModelDelegate?
    
    func delegate(delegate: BookDetailViewModelDelegate) {
        self.delegate = delegate
    }
    
    enum UpdateError: LocalizedError, Equatable {
        case bookNotFound
        case invalidCurrentPage

        var errorDescription: String? {
            switch self {
            case .bookNotFound:
                return "Livro não encontrado."
            case .invalidCurrentPage:
                return "Informe uma página válida para este livro."
            }
        }
    }
    
    private let bookId: UUID
    private let bookService: BookServiceProtocol

    private(set) var book: Book?

    init(bookId: UUID, bookService: BookServiceProtocol) {
        self.bookId = bookId
        self.bookService = bookService
    }

    private func updateProgress(page: Int) {
        bookService.updateProgress(bookId: bookId, currentPage: page)
        loadBook()
    }

    private func findBook() -> Book? {
        bookService.fetchBooks().first { $0.id == bookId }
    }
    
    func loadBook() {
        guard let currentBook = findBook() else { return }
        book = currentBook
        delegate?.didUpdateBook(book: currentBook)
    }

    func incrementPage() {
        guard let currentBook = book else { return }
        updateProgress(page: currentBook.currentPage + 1)
    }

    func decrementPage() {
        guard let currentBook = book else { return }
        updateProgress(page: currentBook.currentPage - 1)
    }

    func saveCurrentPage(text: String?) -> Result<Void, UpdateError> {
        guard let currentBook = book else { return .failure(.bookNotFound) }
        guard let page = Int(text ?? "") else { return .failure(.invalidCurrentPage) }
        guard page >= 0, page <= currentBook.totalPages else { return .failure(.invalidCurrentPage) }

        updateProgress(page: page)
        return .success(())
    }
}
