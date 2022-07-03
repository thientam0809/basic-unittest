//
//  DetailCell.swift
//  FinalProject
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 6/9/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class DetailCell: UITableViewCell {

    // MARK: - IBOulets
    @IBOutlet private weak var areaLabel: UILabel!
    @IBOutlet private weak var numberDeathLabel: UILabel!

    // MARK: - Properties
    var viewModel: DetailCellViewModel? {
        didSet {
            updateView()
        }
    }

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .systemGray
    }

    // MARK: - Private methods
    private func updateView() {
        guard let viewModel = viewModel, let item = viewModel.item else { return }
        areaLabel.text = item.areaName
        numberDeathLabel.text = String(item.death)
    }
}
