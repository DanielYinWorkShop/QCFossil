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
    //weak var parentView = InputMode02View()
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
    
    func updateLocalizedString(){
        self.dpLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Position")
        self.dpDescLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Position Description")
        self.cellDPPLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Position Points & Info")
        self.cellResultLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Result")
        
    }
    
    @IBAction func defectBtnOnClick(sender: UIButton) {
        //add defect cell to defect list
        
        if self.dpInput.text == "" || self.resultValueId < 1 {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Select Inspect Defect Position and Points"))
            return
        }
        
        //Save self to DB to get the taskDataRecordId
        self.saveMyselfToGetId()
        
        let myParentTabVC = self.parentVC!.parentViewController?.parentViewController as! TabBarViewController
        let defectListVC = myParentTabVC.defectListViewController
        
        
        //add defect cell
        
        if !isDefectItemAdded(defectListVC!) {
            let defectObj = defectListVC!.inputCellInit(_INPUTMODE02, isHidden: true, idxLabel: String(cellIdx), iaLabel: dpInput.text!, iiLabel: self.cellDPPInput.text!, sectionId: cellCatIdx, itemId: cellIdx, inspItem: self)
            
            defectListVC!.defectCells.append(defectObj as! InputModeDFMaster2)
            
            defectListVC!.defectCells.sortInPlace({$0.sectionId<$1.sectionId})
            defectListVC!.defectCells.sortInPlace({$0.itemId<$1.itemId})
        }else{
            let inspSectionCells = defectListVC!.defectCells
            let myDefectItems = inspSectionCells.filter({$0.sectionId == cellCatIdx && $0.itemId == cellIdx})
            for myDefectItem in myDefectItems{
                (myDefectItem as! InputMode02DefectCellView).dppInput.text = self.cellDPPInput.text
                (myDefectItem as! InputMode02DefectCellView).dpInput.text = self.dpInput.text
            }
        }
        
        //NSNotificationCenter.defaultCenter().postNotificationName("switchTabViewToDL", object: nil)
    }
    
    func dropdownHandleFunc(textField: UITextField) {
        let taskDataHelper = TaskDataHelper()
        
        if textField == self.cellResultInput {
            self.resultValueId = taskDataHelper.getResultValueIdByResultValue(cellResultInput.text!, prodTypeId: (Cache_Task_On?.prodTypeId)!, inspTypeId: (Cache_Task_On?.inspectionTypeId)!)
            
            updatePhotoAddediConStatus(textField.text!, photoTakenIcon: self.photoAddedIcon)
        }else if textField == self.cellDPPInput {
            self.inspItemText = textField.text!
            myDefectPositPoints = [PositPointObj]()
            
            let cells = textField.text!.characters.split{$0 == ","}.map(String.init)
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
        clearDropdownviewForSubviews(self.parentView!)
        let handleFun:(UITextField)->(Void) = dropdownHandleFunc
        
        if textField == self.cellResultInput {
            textField.showListData(textField, parent: (self.parentView as! InputMode02View).scrollCellView!, handle: handleFun, listData: self.parentView!.resultValues, width: 200, height: 250)
        }else if textField == self.dpInput {
            var positName = [String]()
            
            for dfPosit in (self.parentView as! InputMode02View).defectPosits {
                positName.append( _ENGLISH ? dfPosit.positionNameEn : dfPosit.positionNameCn)
            }
            
            textField.showListData(textField, parent: (self.parentView as! InputMode02View).scrollCellView!, handle: handleFun, listData: positName)
        }else if textField == self.cellDPPInput {
            var positName = [String]()
            let parentPositObjs = (self.parentView as! InputMode02View).defectPosits.filter({$0.positionNameEn == self.dpInput.text || $0.positionNameCn == self.dpInput.text})
            
            if parentPositObjs.count > 0 {
                let defectPositPoints = (self.parentView as! InputMode02View).defectPositPoints.filter({ $0.parentId == parentPositObjs[0].positionId})
            
                for dfPosit in defectPositPoints {
                    positName.append( _ENGLISH ? dfPosit.positionNameEn : dfPosit.positionNameCn)
                }
                
                textField.showListData(textField, parent: (self.parentView as! InputMode02View).scrollCellView!, handle: handleFun, listData: positName, width:320, height:400, allowMulpSel: true)
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
            if self.taskInspDataRecordId > 0 {
                self.deleteTaskPhotos(true)
                //Reload Photos
                NSNotificationCenter.defaultCenter().postNotificationName("reloadAllPhotosFromDB", object: nil, userInfo: nil)
                
                //Delete Item From DB
                self.deleteTaskInspDataRecord(self.taskInspDataRecordId!)
            }
            
            //Delete Relative Defect Items From DB
            NSNotificationCenter.defaultCenter().postNotificationName("deleteDefectItemsByInspItem", object: nil, userInfo: ["inspElmt":self])
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
}
