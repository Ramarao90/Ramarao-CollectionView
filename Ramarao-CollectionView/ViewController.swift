//
//  ViewController.swift
//  Ramarao-CollectionView
//
//  Created by Nagendra Mahto on 07/11/18.
//  Copyright © 2018 www.ramarao.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var panGesture = UIPanGestureRecognizer()
    var longGesture = UILongPressGestureRecognizer()
    let kBounceValue:CGFloat = 0
    var swipeActiveCell:CustomCollectionViewCell?
    var arrayOfItems = Array(arrayLiteral: "Ramarao", "Raj", "Ramdin", "Sourya", "Ramesh", "Gautham", "Gambir", "Kohli", "Ramarao", "Raj", "Ramdin", "Sourya", "Ramesh", "Gautham", "Gambir", "Kohli", "Ramarao", "Raj", "Ramdin", "Sourya", "Ramesh", "Gautham", "Gambir", "Kohli", "Ramarao", "Raj", "Ramdin", "Sourya", "Ramesh", "Gautham", "Gambir", "Kohli", "Ramarao", "Raj", "Ramdin", "Sourya", "Ramesh", "Gautham", "Gambir", "Kohli")
    
    
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.scrollDirection = .horizontal
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panThisCell))
        panGesture.delegate = self
        self.longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        self.longGesture.delaysTouchesBegan = true
        self.longGesture.delegate = self
        self.collectionView.addGestureRecognizer(panGesture)
        self.collectionView.addGestureRecognizer(longGesture)
    }
    
}

//MARK:COLLECTION VIEW DATA SOURCE
extension ViewController:UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrayOfItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        cell.customTextLbl.text = arrayOfItems[indexPath.row]
        cell.delegate = self
        return cell
    }
}

//MARK:COLLECTION VIEW DELEGATE FLOW LAYOUT
extension ViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.view.frame.size.width - 10 * 4) / 3
        return CGSize(width: width, height: 150)
        
    }
}

//MARK:SENDCOMMAND DELEGATE
extension ViewController:SendCommandToVC{
    
    func deleteThisCell(){
        
        let indexpath = self.collectionView.indexPath(for: swipeActiveCell!)
        self.arrayOfItems.remove(at: indexpath?.row ?? 0)
        self.collectionView.deleteItems(at: [indexpath!])
    }
    
    func editThisCell (){
        let actionController = UIAlertController(title: "Please enter the New Name", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        let saveAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            let newNameTextField = actionController.textFields![0] as UITextField
            self.swipeActiveCell?.customTextLbl.text = newNameTextField.text
            let indexpath = self.collectionView.indexPath(for: self.swipeActiveCell!)
            self.arrayOfItems[indexpath?.row ?? 0] = newNameTextField.text ?? "Ram"
        })
        
        actionController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "New Name"
            //textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
        }
        
        actionController.addAction(cancelAction)
        actionController.addAction(saveAction)
        actionController.popoverPresentationController?.sourceView = self.collectionView
        actionController.popoverPresentationController?.sourceRect = self.swipeActiveCell?.frame ?? .zero
        self.present(actionController, animated: true, completion: nil)
    }
}

//MARK:GESTURE RECONIZER DELEGATE FLOW LAYOUT
extension ViewController:UIGestureRecognizerDelegate{
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        //IF FALSE DISABLED COLLECTIONVIEW VERTICAL SCROLLING
        return true
    }
    
}


//MARK: PAN GESTURE METHODS
extension ViewController{
    
    func moreOptionsOnLongPress() {
        let alertController = UIAlertController(title: "More Options", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let deleteCell = UIAlertAction(title: "Delete Cell", style: .default) { (result : UIAlertAction) in
            self.deleteThisCell()
        }
        
        let editCell = UIAlertAction(title: "Edit Cell", style: .default) { (result : UIAlertAction) in
            self.editThisCell()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (result : UIAlertAction) in
        }
        
        alertController.addAction(deleteCell)
        alertController.addAction(editCell)
        alertController.addAction(cancelAction)
        alertController.popoverPresentationController?.sourceView = self.collectionView
        alertController.popoverPresentationController?.sourceRect = self.swipeActiveCell?.frame ?? .zero
        self.present(alertController, animated: true, completion: nil)
    }
    
    func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }
        let p = gesture.location(in: self.collectionView)
        
        if let indexPath = self.collectionView.indexPathForItem(at: p) {
            // get the cell at indexPath (the one you long pressed)
            guard let cell = self.collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell else{
                
                return
                
            }
            // do stuff with the cell
            if swipeActiveCell != cell && swipeActiveCell != nil{
                
            }
            swipeActiveCell = cell
            self.moreOptionsOnLongPress()
        } else {
            print("couldn't find index path")
        }
    }
    
    func panThisCell(_ recognizer:UIPanGestureRecognizer){
        
        if recognizer != panGesture{  return }
        
        let point = recognizer.location(in: self.collectionView)
        let indexpath = self.collectionView.indexPathForItem(at: point)
        if indexpath == nil{  return }
        guard let cell = self.collectionView.cellForItem(at: indexpath!) as? CustomCollectionViewCell else{
            
            return
            
        }
        switch recognizer.state {
        case .began:
            
            cell.startPoint =  self.collectionView.convert(point, to: cell)
            cell.startingBottomLayoutConstraintConstant  = cell.contentViewBottomConstraint.constant
            if swipeActiveCell != cell && swipeActiveCell != nil{
                
                self.resetConstraintToZero(swipeActiveCell!,animate: true, notifyDelegateDidClose: false)
            }
            swipeActiveCell = cell
            
        case .changed:
            
            let currentPoint =  self.collectionView.convert(point, to: cell)
            let deltaY = currentPoint.y - cell.startPoint.y
            var panningTop = false
            
            if currentPoint.y < cell.startPoint.y{
                
                panningTop = true
                
            }
            if cell.startingBottomLayoutConstraintConstant == 0{
                
                if !panningTop{
                    
                    let constant = max(0,-deltaY)
                    if constant == 0{
                        
                        self.resetConstraintToZero(cell,animate: true, notifyDelegateDidClose: false)
                        
                    }else{
                        
                        cell.contentViewBottomConstraint.constant = constant
                        
                    }
                }else{
                    
                    let constant = min(self.getButtonTotalHeight(cell),-deltaY)
                    if constant == self.getButtonTotalHeight(cell){
                        
                        self.setConstraintsToShowAllButtons(cell,animate: true, notifyDelegateDidOpen: false)
                        
                    }else{
                        
                        cell.contentViewBottomConstraint.constant = constant
                        cell.contentViewTopConstraint.constant = -constant
                    }
                }
            }else{
                
                let adjustment = cell.startingBottomLayoutConstraintConstant - deltaY;
                if (!panningTop) {
                    
                    let constant = max(0, adjustment);
                    if (constant == 0) {
                        
                        self.resetConstraintToZero(cell,animate: true, notifyDelegateDidClose: false)
                        
                    } else {
                        
                        cell.contentViewBottomConstraint.constant = constant;
                    }
                } else {
                    let constant = min(self.getButtonTotalHeight(cell), adjustment);
                    if (constant == self.getButtonTotalHeight(cell)) {
                        
                        self.setConstraintsToShowAllButtons(cell,animate: true, notifyDelegateDidOpen: false)
                    } else {
                        
                        cell.contentViewBottomConstraint.constant = constant;
                    }
                }
                cell.contentViewTopConstraint.constant = -cell.contentViewBottomConstraint.constant;
                
            }
            cell.layoutIfNeeded()
        case .cancelled:
            
            if (cell.startingBottomLayoutConstraintConstant == 0) {
                
                self.resetConstraintToZero(cell,animate: true, notifyDelegateDidClose: true)
                
            } else {
                
                self.setConstraintsToShowAllButtons(cell,animate: true, notifyDelegateDidOpen: true)
            }
            
        case .ended:
            
            if (cell.startingBottomLayoutConstraintConstant == 0) {
                //Cell was opening
                let halfOfButtonOne = (cell.swipeView.frame).height / 2;
                if (cell.contentViewBottomConstraint.constant >= halfOfButtonOne) {
                    //Open all the way
                    self.setConstraintsToShowAllButtons(cell,animate: true, notifyDelegateDidOpen: true)
                } else {
                    //Re-close
                    self.resetConstraintToZero(cell,animate: true, notifyDelegateDidClose: true)
                }
            } else {
                //Cell was closing
                let buttonOnePlusHalfOfButton2 = (cell.swipeView.frame).height
                if (cell.contentViewBottomConstraint.constant >= buttonOnePlusHalfOfButton2) {
                    //Re-open all the way
                    self.setConstraintsToShowAllButtons(cell,animate: true, notifyDelegateDidOpen: true)
                } else {
                    //Close
                    self.resetConstraintToZero(cell,animate: true, notifyDelegateDidClose: true)
                }
            }
            
        default:
            print("default")
        }
    }
    
    func getButtonTotalHeight(_ cell:CustomCollectionViewCell)->CGFloat{
        
        let height = cell.frame.height - cell.swipeView.frame.minY
        return height
        
    }
    
    func resetConstraintToZero(_ cell:CustomCollectionViewCell, animate:Bool,notifyDelegateDidClose:Bool){
        
        if (cell.startingBottomLayoutConstraintConstant == 0 &&
            cell.contentViewBottomConstraint.constant == 0) {
            //Already all the way closed, no bounce necessary
            return;
        }
        cell.contentViewBottomConstraint.constant = -kBounceValue;
        cell.contentViewTopConstraint.constant = kBounceValue;
        self.updateConstraintsIfNeeded(cell,animated: animate) {
            cell.contentViewBottomConstraint.constant = 0;
            cell.contentViewTopConstraint.constant = 0;
            
            self.updateConstraintsIfNeeded(cell,animated: animate, completionHandler: {
                
                cell.startingBottomLayoutConstraintConstant = cell.contentViewBottomConstraint.constant;
            })
        }
        cell.startPoint = CGPoint()
        swipeActiveCell = nil
    }
    
    func setConstraintsToShowAllButtons(_ cell:CustomCollectionViewCell, animate:Bool,notifyDelegateDidOpen:Bool){
        
        if (cell.startingBottomLayoutConstraintConstant == self.getButtonTotalHeight(cell) &&
            cell.contentViewBottomConstraint.constant == self.getButtonTotalHeight(cell)) {
            return;
        }
        cell.contentViewTopConstraint.constant = -self.getButtonTotalHeight(cell) - kBounceValue;
        cell.contentViewBottomConstraint.constant = self.getButtonTotalHeight(cell) + kBounceValue;
        
        self.updateConstraintsIfNeeded(cell,animated: animate) {
            cell.contentViewTopConstraint.constant =  -(self.getButtonTotalHeight(cell))
            cell.contentViewBottomConstraint.constant = self.getButtonTotalHeight(cell)
            
            self.updateConstraintsIfNeeded(cell,animated: animate, completionHandler: {(check) in
                
                cell.startingBottomLayoutConstraintConstant = cell.contentViewBottomConstraint.constant;
            })
        }
    }
    
    func setConstraintsAsSwipe(_ cell:CustomCollectionViewCell, animate:Bool,notifyDelegateDidOpen:Bool){
        
        if (cell.startingBottomLayoutConstraintConstant == self.getButtonTotalHeight(cell) &&
            cell.contentViewBottomConstraint.constant == self.getButtonTotalHeight(cell)) {
            return;
        }
        cell.contentViewTopConstraint.constant = -self.getButtonTotalHeight(cell) - kBounceValue;
        cell.contentViewBottomConstraint.constant = self.getButtonTotalHeight(cell) + kBounceValue;
        
        self.updateConstraintsIfNeeded(cell,animated: animate) {
            cell.contentViewTopConstraint.constant =  -(self.getButtonTotalHeight(cell))
            cell.contentViewBottomConstraint.constant = self.getButtonTotalHeight(cell)
            
            self.updateConstraintsIfNeeded(cell,animated: animate, completionHandler: {(check) in
                
                cell.startingBottomLayoutConstraintConstant = cell.contentViewBottomConstraint.constant;
            })
        }
    }
    
    
    func updateConstraintsIfNeeded(_ cell:CustomCollectionViewCell, animated:Bool,completionHandler:@escaping ()->()) {
        var duration:Double = 0
        if animated{
            
            duration = 0.1
            
        }
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
            
            cell.layoutIfNeeded()
            
            }, completion:{ value in
                
                if value{ completionHandler() }
        })
    }
}
