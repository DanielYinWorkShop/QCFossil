//
//  PhotoAlbumViewController.swift
//  QCFossil
//
//  Created by pacmobile on 23/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoAlbumViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, AVCaptureMetadataOutputObjectsDelegate {

    var photosSelected = [Photo]()
    var editable = false
    var dataType = PhotoDataType(caseId: "TASK").rawValue // task:0, inspetion:1, defect:2
    var dataRecordId = 0
    weak var pVC:InputModeDFMaster2?//InputModeDFMaster?
    weak var inspElmt:InputModeICMaster?
    var keyboardHeight:CGFloat = 0
    
    @IBOutlet weak var photoTableView: UITableView!
    @IBOutlet weak var sortingBar: UISegmentedControl!
    @IBOutlet weak var addPhotoBtn: CustomButton!//UIButton!
    @IBOutlet weak var addPhotoFromCamera: CustomButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.parentViewController?.parentViewController?.classForCoder == TabBarViewController.self {
            let parentVC = self.parentViewController?.parentViewController as! TabBarViewController
            parentVC.photoAlbumViewController = self
        }
                
        self.navigationItem.leftBarButtonItem = editButtonItem()
        self.editButtonItem().title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Edit")
        
        photoTableView.delegate = self
        photoTableView.dataSource = self
        
        if pVC != nil {
            self.addPhotoBtn.hidden = true
            self.addPhotoFromCamera.hidden = true
        }
        
        updateLocalizeString()
        loadPhotos()
    }
    
    func updateLocalizeString() {
        self.addPhotoBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Add Photo"), forState: UIControlState.Normal)
        self.addPhotoFromCamera.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("From Camera"), forState: UIControlState.Normal)
        
        let segmentTitles = [MylocalizedString.sharedLocalizeManager.getLocalizedString("Filename"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspect Category"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspect Area"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspect Item")]
        
        for idx in 0...self.sortingBar.numberOfSegments-1 {
            self.sortingBar.setTitle(segmentTitles[idx], forSegmentAtIndex: idx)
        }
    }
    
    func loadPhotos() {
        dispatch_async(dispatch_get_main_queue(), {
            self.view.showActivityIndicator()
            
            //let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
            //dispatch_after(time, dispatch_get_main_queue()) {
            dispatch_async(dispatch_get_main_queue(), {
                if self.pVC != nil {
                    Cache_Task_On?.myPhotos = self.getImageNamesFromLocal(PhotoDataType(caseId: "INSPECT").rawValue)
                    //self.photos = self.getImageNamesFromLocal(PhotoDataType(caseId: "INSPECT").rawValue)
                }else{
                    Cache_Task_On?.myPhotos = self.getImageNamesFromLocal()
                    //self.photos = self.getImageNamesFromLocal()
                }
                
                self.photoTableView.reloadData()
                
                self.view.removeActivityIndicator()
            })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.view.disableAllFunsForView(self.view)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.parentViewController?.parentViewController!.view.removeActivityIndicator()
        })
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PhotoAlbumViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PhotoAlbumViewController.keyboardWillChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        if pVC != nil {
            Cache_Task_On?.myPhotos = self.getImageNamesFromLocal()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if self.editable == true {
            dispatch_async(dispatch_get_main_queue(), {
                self.view.showActivityIndicator()
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.setEditing(false,animated: false)
                    self.view.removeActivityIndicator()
                })
            })
        }
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: self.view.window)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.photoTableView.frame.origin.y =  66
    }
    
    func keyboardWillChange(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            keyboardHeight = keyboardSize.height
            
            //adjustTableViewPosition(66 - (keyboardSize.height - 45))
        }
    }
    
    func adjustTableViewPosition(offset:CGFloat = 0) {
        self.photoTableView.frame.origin.y =  66
        self.photoTableView.frame.origin.y -= ((offset < 1 ? keyboardHeight : offset) - 45)
    }
    
    override func viewWillAppear(animated: Bool) {
        let myParentTabVC = self.parentViewController?.parentViewController as! TabBarViewController
        
        if (Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Reviewed").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Refused").rawValue) {
            myParentTabVC.setLeftBarItem(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Form"),actionName: "backToTaskDetailFromPADF")
        }else{
            myParentTabVC.navigationItem.leftBarButtonItem = self.navigationItem.leftBarButtonItem
        }
        
        myParentTabVC.navigationItem.rightBarButtonItem = nil
        myParentTabVC.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Photo Album")
        self.view.setButtonCornerRadius(self.addPhotoBtn)
        self.view.setButtonCornerRadius(self.addPhotoFromCamera)
        
        if self.pVC != nil {
            self.photosSelected = [Photo]()
            
            let leftButton = UIBarButtonItem()
            leftButton.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel")
            leftButton.tintColor = _DEFAULTBUTTONTEXTCOLOR
            leftButton.style = UIBarButtonItemStyle.Plain
            leftButton.target = self
            leftButton.action = #selector(PhotoAlbumViewController.cancelSelectedPhotos)
            myParentTabVC.navigationItem.leftBarButtonItem = leftButton
            
            let rightButton = UIBarButtonItem()
            rightButton.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Done")
            rightButton.tintColor = _DEFAULTBUTTONTEXTCOLOR
            rightButton.style = UIBarButtonItemStyle.Plain
            rightButton.target = self
            rightButton.action = #selector(PhotoAlbumViewController.didSelectedPhotos)
            myParentTabVC.navigationItem.rightBarButtonItem = rightButton
            
            loadPhotos()
            self.photoTableView.allowsMultipleSelection = true
        }else{
            self.photoTableView.allowsSelection = false
        }

        NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":false])
    }
    
    func cancelSelectedPhotos() {
        print("Cancel Select Photos")
        weak var maskView = self.parentViewController!.view.viewWithTag(_MASKVIEWTAG)
        maskView?.removeFromSuperview()
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func didSelectedPhotos() {
        print("Did Selected Photos")
        
        if self.photosSelected.count < 1{
            self.view.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("No Photo Selected, OK?"), parentVC:self, handlerFun: { (action:UIAlertAction!) in
                weak var maskView = self.parentViewController!.view.viewWithTag(_MASKVIEWTAG)
                maskView?.removeFromSuperview()
                
                self.navigationController?.popViewControllerAnimated(true)
            })
        }else{
        
            let defectItem = Cache_Task_On?.defectItems.filter({$0.inspElmt.cellCatIdx == pVC?.sectionId && $0.inspElmt.cellIdx == pVC?.itemId && $0.cellIdx == pVC?.cellIdx})
            
            if defectItem?.count > 0 {
                let defectCell = (defectItem![0] as TaskInspDefectDataRecord)
                
                if defectCell.photoNames == nil {
                    defectCell.photoNames = [String]()
                }
                
                for photo in photosSelected {
                    
                    if defectCell.photoNames?.count<=5 {
                        let photoFileName = pVC!.getNameByUpdateDefectPhotoData(0, photo: photo, needSave: false)
                        defectCell.photoNames?.append(photoFileName)
                    }
                }
            }
            
            if photosSelected.count > 0 {
                pVC!.photoAdded = String(PhotoAddedStatus.init(caseId: "yes"))
                if pVC?.inputMode == _INPUTMODE04 {
                    
                    if pVC?.classForCoder == DefectListTableViewCell.classForCoder() {
                        
                        (pVC as! DefectListTableViewCell).updatePhotoAddedStatus("yes")
                    }else{
                        
                        (pVC as! InspectionDefectTableViewCellMode4).updatePhotoAddedStatus("yes")
                    }
                    
                }else if pVC?.inputMode == _INPUTMODE03 {
                    
                    if pVC?.classForCoder == DefectListTableViewCellMode3.classForCoder() {
                        
                        (pVC as! DefectListTableViewCellMode3).updatePhotoAddedStatus("yes")
                    }else{
                        
                        (pVC as! InspectionDefectTableViewCellMode3).updatePhotoAddedStatus("yes")
                    }
                }
            }
            
            let maskView = self.parentViewController!.view.viewWithTag(_MASKVIEWTAG)
            maskView?.removeFromSuperview()
        
            //Update Photo Album
            NSNotificationCenter.defaultCenter().postNotificationName("reloadAllPhotosFromDB", object: nil)
                       
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addPhoto(sender: CustomButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .Popover
        
        let ppc = imagePicker.popoverPresentationController
        ppc?.sourceView = sender
        ppc?.sourceRect = sender.bounds
        ppc?.permittedArrowDirections = .Any
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func addPhotoFromCamera(sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePicker.sourceType = .Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        }else{
            imagePicker.modalPresentationStyle = .Popover
            imagePicker.sourceType = .PhotoLibrary
            
            let ppc = imagePicker.popoverPresentationController
            ppc?.sourceView = sender
            ppc?.sourceRect = sender.bounds
            ppc?.permittedArrowDirections = .Any
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func initPhotoTakerNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PhotoAlbumViewController.takePhotoFromICCell(_:)), name: "takePhotoFromICCell", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PhotoAlbumViewController.reloadPhotos(_:)), name: "reloadPhotos", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PhotoAlbumViewController.reloadAddPhotos(_:)), name: "reloadAddPhotos", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PhotoAlbumViewController.reloadAllPhotosFromDB(_:)), name: "reloadAllPhotosFromDB", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PhotoAlbumViewController.updatePhotoInfo(_:)), name: "updatePhotoInfo", object: nil)
    }
    
    func removeNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "takePhotoFromICCell", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "takePhotoFromICCell", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "reloadAddPhotos", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "reloadAllPhotosFromDB", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "updatePhotoInfo", object: nil)
    }
    
    func reloadPhotos(notification:NSNotification) {
        let photoObj:Dictionary<String,Photo> = notification.userInfo as! Dictionary<String,Photo>
        Cache_Task_On!.myPhotos = Cache_Task_On!.myPhotos.filter({$0.photoId != photoObj["photoSelected"]?.photoId})
        
        self.photoTableView?.reloadData()
    }
    
    func reloadAddPhotos(notification:NSNotification) {
        let photoObj:Dictionary<String,Photo> = notification.userInfo as! Dictionary<String,Photo>
        Cache_Task_On!.myPhotos.append(photoObj["photoSelected"]!)
        
        self.photoTableView?.reloadData()
    }
    
    func reloadAllPhotosFromDB(notification:NSNotification) {
        loadPhotos()
    }
    
    func takePhotoFromICCell(notification:NSNotification) {
        let inspElmt:Dictionary<String,InputModeICMaster> = notification.userInfo as! Dictionary<String,InputModeICMaster>
        self.inspElmt = inspElmt["inspElmt"]
        
        if self.inspElmt?.taskInspDataRecordId>0 {
            dataRecordId = (self.inspElmt?.taskInspDataRecordId)!
        }
        dataType = PhotoDataType(caseId: "INSPECT").rawValue
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func updatePhotoInfo(notification:NSNotification) {
        let inspElmt:Dictionary<String,InputModeICMaster> = notification.userInfo as! Dictionary<String,InputModeICMaster>
        
        for photo in (Cache_Task_On?.myPhotos)! /*self.photos*/ {
            if photo.dataRecordId == inspElmt["inspElmt"]?.taskInspDataRecordId {
                photo.inspItemName = inspElmt["inspElmt"]?.inspItemText
                
                if inspElmt["inspElmt"]?.inspCatText == "" {
                    photo.inspAreaName = inspElmt["inspElmt"]?.inspAreaText
                }else{
                    photo.inspAreaName = ""
                }
                
                photo.inspCatName = inspElmt["inspElmt"]?.inspReqCatText
            }
        }
        
        self.photoTableView?.reloadData()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if dataType == PhotoDataType(caseId: "INSPECT").rawValue {
            
            if self.inspElmt == nil {
                print("InspElmt is Nil, Return")
                return
            }
            
            let photo = image.saveImageToLocal(image, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: dataRecordId, dataType: dataType, currentDate: self.view.getCurrentDateTime(), originFileName: "originFileName")
            
            photo.inspCatName = inspElmt?.inspReqCatText
            photo.inspAreaName = inspElmt?.inspAreaText
            photo.inspItemName = inspElmt?.inspItemText
            photo.inspElmt = self.inspElmt
            
            inspElmt?.inspPhotos.append(photo)
            Cache_Task_On!.myPhotos.append(photo)
            
        }else{
            let photo = image.saveImageToLocal(image, savePath: Cache_Task_Path!, taskId: (Cache_Task_On?.taskId)!, bookingNo: (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectorName: (Cache_Inspector?.appUserName)!, dataRecordId: dataRecordId, dataType: dataType, currentDate: self.view.getCurrentDateTime(),originFileName: "originFileName")
        
            Cache_Task_On!.myPhotos.append(photo)
        }
    
        dataType = Int(PhotoDataType(caseId: "TASK").rawValue)
        photoTableView.reloadData()
    }
    
    func getImageNamesFromLocal(dataType:Int=2) ->[Photo] {
        
        if (Cache_Task_Path == nil) {
            return [Photo]()
        }
        
        let photoDataHelper = PhotoDataHelper()
        let photoDBDatas = photoDataHelper.getPhotosByTaskId((Cache_Task_On?.taskId)!, dataType: dataType)
        
        return photoDBDatas!
    }
    
    func getImagesFromLocal(dataType:Int=2) ->[Photo] {
        let fileManager :NSFileManager = NSFileManager.defaultManager()
        
        if (Cache_Task_Path == nil) {
            return [Photo]()
        }
        
        let imageFileArray = fileManager.subpathsAtPath(Cache_Task_Path!)
        
        let photoDataHelper = PhotoDataHelper()
        let photoDBDatas = photoDataHelper.getPhotosByTaskId((Cache_Task_On?.taskId)!, dataType: dataType)
        var photoList = [Photo]()
        
        for imageFile in imageFileArray! {
            if imageFile.containsString(".jpg") {
                let photoDBFilter = photoDBDatas?.filter({$0.photoFile == imageFile})
                
                if photoDBFilter?.count>0 {
                    
                    let photoDBObj = photoDBFilter![0]
                
                    let path = Cache_Thumb_Path!+"/"+imageFile
                    let image = UIImage(contentsOfFile: path)
                    let imageView = UIImageView(image:image)
                
                    photoDBObj.photo = imageView
                    
                    photoList.append(photoDBObj)
                }
            }
        }
        
        return photoList
    }
    
    func numberOfSectionsInTableView(photoTableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(photoTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cache_Task_On!.myPhotos.count//photos.count
    }
    
    func tableView(photoTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = photoTableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoAlbumCellTableViewCell
        
        if indexPath.row < Cache_Task_On!.myPhotos.count {
        
            let photo = Cache_Task_On!.myPhotos[indexPath.row] as Photo
        
            cell.photo.sizeToFit()
            cell.photo.layer.masksToBounds = true
        
            cell.photoFilename.text = photo.photoFilename
            cell.photoDescription.text = photo.photoDesc
        
            cell.inspAreaInput.text = photo.inspAreaName
            cell.inspCatInput.text = photo.inspCatName
            cell.inspItemInput.text = photo.inspItemName
        
            if editable {
                cell.photoDescription.editable = true
                cell.photoDescription.backgroundColor = UIColor.whiteColor()
            }else{
                cell.photoDescription.editable = false
                cell.photoDescription.backgroundColor = _TABLECELL_BG_COLOR1
            }
        
            if photo.photoFile != "" {
            
                let pathForImage = Cache_Task_Path! + "/" + _THUMBSPHYSICALNAME + "/" + photo.photoFile
                cell.photo.image = UIImage(contentsOfFile: pathForImage)
            }
        
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = _TABLECELL_BG_COLOR2
            }else{
                cell.backgroundColor = _TABLECELL_BG_COLOR1
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        NSLog("Did Select Row")
        
        let photoCount = self.pVC?.photoNameAtIndex.filter({ $0 != "" })
        var usedPhotoCount = 0
        if photoCount != nil {
            usedPhotoCount = (photoCount?.count)!
        }
        
        print("SELECTED: \(photosSelected.count + usedPhotoCount)")
        
        if photosSelected.count + usedPhotoCount < 5 {
            photosSelected.append(Cache_Task_On!.myPhotos[indexPath.row])
            
            return indexPath
        }else{
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Maximun 5 Photos!"))
            return nil
        }
    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let photoobj = Cache_Task_On!.myPhotos[indexPath.row]
        photosSelected = photosSelected.filter({$0.photoId != photoobj.photoId})
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete");
    }
    
    func tableView(photoTableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        /*if self.view.disableFuns(self.view) {
            
            if (Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Confirmed").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Cancelled").rawValue) {
                self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cannot update Confirmed or Cancelled Task!"))
            }else if (Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Reviewed").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Refused").rawValue){
                self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cannot update Uploaded, Reviewed or Refused Task!"))
            }
            
            return
        }*/
        
        if (Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Reviewed").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Refused").rawValue) {
            
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cannot update Uploaded, Reviewed or Refused Task!"))
            return
        }
        
        if editingStyle == .Delete {
            self.view.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete Photo From Photo Album?"), parentVC:self, handlerFun: { (action:UIAlertAction!) in
                //Set Photo Added iCon Status for InspElmt
                let photoSelected = Cache_Task_On!.myPhotos[indexPath.row] //self.photos[indexPath.row]
                let inspElmt = photoSelected.inspElmt
                
                if inspElmt != nil {
                    var idx = 0
                    for photo in (inspElmt?.inspPhotos)! {
                        if photo === photoSelected {
                            inspElmt?.inspPhotos.removeAtIndex(idx)
                        }
                        idx += 1
                    }
                }
                
                //Delete From UI
                Cache_Task_On?.myPhotos.removeAtIndex(indexPath.row)
                //self.photos.removeAtIndex(indexPath.row)
                self.photoTableView.reloadData()
                
                //Delete From DB&Local
                if photoSelected.photoId>0 && photoSelected.photoFile != "" {
                    UIImage.init().removeImageFromLocal(photoSelected, path: Cache_Task_Path!)
                }
            })

            //self.photoTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(photoTableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.photoTableView.setEditing(editing, animated: animated)
        
        if editing {
            print("Photo Album Editing")
            self.editButtonItem().title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Done")
            
            self.editable = true
            
        }else{
            print("Photo Album Done")
            self.editButtonItem().title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Edit")
            
            if Cache_Task_On!.myPhotos.count > 0 {//if self.photos.count > 0 {
                
                for idx in 0...Cache_Task_On!.myPhotos.count-1 {
                    let indexPath = NSIndexPath.init(forRow: idx, inSection: 0)
                    
                    let cell = self.photoTableView.cellForRowAtIndexPath(indexPath) as? PhotoAlbumCellTableViewCell
                    
                    if (cell != nil) {
                        
                        let photoSetFilter = Cache_Task_On!.myPhotos.filter({$0.photoFile == (cell?.photoFilename.text)!})
                        
                        if photoSetFilter.count > 0 {
                            let photo = photoSetFilter[0]
                            photo.photoDesc = cell!.photoDescription.text
                        }
                    }
                }
            }
            
            //save to db
            let photoDataHelper = PhotoDataHelper()
            for photo in Cache_Task_On!.myPhotos {
                photoDataHelper.savePhoto(photo)
            }
            
            self.editable = false
            
        }
        
        self.photoTableView.reloadData()
    }
    
    @IBAction func PhotoAlbumSorting(sender: UISegmentedControl) {
        let selectedSegment = sender.selectedSegmentIndex
        
        switch selectedSegment {
        case 0: Cache_Task_On!.myPhotos.sortInPlace(){$0.photoFile>$1.photoFile}; break
        case 1: Cache_Task_On!.myPhotos.sortInPlace(){$0.inspCatName<$1.inspCatName}; break
        case 2: Cache_Task_On!.myPhotos.sortInPlace(){$0.inspAreaName<$1.inspAreaName}; break
        case 3: Cache_Task_On!.myPhotos.sortInPlace(){$0.inspItemName<$1.inspItemName}; break
            
        default: Cache_Task_On!.myPhotos.sortInPlace(){$0.photoFile>$1.photoFile}; break
        }
        
        self.photoTableView.reloadData()
    }
}