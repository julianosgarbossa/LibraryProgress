//
//  BookFormViewModel.swift
//  LibraryProgress
//
//  Created by Juliano Sgarbossa on 25/03/26.
//

import Foundation

final class BookFormViewModel {
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

    private let bookService: BookServiceProtocol

    init(bookService: BookServiceProtocol) {
        self.bookService = bookService
    }

    var screenTitle: String {
        "Novo Livro"
    }

    func save(
        title: String?,
        author: String?,
        totalPagesText: String?,
        currentPageText: String?,
        statusIndex: Int
    ) -> Result<Void, SaveError> {
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

        let book = Book(
            title: normalizedTitle,
            author: normalizedAuthor,
            totalPages: totalPages,
            currentPage: currentPage,
            status: status(from: statusIndex)
        )

        bookService.addBook(book)
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
}
