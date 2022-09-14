//
//  CustomTableViewCell.swift
//  LanarsTestTask
//
//  Created by Yaroslav Shepilov on 02.03.2022.
//

import UIKit

protocol CustomTableViewCellDelegate {
    func didAddToFavorite(index: Int)
}

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var inageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var workPlaceNumberLabel: UILabel!
    @IBOutlet weak var receptionHoursLabel: UILabel!
    @IBOutlet weak var accountantType: UILabel!
    @IBOutlet weak var lunchTimeLabel: UILabel!
    
    private var index: Int?
    var delegate: CustomTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        workPlaceNumberLabel.isHidden = true
        lunchTimeLabel.isHidden = true
        receptionHoursLabel.isHidden = true
        accountantType.isHidden = true
    }
}


