//
//  SettingViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/28.
//

import UIKit

protocol SettingViewDelegate: AnyObject {
    
    func didSettingChanged()
    
}

final class SettingViewController: UIViewController {
    
    weak var settingViewdelegate: SettingViewDelegate?
    
    private var viewModel = SettingViewModel()
    
    private lazy var navigationBar: UINavigationBar = {
        let statusBarHeight: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        let bar = UINavigationBar(
            frame: .init(
                x: 0,
                y: 0,
                width: view.frame.width,
                height: statusBarHeight))
        bar.isTranslucent = false
        bar.backgroundColor = .systemBackground
        return bar
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "나라 검색"
        searchBar.delegate = self
        return searchBar
    }()
    
    private let countryTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureCountryTableView()
        configureLayout()
        view.backgroundColor = .white
    }
    
    private func configureLayout() {
        view.addSubview(navigationBar)
        view.addSubview(searchBar)
        view.addSubview(countryTableView)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countryTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            countryTableView.topAnchor.constraint(
                equalTo: searchBar.bottomAnchor),
            countryTableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor),
            countryTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        let navigationItem = UINavigationItem(title: viewModel.navigationBarTitle)
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissWithSaving))
        let cancelButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(dismissView))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
        navigationBar.items = [navigationItem]
    }
    
    private func configureCountryTableView() {
        countryTableView.delegate = self
        countryTableView.dataSource = self
        countryTableView.register(cellWithClass: UITableViewCell.self)
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
    
    @objc func dismissWithSaving() {
        self.saveSetting()
        self.dismiss(animated: true) { [weak self] in
            self?.settingViewdelegate?.didSettingChanged()
        }
    }
    
    private func saveSetting() {
        viewModel.saveSetting()
    }
    
}

// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
    -> Int
    {
        return viewModel.numberOfCountry()
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(
            withClass: UITableViewCell.self,
            for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = viewModel.countryName(at: indexPath.row)
        configuration.secondaryText = viewModel.countryFlag(at: indexPath.row)
        cell.contentConfiguration = configuration
        
        if viewModel.selectedCountryIndex == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension SettingViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
            viewModel.didSelectCountry(at: indexPath)
            tableView.reloadData()
        }
    
}

// MARK: - UISearchBarDelegate

extension SettingViewController: UISearchBarDelegate {
    
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String)
    {
        viewModel.searchBarTextDidChange(to: searchText)
        countryTableView.reloadData()
    }
    
}
