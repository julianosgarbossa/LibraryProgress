//
//  BookListScreen.swift
//  LibraryProgress
//
//  Created by Juliano Sgarbossa on 24/03/26.
//

import UIKit

protocol BookListScreenDelegate: AnyObject {
    func didChangeFilter(index: Int)
}

class BookListScreen: UIView {
    
    private weak var delegate: BookListScreenDelegate?

    func delegate(delegate: BookListScreenDelegate) {
        self.delegate = delegate
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Buscar livro pelo nome"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private lazy var filterSegmentedControl: UISegmentedControl = {
        let segmented = UISegmentedControl(items: ["Todos", "Vou Ler", "Lendo", "Finalizados"])
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.selectedSegmentIndex = 0
        segmented.addTarget(self, action: #selector(didChangeFilter), for: .valueChanged)
        return segmented
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nenhum livro encontrado neste filtro"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    @objc
    private func didChangeFilter(_ sender: UISegmentedControl) {
        delegate?.didChangeFilter(index: sender.selectedSegmentIndex)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addVisualElements()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addVisualElements() {
        backgroundColor = .systemGroupedBackground

        addSubview(searchBar)
        addSubview(filterSegmentedControl)
        addSubview(tableView)
        addSubview(emptyStateLabel)
        
        configConstraints()
    }

    private func configConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            filterSegmentedControl.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            filterSegmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            filterSegmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: filterSegmentedControl.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            emptyStateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 24),
            emptyStateLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -24)
        ])
    }
    
    func setupSearchBarDelegate(_ delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }
    
    func setupTableView(dataSource: UITableViewDataSource, delegate: UITableViewDelegate) {
        tableView.dataSource = dataSource
        tableView.delegate = delegate
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
}
