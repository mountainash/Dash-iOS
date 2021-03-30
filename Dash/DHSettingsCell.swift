//
//  DHPreferenceCell.swift
//  Dash iOS
//
//  Created by chenhaoyu.1999 on 2021/3/29.
//  Copyright © 2021 Kapeli. All rights reserved.
//

import Foundation

@objcMembers class DHSettingsCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        for subview in contentView.subviews {
            if let label = subview as? UILabel {
                label.textColor = UIColor.label
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .tertiarySystemBackground
    }
    
    
}
