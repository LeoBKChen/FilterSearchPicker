//
//  FilterPickerViewController.swift
//  FilterPickerViewController
//
//  Created by 陳邦亢 on 2023/6/29.
//

import Foundation
import UIKit
import Combine

class FilterSearchPickerViewController: UIViewController {
    // MARK: - Constants
    private let iconPadding: CGFloat = 12
    private let iconHeight: CGFloat = 16
    
    var sourceTextField: UITextField?
    var cancellable = Set<AnyCancellable>()
    
    let viewModel: FilterSearchPickerViewModel
    
    
    // MARK: - view components
    lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.title
        label.font = viewModel.config.titleFont
        label.textColor = viewModel.config.titleTextColor
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle(viewModel.config.closeButtonText, for: .normal)
        button.setTitleColor(viewModel.config.closeButtonTextColor, for: .normal)
        button.titleLabel?.font = viewModel.config.closeButtonFont
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self

        searchBar.searchTextField.backgroundColor = viewModel.config.searchBarBackgroundColor
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: viewModel.placeHolder,
            attributes: [
                NSAttributedString.Key.foregroundColor:
                    viewModel.config.searchBarPlaceholderColor
            ]
        )
        searchBar.searchTextField.clearButtonMode = .whileEditing

        return searchBar
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = viewModel.config.separatorColor
        return view
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    private lazy var tableViewDataSource = makeDataSource()
    
    // MARK: - setup views
    private func setSearchIcon(_ textField: UITextField) {
        let outerView =
            UIView(frame: CGRect(x: iconPadding, y: 0, width: iconHeight + (iconPadding * 2), height: iconHeight))
        let iconView = UIImageView(frame: CGRect(x: iconPadding, y: 0, width: iconHeight, height: iconHeight))
        iconView.image = viewModel.config.searchBarLeftImage
        outerView.addSubview(iconView)
        textField.leftView = outerView
        textField.leftViewMode = .always
    }
    
    func setupViews() {
        
        tableView.dataSource = self.tableViewDataSource
        tableView.delegate = self
        tableView.register(UINib(nibName: FSPTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FSPTableViewCell.identifier)
        
        headerView.addSubviews(
            titleLabel,
            closeButton,
            searchBar,
            separatorView
        )
        view.addSubviews(tableView, headerView)
        
        searchBar.searchTextField.becomeFirstResponder()
    }

    func setupLayouts() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 132).isActive = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 21).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20).isActive = true

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 23).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20).isActive = true
        searchBar.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -21).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20).isActive = true

        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
    }
    
    // MARK: - init
    init(viewModel: FilterSearchPickerViewModel = FilterSearchPickerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - vc life
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setup() {
        setupViews()
        setupLayouts()
        binding()
    }
    
    func show(on view: UIView) {
        
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
}

extension FilterSearchPickerViewController {
    func binding() {
        
        viewModel.$dataSource
            .combineLatest(viewModel.$filterString)
            .receive(on: RunLoop.main)
            .sink { [weak self] viewModel, filter in
                guard let self = self,
                      viewModel.count != 0
                else { return }
                
                var snapshot = NSDiffableDataSourceSnapshot<String, FSPCellViewModel>()
                
                snapshot.appendSections(["testSection"])
                
                if (!filter.isEmpty) {
                    snapshot.appendItems(viewModel.filter {
                        $0.content.localizedCaseInsensitiveContains(filter)
                    })
                }
                else {
                    snapshot.appendItems(viewModel)
                }
                
                self.tableViewDataSource.apply(snapshot, animatingDifferences: true)
                
            }
            .store(in: &cancellable)
    }
}

extension FilterSearchPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard tableViewDataSource.snapshot().itemIdentifiers.indices.contains(indexPath.row) else { return }
        
        let cellViewModel = tableViewDataSource.snapshot().itemIdentifiers[indexPath.row]
        
        print("onclick: \(cellViewModel.content)")
        viewModel.tapOnCell.send(cellViewModel)
        
        self.close()
    }
}

// MARK: - UITableView DiffableData Source
fileprivate extension FilterSearchPickerViewController {
    
    func makeDataSource() -> UITableViewDiffableDataSource<String, FSPCellViewModel> {
        
        return UITableViewDiffableDataSource(
            tableView: tableView) { tableView, indexPath, cellViewModel in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FSPTableViewCell.self), for: indexPath) as? FSPTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(with: cellViewModel)
                
                return cell
            }
    }
}

extension FilterSearchPickerViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterTextChanged(to: searchText)
    }
}
