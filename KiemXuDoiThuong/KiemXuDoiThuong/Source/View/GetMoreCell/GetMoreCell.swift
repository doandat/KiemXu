//
//  GetMoreCell.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 10/24/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit

class GetMoreCell: UITableViewCell {

    @IBOutlet weak var btnCell: UIButton!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbDes: UILabel!
    
    @IBOutlet weak var imv_Des: UIImageView!
    
    @IBOutlet weak var lbCoin: UILabel!
    
    
    var indexPath:NSIndexPath? = nil
    
    var clickSelectButtonEvent : ((NSIndexPath) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionSelectButton(sender: AnyObject)
    {
        if (clickSelectButtonEvent != nil) && (indexPath != nil) {
            clickSelectButtonEvent!(indexPath!)
        }

    }
}
