//
//  BookTableViewCell.swift
//  LibraryProgress
//
//  Created by Juliano Sgarbossa on 24/03/26.
//

import UIKit

protocol BookTableViewCellDelegate: AnyObject {
    func bookTableViewCellDidTapRemove(_ cell: BookTableViewCell)
}

class BookTableViewCell: UITableViewCell {

    static let identifier: String = String(describing: BookTableViewCell.self)
    
    private weak var delegate: BookTableViewCellDelegate?
    
    func delegate(delegate: BookTableViewCellDelegate) {
        self.delegate = delegate
    }
    
    private lazy var bookTableViewCellScreen: BookTableViewCellScreen = {
        let view = BookTableViewCellScreen()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addVisualElements()
        configureDelegates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addVisualElements() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(bookTableViewCellScreen)
        
        configConstraints()
    }

    private func configConstraints() {
        NSLayoutConstraint.activate([
            bookTableViewCellScreen.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            bookTableViewCellScreen.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            bookTableViewCellScreen.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bookTableViewCellScreen.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
    
    private func configureDelegates() {
        bookTableViewCellScreen.delegate(delegate: self)
    }
    
    func configCell(viewModel: BookTableViewCellViewModel) {
        bookTableViewCellScreen.titleLabel.text = "Código Limpo"
        bookTableViewCellScreen.authorLabel.text = "Robert C. Martin"
        bookTableViewCellScreen.statusLabel.text = "Vou Ler"
        bookTableViewCellScreen.progressLabel.text = "0/347 páginas(0%)"
        bookTableViewCellScreen.progressView.progress = 0.7
    }
}

extension BookTableViewCell: BookTableViewCellScreenDelegate {
    func didTapRemoveButton() {
        delegate?.bookTableViewCellDidTapRemove(self)
    }
}
