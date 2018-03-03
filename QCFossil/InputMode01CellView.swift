//
//  InputMode01CellView.swift
//  QCFossil
//
//  Created by Yin Huang on 18/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class InputMode01CellView: InputModeICMaster, UITextFieldDelegate {

    @IBOutlet weak var cellIndexLabel: UILabel!
    @IBOutlet weak var inptItemLabel: UILabel!
    @IBOutlet weak var inptItemInput: UITextField!
    @IBOutlet weak var inptDetailLabel: UILabel!
    @IBOutlet weak var inptDetailInput: UITextField!
    @IBOutlet weak var cellResultLabel: UILabel!
    @IBOutlet weak var cellResultInput: UITextField!
    @IBOutlet weak var cellRemarksLabel: UILabel!
    @IBOutlet weak var cellRemarksInput: UITextField!
    @IBOutlet weak var cellPAInput: UILabel!
    @IBOutlet weak var cellDefectButton: UIButton!
    @IBOutlet weak var cellDismissButton: UIButton!
    @IBOutlet weak var photoAddedIcon: UIImageView!
    @IBOutlet weak var takePhotoIcon: UIButton!
    //weak var parentView = InputMode01View()
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        cellResultInput.delegate = self
        inptItemInput.delegate = self
        
        updateLocalizedString()
        
    }
    
    func updateLocalizedString() {
        self.inptItemLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Item")
        self.inptDetailLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Details")
        self.cellRemarksLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Remarks")
        self.cellResultLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Result")
    }
    
    override func didMoveToSuperview() {
        if self.parentVC == nil {
            return
        }
        
        updatePhotoAddediConStatus("",photoTakenIcon: self.photoAddedIcon)
    }

    @IBAction func defectBtnOnClick(sender: UIButton) {
        //add defect cell to defect list
        
        if self.inptItemInput.text == "" || self.resultValueId < 1 {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Select Inspect Item Result!"))
            return
        }
        
        //Save self to DB to get the taskDataRecordId
        self.saveMyselfToGetId()
        
        let myParentTabVC = self.parentVC!.parentViewController?.parentViewController as! TabBarViewController
        let defectListVC = myParentTabVC.defectListViewController

        
        //add defect cell
        
        if !isDefectItemAdded(defectListVC!) {
            let defectObj = defectListVC!.inputCellInit(_INPUTMODE01, isHidden: false, idxLabel: String(cellIdx), iaLabel: "", iiLabel: inptItemInput.text!, sectionId: cellCatIdx, itemId: cellIdx, inspItem: self)
            
            defectListVC!.defectCells.append(defectObj as! InputModeDFMaster2 )
            
            defectListVC!.defectCells.sortInPlace({$0.sectionId<$1.sectionId})
            defectListVC!.defectCells.sortInPlace({$0.itemId<$1.itemId})
        }
        
        //self.parentVC!.performSegueWithIdentifier("DefectFromScreenSegue", sender:self)
        //NSNotificationCenter.defaultCenter().postNotificationName("switchTabViewToDL", object: nil)
    }
    
    @IBAction func dismissBtnOnClick(sender: UIButton) {
        let photoDataHelper = PhotoDataHelper()
        if photoDataHelper.existPhotoByInspItem(self.taskInspDataRecordId!, dataType: PhotoDataType(caseId: "INSPECT").rawValue) || self.inspPhotos.count>0 {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Photo(s) of this inspection item will be deleted!"), handlerFun: { (action:UIAlertAction!) in
            
                self.deleteInspItem()
            })
        }else{
            deleteInspItem()
        }
    }
    
    func deleteInspItem() {
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete?"), parentVC:(self.parentView?.parentVC)!, handlerFun: { (action:UIAlertAction!) in
            
            (self.parentView as! InputMode01View).inputCells.removeAtIndex(self.cellPhysicalIdx)
            self.removeFromSuperview()
            (self.parentView as! InputMode01View).updateContentView()
            
            //Delete Item From DB
            if self.taskInspDataRecordId > 0 {
                self.deleteTaskPhotos(true)
                //Reload Photos
                NSNotificationCenter.defaultCenter().postNotificationName("reloadAllPhotosFromDB", object: nil, userInfo: nil)
                
                self.deleteTaskInspDataRecord(self.taskInspDataRecordId!)
            }
            
            //Update Parent OptionElmts
            var releaseInspItems = [String]()
            releaseInspItems.append(self.inptItemInput.text!)
            (self.parentView as! InputMode01View).updateOptionalInspElmts(releaseInspItems,action: "add")
            
            //Delete Relative Defect Items From DB
            NSNotificationCenter.defaultCenter().postNotificationName("deleteDefectItemsByInspItem", object: nil, userInfo: ["inspElmt":self])
        })
    }
    
    func showDismissButton() {
        self.cellDismissButton.hidden = false
    }
    
    func dropdownHandleFunc(textField: UITextField) {
        let taskDataHelper = TaskDataHelper()
        
        if textField == self.cellResultInput {
            self.resultValueId = taskDataHelper.getResultValueIdByResultValue(cellResultInput.text!, prodTypeId: (Cache_Task_On?.prodTypeId)!, inspTypeId: (Cache_Task_On?.inspectionTypeId)!)
            
            updatePhotoAddediConStatus(textField.text!, photoTakenIcon: self.photoAddedIcon)
        }else if textField == self.inptItemInput {
            //Update Parent InspElmt
            self.inspAreaText = textField.text!
            updateParentOptionElmts()
            
            NSNotificationCenter.defaultCenter().postNotificationName("updatePhotoInfo", object: nil,userInfo: ["inspElmt":self])
        }
    }
    
    func updateParentOptionElmts() {
        let usedInspItems = (self.parentView as! InputMode01View).inputCells.filter({ $0.requiredElementFlag == 0 })
        var usedInspItemNames = [String]()
        
        for usedInspItem in usedInspItems {
            usedInspItemNames.append(usedInspItem.inptItemInput.text!)
        }
        
        (self.parentView as! InputMode01View).updateOptionalInspElmts(usedInspItemNames)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        clearDropdownviewForSubviews(self.parentView!)
        let handleFun:(UITextField)->(Void) = dropdownHandleFunc
        
        if textField == self.cellResultInput {
            textField.showListData(textField, parent: (self.parentView as! InputMode01View).scrollCellView!, handle: handleFun, listData: self.parentView!.resultValues, width: 200, height:250)
            return false
        }else if textField == self.inptItemInput {
            var listData = [String]()
            for optInspElmt in self.parentView!.optInspElms {
                listData.append( (_ENGLISH ? optInspElmt.elementNameEn : optInspElmt.elementNameCn)!)
            }
            
            textField.showListData(textField, parent: (self.parentView as! InputMode01View).scrollCellView, handle: handleFun, listData: listData, width: self.inptItemInput.frame.size.width*1.2, height: 250)
            
            return false
        }
        
        return true
    }
    
    @IBAction func takePhotoFromCell(sender: UIButton) {
        if self.inptItemInput.text == "" {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Select Inspect Item"))
            
            return
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.showActivityIndicator()
            //Save self to DB to get the taskDataRecordId
            self.saveMyselfToGetId()
            
            dispatch_async(dispatch_get_main_queue(), {
                
                NSNotificationCenter.defaultCenter().postNotificationName("takePhotoFromICCell", object: nil, userInfo: ["inspElmt":self])
                
                self.removeActivityIndicator()
            })
        })
        
    }
    
}
