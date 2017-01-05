//
//  CustomPickerView.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 9/3/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit
import QuartzCore

class CustomPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var arrData :NSArray? = nil;
    
    var arrDataTuple :[(String, String)]? = nil;

    
    var backgroundView :UIView? = nil
    
    var dismisViewEvent : ((Int) -> Void)?

    
    @IBOutlet weak var pickerView: UIPickerView!
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        let view = NSBundle.mainBundle().loadNibNamed( String(CustomPickerView), owner: self, options: nil).first as! UIView
        //        guard let content = contentView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(view)
        
        
    }
    
    init(frame: CGRect, arrData: NSArray) {
        super.init(frame: frame)
        self.commonInit()
        self.arrData = arrData
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
    
    init(frame: CGRect, arrData: [(String,String)]) {
        super.init(frame: frame)
        self.commonInit()
        self.arrDataTuple = arrData
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
    
    func show()
    {
        self.pickerView.reloadAllComponents()
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        self.frame = CGRectMake(0, height-250, width, 250)
        
//        self.transform = CGAffineTransformMakeScale(0, 0)
        
//        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//            self.transform = CGAffineTransformIdentity
//            }, completion: nil)
        
        let pRootWindow = ((UIApplication.sharedApplication().delegate?.window)!)! as UIWindow
        
        self.backgroundView = UIView.init(frame: UIScreen.mainScreen().bounds)
        self.backgroundView?.backgroundColor = UIColor.blackColor()
        self.backgroundView?.alpha = 0.5
        
        pRootWindow.addSubview(self.backgroundView!)
        pRootWindow.addSubview(self)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PopupInstallAppView.closeView))
        self.backgroundView!.addGestureRecognizer(tapGesture)
        
    }
    
    func closeView()
    {
        if (self.dismisViewEvent != nil)
        {
            self.dismisViewEvent!(self.pickerView.selectedRowInComponent(0))
        }
        self.backgroundView?.removeFromSuperview()
        self.backgroundView = nil
        self.removeFromSuperview()
    }
    
    //MARK- PickerView
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if self.arrDataTuple != nil {
            return self.arrDataTuple!.count
        }
        
        return self.arrData!.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if self.arrData != nil {
            return self.arrData![row] as? String
        }
        else if self.arrDataTuple != nil
        {
            return self.arrDataTuple![row].0
        }
        
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {

    }
    
    
}