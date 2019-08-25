//
//  DefectListTableViewCellMode2.swift
//  QCFossil
//
//  Created by pacmobile on 19/1/2017.
//  Copyright © 2017 kira. All rights reserved.
//

import UIKit

class DefectListTableViewCellMode2: InputModeDFMaster2, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var indexInput: UILabel!
    @IBOutlet weak var dpLabel: UILabel!
    @IBOutlet weak var dpInput: UITextField!
    @IBOutlet weak var dppLabel: UILabel!
    @IBOutlet weak var dppInput: UITextField!
    @IBOutlet weak var dtLabel: UILabel!
    @IBOutlet weak var dtInput: UITextField!
    @IBOutlet weak var dfDescLabel: UILabel!
    @IBOutlet weak var dfDescInput: UITextField!
    @IBOutlet weak var criticalLabel: UILabel!
    @IBOutlet weak var criticalInput: UITextField!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var majorInput: UITextField!
    @IBOutlet weak var minorLabel: UILabel!
    @IBOutlet weak var minorInput: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalInput: UITextField!
    @IBOutlet weak var defectPhoto1: UIImageView!
    @IBOutlet weak var defectPhoto2: UIImageView!
    @IBOutlet weak var defectPhoto3: UIImageView!
    @IBOutlet weak var defectPhoto4: UIImageView!
    @IBOutlet weak var defectPhoto5: UIImageView!
    @IBOutlet weak var dismissPhotoButton1: CustomControlButton!
    @IBOutlet weak var dismissPhotoButton2: CustomControlButton!
    @IBOutlet weak var dismissPhotoButton3: CustomControlButton!
    @IBOutlet weak var dismissPhotoButton4: CustomControlButton!
    @IBOutlet weak var dismissPhotoButton5: CustomControlButton!
    @IBOutlet weak var addDefectPhotoButton: CustomControlButton!
    @IBOutlet weak var addDefectPhotoByCamera: CustomControlButton!
    @IBOutlet weak var addDefectPhotoByAlbum: CustomControlButton!
    @IBOutlet weak var sectionName: UILabel!
    
    weak var pVC:DefectListViewController!

    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    override func awakeFromNib() {
        defectPhoto1.image = nil
        defectPhoto2.image = nil
        defectPhoto3.image = nil
        defectPhoto4.image = nil
        defectPhoto5.image = nil
        
        dismissPhotoButton1.hidden = true
        dismissPhotoButton2.hidden = true
        dismissPhotoButton3.hidden = true
        dismissPhotoButton4.hidden = true
        dismissPhotoButton5.hidden = true
        
        self.dtInput.delegate = self
        self.criticalInput.delegate = self
        self.minorInput.delegate = self
        self.majorInput.delegate = self
        self.totalInput.delegate = self
        self.dfDescInput.delegate = self
        
        updateLocalizedString()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DefectListTableViewCellMode3.previewTapOnClick(_:)))
        defectPhoto1.addGestureRecognizer(tap)
        defectPhoto1.userInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(DefectListTableViewCellMode3.previewTapOnClick(_:)))
        defectPhoto2.addGestureRecognizer(tap2)
        defectPhoto2.userInteractionEnabled = true
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(DefectListTableViewCellMode3.previewTapOnClick(_:)))
        defectPhoto3.addGestureRecognizer(tap3)
        defectPhoto3.userInteractionEnabled = true
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(DefectListTableViewCellMode3.previewTapOnClick(_:)))
        defectPhoto4.addGestureRecognizer(tap4)
        defectPhoto4.userInteractionEnabled = true
        
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(DefectListTableViewCellMode3.previewTapOnClick(_:)))
        defectPhoto5.addGestureRecognizer(tap5)
        defectPhoto5.userInteractionEnabled = true
    }
    
    func updateLocalizedString(){
        self.dpLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Position")
        self.dppLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Position Point(s)")
        self.dtLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Type")
        self.dfDescLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Description")
        self.criticalLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Critical")
        self.majorLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Major")
        self.minorLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Minor")
        self.totalLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Total")
        
        self.criticalInput.text = "0"
        self.majorInput.text = "0"
        self.minorInput.text = "0"
        self.totalInput.text = "0"
    }
    
    func closePreviewLayer() {
        let maskView = self.parentVC?.parentViewController!.view.viewWithTag(_MASKVIEWTAG)
        maskView?.removeFromSuperview()
    }
    
    func previewTapOnClick(sender: UITapGestureRecognizer) {
        if (sender.view as! UIImageView).image != nil {
            let imageView = sender.view as! UIImageView
            
            if (Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Reviewed").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Refused").rawValue) {
                let container:UIView = UIView()
                container.tag = _MASKVIEWTAG
                container.hidden = false
                container.frame = (self.parentVC?.parentViewController!.view.frame)!
                container.center = (self.parentVC?.parentViewController!.view.center)!
                container.backgroundColor = UIColor.clearColor()
                
                let layer = UIView()
                layer.frame = (self.parentVC?.parentViewController!.view.frame)!
                layer.center = (self.parentVC?.parentViewController!.view.center)!
                layer.backgroundColor = UIColor.blackColor()
                layer.alpha = 0.7
                container.addSubview(layer)
                
                let image = UIImage(contentsOfFile: Cache_Task_Path!+"/"+self.photoNameAtIndex[imageView.tag-1])
                let imageView = UIImageView(image:image)
                
                imageView.frame = CGRect(x: 0,y: 0,width: 600,height: 800)
                imageView.center = (self.parentVC?.parentViewController!.view.center)!
                
                container.addSubview(imageView)
                
                let button = UIButton(type: UIButtonType.System) as UIButton
                button.frame = (self.parentVC?.parentViewController!.view.frame)!
                button.backgroundColor = UIColor.clearColor()
                button.titleLabel!.font = UIFont(name: "", size: 20)
                button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                button.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Tap Anywhere To Close"), forState: UIControlState.Normal)
                button.contentEdgeInsets = UIEdgeInsetsMake(400 + (self.parentVC?.parentViewController!.view.center.y)!-30, 0, 0, 0);
                button.addTarget(self, action: #selector(DefectListTableViewCellMode3.closePreviewLayer), forControlEvents: UIControlEvents.TouchUpInside)
                
                container.addSubview(button)
                
                self.parentVC?.parentViewController!.view.addSubview(container)
                
            }else if imageView.tag-1 >= 0 && imageView.tag-1 < self.photos.count {
                imageView.previewImage(imageView.tag-1,imageName:self.photoNameAtIndex[imageView.tag-1],senderImageView: imageView, parentItem: self)
            }
        }
    }
    
    func updatePhotoAddedStatus(newStatus:String) {
        if self.inspItem != nil {
            if newStatus == "yes" {
                (self.inspItem as! InputMode03CellView).photoAdded = true
            }else{
                (self.inspItem as! InputMode03CellView).photoAdded = false
            }
            
            (self.inspItem as! InputMode03CellView).updatePhotoAddediConStatus("",photoTakenIcon: (self.inspItem as! InputMode03CellView).photoTakenIcon)
        }
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
        }
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
        return UIImage.init().saveImageToLocal((photo.photo?.image)!, photoFileName: photo.photoFilename, photoId: photo.photoId, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: self.taskDefectDataRecordId, dataType: PhotoDataType(caseId: "DEFECT").rawValue, currentDate: self.getCurrentDateTime(), originFileName: "originFileName")
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
        return UIImage.init().getNameBySaveImageToLocal((photo.photo?.image)!, photoFileName: photo.photoFilename, photoId: photo.photoId, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: self.taskDefectDataRecordId, dataType: PhotoDataType(caseId: "DEFECT").rawValue, currentDate: self.getCurrentDateTime(), originFileName: "originFileName")
    }
    
    override func updateDefectPhotoData(index:Int, photo:Photo, needSave:Bool=true) ->Photo? {
        if index < photos.count {
            
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
            
            //Update Task Photo DB
            if self.taskDefectDataRecordId > 0 && photo.photoId > 0 {
                let photoDataHelper = PhotoDataHelper()
                photoDataHelper.updatePhotoDatas(photo.photoId!, dataType:PhotoDataType(caseId: "DEFECT").rawValue, dataRecordId:self.taskDefectDataRecordId!)
            }
            
            //Save Photo to Local
            if needSave {
                self.photos[index] = savePhotoToLocal(photo)
                
            }else{
                self.photos[index] =  photo
            }
            
            return self.photos[index]
        }
        
        return nil
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.pVC!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        NSLog("Image Pick")
        
        picker.dismissViewControllerAnimated(true, completion: {
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
            
            self.pVC!.updateContentView()
        })
    }
    
    @IBAction func dismissDfPhotoButton(sender: CustomControlButton) {
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete Photo?"),parentVC:self.pVC!, handlerFun: { (action:UIAlertAction!) in
            
            let defectsByItemId = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
            
            if defectsByItemId?.count>0 {
                let defectCell = defectsByItemId![0]
                
                self.clearDefectPhotoDataByPhotoName(defectCell.photoNames![sender.tag-1])
                defectCell.photoNames?.removeAtIndex(sender.tag-1)
                self.photoNameAtIndex[sender.tag-1] = ""
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
    
    @IBAction func addDefectPhotoButton(sender: CustomControlButton) {
        print("add Cell photo")
        NSNotificationCenter.defaultCenter().postNotificationName(UIKeyboardWillHideNotification, object: nil)
        
        if self.defectPhoto1.image != nil && self.defectPhoto2.image != nil && self.defectPhoto3.image != nil && self.defectPhoto4.image != nil && self.defectPhoto5.image != nil {
            
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
            return
        }
        
        self.dpInput.resignFirstResponder()
        self.dppInput.resignFirstResponder()
        self.dtInput.resignFirstResponder()
        self.dfDescInput.resignFirstResponder()
        self.criticalInput.resignFirstResponder()
        self.majorInput.resignFirstResponder()
        self.minorInput.resignFirstResponder()
        self.totalInput.resignFirstResponder()
        
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
    
    @IBAction func addDefectPhotoFromCamera(sender: CustomControlButton) {
        NSNotificationCenter.defaultCenter().postNotificationName(UIKeyboardWillHideNotification, object: nil)
        
        if !self.photoNameAtIndex.contains("") {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
            self.pVC!.presentViewController(imagePicker, animated: true, completion: nil)
            
        }else{
            imagePicker.modalPresentationStyle = .Popover
            imagePicker.sourceType = .PhotoLibrary
            
            let ppc = imagePicker.popoverPresentationController
            ppc?.sourceView = sender
            ppc?.sourceRect = sender.bounds
            ppc?.permittedArrowDirections = .Any
            
            imagePicker.sourceType = .PhotoLibrary
            
            self.pVC!.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func addDefectPhotoFromAlbum(sender: CustomControlButton) {
        NSNotificationCenter.defaultCenter().postNotificationName(UIKeyboardWillHideNotification, object: nil)
        
        if !self.photoNameAtIndex.contains("") {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
            return
        }
        
        self.pVC?.currentCell = self
        self.parentVC?.performSegueWithIdentifier("PhotoAlbumSegueFromDF", sender: self)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == self.dtInput {
            if self.ifExistingSubviewByViewTag(self.pVC.defectTableView, tag: _TAG1) {
                clearDropdownviewForSubviews(self.pVC.defectTableView)
                return false
            }
            
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
                textField.showListData(textField, parent: self.pVC.defectTableView, handle: dropdownHandleFunc, listData: self.sortStringArrayByName(dfElms), height: 500, tag: _TAG1)

            } else {
                
                guard let id = self.taskDefectDataRecordId else {return false}
                let dfElms = defectDataHelper.getDefectTypeByTaskDefectDataRecordId(id)
                textField.showListData(textField, parent: self.pVC.defectTableView, handle: dropdownHandleFunc, listData: self.sortStringArrayByName(dfElms), height: 500, tag: _TAG1)

            }
            
            return false
        }
        
        return true
    }
    
    func dropdownHandleFunc(textField:UITextField) {
        if textField == self.dtInput {
            
            let defectItemFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
            
            if defectItemFilter?.count>0 {
                let defectItem = defectItemFilter![0]
                let defectDataHelper = DefectDataHelper()
                
                defectItem.inspectElementId = defectDataHelper.getInspElementIdByName(textField.text!)
            }
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
                self.totalInput.text = String(defectItem.defectQtyTotal)
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
                self.totalInput.text = String(defectItem.defectQtyTotal)
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
    
    override func setSelectedPhoto(photo:Photo, needSave:Bool=true) {
        
        if defectPhoto1.image == nil {
            let resizePhoto = updateDefectPhotoData(0, photo: photo, needSave: needSave)
            defectPhoto1.image = resizePhoto!.photo?.image
            dismissPhotoButton1.hidden = false
            
        }else if defectPhoto2.image == nil {
            let resizePhoto = updateDefectPhotoData(1, photo: photo, needSave: needSave)
            defectPhoto2.image = resizePhoto!.photo?.image
            dismissPhotoButton2.hidden = false
            
        }else if defectPhoto3.image == nil {
            let resizePhoto = updateDefectPhotoData(2, photo: photo, needSave: needSave)
            defectPhoto3.image = resizePhoto!.photo?.image
            dismissPhotoButton3.hidden = false
            
        }else if defectPhoto4.image == nil {
            let resizePhoto = updateDefectPhotoData(3, photo: photo, needSave: needSave)
            defectPhoto4.image = resizePhoto!.photo?.image
            dismissPhotoButton4.hidden = false
            
        }else if defectPhoto5.image == nil {
            let resizePhoto = updateDefectPhotoData(4, photo: photo, needSave: needSave)
            defectPhoto5.image = resizePhoto!.photo?.image
            dismissPhotoButton5.hidden = false
            
        }
        
        //Update InspItem PhotoAdded Status
        self.photoAdded = String(PhotoAddedStatus.init(caseId: "yes"))
        updatePhotoAddedStatus("yes")
        
        NSNotificationCenter.defaultCenter().postNotificationName("reloadPhotos", object: nil, userInfo: ["photoSelected":photo])
        
        //
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.pVC.view.clearDropdownviewForSubviews((self.pVC?.view)!)
    }
}
