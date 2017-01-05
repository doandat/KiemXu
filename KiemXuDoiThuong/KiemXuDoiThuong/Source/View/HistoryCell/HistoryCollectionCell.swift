//
//  HistoryCollectionCell.swift
//  KiemXuDoiThuong
//
//  Created by Doan Dat on 9/4/16.
//  Copyright © 2016 datdv. All rights reserved.
//

import UIKit

class HistoryCollectionCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var lbCount: UILabel!
    
    @IBOutlet weak var wConstraintCount: NSLayoutConstraint!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var titleContainerView: UIView!
    
    
    @IBOutlet weak var wConstraintViewTitle: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var showButton: Bool = false
    
    var indexPath : NSIndexPath? = nil
    
    var colorView: UIColor? = nil
    
    var numberOfColumn: Int? = nil
    
    var textContents: NSArray? = nil
    
    var trans_id:String? = nil
    
    var updateOffsetX : ((CGFloat) -> Void)?

    var configLayoutCollectionCell : ((NSIndexPath) -> CGSize)?

    var tapEvent : ((Int) -> Void)?
    
    
    let kIdentifier = "kIdentifier"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.settingCollectionView()
        
        self.lbCount.layer.borderWidth = 1.0
        self.lbCount.layer.borderColor = UIColor.lightGrayColor().CGColor
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func settingCollectionView()
    {
        let pLayout: UICollectionViewFlowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        pLayout.sectionInset = UIEdgeInsetsMake(0.0, 1.0, 0.0, 1.0);
        pLayout.itemSize = CGSizeMake(200.0, CGRectGetHeight(self.frame) - 1.0);
        pLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal;
        pLayout.minimumLineSpacing = 0.5;
        pLayout.minimumInteritemSpacing = 0.5;

        
        let nib = UINib(nibName: String(CollectionViewChildCell), bundle: nil)

//        let nibButton = UINib(nibName: String(CollectionViewButtonCell), bundle: nil)

        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: String(CollectionViewChildCell))
//        self.collectionView.registerNib(nibButton, forCellWithReuseIdentifier: String(CollectionViewButtonCell))

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
//        self.collectionView.contentInset
        
        self.collectionView.backgroundColor = UIColor.whiteColor()
        self.collectionView.showsHorizontalScrollIndicator = false;
//        self.collectionView.automaticallyAdjustsScrollViewInsets = NO;

        
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if textContents != nil
        {
            if showButton
            {
                return textContents!.count + 1
            }
            else
            {
                return textContents!.count
            }
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let pCell = collectionView.dequeueReusableCellWithReuseIdentifier(String(CollectionViewChildCell), forIndexPath: indexPath) as! CollectionViewChildCell
        
        if showButton
        {
            if indexPath.row == self.textContents?.count
            {
                pCell.isShowButton(true)
                
                pCell.indexPath = indexPath
                
                pCell.clickButtonEvent = {
                    [weak self] (idxPath : NSIndexPath) -> Void  in
                    
                    print("clickButtonEvent:\(idxPath)")
////
                    if let strongSelf = self
                    {
                        let popUp = InputMessageReportView(frame: CGRectMake(0, 70, 300, 179), trans_id: strongSelf.trans_id ?? "")
                        
                        popUp.show()
                    }
                    
                }
            }
            else
            {
                pCell.isShowButton(false)
                pCell.lbTitle.text = self.textContents?[indexPath.row] as? String
            }

        }
        else
        {
            pCell.isShowButton(false)
            pCell.lbTitle.text = self.textContents?[indexPath.row] as? String
        }
        
        
        if self.colorView != nil
        {
            pCell.containerView.backgroundColor = self.colorView
        }
        else
        {
            pCell.containerView.backgroundColor = UIColor.whiteColor()
        }
        
        return pCell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        if (self.configLayoutCollectionCell != nil)
        {
            return self.configLayoutCollectionCell!(indexPath)
        }
        return CGSizeMake(200, CGRectGetHeight(self.frame))
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if (self.updateOffsetX != nil)
        {
            self.updateOffsetX!(scrollView.contentOffset.x)
        }
    }

    
}
