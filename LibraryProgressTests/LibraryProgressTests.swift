//
//  LibraryProgressTests.swift
//  LibraryProgressTests
//
//  Created by Juliano Sgarbossa on 26/03/26.
//

import XCTest
@testable import LibraryProgress

@MainActor
final class LibraryProgressTests: XCTestCase {

    func testBookInit_normalizesInvalidValues() {
        // Regra de negócio:
        // totalPages não pode ser menor que 1 e currentPage deve ficar no intervalo válido.
        let book = Book(title: "Livro",
                        author: "Autor",
                        totalPages: 0,
                        currentPage: 50,
                        status: .toRead)

        XCTAssertEqual(book.totalPages, 1)
        XCTAssertEqual(book.currentPage, 1)
    }

    func testBookSetCurrentPage_whenBackToZero_setsStatusToToRead() {
        // Regra de negócio:
        // ao voltar progresso para 0, o status base esperado deve ser "Vou Ler".
        var book = Book(title: "Livro",
                        author: "Autor",
                        totalPages: 100,
                        currentPage: 30,
                        status: .reading)

        book.setCurrentPage(page: 0)

        switch book.status {
        case .toRead:
            XCTAssertTrue(true)
        default:
            XCTFail("O status deveria voltar para .toRead quando currentPage for 0.")
        }
    }

    func testBookInit_whenCurrentPageEqualsTotal_setsStatusToFinished() {
        // Regra de negócio:
        // ao iniciar livro com currentPage igual ao total, o status deve ser "Finalizado".
        let book = Book(title: "Livro",
                        author: "Autor",
                        totalPages: 100,
                        currentPage: 100,
                        status: .toRead)

        switch book.status {
        case .finished:
            XCTAssertTrue(true)
        default:
            XCTFail("O status deveria ser .finished quando currentPage == totalPages.")
        }
    }

    func testBookSetCurrentPage_whenExceedsTotal_clampsToTotalAndFinished() {
        // Regra de negócio:
        // ao definir página acima do total, currentPage deve ser limitado ao total e status deve ficar finalizado.
        var book = Book(title: "Livro",
                        author: "Autor",
                        totalPages: 120,
                        currentPage: 10,
                        status: .reading)

        book.setCurrentPage(page: 999)

        XCTAssertEqual(book.currentPage, 120)
        switch book.status {
        case .finished:
            XCTAssertTrue(true)
        default:
            XCTFail("O status deveria ser .finished quando currentPage atinge totalPages.")
        }
    }

    func testBookProgress_returnsExpectedFraction() {
        // Regra de negócio:
        // progresso deve refletir a fração currentPage/totalPages.
        let book = Book(title: "Livro",
                        author: "Autor",
                        totalPages: 200,
                        currentPage: 50,
                        status: .reading)

        XCTAssertEqual(book.progress, 0.25, accuracy: 0.0001)
    }
}
