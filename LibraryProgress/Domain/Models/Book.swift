//
//  Book.swift
//  LibraryProgress
//
//  Created by Juliano Sgarbossa on 25/03/26.
//

import Foundation

enum BookStatus: String, CaseIterable {
    case toRead
    case reading
    case finished
    
    var title: String {
        switch self {
        case .toRead:
            return "Vou Ler"
        case .reading:
            return "Lendo"
        case .finished:
            return "Finalizado"
        }
    }
}

struct Book {
    let id: UUID
    var title: String
    var author: String
    var totalPages: Int
    var currentPage: Int
    var status: BookStatus
    
    init(id: UUID = UUID(), title: String, author: String, totalPages: Int, currentPage: Int = 0, status: BookStatus = .toRead) {
        self.id = id
        self.title = title
        self.author = author
        
        // totalPages nunca pode ser 0 e currentPage fica entre 0...totalPages.
        let normalizedTotal = max(1, totalPages)
        let normalizedCurrent = min(max(0, currentPage), normalizedTotal)
        
        self.totalPages = normalizedTotal
        self.currentPage = normalizedCurrent
        
        self.status = Self.resolveStatus(requestedStatus: status, currentPage: currentPage, totalPages: totalPages)
    }
    
    // Retorna o progresso da leitura (0.0 a 1.0) com base no cálculo (currentPage/totalPages).
    var progress: Double {
        guard totalPages > 0 else { return 0 }
        return Double(currentPage) / Double(totalPages)
    }
    
    // Recalcula o status com base no progresso para manter consistência.
    private static func resolveStatus(requestedStatus: BookStatus, currentPage: Int, totalPages: Int) -> BookStatus {
        if currentPage >= totalPages {
            return .finished
        }
        
        if currentPage > 0 {
            return .reading
        }
        
        return requestedStatus
    }
    
    // Atualiza a página atual dentro dos limites válidos (0...totalPages) e recalcula o status
    mutating func setCurrentPage(page: Int) {
        let normalizedPage = min(max(0, page), totalPages)
        currentPage = normalizedPage
        status = Self.resolveStatus(requestedStatus: status, currentPage: normalizedPage, totalPages: totalPages)
    }
}
