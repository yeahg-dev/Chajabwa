//
//  SettingViewController.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/12/28.
//

import UIKit

protocol SettingViewDelegate {
    
    func didSettingChanged()
    
}

class SettingViewController: UINavigationController {
    
    var settingViewdelegate: SettingViewDelegate?
    
    private let viewModel = SettingViewModel()
    private lazy var selectedIndex: Int = viewModel.selectedCountryIndex
    
    private let countryTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureNavigationBar()
        countryTableView.delegate = self
        countryTableView.dataSource = self
    }
    
    private func configureLayout() {
        view.addSubview(countryTableView)
        NSLayoutConstraint.activate([
            countryTableView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            countryTableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            countryTableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            countryTableView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.title = viewModel.navigationBarTitle
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
        viewModel.didSelectCountry(at: selectedIndex)
    }
    
}

// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int)
    -> Int
    {
        return Country.list.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
    {
        let cell = UITableViewCell()
        var configuration = cell.defaultContentConfiguration()
        configuration.text = viewModel.countryName(at: indexPath.row)
        configuration.secondaryText = viewModel.countryFlag(at: indexPath.row)
        cell.contentConfiguration = configuration
        
        if selectedIndex == indexPath.row {
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
            tableView.deselectRow(at: indexPath, animated: false)
            selectedIndex = indexPath.row
        }
    
}
