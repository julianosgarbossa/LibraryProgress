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
        configureDelegates()
    }
    
    private func configureNavigation() {
        title = "Minha Biblioteca"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    private func configureDelegates() {
        bookListScreen?.setupSearchBarDelegate(self)
        bookListScreen?.delegate(delegate: self)
        bookListScreen?.setupTableView(dataSource: self, delegate: self)
    }
    
    @objc
    private func didTapAdd(_ sender: UIBarButtonItem) {
        print("Navegar para tela de adicionar livro")
    }
}

// MARK: SearchBarDelegate
extension BookListViewController: UISearchBarDelegate {
    
}

// MARK: BookListScreenDelegate
extension BookListViewController: BookListScreenDelegate {
    func didChangeFilter(index: Int) {
        print("Filtro alterado - index: \(index)")
    }
}

// MARK: TableViewDelegate
extension BookListViewController: UITableViewDelegate {
    
}

// MARK: TableViewDataSource
extension BookListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier, for: indexPath) as? BookTableViewCell else { return UITableViewCell() }
        cell.configCell(viewModel: BookTableViewCellViewModel())
        cell.delegate(delegate: self)
        return cell
    }
}

extension BookListViewController: BookTableViewCellDelegate {
    func bookTableViewCellDidTapRemove(_ cell: BookTableViewCell) {
        print("Remover célula")
    }
}
