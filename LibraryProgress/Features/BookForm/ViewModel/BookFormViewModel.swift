//
//  BookFormViewModel.swift
//  LibraryProgress
//
//  Created by Juliano Sgarbossa on 25/03/26.
//

import Foundation

final class BookFormViewModel {
    enum Mode {
        case create
        case edit(Book)
    }

    enum SaveError: LocalizedError, Equatable {
        case emptyTitle
        case emptyAuthor
        case invalidTotalPages
        case invalidCurrentPage

        var errorDescription: String? {
            switch self {
            case .emptyTitle:
                return "Informe o título do livro."
            case .emptyAuthor:
                return "Informe o autor do livro."
            case .invalidTotalPages:
                return "Informe um total de páginas válido (maior que zero)."
            case .invalidCurrentPage:
                return "Página atual inválida para o total informado."
            }
        }
    }

    struct FormData {
        let title: String
        let author: String
        let totalPages: String
        let currentPage: String
        let statusIndex: Int
    }

    private let bookService: BookServiceProtocol
    let mode: Mode

    init(bookService: BookServiceProtocol, mode: Mode) {
        self.bookService = bookService
        self.mode = mode
    }

    var screenTitle: String {
        switch mode {
        case .create:
            return "Novo Livro"
        case .edit:
            return "Editar Livro"
        }
    }

    func initialData() -> FormData? {
        guard case .edit(let book) = mode else { return nil }

        return FormData(title: book.title,
                        author: book.author,
                        totalPages: String(book.totalPages),
                        currentPage: String(book.currentPage),
                        statusIndex: statusIndex(from: book.status))
    }

    func save(title: String?, author: String?, totalPagesText: String?, currentPageText: String?, statusIndex: Int) -> Result<Void, SaveError> {
        let normalizedTitle = title?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let normalizedAuthor = author?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        guard !normalizedTitle.isEmpty else { return .failure(.emptyTitle) }
        guard !normalizedAuthor.isEmpty else { return .failure(.emptyAuthor) }

        guard let totalPages = Int(totalPagesText ?? ""), totalPages > 0 else {
            return .failure(.invalidTotalPages)
        }

        let currentPage = Int(currentPageText ?? "") ?? 0
        guard currentPage >= 0, currentPage <= totalPages else {
            return .failure(.invalidCurrentPage)
        }

        switch mode {
        case .create:
            let newBook = Book(title: normalizedTitle,
                               author: normalizedAuthor,
                               totalPages: totalPages,
                               currentPage: currentPage,
                               status: status(from: statusIndex))
            
            bookService.addBook(newBook)
        case .edit(let existingBook):
            let updatedBook = Book(id: existingBook.id,
                                   title: normalizedTitle,
                                   author: normalizedAuthor,
                                   totalPages: totalPages,
                                   currentPage: currentPage,
                                   status: status(from: statusIndex))
            
            bookService.updateBook(updatedBook)
        }
        return .success(())
    }

    private func status(from index: Int) -> BookStatus {
        switch index {
        case 1:
            return .reading
        case 2:
            return .finished
        default:
            return .toRead
        }
    }

    private func statusIndex(from status: BookStatus) -> Int {
        switch status {
        case .toRead:
            return 0
        case .reading:
            return 1
        case .finished:
            return 2
        }
    }
}
