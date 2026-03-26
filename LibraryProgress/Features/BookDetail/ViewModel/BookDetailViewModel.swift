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

final class BookDetailViewModel {
    private weak var delegate: BookDetailViewModelDelegate?
    
    func setDelegate(_ delegate: BookDetailViewModelDelegate) {
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

    // Atualiza no service e recarrega o livro para manter a UI sincronizada.
    private func updateProgress(page: Int) {
        bookService.updateProgress(bookId: bookId, currentPage: page)
        loadBook()
    }

    // Busca sempre no service para evitar estado local desatualizado.
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
        // Limites são normalizados no modelo/service.
        updateProgress(page: currentBook.currentPage + 1)
    }

    func decrementPage() {
        guard let currentBook = book else { return }
        // Limites são normalizados no modelo/service.
        updateProgress(page: currentBook.currentPage - 1)
    }

    func saveCurrentPage(from text: String?) -> Result<Void, UpdateError> {
        guard let currentBook = book else { return .failure(.bookNotFound) }
        let normalizedText = (text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        // Entrada manual exige número inteiro válido.
        guard let page = Int(normalizedText) else { return .failure(.invalidCurrentPage) }
        guard page >= 0, page <= currentBook.totalPages else { return .failure(.invalidCurrentPage) }

        updateProgress(page: page)
        return .success(())
    }
}
