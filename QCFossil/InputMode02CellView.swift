//
//  InputMode02CellView.swift
//  QCFossil
//
//  Created by Yin Huang on 18/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class InputMode02CellView: InputModeICMaster, UITextFieldDelegate {
    
    @IBOutlet weak var cellIndexLabel: UILabel!
    @IBOutlet weak var dpLabel: UILabel!
    @IBOutlet weak var dpInput: UITextField!
    @IBOutlet weak var dpDescLabel: UILabel!
    @IBOutlet weak var dpDescInput: UITextField!
    @IBOutlet weak var cellResultLabel: UILabel!
    @IBOutlet weak var cellResultInput: UITextField!
    @IBOutlet weak var cellDPPLabel: UILabel!
    @IBOutlet weak var cellDPPInput: UITextField!
    @IBOutlet weak var cellPAInput: UILabel!
    @IBOutlet weak var cellDefectButton: UIButton!
    @IBOutlet weak var cellDismissButton: UIButton!
    @IBOutlet weak var photoAddedIcon: UIImageView!
    @IBOutlet weak var takePhotoIcon: UIButton!
    var myDefectPositPoints = [PositPointObj]()
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    override func awakeFromNib() {
        self.cellResultInput.delegate = self
        self.dpInput.delegate = self
        self.cellDPPInput.delegate = self
        
        updateLocalizedString()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        guard let touch:UITouch = touches.first else
        {
            return;
        }
        
        if touch.view!.isKindOfClass(UITextField().classForCoder) || String(touch.view!.classForCoder) == "UITableViewCellContentView" {
            self.resignFirstResponderByTextField((self.parentVC?.view)!)
            
        }else {
            self.parentVC?.view.clearDropdownviewForSubviews((self.parentVC?.view)!)
            
        }
        
    }
    
    func updateLocalizedString(){
        self.dpLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Position")
        self.dpDescLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Position Description")
        self.cellDPPLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Position Points & Info")
        self.cellResultLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Result")
        
    }
    
    @IBAction func defectBtnOnClick(sender: UIButton) {
        //add defect cell to defect list
        /*
        if self.dpInput.text == "" {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Select Inspect Defect Position and Points"))
            return
        }
        
        //Save self to DB to get the taskDataRecordId
        self.saveMyselfToGetId()
        */
        let myParentTabVC = self.parentVC!.parentViewController?.parentViewController as! TabBarViewController
        let defectListVC = myParentTabVC.defectListViewController
        
        //add defect cell
        if !isDefectItemAdded(defectListVC!) {
            let newDfItem = TaskInspDefectDataRecord(taskId: (Cache_Task_On?.taskId)!, inspectRecordId: self.taskInspDataRecordId, refRecordId: 0, inspectElementId: self.elementDbId, defectDesc: "", defectQtyCritical: 0, defectQtyMajor: 0, defectQtyMinor: 0, defectQtyTotal: 0, createUser: Cache_Inspector?.appUserName, createDate: self.getCurrentDateTime(), modifyUser: Cache_Inspector?.appUserName, modifyDate: self.getCurrentDateTime())
            
            newDfItem?.inputMode = _INPUTMODE02
            newDfItem?.inspElmt = self
            newDfItem?.sectObj = SectObj(sectionId:cellCatIdx, sectionNameEn: self.cellCatName, sectionNameCn: self.cellCatName,inputMode: _INPUTMODE02)
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
    
    func dropdownHandleFunc(textField: UITextField) {
        let taskDataHelper = TaskDataHelper()
        
        if textField == self.cellResultInput {
            self.resultValueId = taskDataHelper.getResultValueIdByResultValue(cellResultInput.text!, prodTypeId: (Cache_Task_On?.prodTypeId)!, inspTypeId: (Cache_Task_On?.inspectionTypeId)!)
            
            updatePhotoAddediConStatus(textField.text!, photoTakenIcon: self.photoAddedIcon)
        }else if textField == self.cellDPPInput {
            self.inspItemText = textField.text!
            myDefectPositPoints = [PositPointObj]()
            /*
            textField.text = textField.text!.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )*/
            
            let selectedValues = textField.text!.stringByReplacingOccurrencesOfString(", ", withString: ",")
            
            let cells = selectedValues.characters.split{$0 == ","}.map(String.init)
            for cell in cells {
                let positName = cell as String

                let positObjs = (self.parentView as! InputMode02View).defectPositPoints.filter({$0.positionNameEn == positName || $0.positionNameCn == positName})
                
                if positObjs.count>0 {
                    myDefectPositPoints.append(positObjs[0])
                }
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("updatePhotoInfo", object: nil,userInfo: ["inspElmt":self])
        }else if textField == self.dpInput {
            
            if self.inspAreaText != textField.text! {
                self.cellDPPInput.text = ""
                self.inspItemText = ""
            }
            
            self.inspAreaText = textField.text!
            
            let inspPostObj = (self.parentView as! InputMode02View).defectPosits.filter({$0.positionNameEn==textField.text || $0.positionNameCn==textField.text})
            
            if inspPostObj.count>0 {
                self.inspPostId=inspPostObj[0].positionId
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("updatePhotoInfo", object: nil,userInfo: ["inspElmt":self])
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == self.cellDPPInput {
            return false
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        //clearDropdownviewForSubviews(self.parentView!)
        let handleFun:(UITextField)->(Void) = dropdownHandleFunc
        
        if textField == self.cellResultInput {
            
            if self.ifExistingSubviewByViewTag(self.parentView, tag: 1000003) {
                clearDropdownviewForSubviews(self.parentView!)
            }else{
                
                textField.showListData(textField, parent: (self.parentView as! InputMode02View).scrollCellView!, handle: handleFun, listData: self.parentView!.resultValues, width: 200, height: 250, tag: 1000003)
            }
            
        }else if textField == self.dpInput {
            var positName = [String]()
            
            for dfPosit in (self.parentView as! InputMode02View).defectPosits {
                positName.append( _ENGLISH ? dfPosit.positionNameEn : dfPosit.positionNameCn)
            }
            
            if self.ifExistingSubviewByViewTag(self.parentView, tag: 1000002) {
                clearDropdownviewForSubviews(self.parentView!)
            }else{
            
                textField.showListData(textField, parent: (self.parentView as! InputMode02View).scrollCellView!, handle: handleFun, listData: positName, tag: 1000002, height:500)
            }
        }else if textField == self.cellDPPInput {
            var positName = [String]()
            let parentPositObjs = (self.parentView as! InputMode02View).defectPosits.filter({$0.positionNameEn == self.dpInput.text || $0.positionNameCn == self.dpInput.text})
            
            if parentPositObjs.count > 0 {
                let defectPositPoints = (self.parentView as! InputMode02View).defectPositPoints.filter({ $0.parentId == parentPositObjs[0].positionId})
            
                for dfPosit in defectPositPoints {
                    positName.append( _ENGLISH ? dfPosit.positionNameEn : dfPosit.positionNameCn)
                }
                
                if self.ifExistingSubviewByViewTag(self.parentView, tag: 1000001) {
                    clearDropdownviewForSubviews(self.parentView!)
                }else{
                
                    textField.showListData(textField, parent: (self.parentView as! InputMode02View).scrollCellView!, handle: handleFun, listData: positName, width:320, height:500, allowMulpSel: true, tag: 1000001)
                    
                }
            }
        }
        
        return false
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
            
            (self.parentView as! InputMode02View).inputCells.removeAtIndex(self.cellPhysicalIdx)
            self.removeFromSuperview()
            (self.parentView as! InputMode02View).updateContentView()
            
            //Update Photos Status
            let taskDataHelper = TaskDataHelper()
            
            if self.taskInspDataRecordId > 0 {
                self.deleteTaskPhotos(true)
                //Reload Photos
                NSNotificationCenter.defaultCenter().postNotificationName("reloadAllPhotosFromDB", object: nil, userInfo: nil)
                
                //Delete Item From DB
                self.deleteTaskInspDataRecord(self.taskInspDataRecordId!)
                
                //Delete Relative Defect Position Points From DB
                taskDataHelper.deleteTaskDefectDataPPTRecordsByInspItemId(self.taskInspDataRecordId!)
            }
            
            //Delete Relative Defect Items From DB       
            let defectItemsArray = Cache_Task_On?.defectItems.filter({ $0.inspElmt.cellCatIdx == self.cellCatIdx && $0.inspElmt.cellIdx == self.cellIdx })
            
            if defectItemsArray?.count > 0 {
                for defectItem in defectItemsArray! {
                    let index = Cache_Task_On?.defectItems.indexOf({ $0.inspElmt.cellCatIdx == defectItem.inspElmt.cellCatIdx && $0.inspElmt.cellIdx == defectItem.inspElmt.cellIdx && $0.cellIdx == defectItem.cellIdx })
                    Cache_Task_On?.defectItems.removeAtIndex(index!)
                    
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
                        taskDataHelper.deleteTaskInspDefectDataRecordById(defectItem.recordId!)
                    }
                }
            }
        })
    }
    
    func showDismissButton() {
        self.cellDismissButton.hidden = false
    }
    
    @IBAction func takePhotoFromCell(sender: UIButton) {
        if self.dpInput.text == "" {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Select Inspect Defect Position and Points"))
            
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
    /*
    override func saveMyselfToGetId() {
        //Save self to DB to get the taskDataRecordId
        let taskDataHelper = TaskDataHelper()
        let taskInspDataRecord = TaskInspDataRecord.init(recordId: self.taskInspDataRecordId,taskId: (Cache_Task_On?.taskId)!, refRecordId: self.refRecordId!, inspectSectionId: self.cellCatIdx, inspectElementId: self.inspElmId!, inspectPositionId: self.inspPostId!, inspectPositionDesc: "", inspectDetail: "", inspectRemarks: "", resultValueId: self.resultValueId, requestSectionId: 0, requestElementDesc: "", createUser: (Cache_Inspector?.appUserName)!, createDate: self.getCurrentDateTime(), modifyUser: (Cache_Inspector?.appUserName)!, modifyDate: self.getCurrentDateTime())
        
        if self.taskInspDataRecordId < 1 {
            self.taskInspDataRecordId = taskDataHelper.insertTaskInspDataRecord(taskInspDataRecord!)
        }else{
            taskDataHelper.updateInspDataRecord(taskInspDataRecord!)
        }
        
        if self.taskInspDataRecordId>0 && self.myDefectPositPoints.count>0 {
            var dppDatas = [TaskInspPosinPoint]()
            for dpp in self.myDefectPositPoints {
                let dppData = TaskInspPosinPoint.init(inspRecordId: self.taskInspDataRecordId!, inspPosinId: dpp.positionId, createUser: (Cache_Inspector?.appUserName)!, createDate: self.getCurrentDateTime(), modifyUser: (Cache_Inspector?.appUserName)!, modifyDate: self.getCurrentDateTime())
                    
                dppDatas.append(dppData!)
            }
                
            let dpDataHelper = DPDataHelper()
            dppDatas = dpDataHelper.updateDefectPositionPoints(self.taskInspDataRecordId!,defectPositionPoints: dppDatas)
        }
    }*/
    
    override func saveMyselfToGetId() {
        //Save self to DB to get the taskDataRecordId
        if self.taskInspDataRecordId < 1 {
            let taskDataHelper = TaskDataHelper()
            let taskInspDataRecord = TaskInspDataRecord.init(recordId: self.taskInspDataRecordId,taskId: (Cache_Task_On?.taskId)!, refRecordId: self.refRecordId!, inspectSectionId: self.cellCatIdx, inspectElementId: self.inspElmId!, inspectPositionId: self.inspPostId!, inspectPositionDesc: "", inspectDetail: "", inspectRemarks: "", resultValueId: self.resultValueId, requestSectionId: 0, requestElementDesc: "", createUser: (Cache_Inspector?.appUserName)!, createDate: self.getCurrentDateTime(), modifyUser: (Cache_Inspector?.appUserName)!, modifyDate: self.getCurrentDateTime())
            
            self.taskInspDataRecordId = taskDataHelper.insertTaskInspDataRecord(taskInspDataRecord!)
            
            if self.taskInspDataRecordId>0 && self.myDefectPositPoints.count>0 {
                var dppDatas = [TaskInspPosinPoint]()
                for dpp in self.myDefectPositPoints {
                    let dppData = TaskInspPosinPoint.init(inspRecordId: self.taskInspDataRecordId!, inspPosinId: dpp.positionId, createUser: (Cache_Inspector?.appUserName)!, createDate: self.getCurrentDateTime(), modifyUser: (Cache_Inspector?.appUserName)!, modifyDate: self.getCurrentDateTime())
                    
                    dppDatas.append(dppData!)
                }
                
                let dpDataHelper = DPDataHelper()
                dppDatas = dpDataHelper.updateDefectPositionPoints(self.taskInspDataRecordId!,defectPositionPoints: dppDatas)
            }
        }
    }
    
    @IBAction func clearDropdownListOnClick(sender: UIButton) {
        self.parentView.clearDropdownviewForSubviews(self.parentView)
    }
    
}
