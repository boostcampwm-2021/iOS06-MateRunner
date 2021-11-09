//
//  MateTableViewCell.swift
//  MateRunner
//
//  Created by 이유진 on 2021/11/09.
//

import UIKit

class MateTableViewCell: UITableViewCell {
    static let identifier = "mateTableViewCell"
    
    private lazy var mateProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50
        return imageView
    }()
    
    private lazy var mateNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.notoSans(size: 16, family: .medium)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
