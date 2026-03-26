//
//  BookFormViewController.swift
//  LibraryProgress
//
//  Created by Juliano Sgarbossa on 25/03/26.
//

import UIKit

protocol BookFormViewControllerDelegate: AnyObject {
    func bookFormViewControllerDidSave(_ controller: BookFormViewController)
}

final class BookFormViewController: UIViewController {
    private let bookFormScreen = BookFormScreen()
    private let bookFormViewModel: BookFormViewModel

    weak var delegate: BookFormViewControllerDelegate?

    init(viewModel: BookFormViewModel) {
        self.bookFormViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = bookFormScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = bookFormViewModel.screenTitle
        bookFormScreen.setDelegate(self)
        setupTapToDismissKeyboard()
        configureDataIfNeeded()
    }

    private func configureDataIfNeeded() {
        guard let formData = bookFormViewModel.initialData() else { return }
        bookFormScreen.apply(formData: formData)
    }

    private func saveBook() {
        view.endEditing(true)
        let formData = bookFormScreen.getFormData()
        
        let result = bookFormViewModel.save(title: formData.title,
                                            author: formData.author,
                                            totalPagesText: formData.totalPagesText,
                                            currentPageText: formData.currentPageText,
                                            statusIndex: formData.statusIndex
        )

        switch result {
        case .success:
            delegate?.bookFormViewControllerDidSave(self)
            navigationController?.popViewController(animated: true)
        case .failure(let error):
            showAlert(message: error.localizedDescription)
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Atenção", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func setupTapToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapToDismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc
    private func didTapToDismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: BookFormScreenDelegate
extension BookFormViewController: BookFormScreenDelegate {
    func didTapSaveButton() {
        saveBook()
    }
}
