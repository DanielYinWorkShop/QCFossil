//
//  TaskDetailsViewController.swift
//  QCFossil
//
//  Created by Yin Huang on 14/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class TaskDetailsViewController: PopoverMaster, UIScrollViewDelegate {

    var ScrollView = UIScrollView()
    var categories = [InptCategoryCell]()
    var categoriesDetail = [InputModeSCMaster]()
    var displaySubViewTag = _TASKDETAILVIEWTAG
    var inspCatAdded = false
    var scrollViewOffset:CGFloat = 0
    var backBtnText = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Form")
    var inspCatText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.parentViewController?.parentViewController?.classForCoder == TabBarViewController.self {
            let parentVC = self.parentViewController!.parentViewController as! TabBarViewController
            parentVC.taskDetalViewContorller = self
        }
                
        // Do any additional setup after loading the view.
        self.ScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: 768, height: 1024))
        
        self.ScrollView.contentSize = CGSize.init(width: 768, height: 1400)
        self.ScrollView.delegate = self
        
        self.view.addSubview(self.ScrollView)
        
        initTask()
    }
    
    override func viewDidAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            self.self.parentViewController!.parentViewController!.view.removeActivityIndicator()
        })
        
        self.view.disableAllFunsForView(self.view)
    }
    
    override func viewWillAppear(animated: Bool) {
        refreshCameraIcon()
        
        self.tabBarItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Form")
        if displaySubViewTag == _TASKINSPCATVIEWTAG {
            self.updateNaviBarMenu(backBtnText, leftBarActionName: "backToTaskDetail", rightBarTitle: MylocalizedString.sharedLocalizeManager.getLocalizedString("Save"), rightBarActionName: "updateTask:")
        }else {
            self.updateNaviBarMenu(rightBarTitle: MylocalizedString.sharedLocalizeManager.getLocalizedString("Save"), rightBarActionName: "updateTask:")
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":true])
    }
    
    func updateNaviBarMenu(leftBarTitle:String = "Task Search", leftBarActionName:String = "backTaskSearch:", rightBarTitle:String, rightBarActionName:String) {
        if let myParentTabVC = self.parentViewController?.parentViewController as? TabBarViewController {
        
        if leftBarTitle == "Task Search" {
            //myParentTabVC.navigationItem.leftBarButtonItem = myParentTabVC.navigationItem.backBarButtonItem
            myParentTabVC.setLeftBarItem("< \(MylocalizedString.sharedLocalizeManager.getLocalizedString(leftBarTitle))",actionName: leftBarActionName)
            myParentTabVC.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Form")
        }else {
            myParentTabVC.setLeftBarItem("< "+leftBarTitle,actionName: leftBarActionName)
            myParentTabVC.navigationItem.title = inspCatText
        }
        
        if !self.view.disableFuns(self.view) {
            myParentTabVC.setRightBarItem(rightBarTitle, actionName: rightBarActionName)
        }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "CreateTaskSegueFromTaskForm" {
            
            let destVC = segue.destinationViewController as! POSearchViewController
            destVC.pVC = self
            
            let taskDetailView = self.view.viewWithTag(_TASKDETAILVIEWTAG) as! TaskDetailViewInput
            destVC.vendorName = taskDetailView.vendorInput.text!
            destVC.vendorLocCode = taskDetailView.vendorLocInput.text!
            
            if taskDetailView.poItems.count > 0 {
                let poItem = taskDetailView.poItems[0]
                destVC.styleNo = poItem.styleNo!
                
                destVC.poSelectedItems = taskDetailView.poItems
            }
        }else if segue.identifier == "DefectListFromInspectItemSegue" {
            
            let destVC = segue.destinationViewController as! InspectionDefectList
            let inspectionItem = sender as! InputModeICMaster
            
            destVC.inspItem = inspectionItem
        }
        
    }
    
    @IBAction func menuButton(sender: UIBarButtonItem) {
        NSLog("Toggle Menu in Scroll-Container")
        
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }

    @IBAction func startTaskMenuButton(sender: UIBarButtonItem) {
        //let ScreenVC = ICScreenOneViewController()
        //self.presentViewController(ScreenVC, animated: true, completion: nil)
        //self.performSegueWithIdentifier("InptCategoryDetailSegue", sender: self)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollViewOffset = scrollView.contentOffset.y
    }
    
    func scrollToPosition(offset:CGFloat) {
        self.ScrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: false)
    }
    
    func initTask(){
        dispatch_async(dispatch_get_main_queue(), {
            self.view.showActivityIndicator()
            
            dispatch_async(dispatch_get_main_queue(), {
                //Retriving Task Data
                let taskDataHelper = TaskDataHelper()
                Cache_Task_On = taskDataHelper.getTaskDetailByTask(Cache_Task_On!)
                
                //Default keep task status Pending for Pending Tasks
                if Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Pending").rawValue {
                    Cache_Task_On?.didKeepPending = true
                }
                
                Cache_Task_On?.didModify = false
                
                //update Inspection Date & No
                if Cache_Task_On?.inspectionNo == "" && Cache_Task_On?.inspectionDate == "" {
                    taskDataHelper.updateTaskInspectionDate((Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!, inspectionDate: self.view.getCurrentDateTime(), taskId: (Cache_Task_On?.taskId)!)
                }
                
                if Cache_Task_On!.inspSections.count > 0 {
                    self.view.createTaskFolderById((Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!)
                    Cache_Task_Path = _TASKSPHYSICALPATH + (Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!
                    Cache_Thumb_Path = Cache_Task_Path!+"/"+_THUMBSPHYSICALNAME
                }else{
                    print("No Inspection Category In Selected Task!")
                    self.parentViewController?.navigationController!.popViewControllerAnimated(true)
                }
                
                //Init sub view TaskDetail
                let taskDetailView = TaskDetailViewInput.loadFromNibNamed("TaskDetailView")!
                taskDetailView.pVC = self
                taskDetailView.tag = _TASKDETAILVIEWTAG
                
                self.ScrollView.addSubview(taskDetailView)
                self.view.removeActivityIndicator()
                
                NSNotificationCenter.defaultCenter().postNotificationName("reloadAllPhotosFromDB", object: nil, userInfo: nil)
            })
        })
    }
    
    func startTask(currentPage:Int = 0) {
        
        if !inspCatAdded {
            dispatch_async(dispatch_get_main_queue(), {
                self.view.showActivityIndicator()
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.view.removeActivityIndicator()
                    
                    let inspectionView = InspectionViewInput.loadFromNibNamed("InspectionView")
                    inspectionView?.tag = _TASKINSPCATVIEWTAG
                    inspectionView?.pVC = self
                    
                    self.ScrollView.addSubview(inspectionView!)
                    
                    self.inspCatAdded = true
                    
                    inspectionView?.updateSectionHeader(currentPage)
                    inspectionView?.scrollToPosition(currentPage, animation: false)
                    
                    self.updateNaviBarMenu(self.backBtnText, leftBarActionName: "backToTaskDetail", rightBarTitle: MylocalizedString.sharedLocalizeManager.getLocalizedString("Save"), rightBarActionName: "updateTask:")
                    
                    self.ScrollView.contentOffset.y = 0
                    
                    self.scrollToPosition(0)
                    
                    self.displaySubViewTag = _TASKINSPCATVIEWTAG
                    
                    self.ScrollView.scrollEnabled = false
                })
            })
            
        }else{
            
            if let inspectionView = self.ScrollView.viewWithTag(_TASKINSPCATVIEWTAG) {
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.view.showActivityIndicator()
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.view.removeActivityIndicator()
                
                        (inspectionView as! InspectionViewInput).updateSectionHeader(currentPage)
                        (inspectionView as! InspectionViewInput).scrollToPosition(currentPage, animation: false)
                
                        self.ScrollView.bringSubviewToFront(self.ScrollView.viewWithTag(_TASKINSPCATVIEWTAG)!)
                
                        self.updateNaviBarMenu(self.backBtnText, leftBarActionName: "backToTaskDetail", rightBarTitle: MylocalizedString.sharedLocalizeManager.getLocalizedString("Save"), rightBarActionName: "updateTask:")
                
                        self.scrollToPosition(0)
                
                        self.displaySubViewTag = _TASKINSPCATVIEWTAG
                
                        self.ScrollView.scrollEnabled = false
                    })
                })
            }
        }
    }
    
    func refreshSummaryResult() {
        if let tastDetailView = view.viewWithTag(_TASKDETAILVIEWTAG) {
            let inspCatView = (tastDetailView as! TaskDetailViewInput).inptCatWrapperView
            
            inspCatView.subviews.forEach({
                if $0.classForCoder == InptCategoryCell.classForCoder() {
                    let icSecs = self.categoriesDetail
                    var itemsCount = 0
                    let inspectionCategoryCell = $0 as? InptCategoryCell
                    
                    for icSec in icSecs {
                        
                        if inspectionCategoryCell?.sectionId == icSec.categoryIdx {
                            let resultSetValues = ($0 as! InptCategoryCell).resultSetValues
                            for resultSetValue in resultSetValues{
                                resultSetValue.clear()
                            }

                            switch icSec.InputMode {
                            case _INPUTMODE01:
                                let inputCells = (icSec as! InputMode01View).inputCells
                                
                                for inputCell in inputCells {
                                    itemsCount += 1
                                    for resultSetValue in resultSetValues{
                                        if resultSetValue.valueName.lowercaseString.rangeOfString((inputCell.cellResultInput.text?.lowercaseString)!) != nil {
                                            resultSetValue.resultCount += 1
                                            break
                                        }
                                    }
                                }
                            case _INPUTMODE02:
                                let inputCells = (icSec as! InputMode02View).inputCells
                                
                                for inputCell in inputCells {
                                    itemsCount += 1
                                    for resultSetValue in resultSetValues{
                                        if resultSetValue.valueName.lowercaseString.rangeOfString((inputCell.cellResultInput.text?.lowercaseString)!) != nil {
                                            resultSetValue.resultCount += 1
                                            break
                                        }
                                    }
                                }
                            case _INPUTMODE03:
                                let inputCells = (icSec as! InputMode03View).inputCells
                                
                                for inputCell in inputCells {
                                    itemsCount += 1
                                    for resultSetValue in resultSetValues{
                                        if resultSetValue.valueName.lowercaseString.rangeOfString((inputCell.cellResultInput.text?.lowercaseString)!) != nil {
                                            resultSetValue.resultCount += 1
                                            break
                                        }
                                    }
                                }
                            case _INPUTMODE04:
                                let inputCells = (icSec as! InputMode04View).inputCells
                                
                                for inputCell in inputCells {
                                    itemsCount += 1
                                    for resultSetValue in resultSetValues{
                                        if resultSetValue.valueName.lowercaseString.rangeOfString((inputCell.subResultInput.text?.lowercaseString)!) != nil {
                                            resultSetValue.resultCount += 1
                                            break
                                        }
                                    }
                                }
                            default:break
                            }
                            
                            inspectionCategoryCell?.updateSummaryResultValues(resultSetValues)
                            let title = _ENGLISH ? icSec.inspSection!.sectionNameEn:icSec.inspSection!.sectionNameCn
                            inspectionCategoryCell?.inptCatButton.setTitle(title!+"(\(itemsCount))", forState: UIControlState.Normal)
                        }
                    }
                }
            })
        }
    }
    
    func refreshCameraIcon() {
        if (view.viewWithTag(_TASKDETAILVIEWTAG) != nil) {
            let photoDataHelper = PhotoDataHelper()
            let icSecs = self.categoriesDetail
            
            for icSec in icSecs {
                switch icSec.InputMode {
                    case _INPUTMODE01:
                        let inputCells = (icSec as! InputMode01View).inputCells
                        
                        for inputCell in inputCells {
                            
                            if photoDataHelper.existPhotoByInspItem(inputCell.taskInspDataRecordId!, dataType: PhotoDataType(caseId: "INSPECT").rawValue) || inputCell.inspPhotos.count>0 {
                                
                                if let image = UIImage(named: "taken_photo_icon") {
                                    inputCell.takePhotoIcon.setImage(image, forState: .Normal)
                                }
                            }else{
                                if let image = UIImage(named: "take_photo") {
                                    inputCell.takePhotoIcon.setImage(image, forState: .Normal)
                                }
                            }
                        }

                    case _INPUTMODE02:
                        let inputCells = (icSec as! InputMode02View).inputCells
                        
                        for inputCell in inputCells {
                            
                            if photoDataHelper.existPhotoByInspItem(inputCell.taskInspDataRecordId!, dataType: PhotoDataType(caseId: "INSPECT").rawValue) || inputCell.inspPhotos.count>0 {
                                
                                if let image = UIImage(named: "taken_photo_icon") {
                                    inputCell.takePhotoIcon.setImage(image, forState: .Normal)
                                }
                            }else{
                                if let image = UIImage(named: "take_photo") {
                                    inputCell.takePhotoIcon.setImage(image, forState: .Normal)
                                }
                            }
                        }
                    
                    case _INPUTMODE03:
                        let inputCells = (icSec as! InputMode03View).inputCells
                        
                        for inputCell in inputCells {
                            
                            if photoDataHelper.existPhotoByInspItem(inputCell.taskInspDataRecordId!, dataType: PhotoDataType(caseId: "INSPECT").rawValue) || inputCell.inspPhotos.count>0 {
                                
                                if let image = UIImage(named: "taken_photo_icon") {
                                    inputCell.takePhotoIcon.setImage(image, forState: .Normal)
                                }
                            }else{
                                if let image = UIImage(named: "take_photo") {
                                    inputCell.takePhotoIcon.setImage(image, forState: .Normal)
                                }
                            }
                        }
                    
                    case _INPUTMODE04:
                        let inputCells = (icSec as! InputMode04View).inputCells
                                
                        for inputCell in inputCells {
                            
                            if photoDataHelper.existPhotoByInspItem(inputCell.taskInspDataRecordId!, dataType: PhotoDataType(caseId: "INSPECT").rawValue) || inputCell.inspPhotos.count>0 {
                                    
                                if let image = UIImage(named: "taken_photo_icon") {
                                    inputCell.takePhotoIcon.setImage(image, forState: .Normal)
                                }
                            }else{
                                if let image = UIImage(named: "take_photo") {
                                    inputCell.takePhotoIcon.setImage(image, forState: .Normal)
                                }
                            }
                        }
                                
                    default:break
                }
                            
            }
        }
    }
    
}
