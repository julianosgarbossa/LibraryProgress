//
//  BookTableViewCellViewModel.swift
//  LibraryProgress
//
//  Created by Juliano Sgarbossa on 24/03/26.
//

import Foundation

class BookTableViewCellViewModel {
    let titleText: String
    let authorText: String
    let statusText: String
    let progressText: String
    let progressValue: Float
    
    init(book: Book) {
        self.titleText = book.title
        self.authorText = book.author
        self.statusText = book.status.title
        
        // Converte o progresso (0...1) em porcentagem arredondada
        let percent = Int((book.progress * 100).rounded())
        
        self.progressText = "\(book.currentPage)/\(book.totalPages) páginas (\(percent)%)"
        self.progressValue = Float(book.progress)
    }
}
