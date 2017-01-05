//
//  CollectionViewChildCell.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 9/4/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit

class CollectionViewChildCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var btnCell: UIButton!
    
    var indexPath:NSIndexPath? = nil
    
    var clickButtonEvent : ((NSIndexPath) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func actionButton(sender: AnyObject)
    {
        if (clickButtonEvent != nil) && (indexPath != nil) {
            clickButtonEvent!(indexPath!)
        }
    }
    
    func isShowButton(isShow: Bool)
    {
        if isShow
        {
            btnCell.hidden = false
            lbTitle.hidden = true
        }
        else
        {
            btnCell.hidden = true
            lbTitle.hidden = false
        }
    }

}
