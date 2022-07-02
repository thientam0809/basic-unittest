//
//  HomeViewController.swift
//  FinalProject
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 6/6/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK: - IBOulets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel = HomeViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        getData()
    }

    // MARK: - Private methods
    private func configTableView() {
        tableView.backgroundColor = .white
        tableView.register(HomeCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func getData() {
        HUD.show()
        viewModel.getData { [weak self] result in
            HUD.popActivity()
            guard let this = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    this.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }
}

// MARK: - Extension UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Extension UITableViewDataSource
extension HomeViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(HomeCell.self)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}
