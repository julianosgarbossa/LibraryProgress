//
//  BookListViewController.swift
//  LibraryProgress
//
//  Created by Juliano Sgarbossa on 24/03/26.
//

import UIKit

class BookListViewController: UIViewController {
    
    private var bookListScreen: BookListScreen?
    private let bookListViewModel: BookListViewModel
    
    init(bookService: BookServiceProtocol) {
        self.bookListViewModel = BookListViewModel(bookService: bookService)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        bookListScreen = BookListScreen()
        view = bookListScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureDelegates()
        bookListViewModel.loadBooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookListViewModel.loadBooks()
    }
    
    private func configureNavigation() {
        title = "Minha Biblioteca"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    private func configureDelegates() {
        bookListScreen?.setupSearchBarDelegate(self)
        bookListScreen?.delegate(delegate: self)
        bookListScreen?.setupTableView(dataSource: self, delegate: self)
        bookListViewModel.delegate(delegate: self)
    }
    
    @objc
    private func didTapAdd(_ sender: UIBarButtonItem) {
        print("Navegar para tela de adicionar livro")
    }
}

// MARK: SearchBarDelegate
extension BookListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        bookListViewModel.setSearchText(text: searchText)
    }
}

// MARK: BookListScreenDelegate
extension BookListViewController: BookListScreenDelegate {
    func didChangeFilter(index: Int) {
        bookListViewModel.setFilter(index: index)
    }
}

// MARK: TableViewDelegate
extension BookListViewController: UITableViewDelegate {
    
}

// MARK: TableViewDataSource
extension BookListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookListViewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier, for: indexPath) as? BookTableViewCell else { return UITableViewCell() }
        cell.configCell(viewModel: bookListViewModel.cellViewModel(index: indexPath.row))
        cell.delegate(delegate: self)
        return cell
    }
}

// MARK: BookTableViewCellDelegate
extension BookListViewController: BookTableViewCellDelegate {
    func bookTableViewCellDidTapRemove(_ cell: BookTableViewCell) {
        guard let indexPath = bookListScreen?.indexPath(for: cell) else { return }
        bookListViewModel.deleteBook(at: indexPath.row)
    }
}

// MARK: BookListViewModelDelegate
extension BookListViewController: BookListViewModelDelegate {
    func didUpdateBooks() {
        bookListScreen?.reloadTableView()
        bookListScreen?.setEmptyStateVisible(visible: bookListViewModel.numberOfItems == 0)
    }
}
