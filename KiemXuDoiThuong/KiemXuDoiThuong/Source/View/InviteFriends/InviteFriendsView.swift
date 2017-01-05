//
//  InviteFriendsView.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 9/11/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import QuartzCore

class InviteFriendsView: UIView {
    
    @IBOutlet weak var lbCode: UILabel!
    
    @IBOutlet weak var btnStore: UIButton!

    @IBOutlet weak var btnShareLinks: UIButton!
    
    var referralCode :NSString?;
    
    var backgroundView :UIView? = nil
    
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        let view = NSBundle.mainBundle().loadNibNamed( String(InviteFriendsView), owner: self, options: nil).first as! UIView
        //        guard let content = contentView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(view)
        
        self.btnStore.layer.cornerRadius = 5.0
        self.btnShareLinks.layer.cornerRadius = 5.0
        
    }
    
    init(frame: CGRect, referralCode: String?) {
        super.init(frame: frame)
        self.commonInit()
        
        self.referralCode = referralCode
        
        self.lbCode.text = referralCode ?? ""
        
    }
    
    func show()
    {
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        self.center = CGPointMake(width*0.5, height*0.5)
        
        self.transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        let pRootWindow = ((UIApplication.sharedApplication().delegate?.window)!)! as UIWindow
        
        self.backgroundView = UIView.init(frame: UIScreen.mainScreen().bounds)
        self.backgroundView?.backgroundColor = UIColor.blackColor()
        self.backgroundView?.alpha = 0.5
        
        pRootWindow.addSubview(self.backgroundView!)
        pRootWindow.addSubview(self)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(InviteFriendsView.closeView))
        self.backgroundView!.addGestureRecognizer(tapGesture)
        
    }
    
    func closeView()
    {
        self.backgroundView?.removeFromSuperview()
        self.backgroundView = nil
        self.removeFromSuperview()
    }
}

