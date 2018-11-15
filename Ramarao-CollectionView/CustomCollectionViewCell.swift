//
//  CustomCollectionViewCell.swift
//  Ramarao-CollectionView
//
//  Created by Nagendra Mahto on 07/11/18.
//  Copyright © 2018 www.ramarao.com. All rights reserved.
//

import UIKit

protocol SendCommandToVC{
    
    func deleteThisCell()
    
}


class CustomCollectionViewCell: UICollectionViewCell,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var customTextLbl: UILabel!
    @IBOutlet weak var customContentView: UIView!
    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewBottomConstraint: NSLayoutConstraint!
    
    var delegate:SendCommandToVC?
    
    var startPoint = CGPoint()
    var startingBottomLayoutConstraintConstant = CGFloat()
    
    @IBAction func unpinThisUnit(_ sender: AnyObject) {
        if let temp = delegate{
            
            temp.deleteThisCell()
            
        }else{
            
            print("you forgot to set the delegate")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
