//
//  POCellViewInput.swift
//  QCFossil
//
//  Created by Yin Huang on 3/2/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class POCellViewInput: UIView, UITextFieldDelegate {

    @IBOutlet weak var poNoLabel: UILabel!
    @IBOutlet weak var poNoText: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var brandText: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var styleText: UILabel!
    @IBOutlet weak var orderQtyLabel: UILabel!
    @IBOutlet weak var orderQtyText: UILabel!
    @IBOutlet weak var poLineNoLabel: UILabel!
    @IBOutlet weak var poLineNoText: UILabel!
    @IBOutlet weak var shipToLabel: UILabel!
    @IBOutlet weak var shipToText: UILabel!
    @IBOutlet weak var availInspectQtyLabel: UILabel!
    @IBOutlet weak var enableLabel: UILabel!
    @IBOutlet weak var availInspectQtyInput: UITextField!
    @IBOutlet weak var enableSwitch: UISwitch!
    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var sampleQtyLabel: UILabel!
    @IBOutlet weak var sampleQtyInput: UITextField!
    @IBOutlet weak var bookingQtyLabel: UILabel!
    @IBOutlet weak var bookingQtyInput: UILabel!
    @IBOutlet weak var opdRsdLabel: UILabel!
    @IBOutlet weak var opdRsdInput: UILabel!
    @IBOutlet weak var shipWinLabel: UILabel!
    @IBOutlet weak var shipWinInput: UILabel!
    
    
    var idx = 0
    var poItemId:Int?
    var isEnable = 1
    var sampleQtyDB:Int = 0
    var availInspQtyDB:Int = 0
    var bookingQtyDB:Int = 0
    var prodDesc = ""
    
    weak var pVC:UIViewController!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    @IBAction func isEnableSwitchOnClick(sender: UISwitch) {
        self.sampleQtyInput.endEditing(true)
        self.availInspectQtyInput.endEditing(true)
        self.bookingQtyInput.endEditing(true)
        
        Cache_Task_On?.didModify = true
        
        if sender.on {
            self.isEnable = 1
            self.sampleQtyInput.text = sampleQtyDB>0 ? String(sampleQtyDB) : ""
            self.availInspectQtyInput.text = availInspQtyDB>0 ? String(availInspQtyDB) : ""
            self.bookingQtyInput.text = String(self.bookingQtyDB)//String(bookingQtyDB)
            
            //enable sample & avail Qty Input
            self.sampleQtyInput.userInteractionEnabled = true
            self.availInspectQtyInput.userInteractionEnabled = true
            
            Cache_Task_On!.poItems.forEach({ if $0.itemId == self.poItemId { $0.isEnable = 1 } })
            
        }else{
            self.isEnable = 0
            self.sampleQtyInput.text = ""
            self.availInspectQtyInput.text = ""
            self.bookingQtyInput.text = "0"//self.orderQtyText.text
            
            self.sampleQtyDB = 0
            self.availInspQtyDB = 0
            
            let taskDataHelper = TaskDataHelper()
            taskDataHelper.updateTaskItemQty(availInspQtyDB, samplingQty: sampleQtyDB, taskId: (Cache_Task_On?.taskId)!, poItemId: poItemId!)
            
            //disable sample & avail Qty Input
            self.sampleQtyInput.userInteractionEnabled = false
            self.availInspectQtyInput.userInteractionEnabled = false
            
            Cache_Task_On!.poItems.forEach({ if $0.itemId == self.poItemId { $0.isEnable = 0 } })
        }
    }
    
    override func awakeFromNib() {
        self.sampleQtyInput.delegate = self
        self.availInspectQtyInput.delegate = self
        
        updateLocalizedString()
    }
    
    override func didMoveToSuperview() {
        if self.isEnable == 1 {
            enableSwitch.setOn(true, animated: false)
        }else {
            enableSwitch.setOn(false, animated: false)
        }
        
        if pVC?.classForCoder == CreateTaskViewController.classForCoder() {
            self.availInspectQtyLabel.hidden = true
            self.availInspectQtyInput.hidden = true
            self.enableLabel.hidden = true
            self.enableSwitch.hidden = true
            
            self.sampleQtyLabel.hidden = true
            self.sampleQtyInput.hidden = true
            self.bookingQtyLabel.hidden = true
            self.bookingQtyInput.hidden = true
        }
        
        if self.disableFuns(self) {
            enableSwitch.enabled = false
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField == self.sampleQtyInput && textField.text != "" {
            self.sampleQtyDB = Int(textField.text!)!
        }else if textField == self.availInspectQtyInput && textField.text != "" {
            self.availInspQtyDB = Int(textField.text!)!
        }else if textField == self.bookingQtyInput && textField.text != "" {
            self.bookingQtyDB = Int(textField.text!)!
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        Cache_Task_On?.didModify = true
        
        
        if textField.keyboardType == UIKeyboardType.NumberPad {
            
            return textField.numberOnlyCheck(textField, sourceText: string)
        }
        
        return false
    }
    
    func updateLocalizedString(){
        
        self.poNoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("PO No.")
        self.poLineNoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("PO Line No.")
        self.brandLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Brand")
        self.styleLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Style, Size")
        self.orderQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Order Qty")
        self.shipToLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Ship To")
        self.availInspectQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Avail. Qty")
        self.enableLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Enable?")
        self.sampleQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Sample Qty")
        self.bookingQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("QC Booked Qty")
        self.opdRsdLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("OPD/RSD")
        self.shipWinLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("SW/Req. Ex-fty Date")
    }
    
    @IBAction func delBtn(sender: UIButton){
        
        if pVC?.classForCoder == CreateTaskViewController.classForCoder() {
            let parentVC = self.pVC as! CreateTaskViewController
            //parentVC.poCellItems.removeAtIndex(self.idx)
            parentVC.poItems.removeAtIndex(self.idx)
            //parentVC.loadPoItemCell()
            
            if parentVC.poItems.count < 1 {
                parentVC.vendorInput.text = ""
                parentVC.vdrLocationInput.text = ""
            }
            
        }else if pVC?.classForCoder == TaskDetailsViewController.classForCoder() {
            let parentVC = self.pVC as! TaskDetailsViewController
            let taskDetailViewInput = parentVC.view.viewWithTag(_TASKDETAILVIEWTAG) as! TaskDetailViewInput
            
            if taskDetailViewInput.poItems.count > 1{
                let poItemRemove = taskDetailViewInput.poItems[self.idx]
                taskDetailViewInput.poItems.removeAtIndex(self.idx)
                //Resize
                taskDetailViewInput.resizePoWrapperContent(-1*CGFloat(taskDetailViewInput.poCellHeight))
                
                taskDetailViewInput.loadPoList()
                
                //Delete From DB
                let taskDataHelper = TaskDataHelper()
                taskDataHelper.deletePOItemByIds(poItemRemove.itemId!, taskId: (Cache_Task_On?.taskId)!)
            }else{
                self.alertView("POItem can not be nil!")
                
            }
            
        }
    }
    
    @IBAction func showProdDesc(sender: UIButton){
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSizeMake(320,150 + _NAVIBARHEIGHT)
        
        popoverContent.dataType = _POPOVERPRODDESC
        popoverContent.selectedValue = prodDesc
        
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        nav.navigationBar.barTintColor = UIColor.whiteColor()
        nav.navigationBar.tintColor = UIColor.blackColor()
        
        let popover = nav.popoverPresentationController
        popover!.delegate = sender.parentVC as! PopoverMaster
        popover!.sourceView = sender
        popover!.sourceRect = CGRectMake(0,sender.frame.minY,sender.frame.size.width,sender.frame.size.height)
        
        sender.parentVC!.presentViewController(nav, animated: true, completion: nil)
        
    }
}
