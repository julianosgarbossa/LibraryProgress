//
//  BookServiceProtocol.swift
//  LibraryProgress
//
//  Created by Juliano Sgarbossa on 25/03/26.
//

import Foundation

protocol BookServiceProtocol: AnyObject {
    func fetchBooks() -> [Book]
    func deleteBook(bookId: UUID)
}
