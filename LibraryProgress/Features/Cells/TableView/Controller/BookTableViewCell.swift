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
        bookTableViewCellScreen.titleLabel.text = viewModel.titleText
        bookTableViewCellScreen.authorLabel.text = viewModel.authorText
        bookTableViewCellScreen.statusLabel.text = viewModel.statusText
        bookTableViewCellScreen.progressLabel.text = viewModel.progressText
        bookTableViewCellScreen.progressView.progress = viewModel.progressValue
    }
}

extension BookTableViewCell: BookTableViewCellScreenDelegate {
    func didTapRemoveButton() {
        delegate?.bookTableViewCellDidTapRemove(self)
    }
}
