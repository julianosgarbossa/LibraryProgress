//
//  BookFormScreen.swift
//  LibraryProgress
//
//  Created by Juliano Sgarbossa on 25/03/26.
//

import UIKit

protocol BookFormScreenDelegate: AnyObject {
    func didTapSaveButton()
}

class BookFormScreen: UIView {
    private weak var delegate: BookFormScreenDelegate?

    func delegate(delegate: BookFormScreenDelegate) {
        self.delegate = delegate
    }

    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Título"
        textField.borderStyle = .roundedRect
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return textField
    }()

    private lazy var authorTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Autor"
        textField.borderStyle = .roundedRect
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return textField
    }()

    private lazy var totalPagesTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Total de páginas"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return textField
    }()

    private lazy var currentPageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Página atual"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return textField
    }()

    private lazy var statusSegmentedControl: UISegmentedControl = {
        let segmented = UISegmentedControl(items: ["Vou Ler", "Lendo", "Finalizado"])
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.selectedSegmentIndex = 0
        return segmented
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Salvar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 14
        return stack
    }()

    @objc
    private func didTapSaveButton(_ sender: UIButton) {
        delegate?.didTapSaveButton()
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

        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        addInputSection(labelTitle: "Título", inputView: titleTextField)
        addInputSection(labelTitle: "Autor", inputView: authorTextField)
        addInputSection(labelTitle: "Total de páginas", inputView: totalPagesTextField)
        addInputSection(labelTitle: "Página atual", inputView: currentPageTextField)
        addInputSection(labelTitle: "Status", inputView: statusSegmentedControl)
        stackView.addArrangedSubview(saveButton)

        configConstraints()
    }

    private func configConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func addInputSection(labelTitle: String, inputView: UIView) {
        let label = UILabel()
        label.text = labelTitle
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel

        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(inputView)
    }
    
    func getFormData() -> BookFormScreenData {
        BookFormScreenData(title: titleTextField.text,
                           author: authorTextField.text,
                           totalPagesText: totalPagesTextField.text,
                           currentPageText: currentPageTextField.text,
                           statusIndex: statusSegmentedControl.selectedSegmentIndex)
    }
}
