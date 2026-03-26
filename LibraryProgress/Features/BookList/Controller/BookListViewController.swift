//
//  BookListViewController.swift
//  LibraryProgress
//
//  Created by Juliano Sgarbossa on 24/03/26.
//

import UIKit

class BookListViewController: UIViewController {
    
    private var bookListScreen: BookListScreen?
    private let bookService: BookServiceProtocol
    private let bookListViewModel: BookListViewModel
    
    init(bookService: BookServiceProtocol) {
        self.bookService = bookService
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
        let formViewModel = BookFormViewModel(bookService: bookService, mode: .create)
        let formController = BookFormViewController(viewModel: formViewModel)
        formController.delegate = self
        navigationController?.pushViewController(formController, animated: true)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = bookListViewModel.book(index: indexPath.row)
        let detailViewModel = BookDetailViewModel(bookId: selectedBook.id, bookService: bookService)
        let detailController = BookDetailViewController(viewModel: detailViewModel)
        detailController.delegate(delegate: self)
        navigationController?.pushViewController(detailController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
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

// MARK: BookFormViewControllerDelegate
extension BookListViewController: BookFormViewControllerDelegate {
    func bookFormViewControllerDidSave(controller: BookFormViewController) {
        bookListViewModel.loadBooks()
    }
}

// MARK: BookDetailViewControllerDelegate
extension BookListViewController: BookDetailViewControllerDelegate {
    func bookDetailViewControllerDidTapEdit(controller: BookDetailViewController, book: Book) {
        let formViewModel = BookFormViewModel(bookService: bookService, mode: .edit(book))
        let formController = BookFormViewController(viewModel: formViewModel)
        formController.delegate = self
        controller.navigationController?.pushViewController(formController, animated: true)
    }
}
