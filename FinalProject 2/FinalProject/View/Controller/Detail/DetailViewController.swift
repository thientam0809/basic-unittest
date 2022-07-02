//
//  DetailViewController.swift
//  FinalProject
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 6/9/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {

    // MARK: - IBOulets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel = DetailViewModel()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
//        getDataCovid()
        viewModel.handleStub {
            self.getDataCovid()
        }
    }

    // MARK: - Private methods
    private func configTableView() {
        tableView.register(DetailCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
    }

    private func getDataCovid() {
        HUD.show()
        viewModel.getDataCovid { [weak self] result in
            HUD.dismiss()
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

// MARK: - Extension UITableViewDelegate, UITalbeViewDataSource
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(DetailCell.self)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}
