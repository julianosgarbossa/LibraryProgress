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
    
    private(set) var books: [Book] = [Book(title: "Arquitetura Limpa",
                                           author: "Robert C. Martin",
                                           totalPages: 432,
                                           currentPage: 0,
                                           status: .toRead),
                                      Book(title: "O Programador Pragmático",
                                           author: "Andrew Hunt & David Thomas",
                                           totalPages: 352,
                                           currentPage: 0,
                                           status: .toRead),
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
                                           currentPage: 0,
                                           status: .toRead),
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
                                           currentPage: 0,
                                           status: .toRead)
    
    
    ]
    
    var numberOfItems: Int {
        books.count
    }
    
    func loadBooks() {
        delegate?.didUpdateBooks()
    }
    
    func book(index: Int) -> Book {
        books[index]
    }
    
    func cellViewModel(index: Int) -> BookTableViewCellViewModel {
        BookTableViewCellViewModel(book: books[index])
    }
    
    func deleteBook(at index: Int) {
        books.remove(at: index)
        loadBooks()
    }
}
