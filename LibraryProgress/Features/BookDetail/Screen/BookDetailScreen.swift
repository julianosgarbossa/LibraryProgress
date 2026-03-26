//
//  BookDetailScreen.swift
//  LibraryProgress
//
//  Created by Juliano Sgarbossa on 26/03/26.
//

import UIKit

protocol BookDetailScreenDelegate: AnyObject {
    func didTapIncreasePageButton()
    func didTapDecreasePageButton()
    func didTapSaveProgressButton()
}

final class BookDetailScreen: UIView {
    private weak var delegate: BookDetailScreenDelegate?

    func setDelegate(_ delegate: BookDetailScreenDelegate) {
        self.delegate = delegate
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 2
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemBlue
        return label
    }()

    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.trackTintColor = .systemGray5
        progress.progressTintColor = .systemGreen
        return progress
    }()

    private lazy var currentPageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.placeholder = "Página atual"
        return textField
    }()

    private lazy var decreaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("-1 página", for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(didTapDecreaseButton), for: .touchUpInside)
        return button
    }()

    private lazy var increaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+1 página", for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(didTapIncreaseButton), for: .touchUpInside)
        return button
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Salvar progresso", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 14
        return stack
    }()

    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        return stack
    }()

    @objc
    private func didTapIncreaseButton(_ sender: UIButton) {
        delegate?.didTapIncreasePageButton()
    }

    @objc
    private func didTapDecreaseButton(_ sender: UIButton) {
        delegate?.didTapDecreasePageButton()
    }

    @objc
    private func didTapSaveButton(_ sender: UIButton) {
        delegate?.didTapSaveProgressButton()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addVisualElements()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addVisualElements() {
        backgroundColor = .systemBackground

        addSubview(stackView)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(statusLabel)
        stackView.addArrangedSubview(progressLabel)
        stackView.addArrangedSubview(progressView)
        stackView.addArrangedSubview(currentPageTextField)

        buttonStackView.addArrangedSubview(decreaseButton)
        buttonStackView.addArrangedSubview(increaseButton)
        stackView.addArrangedSubview(buttonStackView)
        stackView.addArrangedSubview(saveButton)

        configConstraints()
    }

    private func configConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    func display(book: Book) {
        titleLabel.text = book.title
        authorLabel.text = "Autor: \(book.author)"
        statusLabel.text = "Status: \(book.status.title)"

        let percentage = Int((book.progress * 100).rounded())
        progressLabel.text = "Progresso: \(book.currentPage)/\(book.totalPages) páginas (\(percentage)%)"
        progressView.progress = Float(book.progress)
        currentPageTextField.text = String(book.currentPage)
    }

    func currentPageText() -> String? {
        currentPageTextField.text
    }
}
