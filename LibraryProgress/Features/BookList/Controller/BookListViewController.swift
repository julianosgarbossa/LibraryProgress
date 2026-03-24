//
//  BookListViewController.swift
//  LibraryProgress
//
//  Created by Juliano Sgarbossa on 24/03/26.
//

import UIKit

class BookListViewController: UIViewController {
    
    private var bookListScreen: BookListScreen?
    
    override func loadView() {
        bookListScreen = BookListScreen()
        view = bookListScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
    }
    
    private func configureNavigation() {
        title = "Minha Biblioteca"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    private func configureDelegates() {

    }
    
    @objc
    private func didTapAdd(_ sender: UIBarButtonItem) {
        print("Navegar para tela de adicionar livro")
    }
}
