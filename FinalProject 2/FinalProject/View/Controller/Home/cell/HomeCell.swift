//
//  HomeCell.swift
//  FinalProject
//
//  Created by Tam Nguyen K.T. [7] VN.Danang on 6/6/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class HomeCell: UITableViewCell {

    // MARK: - IBOUlets
    @IBOutlet private weak var nameLabel: UILabel!

    // MARK: - Properties
    var viewModel: HomeCellViewModel? {
        didSet {
            updateView()
        }
    }

    // MARK: - Override methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Private methods
    private func updateView() {
        guard let viewModel = viewModel, let item = viewModel.item else { return }
        nameLabel.text = item.name
        backgroundColor = viewModel.isEven() ? .brown : .red
    }
}
