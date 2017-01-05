//
//  MoreCell.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 8/16/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit

class MoreCell: UITableViewCell {

    @IBOutlet weak var btnImage: UIButton!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbExtend: UILabel!
    
    
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
