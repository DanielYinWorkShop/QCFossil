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
    @IBOutlet weak var inptDetailItemList: UIButton!
    @IBOutlet weak var inptDetailItemsListBtn: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    var selectValues = [String]()
    //weak var parentView = InputMode01View()
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        guard let touch:UITouch = touches.first else
        {
            return
        }
        
        if touch.view!.isKindOfClass(UITextField().classForCoder) || String(touch.view!.classForCoder) == "UITableViewCellContentView" {
            self.resignFirstResponderByTextField((self.parentVC?.view)!)
            
        }else {
            self.parentVC?.view.clearDropdownviewForSubviews((self.parentVC?.view)!)
            
        }
        
    }
    
    override func awakeFromNib() {
        cellResultInput.delegate = self
        inptItemInput.delegate = self
        
        updateLocalizedString()
        
    }
    
    func updateLocalizedString() {
        self.inptItemLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Area")
        self.inptDetailLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Details")
        self.cellRemarksLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Remarks")
        self.cellResultLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Result")
        self.errorMessageLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please enter defect point info")
    }
    
    override func didMoveToSuperview() {
        if self.parentVC == nil {
            return
        }
        
        self.inspReqCatText = self.cellCatName
        updatePhotoAddediConStatus("",photoTakenIcon: self.photoAddedIcon)
        
        fetchDetailSelectedValues()
    }
    
    func fetchDetailSelectedValues() {
        
        let taskDataHelper = TaskDataHelper()
        self.selectValues = taskDataHelper.getInptElementDetailSelectValueByElementId(self.inspElmId ?? 0)
        
        if selectValues.count > 0 {
            inptDetailItemsListBtn.hidden = false
        } else {
            inptDetailItemsListBtn.hidden = true
        }
    }

    @IBAction func defectBtnOnClick(sender: UIButton) {
 
        //check if defect input and defect position points nil, then return
        if let value = inptDetailInput.text {
            if inptDetailItemsListBtn.hidden == false && (value == "" || value.isEmpty) {
                self.errorMessageLabel.hidden = false
                return
            } else {
                self.errorMessageLabel.hidden = true
            }
        }
        
        let myParentTabVC = self.parentVC!.parentViewController?.parentViewController as! TabBarViewController
        let defectListVC = myParentTabVC.defectListViewController
        
        //add defect cell
        if !isDefectItemAdded(defectListVC!) {
            let newDfItem = TaskInspDefectDataRecord(taskId: (Cache_Task_On?.taskId)!, inspectRecordId: self.taskInspDataRecordId, refRecordId: 0, inspectElementId: self.elementDbId, defectDesc: "", defectQtyCritical: 0, defectQtyMajor: 0, defectQtyMinor: 0, defectQtyTotal: 0, createUser: Cache_Inspector?.appUserName, createDate: self.getCurrentDateTime(), modifyUser: Cache_Inspector?.appUserName, modifyDate: self.getCurrentDateTime())
            
            newDfItem?.inputMode = _INPUTMODE01
            newDfItem?.inspElmt = self
            newDfItem?.sectObj = SectObj(sectionId:cellCatIdx, sectionNameEn: self.cellCatName, sectionNameCn: self.cellCatName,inputMode: _INPUTMODE01)
            newDfItem?.elmtObj = ElmtObj(elementId:self.elementDbId,elementNameEn:"", elementNameCn:"", reqElmtFlag: 0)
            
            let defectsByItemId = Cache_Task_On?.defectItems.filter({$0.sectObj.sectionId == self.cellCatIdx && $0.elmtObj.elementId == self.elementDbId})
            newDfItem?.cellIdx = defectsByItemId!.count
            newDfItem?.sortNum = (newDfItem?.sectObj.sectionId)!*1000000 + (newDfItem?.inspElmt.elementDbId)!*1000 + (newDfItem?.cellIdx)!
            newDfItem?.photoNames = [String]()
            
            let taskDataHelper = TaskDataHelper()
            newDfItem?.recordId = taskDataHelper.updateInspDefectDataRecord(newDfItem!)
            
            if newDfItem?.recordId > 0 {
                Cache_Task_On?.defectItems.append(newDfItem!)
            }
        }
        
        self.parentVC!.performSegueWithIdentifier("DefectListFromInspectItemSegue", sender:self)
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
        clearDropdownviewForSubviews(self.parentView!)
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
            
            // Delete Relative Defect Items From DB
            self.deleteDefectItems()
        })
    }
    
    func deleteDefectItems() {

        let defectItemsArray = Cache_Task_On?.defectItems.filter({ $0.inspElmt.cellCatIdx == self.cellCatIdx && $0.inspElmt.cellIdx == self.cellIdx })
        
        if defectItemsArray?.count > 0 {
            for defectItem in defectItemsArray! {

                if let defectItems = Cache_Task_On?.defectItems.filter({$0.inspElmt != self}) {
                    Cache_Task_On?.defectItems = defectItems
                }
                
                //remove DB data
                if defectItem.photoNames != nil && defectItem.photoNames?.count>0 {
                    for photoName in defectItem.photoNames! {
                        //Remove defect photo to Photo Album
                        let photoDataHelper = PhotoDataHelper()
                        photoDataHelper.updatePhotoDatasByPhotoName(photoName, dataType:PhotoDataType(caseId: "TASK").rawValue, dataRecordId:0)
                    }
                }
                
                //Delete Record From DB
                if defectItem.recordId > 0 {
                    let taskDataHelper = TaskDataHelper()
                    taskDataHelper.deleteTaskInspDefectDataRecordById(defectItem.recordId!)
                    
                }
            }
        }
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
            
            if self.inspAreaText != textField.text! {
                // delete all defect items if not match
                self.deleteDefectItems()
            }
            
            //Update Parent InspElmt
            self.inspAreaText = textField.text!
            
            updateParentOptionElmts()
            
            let defectDataHelper = DefectDataHelper()
            let inspElementId = defectDataHelper.getInspElementIdByName(textField.text!, elementType: 1)
            
            if inspElementId != self.inspElmId {
                self.inptDetailInput.text = ""
                self.inspElmId = inspElementId
                self.inspPostId = defectDataHelper.getPositionIdByElementId(inspElementId)
                
                fetchDetailSelectedValues()
            }
            
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
            
            textField.showListData(textField, parent: (self.parentView as! InputMode01View).scrollCellView, handle: handleFun, listData: self.sortStringArrayByName(listData), width: self.inptItemInput.frame.size.width*1.2, height:_DROPDOWNLISTHEIGHT)
            
            return false
        }
        
        return true
    }

    @IBAction func showInptDetailVals(sender: UIButton) {
        self.inptDetailInput.showListData(self.inptDetailInput, parent: (self.parentView as! InputMode01View).scrollCellView!, handle: dropdownHandleFunc, listData: self.sortStringArrayByName(self.selectValues), width: 500, height:_DROPDOWNLISTHEIGHT, allowManuallyInput: true)
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
