//
//  InputMode02DefectCellView.swift
//  QCFossil
//
//  Created by Yin Huang on 18/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class InputMode02DefectCellView: InputModeDFMaster2, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    @IBOutlet weak var dismissPhotoButton1: CustomButton!
    @IBOutlet weak var dismissPhotoButton2: CustomButton!
    @IBOutlet weak var dismissPhotoButton3: CustomButton!
    @IBOutlet weak var dismissPhotoButton4: CustomButton!
    @IBOutlet weak var dismissPhotoButton5: CustomButton!
    
    weak var pVC:DefectListViewController!
    //weak var inspItem = InputMode02CellView()
    
    
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
        
        updateLocalizedString()
    }

    func updateLocalizedString(){
        self.dpLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Position")
        self.dppLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Position Points")
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
    
    @IBAction func addDefectPhotoButton(sender: CustomButton) {
        print("add Cell photo")
        
        if self.defectPhoto1.image != nil && self.defectPhoto2.image != nil && self.defectPhoto3.image != nil && self.defectPhoto4.image != nil && self.defectPhoto5.image != nil {
            
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Defect Photos!"))
            return
        }
        
        let sheet:UIActionSheet = UIActionSheet()
        let title:String = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please choose a source")
        sheet.title = title
        sheet.delegate = self
        sheet.addButtonWithTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel"))
        sheet.addButtonWithTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Add from Photo Library"))
        sheet.addButtonWithTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Add from Camera"))
        sheet.addButtonWithTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Add from Photo Album"))
        sheet.cancelButtonIndex = 0
        sheet.showInView(self)
    }
    
    func actionSheet(sheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        NSLog("index %d %@", buttonIndex, sheet.buttonTitleAtIndex(buttonIndex)!)
        
        if buttonIndex < 1 {
            return
        }
        
        if buttonIndex > 2 {
            //self.pVC?.currentCell = self
            self.pVC?.performSegueWithIdentifier("PhotoAlbumSegueFromDF", sender: self)
        }else{
            
            var imagePicker:UIImagePickerController!
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            imagePicker.sourceType = .PhotoLibrary
            if buttonIndex > 1 {
                if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                    imagePicker.sourceType = .Camera
                }
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                self.pVC!.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
                self.pVC!.presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func dismissDfPhotoButton(sender: CustomButton) {
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete Photo?"),parentVC:self.pVC!, handlerFun: { (action:UIAlertAction!) in
            
        self.defectPhoto1.image = nil
        self.dismissPhotoButton1.hidden = true
        self.defectPhoto2.image = nil
        self.dismissPhotoButton2.hidden = true
        self.defectPhoto3.image = nil
        self.dismissPhotoButton3.hidden = true
        self.defectPhoto4.image = nil
        self.dismissPhotoButton4.hidden = true
        self.defectPhoto5.image = nil
        self.dismissPhotoButton5.hidden = true
            
        self.clearDefectPhotoDataAtIndex(sender.tag-1)
        self.refreshPhotos()
        var idx = 1
        for photo in self.photos {
            if photo?.photo != nil {
                if self.defectPhoto1.image == nil {
                    self.defectPhoto1.image = photo?.photo?.image
                    self.dismissPhotoButton1.hidden = false
                    
                }else if self.defectPhoto2.image == nil {
                    self.defectPhoto2.image = photo?.photo?.image
                    self.dismissPhotoButton2.hidden = false
                    
                }else if self.defectPhoto3.image == nil {
                    self.defectPhoto3.image = photo?.photo?.image
                    self.dismissPhotoButton3.hidden = false
                    
                }else if self.defectPhoto4.image == nil {
                    self.defectPhoto4.image = photo?.photo?.image
                    self.dismissPhotoButton4.hidden = false
                    
                }else if self.defectPhoto5.image == nil {
                    self.defectPhoto5.image = photo?.photo?.image
                    self.dismissPhotoButton5.hidden = false
                    
                }
            }
            idx += 1
        }
            
        //Update InspItem PhotoAdded Status
        if self.defectPhoto1.image == nil && self.defectPhoto2.image == nil && self.defectPhoto3.image == nil && self.defectPhoto4.image == nil && self.defectPhoto5.image == nil {
            self.photoAdded = String(PhotoAddedStatus.init(caseId: "no"))
        }
            
        let defectsByItemId = self.pVC?.defectCells.filter({$0.sectionId == self.sectionId && $0.itemId == self.itemId && self.cellIdx>=0})
        let ifPhotoAdded = defectsByItemId!.filter({($0 as! InputMode02DefectCellView).photoAdded == String(PhotoAddedStatus.init(caseId: "yes"))})
            
        if ifPhotoAdded.count<1 {
            self.updatePhotoAddedStatus("no")
        }
            
        })
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        NSLog("Image Pick")
        
        picker.dismissViewControllerAnimated(true, completion: {
            let imageView = UIImageView.init(image: image)
            let photo = Photo(photo: imageView, photoFilename: "", taskId: (Cache_Task_On?.taskId)!, photoFile: "")
            self.setSelectedPhoto(photo!)
        })
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
    }
    
    func updatePhotoAddedStatus(newStatus:String) {
        if newStatus == "yes" {
            (self.inspItem as! InputMode02CellView).photoAdded = true
        }else{
            (self.inspItem as! InputMode02CellView).photoAdded = false
        }
        
        (self.inspItem as! InputMode02CellView).updatePhotoAddediConStatus("",photoTakenIcon: (self.inspItem as! InputMode02CellView).photoAddedIcon)
    }
    
    @IBAction func previewTapOnClick(sender: UITapGestureRecognizer) {
        if (sender.view as! UIImageView).image != nil {
            let imageView = sender.view as! UIImageView
    
            if imageView.tag-1 >= 0 && imageView.tag-1 < self.photos.count {
                imageView.previewImage(imageView.tag-1,imageName:(self.photos[imageView.tag-1]?.photoFile)!,senderImageView: imageView, parentItem: self)
            }
        }
    }
    
    func saveDefectPhotos() {
        if defectPhoto1.image != nil {
            savePhotoToLocal(self.photos[0]!)
        }
        
        if defectPhoto2.image != nil {
            savePhotoToLocal(self.photos[1]!)
        }
        
        if defectPhoto3.image != nil {
            savePhotoToLocal(self.photos[2]!)
        }
        
        if defectPhoto4.image != nil {
            savePhotoToLocal(self.photos[3]!)
        }
        
        if defectPhoto5.image != nil {
            savePhotoToLocal(self.photos[4]!)
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == self.dtInput {
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
                textField.showListData(textField, parent: self.pVC!.defectTableView!, listData: dfElms, height:500)
            } else {
                
                guard let id = self.taskDefectDataRecordId else {return false}
                let dfElms = defectDataHelper.getDefectTypeByTaskDefectDataRecordId(id)
                textField.showListData(textField, parent: self.pVC!.defectTableView!, listData: dfElms, height:500)
            }
            
            return false
        }
        
        return true
    }
    
    @IBAction func dismissDefectCellButton(sender: UIButton) {
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete Defect Item?"),parentVC:self.pVC!, handlerFun: { (action:UIAlertAction!) in
            
            self.updatePhotoAddedStatus("no")
            self.removeDefectCell()
            
        })
    }
    
    override func removeDefectCell() {
        let idx = self.pVC?.defectCells.indexOf({$0.cellIdx==self.cellIdx && $0.itemId==self.itemId && $0.sectionId==self.sectionId})
        
        if idx >= 0 {
            self.pVC?.defectCells.removeAtIndex(idx!)
            self.removeFromSuperview()
            self.pVC?.updateContentView()
            
            for idx in 0...self.photos.count-1 {
                clearDefectPhotoDataAtIndex(idx)
            }
            
            //Delete Record From DB
            if self.taskDefectDataRecordId > 0 {
                self.deleteTaskInspDefectDataRecord(self.taskDefectDataRecordId!)
            }
        }
    
    }
}
