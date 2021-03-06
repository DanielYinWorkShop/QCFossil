//
//  InspectionDefectList.swift
//  QCFossil
//
//  Created by pacmobile on 5/11/2016.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class InspectionDefectList: UIViewController, UITextFieldDelegate, UITableViewDelegate,  UITableViewDataSource {
    

    @IBOutlet weak var inspectionTitle1: UILabel!
    @IBOutlet weak var inspectionTitle2: UILabel!
    @IBOutlet weak var inspectDefectTableview: UITableView!
    @IBOutlet weak var inspectionTitle1Input: UILabel!
    @IBOutlet weak var inspectionTitle2Input: UILabel!
    
    var inspItem:InputModeICMaster?
    weak var currentCell:InputModeDFMaster2!
    var defectItems = [TaskInspDefectDataRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.inspectionTitle1Input.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("\(inspItem?.inspReqCatText != "" ? (inspItem?.inspReqCatText)! : (inspItem?.inspAreaText)!)")
        self.inspectionTitle2Input.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("\((inspItem?.inspItemText)!)")
        
        self.inspectionTitle1.font = UIFont.boldSystemFontOfSize(18.0)
        self.inspectionTitle2.font = UIFont.boldSystemFontOfSize(18.0)
        self.inspectionTitle1.text = MylocalizedString.sharedLocalizeManager.getLocalizedString( inspItem?.inspCatText != "" ? "Inspection Category" : "Inspection Area")
        self.inspectionTitle2.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Item")
        
        //filter all defectItems belong to the inspItem
        var currIdx = 0
        var currSecId = 0
        var currItemId = 0
        Cache_Task_On?.defectItems.sortInPlace({ $0.inspElmt.cellCatIdx < $1.inspElmt.cellCatIdx && $0.inspElmt.cellIdx < $1.inspElmt.cellIdx })
        let defectItemFilter = (Cache_Task_On?.defectItems.filter({ $0.inspElmt.cellCatIdx == self.inspItem!.cellCatIdx && $0.inspElmt.cellIdx == self.inspItem!.cellIdx }))!
        
        for defectItem in defectItemFilter {
            
            if defectItem.inspElmt.cellCatIdx == currSecId && defectItem.inspElmt.cellIdx == currItemId {
                defectItem.cellIdx = currIdx
                
            }else{
                currIdx = 0
                defectItem.cellIdx = currIdx
            }
            
            defectItem.sortNum = (self.inspItem?.cellCatIdx)!*1000000 + (self.inspItem!.cellIdx)*1000 + currIdx
            
            currSecId = defectItem.inspElmt.cellCatIdx
            currItemId = (self.inspItem!.cellIdx)
            currIdx += 1
        }
        
        self.inspectDefectTableview.delegate = self
        self.inspectDefectTableview.dataSource = self
        self.inspectDefectTableview.rowHeight = 170
        self.inspectDefectTableview.allowsSelection = false
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        guard let touch:UITouch = touches.first else
        {
            return
        }
        
        if touch.view!.isKindOfClass(UITextField().classForCoder) || String(touch.view!.classForCoder) == "UITableViewCellContentView" {
            self.view.resignFirstResponderByTextField(self.view)
            
        }else {
            self.view.clearDropdownviewForSubviews(self.view)
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.view.disableAllFunsForView(self.view)
        self.inspectDefectTableview.frame.size.height = 823
        
        dispatch_async(dispatch_get_main_queue(), {
            self.parentViewController!.parentViewController!.view.removeActivityIndicator()
        })
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InspectionDefectList.reloadDefectItems), name: "reloadDefectItems", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InspectionDefectList.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InspectionDefectList.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InspectionDefectList.keyboardDidChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
     
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.inspectDefectTableview.frame.size.height = 823
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "reloadDefectItems", object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: self.view.window)
    }
    
    func reloadDefectItems() {
        updateContentView()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if self.inspectDefectTableview.frame.size.height >= 823{
                self.inspectDefectTableview.frame.size.height -= keyboardSize.height - 45
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.inspectDefectTableview.frame.size.height = 823
    }
    
    func keyboardDidChange(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            self.inspectDefectTableview.frame.size.height = 823 - (keyboardSize.height - 45)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        updateContentView()
        
        let myParentTabVC = self.parentViewController?.parentViewController as! TabBarViewController
        myParentTabVC.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("\((inspItem?.cellCatName)!)")
        
        let leftButton=UIBarButtonItem()
        leftButton.title="< "+MylocalizedString.sharedLocalizeManager.getLocalizedString("Back")
        leftButton.tintColor = _DEFAULTBUTTONTEXTCOLOR
        leftButton.style=UIBarButtonItemStyle.Plain
        leftButton.target=self
        leftButton.action=#selector(InspectionDefectList.clearDefectItemsBeforeGOBack)
        myParentTabVC.navigationItem.leftBarButtonItem=leftButton
        
        //myParentTabVC.setLeftBarItem("< "+MylocalizedString.sharedLocalizeManager.getLocalizedString("Back"),actionName: "backToTaskDetailFromSignOffPage")
        
        if (Cache_Task_On?.taskStatus != GetTaskStatusId(caseId: "Confirmed").rawValue && Cache_Task_On?.taskStatus != GetTaskStatusId(caseId: "Cancelled").rawValue) || _DEBUG_MODE {
            myParentTabVC.setRightBarItem(MylocalizedString.sharedLocalizeManager.getLocalizedString("Save"), actionName: "updateTask:")
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":false])
    }
    
    func clearDefectItemsBeforeGOBack() {
        let defectDataHelper = DefectDataHelper()
        let defectItemArray = (Cache_Task_On?.defectItems.filter({ $0.inspElmt.cellCatIdx == self.inspItem!.cellCatIdx && $0.inspElmt.cellIdx == self.inspItem!.cellIdx }))!
        
        for defectItem in defectItemArray {
            
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
                }else{
                    self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please enter all Defect Qty."))
                    return
                }
                
            }else if defectItem.defectQtyMajor < 1 && defectItem.defectQtyMinor < 1 && defectItem.defectQtyTotal < 1 && defectItem.defectQtyCritical < 1 {
                self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please enter all Defect Qty."))
                return
            }
        }
        
        self.navigationController?.popViewControllerAnimated(true)
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
        
        if segue.identifier == "PhotoAlbumSegueFromIDF" {
            
            weak var destVC = segue.destinationViewController as? PhotoAlbumViewController
            destVC!.pVC = self.currentCell
            destVC?.loadPhotos()
        }
     }
    
    func updateContentView() {
        
        //Cache_Task_On?.defectItems.sortInPlace({ $0.sortNum < $1.sortNum })
        self.defectItems = (Cache_Task_On?.defectItems.filter({ $0.inspElmt.cellCatIdx == inspItem!.cellCatIdx && $0.inspElmt.cellIdx == inspItem!.cellIdx }))!//(Cache_Task_On?.defectItems)!
        self.defectItems.sortInPlace({ $0.sortNum < $1.sortNum && $0.cellIdx < $1.cellIdx })
        
        var cellIdx = 0
        self.defectItems.forEach({ $0.cellIdx = cellIdx; $0.sortNum = (self.inspItem?.cellCatIdx)!*1000000 + (self.inspItem!.cellIdx)*1000 + cellIdx; cellIdx += 1 })
        
        self.defectItems.sortInPlace({ $0.sortNum > $1.sortNum })
        
        self.inspectDefectTableview?.reloadData()
    }
    
    @IBAction func addDefectCell(sender: UIButton) {
        let newDfItem = TaskInspDefectDataRecord(taskId: (Cache_Task_On?.taskId)!, inspectRecordId: inspItem!.taskInspDataRecordId, refRecordId: 0, inspectElementId: inspItem!.elementDbId, defectDesc: "", defectQtyCritical: 0, defectQtyMajor: 0, defectQtyMinor: 0, defectQtyTotal: 0, createUser: Cache_Inspector?.appUserName, createDate: self.view.getCurrentDateTime(), modifyUser: Cache_Inspector?.appUserName, modifyDate: self.view.getCurrentDateTime())
        
        newDfItem?.inputMode = inspItem?.parentView?.InputMode
        newDfItem?.inspElmt = inspItem!
        newDfItem?.sectObj = SectObj(sectionId:inspItem!.cellCatIdx, sectionNameEn: inspItem!.cellCatName, sectionNameCn: inspItem!.cellCatName,inputMode: (inspItem?.parentView?.InputMode)!)
        newDfItem?.elmtObj = ElmtObj(elementId:inspItem!.elementDbId,elementNameEn:"", elementNameCn:"", reqElmtFlag: 0)
        
        let cellIdx = (Cache_Task_On?.defectItems.filter({ $0.inspElmt.cellCatIdx == inspItem!.cellCatIdx && $0.inspElmt.cellIdx == inspItem!.cellIdx }))!
        newDfItem?.cellIdx = cellIdx.count
        newDfItem?.sortNum = (self.inspItem!.cellCatIdx)*1000000 + (self.inspItem!.cellIdx)*1000 + cellIdx.count
        
        newDfItem?.photoNames = [String]()
        
        let taskDataHelper = TaskDataHelper()
        newDfItem?.recordId = taskDataHelper.updateInspDefectDataRecord(newDfItem!)
        
        if newDfItem?.recordId > 0 {
            Cache_Task_On?.defectItems.append(newDfItem!)
            
            updateContentView()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.defectItems.count
    }
    /*
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 170
    }
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let defectItem = self.defectItems[indexPath.row]
        
        if defectItem.inputMode! == _INPUTMODE04 {
            
            let cellMode4 = tableView.dequeueReusableCellWithIdentifier("InspDefectCellMode4", forIndexPath: indexPath) as! InspectionDefectTableViewCellMode4
            
            cellMode4.pVC = self
            cellMode4.taskDefectDataRecordId = defectItem.recordId!
            cellMode4.inspItem = defectItem.inspElmt as? InputMode04CellView
            cellMode4.sectionId = defectItem.inspElmt.cellCatIdx
            cellMode4.itemId = defectItem.inspElmt.cellIdx
            cellMode4.cellIdx = defectItem.cellIdx
            cellMode4.indexLabel.text = "\(defectItem.inspElmt.cellIdx).\(defectItem.cellIdx)"
            cellMode4.inputMode = _INPUTMODE04
            cellMode4.defectDescInput.text = defectItem.defectDesc! //+ "SortNum: \(defectItem.sortNum) ElementId: \(defectItem.inspElmt.cellIdx)"
            cellMode4.defectQtyInput.text = defectItem.defectQtyTotal < 1 ? "" : String(defectItem.defectQtyTotal)
            
            cellMode4.refreshImageviews()
            if defectItem.photoNames != nil && defectItem.photoNames?.count > 0 {
                cellMode4.showDefectPhotoByName(defectItem.photoNames!)
            }
            
            if indexPath.row % 2 == 0 {
                cellMode4.backgroundColor = _TABLECELL_BG_COLOR2
            }else{
                cellMode4.backgroundColor = _TABLECELL_BG_COLOR1
            }
            
            return cellMode4
            
        }else {
            
            let cellMode3 = tableView.dequeueReusableCellWithIdentifier("InspDefectCellMode3", forIndexPath: indexPath) as! InspectionDefectTableViewCellMode3
            
            cellMode3.pVC = self
            cellMode3.taskDefectDataRecordId = defectItem.recordId!
            cellMode3.inspItem = defectItem.inspElmt as? InputMode03CellView
            cellMode3.sectionId = defectItem.inspElmt.cellCatIdx
            cellMode3.itemId = defectItem.inspElmt.cellIdx
            cellMode3.cellIdx = defectItem.cellIdx
            cellMode3.indexLabel.text = "\(defectItem.inspElmt.cellIdx).\(defectItem.cellIdx)"
            cellMode3.inputMode = _INPUTMODE03
            cellMode3.defectDescInput.text = defectItem.defectDesc! //+ "SortNum: \(defectItem.sortNum) ElementId: \(defectItem.inspElmt.cellIdx)"
            cellMode3.defectQtyInput.text = defectItem.defectQtyTotal < 1 ? "" : String(defectItem.defectQtyTotal)
            
            cellMode3.refreshImageviews()
            
            if defectItem.photoNames != nil && defectItem.photoNames?.count > 0 {
                cellMode3.showDefectPhotoByName(defectItem.photoNames!)
            }
            
            if indexPath.row % 2 == 0 {
                cellMode3.backgroundColor = _TABLECELL_BG_COLOR2
            }else{
                cellMode3.backgroundColor = _TABLECELL_BG_COLOR1
            }
            
            return cellMode3
        }
    }
    
}