//
//  CompanyTableViewCell.swift
//  empresas-ios
//
//  Created by Henrique Barbosa on 07/04/21.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {

// MARK: - IBOutlets

    @IBOutlet weak var companyBackgroundView: UIView!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var companyImage: UIImageView!

// MARK: - LifeCycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

// MARK: - Layout

extension CompanyTableViewCell {

    override func layoutSubviews() {
        super.layoutSubviews()
        companyBackgroundView.frame = companyBackgroundView.frame
            .inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0))
    }
}
