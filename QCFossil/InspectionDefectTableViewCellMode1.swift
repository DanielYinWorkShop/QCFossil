//
//  InspectionDefectTableViewCellMode1.swift
//  QCFossil
//
//  Created by pacmobile on 19/1/2017.
//  Copyright © 2017 kira. All rights reserved.
//

import UIKit

class InspectionDefectTableViewCellMode1: InputModeDFMaster2, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var defectDescLabel: UILabel!
    @IBOutlet weak var defectQtyLabel: UILabel!
    @IBOutlet weak var defectDescInput: UITextField!
    @IBOutlet weak var defectQtyInput: UITextField!
    @IBOutlet weak var criticalLabel: UILabel!
    @IBOutlet weak var criticalInput: UITextField!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var majorInput: UITextField!
    @IBOutlet weak var minorLabel: UILabel!
    @IBOutlet weak var minorInput: UITextField!
    @IBOutlet weak var defectTypeLabel: UILabel!
    @IBOutlet weak var defectTypeInput: UITextField!
    @IBOutlet weak var defectDesc1Label: UILabel!
    @IBOutlet weak var defectDesc2Label: UILabel!
    @IBOutlet weak var defectDesc1Input: UITextField!
    @IBOutlet weak var defectDesc2Input: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var defectDesc1ListIcon: UIButton!
    @IBOutlet weak var defectDesc2ListIcon: UIButton!
    @IBOutlet weak var othersRemarkLabel: UILabel!
    @IBOutlet weak var othersRemarkInput: UITextField!
    
    weak var pVC:InspectionDefectList!
    
    var defectValues:[DropdownValue]?
    var caseValues:[DropdownValue]?
    var defectTypeKeyValues = [String:Int]()
    var remarkKeyValue = [String:Int]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.defectDescInput.delegate = self
        self.defectQtyInput.delegate = self
        self.criticalInput.delegate = self
        self.majorInput.delegate = self
        self.minorInput.delegate = self
        self.defectTypeInput.delegate = self
        self.defectQtyInput.userInteractionEnabled = false
        self.defectDesc1Input.delegate = self
        self.defectDesc2Input.delegate = self
        self.defectDescInput.delegate = self
        self.othersRemarkInput.delegate = self
        
        self.defectDescLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Description")
        self.defectQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Total")
        self.defectTypeLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Type")
        self.criticalLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Critical")
        self.majorLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Major")
        self.minorLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Minor")
        self.defectDesc1Label.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Desc. 1")
        self.defectDesc2Label.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Desc. 2")
        self.errorMessageLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please enter defect quantity")
        self.othersRemarkLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Other Remark")
        
        self.criticalInput.text = "0"
        self.majorInput.text = "0"
        self.minorInput.text = "0"
        self.defectQtyInput.text = "0"
    }
    
    @IBAction func addDefectPhoto(sender: UIButton) {
        print("add Cell photo")
        
        NSNotificationCenter.defaultCenter().postNotificationName(UIKeyboardWillHideNotification, object: nil)
        
        if !self.photoNameAtIndex.contains("") {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
            return
        }
        
        self.defectDescInput.resignFirstResponder()
        self.defectQtyInput.resignFirstResponder()
        self.criticalInput.resignFirstResponder()
        self.majorInput.resignFirstResponder()
        self.minorInput.resignFirstResponder()
        self.othersRemarkInput.resignFirstResponder()
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .Popover
        
        let ppc = imagePicker.popoverPresentationController
        ppc?.sourceView = sender
        ppc?.sourceRect = sender.bounds
        ppc?.permittedArrowDirections = .Any
        
        self.parentVC!.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addDefectPhotoFromCamera(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName(UIKeyboardWillHideNotification, object: nil)
        
        if !self.photoNameAtIndex.contains("") {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
            self.parentVC!.presentViewController(imagePicker, animated: true, completion: nil)
            
        }else{
            imagePicker.modalPresentationStyle = .Popover
            imagePicker.sourceType = .PhotoLibrary
            
            let ppc = imagePicker.popoverPresentationController
            ppc?.sourceView = sender
            ppc?.sourceRect = sender.bounds
            ppc?.permittedArrowDirections = .Any
            
            imagePicker.sourceType = .PhotoLibrary
            
            self.parentVC!.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func addDefectPhotoFromAlbum(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName(UIKeyboardWillHideNotification, object: nil)
        
        if !self.photoNameAtIndex.contains("") {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
            return
        }
        
        self.pVC?.currentCell = self
        self.parentVC?.performSegueWithIdentifier("PhotoAlbumSegueFromIDF", sender: self)
    }
    
    func refreshImageviews() {
        self.subviews.forEach({ if $0.tag>0 {$0.removeFromSuperview()} })
        self.photoNameAtIndex = ["","","","",""]
    }
    
    func showDefectPhotoByName(photoNames:[String]) {
        var idx = 0
        for photoName in photoNames {
            
            if idx < 5 && photoName != "" {
                
                let pathForImage = Cache_Task_Path! + "/" + _THUMBSPHYSICALNAME + "/" + photoName
                let imageView = UIImageView.init(image: UIImage(contentsOfFile: pathForImage))
                
                imageView.frame = CGRect(x: xPos[idx], y: 265, width: 40, height: 40)
                imageView.tag = idx + 1
                
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(InspectionDefectTableViewCellMode1.previewTapOnClick(_:)))
                imageView.userInteractionEnabled = true
                imageView.addGestureRecognizer(tapGestureRecognizer)
                
                photoNameAtIndex[idx] = photoName
                
                self.addSubview(imageView)
                
                let cBtn = CustomControlButton()
                cBtn.frame = CGRect.init(x: xPosBtn[idx], y: 255, width: 20, height: 20)
                cBtn.addTarget(self, action: #selector(InspectionDefectTableViewCellMode1.removeDefectPhotoOnIndex(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                cBtn.tag = idx + 1
                cBtn.setTitle("-", forState: UIControlState.Normal)
                cBtn.backgroundColor = UIColor.redColor()
                cBtn.layer.cornerRadius = _CORNERRADIUS
                
                self.addSubview(cBtn)
                
                idx += 1
            }
        }
    }
    
    func showDefectPhoto(photos:[Photo]){
        
        var idx = 0
        for photo in photos {
            
            if idx < 5 {
                
                let imageView = photo.photo
                
                imageView?.frame = CGRect(x: xPos[idx], y: 35, width: 40, height: 40)
                imageView?.tag = idx + 1
                
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(InspectionDefectTableViewCellMode1.previewTapOnClick(_:)))
                imageView?.userInteractionEnabled = true
                imageView?.addGestureRecognizer(tapGestureRecognizer)
                
                photoNameAtIndex[idx] = photo.photoFile
                
                self.addSubview(imageView!)
                
                let cBtn = CustomButton()
                cBtn.frame = CGRect.init(x: xPosBtn[idx], y: 27, width: 15, height: 15)
                cBtn.addTarget(self, action: #selector(InspectionDefectTableViewCellMode1.removeDefectPhotoOnIndex(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                cBtn.tag = idx + 1
                cBtn.setTitle("-", forState: UIControlState.Normal)
                cBtn.backgroundColor = UIColor.redColor()
                cBtn.layer.cornerRadius = _CORNERRADIUS
                
                self.addSubview(cBtn)
                
                idx += 1
            }
        }
    }
    
    func removeDefectPhotoOnIndex(sender: CustomButton) {
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete Photo?"),parentVC:self.pVC!, handlerFun: { (action:UIAlertAction!) in
            
            let defectsByItemId = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
            if defectsByItemId?.count>0 {
                let defectCell = defectsByItemId![0]
                
                self.clearDefectPhotoDataByPhotoName(defectCell.photoNames![sender.tag-1])
                defectCell.photoNames?.removeAtIndex(sender.tag-1)
                self.photoNameAtIndex.removeAtIndex(sender.tag-1)
            }
            
            let selfPhotoAdded = defectsByItemId!.filter({$0.photoNames?.count > 0})
            
            if selfPhotoAdded.count<1 {
                self.photoAdded = String(PhotoAddedStatus.init(caseId: "no"))
            }
            
            let defectsByItemIdFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && self.cellIdx>=0})
            let ifPhotoAdded = defectsByItemIdFilter!.filter({$0.photoNames?.count > 0})
            
            if ifPhotoAdded.count<1 {
                self.updatePhotoAddedStatus("no")
            }
            
            self.pVC?.updateContentView()
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.pVC?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        NSLog("Image Pick")
        
        picker.dismissViewControllerAnimated(true, completion:{
            if !self.photoNameAtIndex.contains("") {
                self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
                return
            }
            
            let imageView = UIImageView.init(image: image)
            
            let photo = Photo(photo: imageView, photoFilename: "", taskId: (Cache_Task_On?.taskId)!, photoFile: "")
            
            let photoName = self.getNameBySaveDefectPhotoData(0, photo: photo!)
            
            let defectItem = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
            if defectItem?.count > 0 {
                let defectCell = (defectItem![0] as TaskInspDefectDataRecord)
                
                if defectCell.photoNames == nil {
                    defectCell.photoNames = [String]()
                }
                
                if defectCell.photoNames!.count<=5 {
                    defectCell.photoNames!.append(photoName)
                }
            }
            
            //Update InspItem PhotoAdded Status
            self.photoAdded = String(PhotoAddedStatus.init(caseId: "yes"))
            self.updatePhotoAddedStatus("yes")
            
            NSNotificationCenter.defaultCenter().postNotificationName("reloadPhotos", object: nil, userInfo: ["photoSelected":photo!])
            
            self.pVC?.updateContentView()
        })
        
    }
    
    func saveDefectPhotoData(index:Int, photo:Photo, needSave:Bool=true) ->Photo {
        
        //Save self to DB for TaskInspDefectRecordId
        if self.taskDefectDataRecordId<1 {
            let taskDataHelper = TaskDataHelper()
            let defectItem = TaskInspDefectDataRecord(recordId: self.taskDefectDataRecordId,taskId: (Cache_Task_On?.taskId)!, inspectRecordId: self.inspItem?.taskInspDataRecordId, refRecordId: 0, inspectElementId: self.inspItem?.elementDbId, defectDesc: "", defectQtyCritical: 0, defectQtyMajor: 0, defectQtyMinor: 0, defectQtyTotal: 0, createUser: Cache_Inspector?.appUserName, createDate: self.getCurrentDateTime(), modifyUser: Cache_Inspector?.appUserName, modifyDate: self.getCurrentDateTime())
            self.taskDefectDataRecordId = taskDataHelper.updateInspDefectDataRecord(defectItem!)
            
            let defectItemFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
            
            if defectItemFilter?.count > 0 {
                let defectItem = defectItemFilter![0]
                defectItem.recordId = self.taskDefectDataRecordId
            }
        }
        
        //Save Photo to Local
        return UIImage.init().saveImageToLocal((photo.photo?.image)!, photoFileName: photo.photoFilename, photoId: photo.photoId, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: self.taskDefectDataRecordId, dataType: PhotoDataType(caseId: "DEFECT").rawValue, currentDate: self.getCurrentDateTime(), originFileName: "originFileNameMode1")
    }
    
    func getNameBySaveDefectPhotoData(index:Int, photo:Photo, needSave:Bool=true) ->String {
        
        //Save self to DB for TaskInspDefectRecordId
        if self.taskDefectDataRecordId<1 {
            let taskDataHelper = TaskDataHelper()
            let defectItem = TaskInspDefectDataRecord(recordId: self.taskDefectDataRecordId,taskId: (Cache_Task_On?.taskId)!, inspectRecordId: self.inspItem?.taskInspDataRecordId, refRecordId: 0, inspectElementId: self.inspItem?.elementDbId, defectDesc: "", defectQtyCritical: 0, defectQtyMajor: 0, defectQtyMinor: 0, defectQtyTotal: 0, createUser: Cache_Inspector?.appUserName, createDate: self.getCurrentDateTime(), modifyUser: Cache_Inspector?.appUserName, modifyDate: self.getCurrentDateTime())
            self.taskDefectDataRecordId = taskDataHelper.updateInspDefectDataRecord(defectItem!)
            
            let defectItemFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
            
            if defectItemFilter?.count > 0 {
                let defectItem = defectItemFilter![0]
                defectItem.recordId = self.taskDefectDataRecordId
            }
        }
        
        //Save Photo to Local
        return UIImage.init().getNameBySaveImageToLocal((photo.photo?.image)!, photoFileName: photo.photoFilename, photoId: photo.photoId, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: self.taskDefectDataRecordId, dataType: PhotoDataType(caseId: "DEFECT").rawValue, currentDate: self.getCurrentDateTime(), originFileName: "originFileNameMode1")
    }
    
    func updatePhotoAddedStatus(newStatus:String) {
        if newStatus == "yes" {
            (self.inspItem as! InputMode01CellView).photoAdded = true
        }else{
            (self.inspItem as! InputMode01CellView).photoAdded = false
        }
        
        (self.inspItem as! InputMode01CellView).updatePhotoAddediConStatus("",photoTakenIcon: (self.inspItem as! InputMode01CellView).photoAddedIcon)
    }
    
    func previewTapOnClick(sender: UITapGestureRecognizer) {
        if (sender.view as! UIImageView).image != nil {
            let imageView = sender.view as! UIImageView
            
            if imageView.tag-1 >= 0 && imageView.tag-1 < self.photos.count {
                imageView.previewImage(imageView.tag-1,imageName:self.photoNameAtIndex[imageView.tag-1],senderImageView: imageView, parentItem: self)
            }
        }
    }
    
    @IBAction func removeDefectCell(sender: UIButton) {
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete Defect Item?"),parentVC:self.pVC!, handlerFun: { (action:UIAlertAction!) in
            
            self.photoAdded = String(PhotoAddedStatus.init(caseId: "no"))
            self.removeDefectCell()
            
            let defectsByItemIdFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && self.cellIdx>=0})
            let ifPhotoAdded = defectsByItemIdFilter!.filter({$0.photoNames?.count > 0})
            
            if ifPhotoAdded.count<1 {
                self.updatePhotoAddedStatus("no")
            }
        })
    }
    
    override func removeDefectCell() {
        
        let defectCellFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
        if defectCellFilter?.count > 0 {
            let defectCell = defectCellFilter![0] as TaskInspDefectDataRecord
            
            if defectCell.photoNames != nil && defectCell.photoNames?.count>0 {
                for idx in 0...(defectCell.photoNames?.count)!-1 {
                    clearDefectPhotoDataAtIndex(idx)
                }
            }
            
            let index = Cache_Task_On?.defectItems.indexOf({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
            Cache_Task_On?.defectItems.removeAtIndex(index!)
            
            //Delete Record From DB
            if self.taskDefectDataRecordId > 0 {
                self.deleteTaskInspDefectDataRecord(self.taskDefectDataRecordId!)
            }
            
            self.pVC?.updateContentView()
            
            //Update Photo Album
            NSNotificationCenter.defaultCenter().postNotificationName("reloadAllPhotosFromDB", object: nil)
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if textField == self.defectTypeInput {
            
            /*
             Element Type
             1: Inspect Item
             2: Defect Item
             */

            var dfElms = [String]()
            for key in defectTypeKeyValues.keys {
                dfElms.append(key)
            }
 
            if self.ifExistingSubviewByViewTag(self.pVC.inspectDefectTableview, tag: _TAG1) {
                clearDropdownviewForSubviews(self.pVC.inspectDefectTableview)
            } else {
                textField.showListData(textField, parent: self.pVC.inspectDefectTableview, handle: dropdownHandleFunc, listData: self.sortStringArrayByName(dfElms), height:_DROPDOWNLISTHEIGHT, tag: _TAG1)
            }
            return false
        } else if textField == self.defectDesc1Input {
            
            //self.defectValues = ZoneDataHelper.sharedInstance.getDefectValuesByElementId(self.inspectElementId ?? 0)
            var listData = [String]()
            
            self.defectValues?.forEach({ value in
                listData.append(_ENGLISH ? value.valueNameEn ?? "":value.valueNameCn ?? "")
            })
            
            if self.ifExistingSubviewByViewTag(self.pVC.inspectDefectTableview, tag: _TAG1) {
                clearDropdownviewForSubviews(self.pVC.inspectDefectTableview)
            } else {
                textField.showListData(textField, parent: self.pVC.inspectDefectTableview, handle: dropdownHandleFunc, listData: self.sortStringArrayByName(listData), height:_DROPDOWNLISTHEIGHT, tag: _TAG1)
            }
            

            return false
        } else if textField == self.defectDesc2Input {
            
            //self.caseValues = ZoneDataHelper.sharedInstance.getCaseValuesByElementId(self.inspectElementId ?? 0)
            var listData = [String]()
            
            self.caseValues?.forEach({ value in
                listData.append(_ENGLISH ? value.valueNameEn ?? "":value.valueNameCn ?? "")
            })
            
            if self.ifExistingSubviewByViewTag(self.pVC.inspectDefectTableview, tag: _TAG1) {
                clearDropdownviewForSubviews(self.pVC.inspectDefectTableview)
            } else {
                
                textField.showListData(textField, parent: self.pVC.inspectDefectTableview, handle: dropdownHandleFunc, listData: self.sortStringArrayByName(listData), height:_DROPDOWNLISTHEIGHT, tag: _TAG1)
            }

            return false
        } else if textField == self.majorInput || textField == self.minorInput || textField == self.criticalInput {
            
            if textField.text == "0" {
                textField.text = ""
            }
        } else if textField == self.defectDescInput {
            var listData = [String]()
            for key in self.remarkKeyValue.keys {
                listData.append(key)
            }
            
            if self.ifExistingSubviewByViewTag(self.pVC.inspectDefectTableview, tag: _TAG1) {
                clearDropdownviewForSubviews(self.pVC.inspectDefectTableview)
            } else {
                textField.showListData(textField, parent: self.pVC.inspectDefectTableview, handle: dropdownHandleFunc, listData: self.sortStringArrayByName(listData), height:_DROPDOWNLISTHEIGHT, allowMulpSel: true, tag: _TAG1)
            }
            
            return false
        }
        
        return true
    }
    
    override func textFieldDidEndEditing(textField: UITextField) {
        if textField == self.majorInput || textField == self.minorInput || textField == self.criticalInput {
            
            if textField.text == "" {
                textField.text = "0"
            }
        } else if textField == self.othersRemarkInput {
            
            let defectItemFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx}).first
            guard let defectItem = defectItemFilter else {return}
            
            defectItem.othersRemark = textField.text
        }
    }
    
    func dropdownHandleFunc(textField:UITextField) {
        
        let defectItemFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx}).first
        guard let defectItem = defectItemFilter else {return}
        
        if textField == self.defectTypeInput {
            
            defectItem.inspectElementId = defectTypeKeyValues[textField.text ?? ""]
            self.inspectElementId = inspectElementId
            defectItem.defectType = textField.text ?? ""
            
            self.defectDesc1Input.text = ""
            self.defectDesc2Input.text = ""
            defectItem.inspectElementDefectValueId = 0
            defectItem.inspectElementCaseValueId = 0
            
            self.defectValues = ZoneDataHelper.sharedInstance.getDefectValuesByElementId(defectItem.inspectElementId ?? 0)
            self.caseValues = ZoneDataHelper.sharedInstance.getCaseValuesByElementId(defectItem.inspectElementId ?? 0)
            
            if self.defectValues?.count < 1 {
                self.defectDesc1Input.backgroundColor = _GREY_BACKGROUD
                self.defectDesc1ListIcon.hidden = true
            } else {
                self.defectDesc1Input.backgroundColor = UIColor.whiteColor()
                self.defectDesc1ListIcon.hidden = false
            }
            
            if self.caseValues?.count < 1 {
                self.defectDesc2Input.backgroundColor = _GREY_BACKGROUD
                self.defectDesc2ListIcon.hidden = true
            } else {
                self.defectDesc2Input.backgroundColor = UIColor.whiteColor()
                self.defectDesc2ListIcon.hidden = false
            }
            
        } else if textField == self.defectDesc1Input {
            
            guard let defectValueName = self.defectDesc1Input.text else {return}
            guard let defectValues = self.defectValues else {return}
            
            defectValues.forEach({ selectedObject in
                if selectedObject.valueNameEn == defectValueName || selectedObject.valueNameCn == defectValueName {
                    self.inspectElementDefectValueId = selectedObject.valueId
                    defectItem.inspectElementDefectValueId = selectedObject.valueId
                }
            })
            
        } else if textField == self.defectDesc2Input {
            
            guard let caseValueName = self.defectDesc2Input.text else {return}
            guard let caseValues = self.caseValues else {return}
            
            caseValues.forEach({ selectedObject in
                if selectedObject.valueNameEn == caseValueName || selectedObject.valueNameCn == caseValueName {
                    self.inspectElementCaseValueId = selectedObject.valueId
                    defectItem.inspectElementCaseValueId = selectedObject.valueId
                }
            })
            
        } else if textField == self.defectDescInput {
            defectItem.defectRemarksOptionList = self.defectDescInput.text
            
        }
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        Cache_Task_On?.didModify = true
        
        let defectItemFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
        
        if textField.keyboardType == UIKeyboardType.NumberPad {
            if defectItemFilter?.count>0 {
                let defectItem = defectItemFilter![0]
                
                if textField == self.criticalInput {
                    defectItem.defectQtyCritical = 0
                    
                }else if textField == self.majorInput {
                    defectItem.defectQtyMajor = 0
                    
                }else if textField == self.minorInput {
                    defectItem.defectQtyMinor = 0
                    
                }
                
                defectItem.defectQtyTotal = Int(defectItem.defectQtyCritical + defectItem.defectQtyMajor + defectItem.defectQtyMinor)
                self.defectQtyInput.text = String(defectItem.defectQtyTotal)
            }
        }
        
        return true
    }
    
    override func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        Cache_Task_On?.didModify = true
        var inputValue = ""
        if textField.text!.characters.count < 2 && string == "" {
            inputValue = ""
        }else if string == ""{
            inputValue = String(textField.text!.characters.dropLast())
        }else {
            inputValue = textField.text! + string
        }
        
        let defectItemFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
        
        if textField.keyboardType == UIKeyboardType.NumberPad {
            if defectItemFilter?.count>0 {
                let defectItem = defectItemFilter![0]
                
                if Int(inputValue) == nil {
                    inputValue = "0"
                }
                //if Int(inputValue) != nil {
                
                if textField == self.criticalInput {
                    defectItem.defectQtyCritical = Int(inputValue)!
                    
                }else if textField == self.majorInput {
                    defectItem.defectQtyMajor = Int(inputValue)!
                    
                }else if textField == self.minorInput {
                    defectItem.defectQtyMinor = Int(inputValue)!
                    
                }
                //}
                
                defectItem.defectQtyTotal = Int(defectItem.defectQtyCritical + defectItem.defectQtyMajor + defectItem.defectQtyMinor)
                self.defectQtyInput.text = String(defectItem.defectQtyTotal)
            }
            
            return textField.numberOnlyCheck(textField, sourceText: string)
        }
        
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.pVC.view.clearDropdownviewForSubviews((self.pVC?.view)!)
    }
}
