//
//  DefectListTableViewCellMode2.swift
//  QCFossil
//
//  Created by pacmobile on 24/10/2016.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class DefectListTableViewCellMode3: InputModeDFMaster2, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ELCImagePickerControllerDelegate {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var icLabel: UILabel!
    @IBOutlet weak var icInput: UITextField!
    @IBOutlet weak var iiLabel: UILabel!
    @IBOutlet weak var iiInput: UITextField!
    @IBOutlet weak var ddLabel: UILabel!
    @IBOutlet weak var ddInput: UITextField!
    @IBOutlet weak var dfQtyLabel: UILabel!
    @IBOutlet weak var dfQtyInput: UITextField!
    @IBOutlet weak var addDescButton: UIButton!
    @IBOutlet weak var dismissDescButton: UIButton!
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
    @IBOutlet weak var sectionName: UILabel!
    @IBOutlet weak var addDefectPhotoButton: CustomControlButton!
    @IBOutlet weak var addDefectPhotoByCamera: CustomControlButton!
    @IBOutlet weak var addDefectPhotoByAlbum: CustomControlButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    weak var pVC:DefectListViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
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
        
        self.dfQtyInput.delegate = self
        self.activityIndicator.hidden = true
        //imagePicker.delegate = self
        
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
        self.icLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Category")
        self.iiLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Item")
        self.ddLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Description")
        self.dfQtyLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Qty")
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
    
    @IBAction func addDefectCellButton(sender: UIButton) {
        print("add cell")
        
        if self.icInput.text == "" || self.iiInput.text == "" {
            self.alertView("Please select the Inspect Area & Inspect Item!")
            return
        }
        
        let defectsByItemId = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId})
        self.pVC!.addDefectCellWithSection(_INPUTMODE03, idxLabel: "\(self.itemId).\((defectsByItemId?.count)!)",iaLabel: icInput.text!,iiLabel: iiInput.text!,sectionId: sectionId,itemId: itemId, inspItem: inspItem!, cellIdx: (defectsByItemId?.count)!)
    }
    
    @IBAction func dismissDefectCellButton(sender: UIButton) {
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete Defect Item?"),parentVC:self.pVC!, handlerFun: { (action:UIAlertAction!) in
            
            self.photoAdded = String(PhotoAddedStatus.init(caseId: "no"))
            
            let defectsByItemIdFilter = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && self.cellIdx>=0})
            let ifPhotoAdded = defectsByItemIdFilter!.filter({$0.photoNames?.count > 0})
            
            if ifPhotoAdded.count<1 {
                self.updatePhotoAddedStatus("no")
            }
            
            self.removeDefectCell()
            
        })
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
    
    func getNamesBySaveDefectPhotos(photos:[Photo], needSave:Bool=true) ->[String] {
        
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
        return UIImage.init().getNamesBySaveImageToLocal(photos, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: self.taskDefectDataRecordId, dataType: PhotoDataType(caseId: "DEFECT").rawValue, currentDate: self.getCurrentDateTime(), originFileName: "originFileNameMode3")
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
    
    func elcImagePickerController(picker: ELCImagePickerController!, didFinishPickingMediaWithInfo info: [AnyObject]!) {
        
        let defectItem = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == self.sectionId && $0.inspElmt.cellIdx == self.itemId && $0.cellIdx == self.cellIdx})
        var photos = [Photo]()
        
        for object in info {
            
            if let dictionary = object as? NSDictionary {
                
                if let image = dictionary.objectForKey(UIImagePickerControllerOriginalImage) as? UIImage {
                    
                    let imageView = UIImageView.init(image: image)
                    
                    if let photo = Photo(photo: imageView, photoFilename: "", taskId: (Cache_Task_On?.taskId)!, photoFile: "") {
                        
                        photos.append(photo)
                        
                    }
                }
            }
        }
        
        //Update InspItem PhotoAdded Status
        self.photoAdded = String(PhotoAddedStatus.init(caseId: "yes"))
        self.updatePhotoAddedStatus("yes")
        
        self.parentVC?.dismissViewControllerAnimated(true, completion: {
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                let photoNames = self.getNamesBySaveDefectPhotos(photos)
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if defectItem?.count > 0 {
                        let defectCell = (defectItem![0] as TaskInspDefectDataRecord)
                        
                        if defectCell.photoNames == nil {
                            defectCell.photoNames = [String]()
                        }
                        
                        photoNames.forEach({
                            defectCell.photoNames?.append(String($0))
                        })
                        
                    }
                    
                    photos.forEach({
                        NSNotificationCenter.defaultCenter().postNotificationName("reloadPhotos", object: nil, userInfo: ["photoSelected":$0])
                    })
                    
                    self.pVC?.updateContentView()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                })
            }
        })
    }
    
    func elcImagePickerControllerDidCancel(picker: ELCImagePickerController!) {
        self.parentVC?.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func dismissDfPhotoButton(sender: CustomButton) {
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
    
    @IBAction func addDefectPhotoButton(sender: CustomButton) {
        print("add Cell photo")
        NSNotificationCenter.defaultCenter().postNotificationName(UIKeyboardWillHideNotification, object: nil)
        
        if self.defectPhoto1.image != nil && self.defectPhoto2.image != nil && self.defectPhoto3.image != nil && self.defectPhoto4.image != nil && self.defectPhoto5.image != nil {
            
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
            return
        }
        
        self.ddInput.resignFirstResponder()
        self.dfQtyInput.resignFirstResponder()
        
        let availableCount = self.photoNameAtIndex.filter({$0 == ""})
        
        let imagePicker = ELCImagePickerController(imagePicker: ())
        imagePicker.maximumImagesCount = availableCount.count
        imagePicker.returnsOriginalImage = true
        imagePicker.returnsImage = true
        imagePicker.onOrder = true
        
        imagePicker.imagePickerDelegate = self
        self.parentVC?.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addDefectPhotoFromCamera(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName(UIKeyboardWillHideNotification, object: nil)
        
        if !self.photoNameAtIndex.contains("") {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            imagePicker.sourceType = .Camera
            self.pVC?.presentViewController(imagePicker, animated: true, completion: nil)
            
        }else{
            let availableCount = self.photoNameAtIndex.filter({$0 == ""})
            
            let imagePicker = ELCImagePickerController(imagePicker: ())
            imagePicker.maximumImagesCount = availableCount.count
            imagePicker.returnsOriginalImage = true
            imagePicker.returnsImage = true
            imagePicker.onOrder = true
            
            imagePicker.imagePickerDelegate = self
            self.pVC?.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func addDefectPhotoFromAlbum(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName(UIKeyboardWillHideNotification, object: nil)
        
        if !self.photoNameAtIndex.contains("") {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
            return
        }
        
        self.pVC?.currentCell = self
        self.parentVC?.performSegueWithIdentifier("PhotoAlbumSegueFromDF", sender: self)
    }
}
