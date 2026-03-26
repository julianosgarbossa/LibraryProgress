//
//  BookDetailViewController.swift
//  LibraryProgress
//
//  Created by Juliano Sgarbossa on 26/03/26.
//

import UIKit

protocol BookDetailViewControllerDelegate: AnyObject {
    func bookDetailViewControllerDidTapEdit(controller: BookDetailViewController, book: Book)
}

class BookDetailViewController: UIViewController {
    private var bookDetailScreen: BookDetailScreen?
    private let bookDetailViewModel: BookDetailViewModel
    private weak var delegate: BookDetailViewControllerDelegate?
    
    func delegate(delegate: BookDetailViewControllerDelegate) {
        self.delegate = delegate
    }

    init(viewModel: BookDetailViewModel) {
        self.bookDetailViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        bookDetailScreen = BookDetailScreen()
        view = bookDetailScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureDelegates()
        bookDetailViewModel.loadBook()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookDetailViewModel.loadBook()
    }
    
    private func configureNavigation() {
        title = "Detalhes"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Editar",
            style: .plain,
            target: self,
            action: #selector(didTapEdit)
        )
    }
    
    private func configureDelegates() {
        bookDetailScreen?.delegate(delegate: self)
        bookDetailViewModel.delegate(delegate: self)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Atenção", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc
    private func didTapEdit() {
        guard let currentBook = bookDetailViewModel.book else { return }
        delegate?.bookDetailViewControllerDidTapEdit(controller: self, book: currentBook)
    }
}

// MARK: BookDetailScreenDelegate
extension BookDetailViewController: BookDetailScreenDelegate {
    func didTapIncreasePageButton() {
        bookDetailViewModel.incrementPage()
    }

    func didTapDecreasePageButton() {
        bookDetailViewModel.decrementPage()
    }

    func didTapSaveProgressButton() {
        let result = bookDetailViewModel.saveCurrentPage(text: bookDetailScreen?.currentPageText())

        if case let .failure(error) = result {
            showAlert(message: error.localizedDescription)
        }
    }
}

// MARK: BookDetailViewModelDelegate
extension BookDetailViewController: BookDetailViewModelDelegate {
    func didUpdateBook(book: Book) {
        bookDetailScreen?.display(book: book)
    }
}
