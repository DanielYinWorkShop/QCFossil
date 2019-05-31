//
//  TabBarViewController.swift
//  QCFossil
//
//  Created by pacmobile on 6/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    weak var taskDetalViewContorller:TaskDetailsViewController!
    weak var photoAlbumViewController:PhotoAlbumViewController!
    weak var defectListViewController:DefectListViewController!
    var handler:(()->(Bool))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TabBarViewController.switchTabViewToDL), name: "switchTabViewToDL", object: nil)
        
        //selected index 2: DefectListViewController
        defectListViewController = self.childViewControllers[2].childViewControllers[0] as? DefectListViewController
        defectListViewController?.initNotificationCenter()
        defectListViewController?.tabBarItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Findings")
        
        //selected index 1: photoAlbumViewController
        photoAlbumViewController = self.childViewControllers[1].childViewControllers[0] as? PhotoAlbumViewController
        photoAlbumViewController?.initPhotoTakerNotification()
        photoAlbumViewController?.tabBarItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Photo Album")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    func switchTabViewToDL() {
        defectListViewController?.updateContentView()
        self.selectedIndex = 2
    }*/
    
    func setLeftBarItem(title:String, actionName:String) {
        
        let leftButton=UIBarButtonItem()
        leftButton.title=title
        leftButton.tintColor = _DEFAULTBUTTONTEXTCOLOR
        leftButton.style=UIBarButtonItemStyle.Plain
        leftButton.target=self
        leftButton.action=Selector(actionName)
        self.navigationItem.leftBarButtonItem=leftButton
    }
    
    func setRightBarItem(title:String, actionName:String) {
        let rightButton=UIBarButtonItem()
        rightButton.title=title
        rightButton.tintColor = _DEFAULTBUTTONTEXTCOLOR
        rightButton.style=UIBarButtonItemStyle.Plain
        rightButton.target=self
        rightButton.action=Selector(actionName)
        self.navigationItem.rightBarButtonItem=rightButton
    }
    
    func setRightBarItemWithHandler(title:String, actionName:String, handler:(()->(Bool))?) {
        let rightButton=UIBarButtonItem()
        rightButton.title=title
        rightButton.tintColor = _DEFAULTBUTTONTEXTCOLOR
        rightButton.style=UIBarButtonItemStyle.Plain
        rightButton.target=self
        rightButton.action=Selector(actionName)
        self.navigationItem.rightBarButtonItem=rightButton
        self.handler = handler
    }
    
    func updateRightBarItem(title:String, actionName:String) {
        self.navigationItem.rightBarButtonItem?.title = title
        self.navigationItem.rightBarButtonItem?.action = Selector(actionName)
    }
    
    func startInspectionCategory() {
        print("Start IC")
        taskDetalViewContorller!.startTask()
    }
    
    func saveIC() {
        print("Save Inspection Category")
        /*
        var title = "Save success."
        
        if !saveICItems() {
            title = "Save fail."
        }
        
        self.view.alertView(title)
        */
    }
    
    func saveICItems(needValidate:Bool) ->Bool {
        let taskDataHelper = TaskDataHelper()
        let dpDataHelper = DPDataHelper()
        let icSecs = self.taskDetalViewContorller?.categoriesDetail
        var icItemDatas = [TaskInspDataRecord]()
        var dppDatas = [TaskInspPosinPoint]()
        let currentDate = self.view.getCurrentDateTime()
        
        if icSecs?.count > 0 {
            
            for idx in 0...(icSecs?.count)!-1 {
                let icItem = icSecs![idx]
                
                switch icItem.InputMode {
                case _INPUTMODE01:
                    let icItemTmp = icItem as! InputMode01View
                    let icElms = icItemTmp.inputCells
                    
                    for icElm in icElms {
                        if (icElm.resultValueId < 1 || icElm.inptItemInput.text == "") && needValidate {
                            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please enter all Inspection Item results."))
                            return false
                        }
                        
                        //if icElm.inptItemInput.text != "" && icElm.resultValueId > 0 {
                            let icItemData = TaskInspDataRecord.init(recordId: icElm.taskInspDataRecordId,taskId: (Cache_Task_On?.taskId)!, refRecordId: icElm.refRecordId!, inspectSectionId: icElm.cellCatIdx, inspectElementId: icElm.inspElmId!, inspectPositionId: icElm.inspPostId!, inspectPositionDesc: "", inspectDetail: icElm.inptDetailInput.text, inspectRemarks: icElm.cellRemarksInput.text, resultValueId: icElm.resultValueId, requestSectionId: 0, requestElementDesc: "", createUser: (Cache_Inspector?.appUserName)!, createDate: currentDate, modifyUser: (Cache_Inspector?.appUserName)!, modifyDate: currentDate)
                        
                            icItemDatas.append(icItemData!)
                        
                            if icElm.requiredElementFlag < 1 || icElm.inptItemInput.text != "" || icElm.resultValueId > 0 {
                                Cache_Task_On?.didKeepPending = false
                            }
                        
                        //}
                    }
                    
                case _INPUTMODE02:
                    let icItemTmp = icItem as! InputMode02View
                    let icElms = icItemTmp.inputCells
                    
                    for icElm in icElms {
                        if (icElm.resultValueId < 1 || icElm.dpInput.text == "" || icElm.cellDPPInput.text == "") && needValidate {
                            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please enter all Inspection Item results."))
                            return false
                        }
                        
                        //if icElm.dpInput.text != "" && icElm.cellDPPInput.text != "" && icElm.resultValueId > 0 {
                        var icItemData = TaskInspDataRecord.init(recordId: icElm.taskInspDataRecordId,taskId: (Cache_Task_On?.taskId)!, refRecordId: icElm.refRecordId!, inspectSectionId: icElm.cellCatIdx, inspectElementId: icElm.inspElmId!, inspectPositionId: icElm.inspPostId!, inspectPositionDesc: icElm.dpDescInput.text, inspectDetail: "", inspectRemarks: "", resultValueId: icElm.resultValueId, requestSectionId: 0, requestElementDesc: "", inspectPositionZoneValueId: icElm.inspectZoneValueId, createUser: (Cache_Inspector?.appUserName)!, createDate: currentDate, modifyUser: (Cache_Inspector?.appUserName)!, modifyDate: currentDate)
                            
                            //Save To DB
                            icItemData = taskDataHelper.updateInspDataRecord(icItemData!)
                            
                            
                            if icItemData!.recordId>0 /*&& icElm.myDefectPositPoints.count>0*/ {
                                for dpp in icElm.myDefectPositPoints {
                                    let dppData = TaskInspPosinPoint.init(inspRecordId: icItemData!.recordId!, inspPosinId: dpp.positionId, createUser: (Cache_Inspector?.appUserName)!, createDate: currentDate, modifyUser: (Cache_Inspector?.appUserName)!, modifyDate: currentDate)
                                    
                                    dppDatas.append(dppData!)
                                }
                                
                                dppDatas = dpDataHelper.updateDefectPositionPoints(icItemData!.recordId!,defectPositionPoints: dppDatas)
                            }
                        
                            if icElm.requiredElementFlag < 1 || icElm.dpInput.text != "" || icElm.cellDPPInput.text != "" || icElm.resultValueId > 0 {
                                Cache_Task_On?.didKeepPending = false
                            }
                        
                        //}
                    }
                    
                case _INPUTMODE03:
                    let icItemTmp = icItem as! InputMode03View
                    let icElms = icItemTmp.inputCells
                    
                    for icElm in icElms {
                        if (icElm.resultValueId < 1 || icElm.iiInput.text == "") && needValidate {
                            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please enter all Inspection Item results."))
                            return false
                        }
                        
                        //if icElm.requestSectionId>0 && icElm.iiInput.text != "" {
                            let icItemData = TaskInspDataRecord.init(recordId: icElm.taskInspDataRecordId,taskId: (Cache_Task_On?.taskId)!, refRecordId: icElm.refRecordId!, inspectSectionId: icElm.cellCatIdx, inspectElementId: icElm.inspElmId!, inspectPositionId: icElm.inspPostId!, inspectPositionDesc: icElm.idInput.text!, inspectDetail: icElm.idInput.text, inspectRemarks: icElm.cellRemarksInput.text, resultValueId: icElm.resultValueId, requestSectionId: icElm.requestSectionId!, requestElementDesc: icElm.iiInput.text!, createUser: (Cache_Inspector?.appUserName)!, createDate: currentDate, modifyUser: (Cache_Inspector?.appUserName)!, modifyDate: currentDate)
                            
                            icItemDatas.append(icItemData!)
                        
                            Cache_Task_On?.didKeepPending = false
                        //}
                    }
                    
                case _INPUTMODE04:
                    let icItemTmp = icItem as! InputMode04View
                    let icElms = icItemTmp.inputCells
                    
                    for icElm in icElms {
                        if (icElm.resultValueId < 1 || icElm.inspectionAreaLabel.text == "" || icElm.inspectionItemLabel.text == "") && needValidate {
                            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please enter all Inspection Item results."))
                            return false
                        }
                        
                        //if icElm.inspectionAreaLabel.text != "" && icElm.inspectionItemLabel.text != "" && icElm.resultValueId > 0 {
                        
                            let icItemData = TaskInspDataRecord.init(recordId: icElm.taskInspDataRecordId,taskId: (Cache_Task_On?.taskId)!, refRecordId: icElm.refRecordId!, inspectSectionId: icElm.cellCatIdx, inspectElementId: icElm.inspElmId!, inspectPositionId: icElm.inspPostId!, inspectPositionDesc: "", inspectDetail: "", inspectRemarks: "", resultValueId: icElm.resultValueId, requestSectionId: 0, requestElementDesc: "", createUser: (Cache_Inspector?.appUserName)!, createDate: currentDate, modifyUser: (Cache_Inspector?.appUserName)!, modifyDate: currentDate)
                        
                            icItemDatas.append(icItemData!)
                        
                        
                            if icElm.requiredElementFlag < 1 || icElm.resultValueId > 0 {
                                Cache_Task_On?.didKeepPending = false
                            }
                        //}
                    }
                    
                default:break
                }
            }
        }
        
        if icItemDatas.count > 0 {
            icItemDatas = taskDataHelper.updateInspDataRecord(icItemDatas)
            
            if icItemDatas.count < 1 {
                return false
            }
        }
        
        if needValidate && !taskDataHelper.checkAllInspDataRecordDone() {
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please enter all Inspection Item results."))
            return false
        }
        
        return true
    }
    
    func backToTaskDetailFromSignOffPage() {
        self.taskDetalViewContorller!.navigationController?.popViewControllerAnimated(true)
    }
    
    func backToTaskDetail() {
        print("Back to task detail")
        
        self.taskDetalViewContorller!.displaySubViewTag = _TASKDETAILVIEWTAG
        self.taskDetalViewContorller!.scrollToPosition(self.taskDetalViewContorller!.scrollViewOffset)
        
        self.taskDetalViewContorller!.ScrollView.scrollEnabled = true
        self.taskDetalViewContorller!.ScrollView.bringSubviewToFront(self.taskDetalViewContorller!.view.viewWithTag(_TASKDETAILVIEWTAG)!)
        self.setLeftBarItem("< \(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Search"))",actionName: "backTaskSearch:")
        //self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem
        //self.setRightBarItem("Start", actionName: "startInspectionCategory")
        self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Form")
        
        self.taskDetalViewContorller!.refreshSummaryResult()
    }
    
    func noAction() {
        
    }
    
    func backToTaskDetailFromPADF() {
        
        dispatch_async(dispatch_get_main_queue(), {
        
            self.view.showActivityIndicator()
        })
        
        self.selectedIndex = 0
    }
    
    func selectFromPhotoAlbum() {
        print("Select From Photo Album")
    }
    
    func saveDefectList() {
        print("Save Defect List")
    }
    
    func saveDFItems(needValidate:Bool = false) ->Bool {
        
        let taskDataHelper = TaskDataHelper()
        let defects = Cache_Task_On?.defectItems
        
        for defect in defects! {
            
            defect.modifyDate = self.view.getCurrentDateTime()
            defect.modifyUser = Cache_Inspector?.appUserName
            
            if needValidate {
                if defect.defectQtyCritical < 1 && defect.defectQtyMajor < 1 && defect.defectQtyMinor < 1 && defect.defectQtyTotal < 1 {
                    self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please enter all Defect Qty."))
                    return false
                }
            }
            
            let recordId = taskDataHelper.updateInspDefectDataRecord(defect)
            
            if recordId > 0 {
                defect.recordId = recordId
            }else{
                print("Saving Defects Error")
                return false
            }

        }
        
        return true
    }
    
    func updateTask(taskStatus:Int=GetTaskStatusId(caseId: "Draft").rawValue) {
        
        if let handler = self.handler {
            if !handler() {
                return
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.view.showActivityIndicator(MylocalizedString.sharedLocalizeManager.getLocalizedString("Saving..."))
        })
        
        //-------------------- Clear Blank Records --------------------------------------
        let defectDataHelper = DefectDataHelper()
        var needReloadData = false
        
        for defectItem in (Cache_Task_On?.defectItems)! {
            
            if defectItem.defectDesc == "" && defectItem.defectQtyCritical<1 && defectItem.defectQtyMajor<1 && defectItem.defectQtyMinor<1 && defectItem.defectQtyTotal<1 {
                var noPhotos = true
                
                for name in defectItem.photoNames! {
                    if name != "" {
                        noPhotos = false
                        break
                    }
                }
                
                if noPhotos {
                    let index = Cache_Task_On?.defectItems.indexOf({ $0.inspElmt.cellCatIdx == defectItem.inspElmt.cellCatIdx && $0.inspElmt.cellIdx == defectItem.inspElmt.cellIdx && $0.cellIdx == defectItem.cellIdx })
                
                    defectDataHelper.deleteDefectItemById(defectItem.recordId!)
                    Cache_Task_On?.defectItems.removeAtIndex(index!)
                    
                    needReloadData = true
                }
            }
        }
        
        if needReloadData {
            NSNotificationCenter.defaultCenter().postNotificationName("reloadDefectItems", object: nil, userInfo: nil)
            
            if self.defectListViewController?.defectTableView != nil {
                self.defectListViewController?.defectTableView.reloadData()
            }
        }
        //--------------------------------------------------------------------------------
        
        let taskStatusCurr = GetTaskStatusId(caseId: "Draft").rawValue
        
        if saveTask(taskStatusCurr) {
            dispatch_async(dispatch_get_main_queue(), {
                self.view.removeActivityIndicator()
                self.view.resignFirstResponderByTextField(self.view)
            })
            
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Save Success!"))
        }else{
            dispatch_async(dispatch_get_main_queue(), {
                self.view.removeActivityIndicator()
                self.view.resignFirstResponderByTextField(self.view)
            })
            
            if Cache_Task_On?.errorCode > 0 {
                self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("No active PO line!"))
            }else{
                self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Save fail!"))
            }
        }
    }
    
    func confirmTask() {
        print("Confirm Task")
        dispatch_async(dispatch_get_main_queue(), {
            self.view.showActivityIndicator(MylocalizedString.sharedLocalizeManager.getLocalizedString("Saving..."))
            
            dispatch_async(dispatch_get_main_queue(), {
        
                if Cache_Task_On?.vdrSignName == nil || Cache_Task_On?.vdrSignName == "" {
                    self.view.removeActivityIndicator()
                    self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please input Vendor Name."))
                    return
                }
        
                if Cache_Task_On?.vdrSignImageFile == nil || Cache_Task_On?.vdrSignImageFile == "" || Cache_Task_On?.inspectionSignImageFile == nil || Cache_Task_On?.inspectionSignImageFile == ""  {
                    self.view.removeActivityIndicator()
                    self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Signature"))
                    return
                }
        
                var taskStatus = GetTaskStatusId(caseId: "Confirmed").rawValue
                var needValidate = true
        
                if Cache_Task_On!.inspectionResultValueId <= 0 {
                    taskStatus = GetTaskStatusId(caseId: "Cancelled").rawValue
            
                    //Ad-hoc Task Mark Delete
                    if Cache_Task_On?.bookingNo! == "" {
                        Cache_Task_On?.deleteFlag = 1
            
                    }else{
                        //Booking Task Mark Cancel Date
                        Cache_Task_On?.cancelDate = self.view.getCurrentDateTime()
                
                    }
            
                    needValidate = false
                }
        
                if self.saveTask(taskStatus, needValidate: needValidate) {
                    self.view.removeActivityIndicator()
                    self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Save Success!"), handlerFun: { (action:UIAlertAction!) in
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.view.showActivityIndicator(MylocalizedString.sharedLocalizeManager.getLocalizedString("Redirecting"))
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":true])
                                self.navigationController?.popViewControllerAnimated(true)
                            })
                        })
                    })
            
                }else{
                    self.view.removeActivityIndicator()
                    self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Save fail!"))
            
                }
            })
        })
    }
    
    func backTaskSearch(alert: UIAlertAction! = nil) {
        
        if Cache_Task_On?.didModify == true && (Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Draft").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Pending").rawValue) {
            
            self.view.alertConfirmViewStyle3(MylocalizedString.sharedLocalizeManager.getLocalizedString("Save Task")+"?",parentVC:self, handlerFunYes: { (action:UIAlertAction!) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.view.showActivityIndicator(MylocalizedString.sharedLocalizeManager.getLocalizedString("Saving..."))
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        let taskStatusCurr = GetTaskStatusId(caseId: "Draft").rawValue
                        
                        if self.saveTask(taskStatusCurr) {
                            self.view.removeActivityIndicator()
                            
                            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Save Success!"), handlerFun: { (action:UIAlertAction!) in
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.view.showActivityIndicator(MylocalizedString.sharedLocalizeManager.getLocalizedString("Redirecting"))
                                    
                                    dispatch_async(dispatch_get_main_queue(), {
                                        NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":true])
                                        self.navigationController?.popViewControllerAnimated(true)
                                    })
                                })
                            })
                            
                        }else{
                            self.view.removeActivityIndicator()
                            if Cache_Task_On?.errorCode > 0 {
                                self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("No active PO line!"))
                            }else{
                                self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Save fail!"))
                            }
                        }
                    })
                    
                })
                
            }, handlerFunNo:{ (action:UIAlertAction!) in
                    
                NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":true])
                self.navigationController?.popViewControllerAnimated(true)
                    
            }, handlerFunCancel: { (action:UIAlertAction!) in
                //Cancel Here, Not Need Any Update
                
            })
            
        }else{
            //Check If Any Update in Adding Items which will no need to save
            let taskDataHelper = TaskDataHelper()
            if Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Pending").rawValue {
                
                if !taskDataHelper.checkIfKeepPendingTaskStatus(Cache_Task_On!.taskId!) {
                    //Update Task Status
                    taskDataHelper.updateTaskStatusByTaskId(GetTaskStatusId(caseId: "Draft").rawValue, taskId: Cache_Task_On!.taskId!)
                    Cache_Task_On?.taskStatus = GetTaskStatusId(caseId: "Draft").rawValue
                    
                }else {
                
                    for poItem in (Cache_Task_On?.poItems)! {
                        
                        if taskDataHelper.didChangeInTaskPoItems((Cache_Task_On?.taskId)!, poItemId: poItem.itemId!) {
                            taskDataHelper.updateTaskStatusByTaskId(GetTaskStatusId(caseId: "Draft").rawValue, taskId: Cache_Task_On!.taskId!)
                            Cache_Task_On?.taskStatus = GetTaskStatusId(caseId: "Draft").rawValue
                            
                            break
                        }
                    }
                }
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":true])
            self.navigationController?.popViewControllerAnimated(true)
            
        }
    }
    
    func saveTask(TaskStatus:Int=GetTaskStatusId(caseId: "Draft").rawValue, needValidate:Bool=false) ->Bool {
                
        var rs = false
        
        //Saving Task Insp Elmts
        let rs1 = self.saveICItems(needValidate)
        if !rs1 && needValidate {
            self.view.removeActivityIndicator()
            return false
        }
        
        //Saving Task Defect Items
        let rs2 = self.saveDFItems(needValidate)
        
        if !rs2 && needValidate {
            self.view.removeActivityIndicator()
            return false
        }
        
        //Saving TaskComments, VendorNotes...
        let taskCatView = self.taskDetalViewContorller!.view.viewWithTag(_TASKDETAILVIEWTAG) as! TaskDetailViewInput
        let rs3 = taskCatView.saveTask(TaskStatus)
        
        if rs1 && rs2 && rs3 {
            rs = true
        }
        
        return rs
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
