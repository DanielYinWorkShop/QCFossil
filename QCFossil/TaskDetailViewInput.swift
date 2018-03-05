//
//  TaskDetailViewInput.swift
//  QCFossil
//
//  Created by Yin Huang on 14/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class TaskDetailViewInput: UIView, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var inptCatWrapperView: UIView!
    @IBOutlet weak var commentWarpperView: UIView!
    @IBOutlet weak var poListWrapperView: UIView!
    @IBOutlet weak var basicInfomationSectionLabel: UILabel!
    @IBOutlet weak var inspectionInformationSectionLabel: UILabel!
    @IBOutlet weak var inspectionCategoriesSectionLabel: UILabel!
    @IBOutlet weak var bookingNoLabel: UILabel!
    @IBOutlet weak var bookingNoInput: UITextField!
    @IBOutlet weak var bookingDateLabel: UILabel!
    @IBOutlet weak var bookingDateInput: UITextField!
    @IBOutlet weak var inspTypeLabel: UILabel!
    @IBOutlet weak var inspTypeInput: UITextField!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var vendorInput: UITextField!
    @IBOutlet weak var inspectorLabel: UILabel!
    @IBOutlet weak var inspectorInput: UITextField!
    @IBOutlet weak var vendorLocLabel: UILabel!
    @IBOutlet weak var vendorLocInput: UITextField!
    @IBOutlet weak var tastStatusLabel: UILabel!
    @IBOutlet weak var taskStatusInput: UITextField!
    @IBOutlet weak var inspResultLabel: UILabel!
    @IBOutlet weak var inspResultInput: UITextField!
    @IBOutlet weak var inspCommentLabel: UILabel!
    @IBOutlet weak var inspCommentInput: CustomTextView!
    @IBOutlet weak var vendorNotesLabel: UILabel!
    @IBOutlet weak var vendorNotesInput: CustomTextView!
    @IBOutlet weak var inspResultBottomLabel: UILabel!
    @IBOutlet weak var inspResultBottomInput: UITextField!
    @IBOutlet weak var inspCatLabel: UILabel!
    @IBOutlet weak var resultSummaryLabel: UILabel!
    @IBOutlet weak var addPOLineBtn: UIButton!
    @IBOutlet weak var signoffConfirmBtn: UIButton!
    @IBOutlet weak var cancelConfirmBtn: UIButton!
    
    @IBOutlet weak var taskStatusDescLabel: UILabel!
    @IBOutlet weak var dataRefuseDesc: UILabel!
    
    weak var pVC:TaskDetailsViewController!
    var cellHeight:Int = 40
    var poCellHeight:Int = 100
    
    var poItems = Cache_Task_On!.poItems
    var poCellItems = [POCellViewInput]()
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    override func awakeFromNib() {
        self.inspResultBottomInput.delegate = self
        self.inspCommentInput.delegate = self
        self.vendorNotesInput.delegate = self
        
        var inspResultValueName = ""
        
        if Cache_Task_On!.inspectionResultValueId! >= 0 {
            let taskDataHelper = TaskDataHelper()
            inspResultValueName = taskDataHelper.getResultValueNameById(Cache_Task_On!.inspectionResultValueId!)
        }else{
            //inspResultValueName = MylocalizedString.sharedLocalizeManager.getLocalizedString(String(TaskStatus(caseId: (Cache_Task_On?.taskStatus!)!)))
        }
        
        //Hidden addPOLineBtn for Booking Task
        if Cache_Task_On!.bookingNo!.isEmpty {
            self.addPOLineBtn.hidden = false
        }else{
            self.addPOLineBtn.hidden = true
        }
        
        self.bookingNoInput.text = Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo
        self.bookingDateInput.text = Cache_Task_On!.bookingDate!.isEmpty ? Cache_Task_On!.inspectionDate : Cache_Task_On!.bookingDate
        self.inspTypeInput.text = Cache_Task_On?.inspectionType
        self.vendorInput.text = Cache_Task_On?.vendor
        self.inspectorInput.text = Cache_Inspector?.inspectorName
        self.vendorLocInput.text = Cache_Task_On?.vendorLocation
        
        if Cache_Task_On!.taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue && Cache_Task_On!.cancelDate != "" {
            self.taskStatusInput.text = MylocalizedString.sharedLocalizeManager.getLocalizedString(String(TaskStatus(caseId: (Cache_Task_On?.taskStatus!)!))) + " (C)"
        }else{
            self.taskStatusInput.text = MylocalizedString.sharedLocalizeManager.getLocalizedString(String(TaskStatus(caseId: (Cache_Task_On?.taskStatus!)!)))
        }
        
        self.inspResultInput.text = inspResultValueName
        
        self.inspCommentInput.text = Cache_Task_On?.taskRemarks
        self.vendorNotesInput.text = Cache_Task_On?.vdrNotes
        self.inspResultBottomInput.text = inspResultValueName
        
        if Cache_Task_On?.dataRefuseDesc != "" {
            self.dataRefuseDesc.hidden = false
            self.dataRefuseDesc.text = Cache_Task_On?.dataRefuseDesc
            self.taskStatusDescLabel.hidden = false
        }
        
        updateLocalizedString()
    }
    
    func updateLocalizedString(){
        self.basicInfomationSectionLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Basic Information")
        self.inspectionInformationSectionLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Information")
        self.inspectionCategoriesSectionLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Categories")
        self.inspTypeLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Type")
        self.bookingNoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Book No")
        self.bookingDateLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Book Date")
        self.vendorLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor")
        self.inspectorLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspector")
        self.vendorLocLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor Location")
        self.tastStatusLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Status")
        self.inspResultLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Result")
        self.inspCommentLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspector Comment")
        self.vendorNotesLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor Notes")
        self.inspResultBottomLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Result")
        self.inspCatLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Category")
        self.resultSummaryLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Result Summary")
        
        self.addPOLineBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Add PO Line(s)"), forState: UIControlState.Normal)
        self.signoffConfirmBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Sign-off & Confirm"), forState: UIControlState.Normal)
        self.cancelConfirmBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel Task"), forState: UIControlState.Normal)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.parentVC!.view.frame.origin.y =  0
        
    }
    
    func keyboardWillChange(notification: NSNotification) {
        
        if self.currentFirstResponder() != nil && (self.currentFirstResponder()?.classForCoder)! == CustomTextView.classForCoder() {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
                self.parentVC!.view.frame.origin.y =  0
                self.parentVC!.view.frame.origin.y -= keyboardSize.height
            
            }
        }
    }
    
    override func didMoveToSuperview() {
        
        if (self.parentVC == nil) {
            // a removeFromSuperview situation
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.window)
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: self.window)
            
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TaskDetailViewInput.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TaskDetailViewInput.keyboardWillChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        self.disableAllFunsForView(self)
        self.setButtonCornerRadius(self.addPOLineBtn)
        self.setButtonCornerRadius(self.signoffConfirmBtn)
        self.setButtonCornerRadius(self.cancelConfirmBtn)
        self.taskStatusDescLabel.layer.masksToBounds = true
        self.taskStatusDescLabel.layer.cornerRadius = 5
        
        let categoryCount = Cache_Task_On!.inspSections.count
        if categoryCount < 1 {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("No Category Info in DB!"))
            return
        }
        
        //init po list
        loadPoList()
        
        //init section cat buttons
        self.inptCatWrapperView.frame = CGRectMake(self.inptCatWrapperView.frame.origin.x,CGFloat(420+(poItems.count-1)*poCellHeight),self.inptCatWrapperView.frame.size.width,CGFloat((categoryCount+2)*cellHeight))
        
        self.addSubview(self.inptCatWrapperView)
        
        //Get result values
        let taskDataHelper = TaskDataHelper()
        let resultValues = taskDataHelper.getResultSetValuesByTaskId((Cache_Task_On?.taskId)!)
        
        //init categories
        for idx in 0...categoryCount-1 {
            let inputInptCatViewObj = InptCategoryCell.loadFromNibNamed("InptCategoryCellView")
            inputInptCatViewObj?.frame = CGRect.init(x: 0, y: 80+cellHeight*idx, width: 768, height: cellHeight)
            inputInptCatViewObj?.inptCatButton.tag = idx
            
            let section = Cache_Task_On?.inspSections[idx]
            var itemCount = taskDataHelper.getCatItemCountById((Cache_Task_On?.taskId)!,sectionId: (section?.sectionId)!)
            /*
            if section?.inputModeCode == _INPUTMODE02 {
                itemCount = itemCount - 1
            }*/
            
            let catBtnTitle = (_ENGLISH ? section?.sectionNameEn:section?.sectionNameCn)!+"(\(itemCount))"
            inputInptCatViewObj?.inptCatButton.setTitle(catBtnTitle, forState: UIControlState.Normal)
            inputInptCatViewObj?.parentView = self
            
            let sectionResultValues = resultValues.filter({$0.sectionId == section?.sectionId})
            for resultValue in sectionResultValues {
                let sResultValue = SummaryResultValue(sectionId:resultValue.sectionId, sectionName: resultValue.sectionName, valueId: resultValue.valueId, valueName: resultValue.valueName, resultCount: resultValue.resultCount)
                inputInptCatViewObj?.resultSetValues.append(sResultValue)
            }
            
            self.inptCatWrapperView.addSubview(inputInptCatViewObj!)
            self.pVC!.categories.append(inputInptCatViewObj!)
        }
        
        self.commentWarpperView.frame = CGRectMake(0, self.inptCatWrapperView.frame.origin.y+self.inptCatWrapperView.frame.size.height+CGFloat(cellHeight), self.commentWarpperView.frame.size.width, self.commentWarpperView.frame.size.height)
        
        self.addSubview(self.commentWarpperView)
        
        self.frame.size = CGSize(width: 768, height: self.frame.size.height + 200)
        updateContentView(CGFloat((categoryCount-3)*cellHeight+(poItems.count-1)*poCellHeight))
    }
    
    func getPoList(){
        if poItems.count > 0 {
            self.poListWrapperView.frame = CGRectMake(0,309,768,CGFloat(poItems.count*poCellHeight))
            var idx = 0
            for poItem in poItems {
                let poItemCellView = POCellViewInput.loadFromNibNamed("POCellView")
                poItemCellView?.frame = CGRectMake(20,CGFloat(idx*poCellHeight),728,CGFloat(poCellHeight))
                poItemCellView?.backgroundColor = _TABLECELL_BG_COLOR1
                poItemCellView?.poNoText.text = poItem.poNo
                poItemCellView?.poLineNoText.text = poItem.poLineNo
                poItemCellView?.brandText.text = poItem.brandName
                poItemCellView?.styleText.text = poItem.styleNo
                poItemCellView?.orderQtyText.text = String(poItem.orderQty)
                poItemCellView?.shipToText.text = poItem.shipTo
                poItemCellView?.poItemId = poItem.itemId
                poItemCellView?.isEnable = poItem.isEnable
                poItemCellView?.shipWinInput.text = String(poItem.shipWin)
                poItemCellView?.sampleQtyInput.text = poItem.samplingQty < 1 ? "":String(poItem.samplingQty)
                poItemCellView?.opdRsdInput.text = poItem.opdRsd
                poItemCellView?.bookingQtyInput.text = String(poItem.qcBookedQty)//String(poItem.orderQty - poItem.samplingQty)
                poItemCellView?.sampleQtyDB = poItem.samplingQty
                poItemCellView?.prodDesc = "\(poItem.dimen2!) / \(poItem.prodDesc!)"
                
                if poItem.isEnable == 1 && Cache_Task_On?.bookingNo != "" {
                    poItemCellView?.bookingQtyDB = poItem.qcBookedQty//poItem.orderQty - poItem.samplingQty
                    poItemCellView!.bookingQtyInput.text = String(poItem.qcBookedQty)
                }else if poItem.isEnable == 0 && Cache_Task_On?.bookingNo != "" {
                    poItemCellView?.bookingQtyDB = poItem.qcBookedQty
                    poItemCellView!.bookingQtyInput.text = "0"
                    poItemCellView?.availInspectQtyInput.userInteractionEnabled = false
                    poItemCellView?.sampleQtyInput.userInteractionEnabled = false
                }else if poItem.isEnable == 1 {
                    poItemCellView?.bookingQtyDB = 0
                    poItemCellView!.bookingQtyInput.text = "0"
                }else{
                    poItemCellView?.bookingQtyDB = 0
                    poItemCellView!.bookingQtyInput.text = "0"
                    poItemCellView?.availInspectQtyInput.userInteractionEnabled = false
                    poItemCellView?.sampleQtyInput.userInteractionEnabled = false
                }
                
                if Cache_Task_On!.inspectionResultValueId < 0 {
                    poItemCellView?.availInspectQtyInput.text = ""
                    poItemCellView?.availInspQtyDB = 0
                }else{
                    poItemCellView?.availInspectQtyInput.text = poItem.availableQty < 1 ? "":String(poItem.availableQty)
                    poItemCellView?.availInspQtyDB = poItem.availableQty
                }
                
                poItemCellView?.idx = idx
                poItemCellView?.pVC = self.pVC
                poItemCellView?.delBtn.hidden = true
                
                poCellItems.append(poItemCellView!)
                
                self.poListWrapperView.addSubview(poItemCellView!)
                idx += 1
            }
            
            self.addSubview(poListWrapperView)
        }
    }
    
    func loadPoList(){
        self.poListWrapperView.subviews.forEach({ $0.removeFromSuperview() })
        poCellItems = []
        getPoList()
        
        for pocell in poCellItems{
            self.poListWrapperView.addSubview(pocell)
        }
    }
    
    func updateContentView(offSet:CGFloat) {
        NSLog("update view position")
        
        //self.pVC!.ScrollView.contentSize.height += offSet
        self.frame.size = CGSize(width: 768, height: self.frame.size.height + offSet)
        self.pVC!.ScrollView.contentSize.height = self.frame.size.height
    }
    
    func validateBeforeSignoff(taskStatus:Int=0) ->Bool {
        
        if taskStatus == 0 {
            //Reset all po items
            var poItemsActive = false
            for poCellItem in self.poCellItems {
                if poCellItem.isEnable == 1 {
                    
                    if poCellItem.sampleQtyInput.text == "" || poCellItem.availInspectQtyInput.text == "" {
                        self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please enter: 1. Sample Qty 2. Avail. Qty!"))
                        return false
                    }
                    
                    if poCellItem.sampleQtyInput.text != nil && poCellItem.availInspectQtyInput.text != nil && Int(poCellItem.sampleQtyInput.text!) > Int(poCellItem.availInspectQtyInput.text!) {
                        self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Not allow [Lot Size(N)] less than [Sample Qty(n)]"))
                        return false
                    }
                }
                
                if poCellItem.isEnable > 0 {
                    poItemsActive = true
                }
            }
            
            if !poItemsActive {
                self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("No active PO line!"))
                return false
            }
            
            if self.inspResultBottomInput.text == "" {
                self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspect Result Cannot Be Nil!"))
                return false
                
            }else if self.inspResultBottomInput.text!.lowercaseString.rangeOfString("c.a.") != nil || self.inspResultBottomInput.text!.lowercaseString.rangeOfString("fail") != nil || self.inspResultBottomInput.text!.lowercaseString.rangeOfString("hold") != nil || self.inspResultBottomInput.text!.lowercaseString.rangeOfString("reject (comment)") != nil || self.inspResultBottomInput.text!.lowercaseString.rangeOfString("Reject (Document)") != nil || self.inspResultBottomInput.text!.lowercaseString.rangeOfString("有条件批准") != nil || self.inspResultBottomInput.text!.lowercaseString.rangeOfString("不合格") != nil || self.inspResultBottomInput.text!.lowercaseString.rangeOfString("保留") != nil || self.inspResultBottomInput.text!.lowercaseString.rangeOfString("拒绝 (待评语)") != nil || self.inspResultBottomInput.text!.lowercaseString.rangeOfString("拒绝 (欠文件)") != nil{
            
                if self.inspCommentInput.text == "" || self.vendorNotesInput.text == "" {
                    self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please fill in: 1. Inspector Comment 2. Vendor Notes!"))
                    return false
                }
            }
        }else{
            if self.inspCommentInput.text == "" || self.vendorNotesInput.text == "" {
                self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please fill in: 1. Inspector Comment 2. Vendor Notes!"))
                return false
            }
        }
        
        return true
    }
    
    @IBAction func signoffViewButton(sender: UIButton) {
        
        if validateBeforeSignoff() {
            let myParentTabVC = self.pVC!.parentViewController?.parentViewController as! TabBarViewController
            if myParentTabVC.saveTask(GetTaskStatusId(caseId: "Draft").rawValue, needValidate: true) {
                self.pVC!.performSegueWithIdentifier("ToSignoffSegue", sender: sender)
            }
        }
    }
    
    @IBAction func cancelBtnOnClick(sender: UIButton) {
        
        if Cache_Task_On?.bookingNo! == "" {
            
            self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel Ad-hoc Task?"),parentVC:self.pVC!, handlerFun: { (action:UIAlertAction!) in
                
                Cache_Task_On?.deleteFlag = 1
                self.pVC!.parentViewController!.navigationController?.popViewControllerAnimated(true)
            })
            
        }else if validateBeforeSignoff(1) {
            //Task Cancel, inspection result is 0
            Cache_Task_On?.inspectionResultValueId = -1
            self.pVC!.performSegueWithIdentifier("ToSignoffSegue", sender: sender)
        }
    }
    
    @IBAction func addPOLinesButton(sender: UIButton) {
        
        self.parentVC!.performSegueWithIdentifier("CreateTaskSegueFromTaskForm", sender:self)
    }
    
    func resizePoWrapperContent(offset:CGFloat) {
       
        self.inptCatWrapperView.frame = CGRectMake(self.inptCatWrapperView.frame.origin.x,self.inptCatWrapperView.frame.origin.y+offset,self.inptCatWrapperView.frame.size.width,self.inptCatWrapperView.frame.size.height)
        
        self.commentWarpperView.frame = CGRectMake(self.commentWarpperView.frame.origin.x,self.commentWarpperView.frame.origin.y+offset,self.commentWarpperView.frame.size.width,self.commentWarpperView.frame.size.height)
        
        self.pVC!.ScrollView.contentSize.height += offset
        self.frame.size = CGSize(width: 768, height: self.frame.size.height+offset)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.clearDropdownviewForSubviews(self)
        let handleFun:(UITextField)->(Void) = dropdownHandleFunc
        
        if textField == self.inspResultBottomInput {
            let taskDataHelper = TaskDataHelper()
            let resultSetId = taskDataHelper.getResultSetIdByTmplId((Cache_Task_On?.tmplId)!)
            let resultSet = taskDataHelper.getResultSetValueBySetId(resultSetId)
            //resultSet?.append(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel"))
            
            textField.showListData(textField, parent: self, handle: handleFun, listData: resultSet!, width: 250, height:250)
            Cache_Task_On?.didModify = true
            
            return false
        }
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.inspResultBottomInput {
            return false
        }
        
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        Cache_Task_On?.didModify = true
        
        return true
    }
    
    func dropdownHandleFunc(textField: UITextField) {
        
        if textField == self.inspResultBottomInput {
            //let taskDataHelper = TaskDataHelper()
            //Cache_Task_On?.inspectionResultValueId = taskDataHelper.getResultValueIdByName(self.inspResultBottomInput.text!)
            
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        guard let touch:UITouch = touches.first else
        {
            return;
        }
        
        if touch.view!.isKindOfClass(UITextField().classForCoder) || String(touch.view!.classForCoder) == "UITableViewCellContentView" {
            self.resignFirstResponderByTextField(self)
            
        }else {
            self.clearDropdownviewForSubviews(self)
            
        }
    }
    
    func saveTask(taskStatus:Int=GetTaskStatusId(caseId: "Draft").rawValue) ->Bool {
        print("Save Task")
        //check if no enable poItems, then prompt msg
        let enablePoItems = self.poCellItems.filter({ $0.isEnable == 1 })
        if enablePoItems.count < 1 {

            Cache_Task_On?.errorCode = 2
            return false
        }
        
        let taskDataHelper = TaskDataHelper()
        
        //Reset all po items
        for poCellItem in self.poCellItems {
            let targetInspectQty = poCellItem.orderQtyText.text != "" ? Int(poCellItem.orderQtyText.text!)!:0
            let samplingQty = poCellItem.sampleQtyInput.text != "" ? Int(poCellItem.sampleQtyInput.text!)!:0
            let availQty = poCellItem.availInspectQtyInput.text != "" ? Int(poCellItem.availInspectQtyInput.text!)!:0
            
            let taskItem = TaskItem(taskId: (Cache_Task_On?.taskId)!, poItemId: poCellItem.poItemId!, targetInspectQty: targetInspectQty, availInspectQty: Cache_Task_On!.inspectionResultValueId! < 0 ? 0 : availQty, inspectEnableFlag: Cache_Task_On!.inspectionResultValueId! < 0 ? 0 : poCellItem.isEnable, createUser: Cache_Inspector?.appUserName, createDate: self.getCurrentDateTime(), modifyUser: Cache_Inspector?.appUserName, modifyDate: self.getCurrentDateTime(), samplingQty: samplingQty)
            
            //Check if need to Update task status from Pending to Draft
            if taskDataHelper.didChangeInTaskPoItems((Cache_Task_On?.taskId)!, poItemId: poCellItem.poItemId!) {
                Cache_Task_On?.didKeepPending = false
            }
            
            taskDataHelper.updateTaskItem(taskItem)
            
            if Cache_Task_On!.inspectionResultValueId < 0 {
                poCellItem.enableSwitch.setOn(false, animated: false)
                poCellItem.availInspectQtyInput.text = "0"
            }
        }
        
        //Update Task PoItems No.
        var poNos = [String]()
        for poNo in Cache_Task_On!.poItems {
            if poNo.isEnable == 1 || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Cancelled").rawValue || (Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue && Cache_Task_On?.cancelDate != ""){
                poNos.append(poNo.poNo!)
            }
        }
        
        var uniquePoNos = Array(Set(poNos))
        uniquePoNos.sortInPlace({ Int($0) < Int($1) })
        
        Cache_Task_On!.poNo = uniquePoNos.joinWithSeparator(",")
        
        //Update Task poItems shipWin
        var shipWins = [String]()
        for poItem in Cache_Task_On!.poItems {
            if poItem.isEnable == 1 || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Cancelled").rawValue || (Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue && Cache_Task_On?.cancelDate != "") {
                shipWins.append(poItem.shipWin)
            }
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = _DATEFORMATTER
        
        var uniqueShipWins = Array(Set(shipWins))
        uniqueShipWins.sortInPlace({ dateFormatter.dateFromString($0)!.isGreaterThanDate(dateFormatter.dateFromString($1)!) })
        
        Cache_Task_On!.shipWin = uniqueShipWins.joinWithSeparator(",")
        
        Cache_Task_On?.reportPrefix = Cache_Inspector?.reportPrefix
        Cache_Task_On?.reportInspectorId = Cache_Inspector?.inspectorId
        Cache_Task_On?.reportRunningNo = Cache_Inspector?.reportRunningNo
        Cache_Task_On?.poItems = self.poItems
        Cache_Task_On?.taskRemarks = self.inspCommentInput.text
        Cache_Task_On?.vdrNotes = self.vendorNotesInput.text
        Cache_Task_On?.taskStatus = taskStatus
        self.inspResultInput.text = self.inspResultBottomInput.text!
        
        Cache_Task_On?.inspectionResultValueId = taskDataHelper.getResultValueIdByName(self.inspResultBottomInput.text!)
        Cache_Task_On?.uploadInspectorId = Cache_Inspector?.inspectorId
        Cache_Task_On?.uploadDeviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
        
        if (Cache_Task_On?.myPhotos.count)! > 0 || (Cache_Task_On?.taskRemarks)! != "" || Cache_Task_On?.vdrNotes != "" || (Cache_Task_On?.inspectionResultValueId > 0) || taskDataHelper.ifPhotosAddedInTask((Cache_Task_On?.taskId)!) {
            Cache_Task_On?.didKeepPending = false
        }
        
        if Cache_Task_On?.didKeepPending == true {
            Cache_Task_On?.taskStatus = GetTaskStatusId(caseId: "Pending").rawValue
        }
        
        self.taskStatusInput.text = MylocalizedString.sharedLocalizeManager.getLocalizedString(String(TaskStatus(caseId: (Cache_Task_On?.taskStatus)!)))
        
        if taskDataHelper.updateTask(Cache_Task_On!) {
            
            Cache_Task_On?.didModify = false
            
            return true
        }
        
        return false
    }
}
