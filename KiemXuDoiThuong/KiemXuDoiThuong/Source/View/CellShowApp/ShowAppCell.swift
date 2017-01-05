//
//  ShowAppCell.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/19/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit

class ShowAppCell: UITableViewCell {

    @IBOutlet weak var imv_appIcon: UIImageView!
    
    @IBOutlet weak var lbTitleApp: UILabel!
    
    @IBOutlet weak var lbCoin: UILabel!
    
    @IBOutlet weak var lbDes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
