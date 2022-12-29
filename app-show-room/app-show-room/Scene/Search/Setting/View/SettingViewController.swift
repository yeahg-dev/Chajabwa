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

class SettingViewController: UIViewController {
    
    var settingViewdelegate: SettingViewDelegate?
    
    private let viewModel = SettingViewModel()
    private lazy var selectedIndex: Int = viewModel.selectedCountryIndex
    
    private lazy var navigationBar: UINavigationBar = {
        let statusBarHeight: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
        let bar = UINavigationBar(
            frame: .init(
                x: 0,
                y: statusBarHeight,
                width: view.frame.width,
                height: statusBarHeight))
        bar.isTranslucent = false
        bar.backgroundColor = .systemBackground
        return bar
    }()
    
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
        view.addSubview(navigationBar)
        view.addSubview(countryTableView)
        NSLayoutConstraint.activate([
            countryTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            countryTableView.topAnchor.constraint(
                equalTo: navigationBar.bottomAnchor),
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
            let beforeSelectedIndex = IndexPath(row: selectedIndex, section: 0)
            selectedIndex = indexPath.row
            tableView.reloadRows(
                at: [indexPath, beforeSelectedIndex],
                with: .fade)
        }
    
}
