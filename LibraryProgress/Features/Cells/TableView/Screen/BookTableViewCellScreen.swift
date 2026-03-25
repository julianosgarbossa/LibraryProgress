//
//  BookTableViewCellScreen.swift
//  LibraryProgress
//
//  Created by Juliano Sgarbossa on 24/03/26.
//

import UIKit

protocol BookTableViewCellScreenDelegate: AnyObject {
    func didTapRemoveButton()
}

class BookTableViewCellScreen: UIView {

    private weak var delegate: BookTableViewCellScreenDelegate?

    func delegate(delegate: BookTableViewCellScreenDelegate) {
        self.delegate = delegate
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()

    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()

    lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .systemBlue
        return label
    }()

    lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        return label
    }()

    lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.trackTintColor = .systemGray5
        progress.progressTintColor = .systemGreen
        return progress
    }()

    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Remover", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .caption1)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(didTapRemoveButton), for: .touchUpInside)
        return button
    }()

    private lazy var infoStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 6
        return stack
    }()

    @objc
    private func didTapRemoveButton(_ sender: UIButton) {
         delegate?.didTapRemoveButton()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addVisualElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addVisualElements() {
        addSubview(infoStack)
        infoStack.addArrangedSubview(titleLabel)
        infoStack.addArrangedSubview(authorLabel)
        infoStack.addArrangedSubview(statusLabel)
        infoStack.addArrangedSubview(progressLabel)
        infoStack.addArrangedSubview(progressView)
        infoStack.addArrangedSubview(removeButton)
        
        configConstraints()
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            infoStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            infoStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            infoStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            infoStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
}
