//
//  InspectionDefectTableViewCellMode2.swift
//  QCFossil
//
//  Created by pacmobile on 19/1/2017.
//  Copyright © 2017 kira. All rights reserved.
//


import UIKit

class InspectionDefectTableViewCellMode2: InputModeDFMaster2, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var defectDescLabel: UILabel!
    @IBOutlet weak var defectDescInput: UITextField!
    @IBOutlet weak var defectCriticalQtyLabel: UILabel!
    @IBOutlet weak var defectCriticalQtyInput: UITextField!
    @IBOutlet weak var defectMajorQtyLabel: UILabel!
    @IBOutlet weak var defectMajorQtyInput: UITextField!
    @IBOutlet weak var defectMinorQtyLabel: UILabel!
    @IBOutlet weak var defectMinorQtyInput: UITextField!
    @IBOutlet weak var defectTotalQtyLabel: UILabel!
    @IBOutlet weak var defectTotalQtyInput: UITextField!
    @IBOutlet weak var defectTypeLabel: UILabel!
    @IBOutlet weak var defectTypeInput: UITextField!
    @IBOutlet weak var defectPPILabel: UILabel!
    @IBOutlet weak var defectPPIInput: UITextField!
    @IBOutlet weak var defectPositLabel: UILabel!
    @IBOutlet weak var defectPositInput: UITextField!
    @IBOutlet weak var defectDesc1Label: UILabel!
    @IBOutlet weak var defectDesc1Input: UITextField!
    @IBOutlet weak var defectDesc2Label: UILabel!
    @IBOutlet weak var defectDesc2Input: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var defectDesc1ListIcon: UIButton!
    @IBOutlet weak var defectDesc2ListIcon: UIButton!
    
    weak var pVC:InspectionDefectList!
    
    var defectValues:[DropdownValue]?
    var caseValues:[DropdownValue]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.defectDescInput.delegate = self
        self.defectCriticalQtyInput.delegate = self
        self.defectMajorQtyInput.delegate = self
        self.defectMinorQtyInput.delegate = self
        self.defectTotalQtyInput.delegate = self
        self.defectTypeInput.delegate = self
        self.defectPPIInput.delegate = self
        self.defectPositInput.delegate = self
        self.defectDesc1Input.delegate = self
        self.defectDesc2Input.delegate = self
        self.defectTotalQtyInput.userInteractionEnabled = false
        
        self.defectDescLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Description")
        self.defectPositLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Position")
        self.defectPPILabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Position Points & Info")
        self.defectTypeLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Type")
        self.defectCriticalQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Critical")
        self.defectMajorQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Major")
        self.defectMinorQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Minor")
        self.defectTotalQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Total")
        self.defectDesc1Label.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Desc. 1")
        self.defectDesc2Label.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Desc. 2")
        self.errorMessageLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please enter defect quantity")
    }
    
    @IBAction func addDefectPhoto(sender: UIButton) {
        print("add Cell photo")
        
        NSNotificationCenter.defaultCenter().postNotificationName(UIKeyboardWillHideNotification, object: nil)
        
        if !self.photoNameAtIndex.contains("") {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
            return
        }
        
        self.defectDescInput.resignFirstResponder()
        self.defectCriticalQtyInput.resignFirstResponder()
        self.defectMajorQtyInput.resignFirstResponder()
        self.defectMinorQtyInput.resignFirstResponder()
        self.defectTotalQtyInput.resignFirstResponder()
        self.defectPPIInput.resignFirstResponder()
        self.defectPositInput.resignFirstResponder()
        
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
                
                imageView.frame = CGRect(x: xPos[idx], y: 187, width: 40, height: 40)
                imageView.tag = idx + 1
                
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(InspectionDefectTableViewCellMode2.previewTapOnClick(_:)))
                imageView.userInteractionEnabled = true
                imageView.addGestureRecognizer(tapGestureRecognizer)
                
                photoNameAtIndex[idx] = photoName
                
                self.addSubview(imageView)
                
                let cBtn = CustomControlButton()
                cBtn.frame = CGRect.init(x: xPosBtn[idx], y: 174, width: 20, height: 20)
                cBtn.addTarget(self, action: #selector(InspectionDefectTableViewCellMode2.removeDefectPhotoOnIndex(_:)), forControlEvents: UIControlEvents.TouchUpInside)
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
                
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(InspectionDefectTableViewCellMode2.previewTapOnClick(_:)))
                imageView?.userInteractionEnabled = true
                imageView?.addGestureRecognizer(tapGestureRecognizer)
                
                photoNameAtIndex[idx] = photo.photoFile
                
                self.addSubview(imageView!)
                
                let cBtn = CustomButton()
                cBtn.frame = CGRect.init(x: xPosBtn[idx], y: 27, width: 15, height: 15)
                cBtn.addTarget(self, action: #selector(InspectionDefectTableViewCellMode2.removeDefectPhotoOnIndex(_:)), forControlEvents: UIControlEvents.TouchUpInside)
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
        
        picker.dismissViewControllerAnimated(true, completion: {
        
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
        return UIImage.init().saveImageToLocal((photo.photo?.image)!, photoFileName: photo.photoFilename, photoId: photo.photoId, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: self.taskDefectDataRecordId, dataType: PhotoDataType(caseId: "DEFECT").rawValue, currentDate: self.getCurrentDateTime(), originFileName: "originFileNameMode2")
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
        return UIImage.init().getNameBySaveImageToLocal((photo.photo?.image)!, photoFileName: photo.photoFilename, photoId: photo.photoId, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: self.taskDefectDataRecordId, dataType: PhotoDataType(caseId: "DEFECT").rawValue, currentDate: self.getCurrentDateTime(), originFileName: "originFileNameMode2")
    }
    
    func updatePhotoAddedStatus(newStatus:String) {
        if newStatus == "yes" {
            (self.inspItem as! InputMode02CellView).photoAdded = true
        }else{
            (self.inspItem as! InputMode02CellView).photoAdded = false
        }
        
        (self.inspItem as! InputMode02CellView).updatePhotoAddediConStatus("",photoTakenIcon: (self.inspItem as! InputMode02CellView).photoAddedIcon)
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
            let defectDataHelper = DefectDataHelper()
            /*
             Element Type
             1: Inspect Item
             2: Defect Item
             */
            
            if let parentCellView = self.inspItem as? InputMode02CellView {
                let positionIds = parentCellView.myDefectPositPoints
                let positionIdArray = positionIds.map({ position in
                    return "\(position.positionId)"
                })
                
                let dfElms = defectDataHelper.getDefectTypeElms(positionIdArray)
                textField.showListData(textField, parent: self.pVC.inspectDefectTableview, handle: dropdownHandleFunc, listData: self.sortStringArrayByName(dfElms), height:_DROPDOWNLISTHEIGHT)
            } else {
                
                guard let id = self.taskDefectDataRecordId else {return false}
                let dfElms = defectDataHelper.getDefectTypeByTaskDefectDataRecordId(id)
                
                textField.showListData(textField, parent: self.pVC.inspectDefectTableview, handle: dropdownHandleFunc, listData: self.sortStringArrayByName(dfElms), height:_DROPDOWNLISTHEIGHT)
            }
            
            return false
        } else if textField == self.defectDesc1Input {
            
            self.defectValues = ZoneDataHelper.sharedInstance.getDefectValuesByElementId(self.inspectElementId ?? 0)
            var listData = [String]()
            
            self.defectValues?.forEach({ value in
                listData.append(_ENGLISH ? value.valueNameEn ?? "":value.valueNameCn ?? "")
            })
            
            textField.showListData(textField, parent: self.pVC.inspectDefectTableview, handle: dropdownHandleFunc, listData: self.sortStringArrayByName(listData), height:_DROPDOWNLISTHEIGHT)
            
            return false
        } else if textField == self.defectDesc2Input {
            
            self.caseValues = ZoneDataHelper.sharedInstance.getCaseValuesByElementId(self.inspectElementId ?? 0)
            var listData = [String]()
            
            self.caseValues?.forEach({ value in
                listData.append(_ENGLISH ? value.valueNameEn ?? "":value.valueNameCn ?? "")
            })
            
            textField.showListData(textField, parent: self.pVC.inspectDefectTableview, handle: dropdownHandleFunc, listData: self.sortStringArrayByName(listData), height:_DROPDOWNLISTHEIGHT)

            return false
        } else if textField == self.defectMajorQtyInput || textField == self.defectMinorQtyInput || textField == self.defectCriticalQtyInput {
            
            if textField.text == "0" {
                textField.text = ""
            }
        }
        
        return true
    }
    
    override func textFieldDidEndEditing(textField: UITextField) {
        if textField == self.defectMajorQtyInput || textField == self.defectMinorQtyInput || textField == self.defectCriticalQtyInput {
            if textField.text == "" {
                textField.text = "0"
            }
        }
    }
    
    func dropdownHandleFunc(textField:UITextField) {
        let defectItemFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx}).first
        guard let defectItem = defectItemFilter else {return}
        
        if textField == self.defectTypeInput {
            
            let defectDataHelper = DefectDataHelper()
            let inspectElementId = defectDataHelper.getInspElementIdByName(textField.text ?? "")
            defectItem.inspectElementId = inspectElementId
            self.inspectElementId = inspectElementId
            defectItem.defectType = textField.text ?? ""
            
            let defectValues = ZoneDataHelper.sharedInstance.getDefectValuesByElementId(defectItem.inspectElementId ?? 0)
            let caseValues = ZoneDataHelper.sharedInstance.getCaseValuesByElementId(defectItem.inspectElementId ?? 0)
            
            if defectValues.count < 1 {
                self.defectDesc1Input.backgroundColor = _GREY_BACKGROUD
                self.defectDesc1ListIcon.hidden = true

            } else {
                self.defectDesc1Input.backgroundColor = UIColor.whiteColor()
                self.defectDesc1ListIcon.hidden = false

            }
            
            if caseValues.count < 1 {
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
            
        }
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        Cache_Task_On?.didModify = true
        
        let defectItemFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
        
        if textField.keyboardType == UIKeyboardType.NumberPad {
            if defectItemFilter?.count>0 {
                let defectItem = defectItemFilter![0]
                
                if textField == self.defectCriticalQtyInput {
                    defectItem.defectQtyCritical = 0
                    
                }else if textField == self.defectMajorQtyInput {
                    defectItem.defectQtyMajor = 0
                    
                }else if textField == self.defectMinorQtyInput {
                    defectItem.defectQtyMinor = 0
                    
                }
                
                defectItem.defectQtyTotal = Int(defectItem.defectQtyCritical + defectItem.defectQtyMajor + defectItem.defectQtyMinor)
                self.defectTotalQtyInput.text = String(defectItem.defectQtyTotal)
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
                    
                if textField == self.defectCriticalQtyInput {
                    defectItem.defectQtyCritical = Int(inputValue)!
                        
                }else if textField == self.defectMajorQtyInput {
                    defectItem.defectQtyMajor = Int(inputValue)!
                        
                }else if textField == self.defectMinorQtyInput {
                    defectItem.defectQtyMinor = Int(inputValue)!
                        
                }
                //}
                
                defectItem.defectQtyTotal = Int(defectItem.defectQtyCritical + defectItem.defectQtyMajor + defectItem.defectQtyMinor)
                self.defectTotalQtyInput.text = String(defectItem.defectQtyTotal)
            }
            
            return textField.numberOnlyCheck(textField, sourceText: string)
        }else{
            if defectItemFilter?.count>0 {
                let defectItem = defectItemFilter![0]
                
                defectItem.defectDesc = inputValue
            }
        }
        
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        
        self.pVC.view.clearDropdownviewForSubviews((self.pVC?.view)!)
        
    }
}
