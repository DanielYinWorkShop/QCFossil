//
//  TaskSearchViewController.swift
//  QCFossil
//
//  Created by Yin Huang on 16/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

class TaskSearchViewController: PopoverMaster, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var taskItemTableView: UITableView!
    @IBOutlet weak var taskHeaderSegment: UISegmentedControl!
    @IBOutlet weak var bookingDateFromLabel: UILabel!
    @IBOutlet weak var bookingDateFromInput: UITextField!
    @IBOutlet weak var bookingDateToLabel: UILabel!
    @IBOutlet weak var bookingDateToInput: UITextField!
    @IBOutlet weak var bookingNoLabel: UILabel!
    @IBOutlet weak var bookingNoInput: UITextField!
    @IBOutlet weak var inspTypeLabel: UILabel!
    @IBOutlet weak var inspTypeInput: UITextField!
    @IBOutlet weak var styleLabel: UILabel!
    @IBOutlet weak var styleInput: UITextField!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var brandInput: UITextField!
    @IBOutlet weak var poNoLabel: UILabel!
    @IBOutlet weak var poNoInput: UITextField!
    @IBOutlet weak var shipWinFromLabel: UILabel!
    @IBOutlet weak var shipWinFromInput: UITextField!
    @IBOutlet weak var shipWinToLabel: UILabel!
    @IBOutlet weak var shipWinToInput: UITextField!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var vendorInput: UITextField!
    @IBOutlet weak var vendorLocationLabel: UILabel!
    @IBOutlet weak var vendorLocationInput: UITextField!
    @IBOutlet weak var taskStatusLabel: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var draftLabel: UILabel!
    @IBOutlet weak var confirmedLabel: UILabel!
    @IBOutlet weak var uploadedLabel: UILabel!
    @IBOutlet weak var refuseLabel: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var canceledLabel: UILabel!
    @IBOutlet weak var reviewedLabel: UILabel!
    @IBOutlet weak var opdRsdFromLabel: UILabel!
    @IBOutlet weak var opdRsdFromInput: UITextField!
    @IBOutlet weak var opdRsdToLabel: UILabel!
    @IBOutlet weak var opdRsdToInput: UITextField!
    
    var taskItems = [TaskItem]()
    var taskSet = [Task]()
    var tasks = [Task]()
    var vendors = [Vendor]()
    var vendorLocs = [VdrLoc]()
    var brands = [Brand]()
    var pendingSwitch = true
    var draftSwitch = true
    var confirmedSwitch = true
    var uploadedSwitch = false
    var refuseSwitch = false
    var canceledSwitch = false
    var reviewedSwitch = false
    var showListData = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //loadSampleTasks()
        NSLog("Task Search Page Did Load")
        
        initData()
        
        taskItemTableView.delegate = self
        taskItemTableView.dataSource = self
        
        bookingDateFromInput.delegate = self
        bookingDateToInput.delegate = self
        shipWinFromInput.delegate = self
        shipWinToInput.delegate = self
        opdRsdFromInput.delegate = self
        opdRsdToInput.delegate = self
        styleInput.delegate = self
        vendorInput.delegate = self
        vendorLocationInput.delegate = self
        brandInput.delegate = self
        inspTypeInput.delegate = self
        poNoInput.delegate = self
        bookingNoInput.delegate = self
        
        self.view.setButtonCornerRadius(self.searchBtn)
        self.view.setButtonCornerRadius(self.clearBtn)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TaskSearchViewController.reloadTaskSearchTableView), name: "reloadTaskSearchTableView", object: nil)
    }
    
    func initData() {
        let taskDataHelper = TaskDataHelper()
        brands = taskDataHelper.getAllTaskBrands()
        taskItems = taskDataHelper.getAllTaskItems()!
        
        for taskItem in taskItems {
            if let task = taskDataHelper.getTaskById(taskItem.taskId!) {
                taskSet.append(task)
            }
        }
        
        tasks = taskSet
        
        tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Uploaded").rawValue })
        tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Reviewed").rawValue })
        tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Refused").rawValue })
        tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Cancelled").rawValue })
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = _DATEFORMATTER
        tasks.sortInPlace(){ (dateFormatter.dateFromString($0.bookingDate! != "" ? $0.bookingDate! : $0.inspectionDate!)?.isGreaterThanDate(dateFormatter.dateFromString($1.bookingDate! != "" ? $1.bookingDate! : $1.inspectionDate!)!))! }
        
        let vendorDataHelper = VendorDataHelper()
        vendors = vendorDataHelper.getAllVendorsFromTaskSearch()!
        vendorLocs = vendorDataHelper.getAllVdrLocsFromTaskSearch()!
        
        updateLocalizedString()
    }
    
    func reloadTaskSearchTableView() {
        taskSet = [Task]()
        tasks = [Task]()
        brands = [Brand]()
        
        let taskDataHelper = TaskDataHelper()
        brands = taskDataHelper.getAllTaskBrands()
        taskItems = taskDataHelper.getAllTaskItems()!
        
        let vendorDataHelper = VendorDataHelper()
        vendors = vendorDataHelper.getAllVendorsFromTaskSearch()!
        vendorLocs = vendorDataHelper.getAllVdrLocsFromTaskSearch()!

        for taskItem in taskItems {
            if let task = taskDataHelper.getTaskById(taskItem.taskId!) {
                taskSet.append(task)
            }
        }
        
        tasks = taskSet
        
        if !self.pendingSwitch {
            tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Pending").rawValue })
        }
        
        if !self.draftSwitch {
            tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Draft").rawValue })
        }
        
        if !self.confirmedSwitch {
            tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Confirmed").rawValue })
        }
        
        if !self.uploadedSwitch {
            tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Uploaded").rawValue })
        }
        
        if !self.reviewedSwitch {
            tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Reviewed").rawValue })
        }
        
        if !self.refuseSwitch {
            tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Refused").rawValue })
        }
        
        if !self.canceledSwitch {
            tasks = tasks.filter({ $0.taskStatus != GetTaskStatusId(caseId: "Cancelled").rawValue })
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = _DATEFORMATTER
        tasks.sortInPlace(){ (dateFormatter.dateFromString($0.bookingDate! != "" ? $0.bookingDate! : $0.inspectionDate!)?.isGreaterThanDate(dateFormatter.dateFromString($1.bookingDate! != "" ? $1.bookingDate! : $1.inspectionDate!)!))! }
        
        if (self.taskItemTableView != nil) {
            self.taskItemTableView.reloadData()
        }
    }
    
    func updateLocalizedString(){
        
        self.bookingDateFromLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Book/Inspect Date From")
        self.bookingDateToLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("To")
        self.bookingNoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Book/Inspect No.")
        self.inspTypeLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Type")
        self.styleLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Style")
        self.brandLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Brand")
        self.poNoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("PO No.")
        self.shipWinFromLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Ship Win From")
        self.shipWinToLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("To")
        self.vendorLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor")
        self.vendorLocationLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor Location")
        self.taskStatusLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Status")
        self.pendingLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Pending")
        self.draftLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Draft")
        self.confirmedLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Confirmed")
        self.uploadedLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Uploaded")
        self.refuseLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Refused")
        self.canceledLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancelled")
        self.reviewedLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Reviewed")
        self.searchBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Search"), forState: UIControlState.Normal)
        self.clearBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Clear"), forState: UIControlState.Normal)
        self.vendorInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor PlaceHolder")
        self.vendorLocationInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor Location PlaceHolder")
        self.opdRsdFromLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("OPD/RSD From")
        self.opdRsdToLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("To")
        
        let segmentTitles = [MylocalizedString.sharedLocalizeManager.getLocalizedString("Book Date"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Book No"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Status"),MylocalizedString.sharedLocalizeManager.getLocalizedString("PO"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Style"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Brand"),MylocalizedString.sharedLocalizeManager.getLocalizedString("Ship Win")]
        
        for idx in 0...self.taskHeaderSegment.numberOfSegments-1 {
            self.taskHeaderSegment.setTitle(segmentTitles[idx], forSegmentAtIndex: idx)
        }
        
        self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Search")
        self.navigationItem.leftBarButtonItem?.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("App Menu")
        self.navigationItem.rightBarButtonItem?.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Create Task")
        
        self.inspTypeInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Final/Material/In-line")
        self.bookingNoInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspect/Book No.")
        self.poNoInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("PO No.")
        self.styleInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Style")
        self.brandInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Brand")
        self.bookingDateFromInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("MM/DD/YYYY")
        self.bookingDateToInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("MM/DD/YYYY")
        self.shipWinFromInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("MM/DD/YYYY")
        self.shipWinToInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("MM/DD/YYYY")
        self.opdRsdFromInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("MM/DD/YYYY")
        self.opdRsdToInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("MM/DD/YYYY")
    }

    func find<C: CollectionType>(collection: C, predicate: (C.Generator.Element) -> Bool) -> C.Index? {
        for index in collection.startIndex ..< collection.endIndex {
            if predicate(collection[index]) {
                return index
            }
        }
        return nil
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if touch.view!.isKindOfClass(UITextField().classForCoder) || String(touch.view!.classForCoder) == "UITableViewCellContentView" {
            self.view.resignFirstResponderByTextField(self.view)
            
        }else {
            self.view.clearDropdownviewForSubviews(self.view)
            
        }
        
        return false
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
    
    override func viewWillAppear(animated: Bool) {
        //self.taskItemTableView.reloadData()
        
        let taskOnArray = tasks.filter({$0.taskId == Cache_Task_On?.taskId})
        if taskOnArray.count>0 {
            let index = find(tasks) { $0.taskId == Cache_Task_On?.taskId }
            if let index = index {
                tasks[index] = Cache_Task_On!
                self.taskItemTableView.reloadData()
            }
        }
        
        let taskSetOnArray = taskSet.filter({$0.taskId == Cache_Task_On?.taskId})
        if taskSetOnArray.count>0 {
            let index = find(taskSet) { $0.taskId == Cache_Task_On?.taskId }
            if let index = index {
                taskSet[index] = Cache_Task_On!
            }
        }
        
        //Physical Delete Task if Need
        if Cache_Task_On?.deleteFlag == 1 {
            if Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Cancelled").rawValue {
                self.view.deleteTask((Cache_Task_On?.taskId)!)
                self.reloadTaskSearchTableView()
                
            }else{
                self.view.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete all invalid tasks?"), parentVC:self, handlerFun: { (action:UIAlertAction!) in
                
                    dispatch_async(dispatch_get_main_queue(), {
                        self.view.showActivityIndicator("Deleting...")
                    
                        dispatch_async(dispatch_get_main_queue(), {
                            let taskDataHelper = TaskDataHelper()
                            var invalidTaskIds = taskDataHelper.getAllInvalidTaskId()
                
                            while let id = invalidTaskIds.popLast() {
                                    self.view.deleteTask(id)
                            }
                        
                            Cache_Task_On = nil
                            self.view.removeActivityIndicator()
                            self.reloadTaskSearchTableView()
                        })
                    })
                
                })
            }
        }
        
        //NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":true])
        //self.reloadTaskSearchTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Menu(sender: UIBarButtonItem) {
        NSLog("Toggle Menu")
        
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }

    @IBAction func createTaskBarButton(sender: UIBarButtonItem) {
        NSLog("Create Task")
        
        self.performSegueWithIdentifier("CreateTaskSegue", sender:self)
    }
    
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
    }
    */
    
    func numberOfSectionsInTableView(taskItemTableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        return 1
    }
    
    func tableView(taskItemTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return tasks.count
    }
    
    func tableView(taskItemTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = taskItemTableView.dequeueReusableCellWithIdentifier("TaskCell", forIndexPath: indexPath) as! TaskTableViewCell
        
        let task = tasks[indexPath.row] as Task
        
        cell.bookingDateText.text = task.bookingDate!.isEmpty ? task.inspectionDate : task.bookingDate
        cell.bookingNoText.text = task.bookingNo!.isEmpty ? task.inspectionNo : task.bookingNo
        
        if task.taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue && task.cancelDate != "" {
            cell.taskStatusText.text = MylocalizedString.sharedLocalizeManager.getLocalizedString(String(TaskStatus(caseId: task.taskStatus!)) + " (C)")
        }else{
            cell.taskStatusText.text = MylocalizedString.sharedLocalizeManager.getLocalizedString(String(TaskStatus(caseId: task.taskStatus!)))
        }
        
        var vendorLoc = ""
        if task.vendor != nil {
            vendorLoc = task.vendor!
        }
        
        if task.vendorLocation != nil {
            vendorLoc = "\(vendorLoc)(\(task.vendorLocation!))"
        }
        
        cell.vendorLabelText.text = vendorLoc
        cell.brandText.text = task.brand
        cell.styleText.text = task.style
        cell.poListText.text = task.poNo
        cell.inspectionTypeText.text = task.inspectionType
        cell.taskId = task.taskId!
        cell.dataRefuseDesc = task.dataRefuseDesc
        cell.parentTaskSearchVC = self
        
        if task.prodDesc != nil {
            cell.prodDesc = task.prodDesc!
        }else{
            cell.prodDesc = ""
        }
        
        if task.poNo?.rangeOfString(",") != nil {
            cell.showAllPOLines.hidden = false
            cell.showAllPOLines2.hidden = false
        }else{
            cell.showAllPOLines.hidden = true
            cell.showAllPOLines2.hidden = true
        }
        
        if task.shipWin?.rangeOfString(",") != nil {
            cell.showAllShipWinDates.hidden = false
            cell.showAllshipWinDatesLabel.hidden = false
        }else{
            cell.showAllShipWinDates.hidden = true
            cell.showAllshipWinDatesLabel.hidden = true
        }
        
        if task.opdRsd?.rangeOfString(",") != nil {
            cell.showOpdRsd.hidden = false
        }else{
            cell.showOpdRsd.hidden = true
        }
        
        if task.dataRefuseDesc == "" {
            cell.taskStatusDescLabel.hidden = true
            cell.showTaskStatusDesc.hidden = true
        }else{
            cell.taskStatusDescLabel.hidden = false
            cell.showTaskStatusDesc.hidden = false
        }
        
        cell.shipWinText.text = task.shipWin
        cell.vendorLocationText.text = task.opdRsd
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = _TABLECELL_BG_COLOR2
        }else{
            cell.backgroundColor = _TABLECELL_BG_COLOR1
        }
        
        if cell.taskId == Cache_Task_On?.taskId {
            self.taskItemTableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Task Selected")
        
        Cache_Task_On = tasks[indexPath.row]
        /*
        let tmpTask = tasks[indexPath.row]
        
        if Cache_Task_On?.vdrSignName != "" && Cache_Task_On?.vdrLocationId == tmpTask.vdrLocationId {
            tmpTask.vdrSignName = Cache_Task_On?.vdrSignName
        }else{
            let taskDataHelper = TaskDataHelper()
            tmpTask.vdrSignName = taskDataHelper.getLastVdrConfirmerNameToday(tmpTask.vdrLocationId!)
            
            if tmpTask.vdrSignName == "" {
                tmpTask.vdrSignName = taskDataHelper.getVdrConfirmerNameByTaskId(tmpTask.taskId!)
            }
        }
        
        Cache_Task_On = tmpTask
        */
        self.performSegueWithIdentifier("TaskDetailAfterSearchSegue", sender:self)
    }
    
    @IBAction func taskHeaderSegmentClick(sender: UISegmentedControl) {
        
        let selectedSegment = sender.selectedSegmentIndex
        
        sortBySegmentSelected(selectedSegment)
        
        self.taskItemTableView.reloadData()
    }
    
    func sortBySegmentSelected(selectedSegment:Int = 0) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = _DATEFORMATTER
        
        switch selectedSegment {
        case 0: tasks.sortInPlace(){ (dateFormatter.dateFromString($0.bookingDate! != "" ? $0.bookingDate! : $0.inspectionDate!)?.isGreaterThanDate(dateFormatter.dateFromString($1.bookingDate! != "" ? $1.bookingDate! : $1.inspectionDate!)!))! }; break
        case 1: tasks.sortInPlace(){ $0.bookingNo<$1.bookingNo && $0.sortingNum<$1.sortingNum  }; break
        //case 1: tasks.sortInPlace(){$0.bookingNo<$1.bookingNo}; break
        //case 2: tasks.sortInPlace(){$0.taskStatus<$1.taskStatus}; break
        case 2: tasks.sortInPlace(){String(TaskStatus(caseId: $0.taskStatus!))<String(TaskStatus(caseId: $1.taskStatus!))}; break
        case 3: tasks.sortInPlace(){$0.poNo<$1.poNo}; break
        case 4: tasks.sortInPlace(){$0.style<$1.style}; break
        case 5: tasks.sortInPlace(){$0.brand<$1.brand}; break
        case 6: tasks.sortInPlace(){ ($0.shipWin != nil && $1.shipWin != nil) ? sortByShipWin($0.shipWin!, shipWin2: $1.shipWin!) : $0.shipWin>$1.shipWin }; break
        default: tasks.sortInPlace(){ (dateFormatter.dateFromString($0.bookingDate!)?.isGreaterThanDate(dateFormatter.dateFromString($1.bookingDate!)!))! }; break
        }
    }
    
    func sortByShipWin(shipWin1:String, shipWin2:String) ->Bool {
        let shipWin1Array = shipWin1.characters.split{$0 == ","}.map(String.init)
        let shipWin2Array = shipWin2.characters.split{$0 == ","}.map(String.init)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = _DATEFORMATTER
        
        if shipWin1Array.count>0 && shipWin2Array.count>0 {
            
            if dateFormatter.dateFromString(shipWin1Array[0])!.isGreaterThanDate(dateFormatter.dateFromString(shipWin2Array[0])!) {
                
                return true
            }
        }
        
        return false
    }
    
    @IBAction func switchOnClick(sender: UISwitch) {
        switch sender.tag {
            case 1: if sender.on {self.pendingSwitch = true}else{self.pendingSwitch = false}
            case 2: if sender.on {self.draftSwitch = true}else{self.draftSwitch = false}
            case 3: if sender.on {self.confirmedSwitch = true}else{self.confirmedSwitch = false}
            case 4: if sender.on {self.uploadedSwitch = true}else{self.uploadedSwitch = false}
            case 5: if sender.on {self.refuseSwitch = true}else{self.refuseSwitch = false}
            case 6: if sender.on {self.canceledSwitch = true}else{self.canceledSwitch = false}
            case 7: if sender.on {self.reviewedSwitch = true}else{self.reviewedSwitch = false}
            default: break
        }
    }
    
    @IBAction func searchTaskOnClick(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            self.view.showActivityIndicator()
            
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue()) {
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = _DATEFORMATTER
                
                let taskDataHelper = TaskDataHelper()
                self.taskItems = taskDataHelper.getAllTaskItems()!
                
                self.taskSet = [Task]()
                
                for taskItem in self.taskItems {
                    if let task = taskDataHelper.getTaskById(taskItem.taskId!) {
                        self.taskSet.append(task)
                    }
                }
                
                var tasksByFilter = self.taskSet
                
                //Filter By Booking Date
                let bookingDateFrom = dateFormatter.dateFromString(self.bookingDateFromInput.text!)
                let bookingDateTo = dateFormatter.dateFromString(self.bookingDateToInput.text!)
                
                if self.bookingDateFromInput.text != "" {
                    tasksByFilter = tasksByFilter.filter({ ($0.bookingDate != nil && $0.bookingDate != "") ? ((dateFormatter.dateFromString($0.bookingDate!)!.equalToDate(bookingDateFrom!)) || (dateFormatter.dateFromString($0.bookingDate!)!.isGreaterThanDate(bookingDateFrom!))) : ((dateFormatter.dateFromString($0.inspectionDate!)!.equalToDate(bookingDateFrom!)) || (dateFormatter.dateFromString($0.inspectionDate!)!.isGreaterThanDate(bookingDateFrom!))) })
                }
                
                if self.bookingDateToInput.text != "" {
                    tasksByFilter = tasksByFilter.filter({ ($0.bookingDate != nil && $0.bookingDate != "") ? ((dateFormatter.dateFromString($0.bookingDate!)!.equalToDate(bookingDateTo!)) || (dateFormatter.dateFromString($0.bookingDate!)!.isLessThanDate(bookingDateTo!))) : ((dateFormatter.dateFromString($0.inspectionDate!)!.equalToDate(bookingDateTo!)) || (dateFormatter.dateFromString($0.inspectionDate!)!.isLessThanDate(bookingDateTo!))) })
                }
                
                //Filter By Booking No.
                if self.bookingNoInput.text != "" {
                    tasksByFilter = tasksByFilter.filter({ $0.bookingNo == nil || ($0.bookingNo?.lowercaseString.containsString((self.bookingNoInput.text?.lowercaseString)!))! || ($0.inspectionNo?.lowercaseString.containsString((self.bookingNoInput.text?.lowercaseString)!))! })
                }
                
                //Filter By InspType
                if self.inspTypeInput.text != "" {
                    tasksByFilter = tasksByFilter.filter({ $0.inspectionType == nil || ($0.inspectionType?.lowercaseString.containsString((self.inspTypeInput.text?.lowercaseString)!))! })
                }
                
                //Filter By Style
                if self.styleInput.text != "" {
                    tasksByFilter = tasksByFilter.filter({ $0.style == nil || ($0.style?.lowercaseString.containsString((self.styleInput.text?.lowercaseString)!))! })
                }
                
                //Filter By Brand
                if self.brandInput.text != "" {
                    tasksByFilter = tasksByFilter.filter({ $0.brand == nil || ($0.brand?.lowercaseString.containsString((self.brandInput.text?.lowercaseString)!))! })
                }
                
                //Filter By PoNo.
                if self.poNoInput.text != "" {
                    tasksByFilter = tasksByFilter.filter({ $0.poNo == nil || ($0.poNo?.lowercaseString.containsString((self.poNoInput.text?.lowercaseString)!))! })
                }
                
                //Filter By Ship Win Date
                let shipWinFrom = dateFormatter.dateFromString(self.shipWinFromInput.text! == "" ? "01/01/1970" : self.shipWinFromInput.text!)
                let shipWinTo = dateFormatter.dateFromString(self.shipWinToInput.text! == "" ? "12/30/2099" : self.shipWinToInput.text!)
                
                tasksByFilter = tasksByFilter.filter({ $0.shipWin == nil || $0.shipWin == "" || self.filterByShipWin($0.shipWin!, shipWinFrom: shipWinFrom!, shipWinTo: shipWinTo!) })
                
                //Filter By OPDRSD
                let opdRsdFrom = dateFormatter.dateFromString(self.opdRsdFromInput.text! == "" ? "01/01/1970" : self.opdRsdFromInput.text!)
                let opdRsdTo = dateFormatter.dateFromString(self.opdRsdToInput.text! == "" ? "12/30/2099" : self.opdRsdToInput.text!)
                
                tasksByFilter = tasksByFilter.filter({ $0.opdRsd == nil || $0.opdRsd == "" || self.filterByOPDRSD($0.opdRsd!, opdRsdFrom: opdRsdFrom!, opdRsdTo: opdRsdTo!) })
                
                //Filter By Vendor
                if self.vendorInput.text != "" {
                    tasksByFilter = tasksByFilter.filter({ $0.vendor == nil || ($0.vendor != "" && ($0.vendor?.lowercaseString.containsString((self.vendorInput.text?.lowercaseString)!))!) })
                }
                
                //Filter By VendorLocation
                if self.vendorLocationInput.text != "" {
                    tasksByFilter = tasksByFilter.filter({ $0.vendorLocation == nil || ($0.vendorLocation != "" && ($0.vendorLocation?.lowercaseString.containsString((self.vendorLocationInput.text?.lowercaseString)!))!) })
                }
                
                
                //Filter By Task Status Pending
                if !self.pendingSwitch {
                    tasksByFilter = tasksByFilter.filter({ TaskStatus(caseId: $0.taskStatus!) != TaskStatus(caseId: GetTaskStatusId(caseId: "Pending").rawValue) })
                }
                
                
                //Filter By Task Status Draft
                if !self.draftSwitch {
                    tasksByFilter = tasksByFilter.filter({ TaskStatus(caseId: $0.taskStatus!) != TaskStatus(caseId: GetTaskStatusId(caseId: "Draft").rawValue) })
                }
                
                
                //Filter By Task Status Confirmed
                if !self.confirmedSwitch {
                    tasksByFilter = tasksByFilter.filter({ TaskStatus(caseId: $0.taskStatus!) != TaskStatus(caseId: GetTaskStatusId(caseId: "Confirmed").rawValue) })
                }
                
                
                //Filter By Task Status Uploaded
                if !self.uploadedSwitch {
                    tasksByFilter = tasksByFilter.filter({ TaskStatus(caseId: $0.taskStatus!) != TaskStatus(caseId: GetTaskStatusId(caseId: "Uploaded").rawValue) })
                }
                
                
                //Filter By Task Status Refuserd
                if !self.refuseSwitch {
                    tasksByFilter = tasksByFilter.filter({ TaskStatus(caseId: $0.taskStatus!) != TaskStatus(caseId: GetTaskStatusId(caseId: "Refused").rawValue) })
                }
                
                
                //Filter By Task Status Cancelled
                if !self.canceledSwitch {
                    tasksByFilter = tasksByFilter.filter({ TaskStatus(caseId: $0.taskStatus!) != TaskStatus(caseId: GetTaskStatusId(caseId: "Cancelled").rawValue) })
                }
                
               
                //Filter By Task Status Revieweded
                if !self.reviewedSwitch {
                    tasksByFilter = tasksByFilter.filter({ TaskStatus(caseId: $0.taskStatus!) != TaskStatus(caseId: GetTaskStatusId(caseId: "Reviewed").rawValue) })
                }
                
                self.tasks = tasksByFilter
                
                self.sortBySegmentSelected(self.taskHeaderSegment.selectedSegmentIndex)
                
                self.taskItemTableView.reloadData()
                
                self.view.removeActivityIndicator()
            }
        })
    }
    
    func filterByShipWin(shipWinTmp:String, shipWinFrom:NSDate, shipWinTo:NSDate) ->Bool {
        let shipWinTmpArray = shipWinTmp.characters.split{$0 == ","}.map(String.init)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = _DATEFORMATTER
        
        if shipWinTmpArray.count>0 {
            
            for shipWin in shipWinTmpArray {
                
                if shipWin != "" && (dateFormatter.dateFromString(shipWin)!.equalToDate(shipWinFrom) || dateFormatter.dateFromString(shipWin)!.equalToDate(shipWinTo) || (dateFormatter.dateFromString(shipWin)!.isGreaterThanDate(shipWinFrom) && dateFormatter.dateFromString(shipWin)!.isLessThanDate(shipWinTo)))
                {
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    func filterByOPDRSD(opdRsdTmp:String, opdRsdFrom:NSDate, opdRsdTo:NSDate) ->Bool {
        let opdRsdTmpArray = opdRsdTmp.characters.split{$0 == ","}.map(String.init)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = _DATEFORMATTER
        
        if opdRsdTmpArray.count>0 {
            
            for opdRsd in opdRsdTmpArray {
                
                if opdRsd != "" && (dateFormatter.dateFromString(opdRsd)!.equalToDate(opdRsdFrom) || dateFormatter.dateFromString(opdRsd)!.equalToDate(opdRsdTo) || (dateFormatter.dateFromString(opdRsd)!.isGreaterThanDate(opdRsdFrom) && dateFormatter.dateFromString(opdRsd)!.isLessThanDate(opdRsdTo)))
                {
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    @IBAction func clearOnClick(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(), {
            self.view.showActivityIndicator()
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.bookingDateFromInput.text = ""
                self.bookingDateToInput.text = ""
                self.bookingNoInput.text = ""
                self.inspTypeInput.text = ""
                self.styleInput.text = ""
                self.brandInput.text = ""
                self.poNoInput.text = ""
                self.shipWinFromInput.text = ""
                self.shipWinToInput.text = ""
                self.vendorInput.text = ""
                self.vendorLocationInput.text = ""
                self.opdRsdFromInput.text = ""
                self.opdRsdToInput.text = ""
                
                self.view.removeActivityIndicator()
            })
        })
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.view.clearDropdownviewForSubviews(self.view)
        if !showListData {
            showListData = true
            return false
        }
        
        let handleFun:(UITextField)->(Void) = dropdownHandleFunc
        
        if textField == self.bookingDateFromInput || textField == self.bookingDateToInput || textField == self.shipWinFromInput || textField == self.shipWinToInput || textField == self.opdRsdFromInput || textField == self.opdRsdToInput {
            UITextField.init().showDatePicker(textField)
            
            return false
        }else if textField == self.inspTypeInput {
            let taskDataHelper = TaskDataHelper()
            let inspTypeData = taskDataHelper.getAllInspType()
            
            textField.showListData(textField, parent: self.view, handle: handleFun, listData: inspTypeData)
            return false
        }
        
        /*else if textField == self.bookingNoInput {
            let taskDataHelper = TaskDataHelper()
            let bookingNoList = taskDataHelper.getAllTaskBookingNo(textField.text!)
            
            Cache_Dropdown_Instance = textField.showListData(textField, parent: self.view, listData: bookingNoList, width: 200, height: 650)
        
        }else if textField == self.poNoInput {
            let poDataHelper = PoDataHelper()
            let poNoList = poDataHelper.getAllTaskPoNo(textField.text!)
            
            Cache_Dropdown_Instance = textField.showListData(textField, parent: self.view, listData: poNoList, width: 200, height: 650)
        }else if textField == self.styleInput {
            let poDataHelper = PoDataHelper()
            let styleList = poDataHelper.getAllStyleNoByValue(textField.text!)
            
            Cache_Dropdown_Instance = textField.showListData(textField, parent: self.view, listData: styleList, width: 200, height: 650)
        }*/else if textField == self.brandInput {
            let taskDataHelper = TaskDataHelper()
            let brandList = taskDataHelper.getAllTaskBrandCodes()
            
            textField.showListData(textField, parent: self.view, listData: brandList)
            
        }else if textField == self.vendorInput {
            
            var vdrData = [String]()
            
            for vendor in vendors {
                vdrData.append(vendor.displayName!)
            }
            
            textField.showListData(textField, parent: self.view, handle: handleFun, listData: vdrData)
        }else if textField == self.vendorLocationInput{
            var vdrLocData = [String]()
            var currVendorId = 0
            
            if self.vendorInput.text != "" {
                let vendorOnFilter = vendors.filter({ $0.displayName == self.vendorInput.text })
                
                if vendorOnFilter.count > 0 {
                    let vendorOn = vendorOnFilter[0]
                    currVendorId = vendorOn.vdrId!
                }
            }
            
            for vendorLoc in vendorLocs {
                if vendorLoc.vdrId == currVendorId || currVendorId == 0 {
                    vdrLocData.append(vendorLoc.locationCode!)
                }
            }
            
            textField.showListData(textField, parent: self.view, handle: handleFun, listData: vdrLocData, width: 150)
        }
 
        
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        
        if textField == self.vendorLocationInput || textField == self.vendorInput {
            self.vendorLocationInput.text = ""
            self.vendorInput.text = ""
            
            showListData = false
        }
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var inputValue = ""
        if textField.text!.characters.count < 2 && string == "" {
            inputValue = ""
            textField.showListData(textField, parent: self.view, handle: nil, listData: [String](), width: 200)
            return true
        }else if string == ""{
            inputValue = String(textField.text!.characters.dropLast())
        }else {
            inputValue = textField.text! + string
        }
        
        if textField == self.styleInput {
            let taskDataHelper = TaskDataHelper()
            let styleList = taskDataHelper.getAllStyleNoByValue(inputValue)

            textField.showListData(textField, parent: self.view, listData: styleList, width: 200)
            
        }else if textField == self.bookingNoInput {
            let taskDataHelper = TaskDataHelper()
            let bookingNoList = taskDataHelper.getAllTaskBookingNo(inputValue)
            
            textField.showListData(textField, parent: self.view, listData: bookingNoList, width: 200)
            
        }else if textField == self.poNoInput {
            let poDataHelper = PoDataHelper()
            let poNoList = poDataHelper.getAllTaskPoNo(inputValue)
            
            textField.showListData(textField, parent: self.view, listData: poNoList, width: 200)
            
        }else if textField == self.brandInput {
            let taskDataHelper = TaskDataHelper()
            let brandList = taskDataHelper.getAllTaskBrandCodes(inputValue)
            
            textField.showListData(textField, parent: self.view, listData: brandList, width: 200)
            
        }else if textField == self.vendorInput {
            let vendorDataHelper = VendorDataHelper()
            let vendorList = vendorDataHelper.getAllVendors(inputValue)
            let handleFun:(UITextField)->(Void) = dropdownHandleFunc
            
            textField.showListData(textField, parent: self.view, handle: handleFun, listData: vendorList, width: 200)
        }
        else if textField == self.vendorLocationInput {
            let vendorDataHelper = VendorDataHelper()
            let vendorLocationList = vendorDataHelper.getAllVendorLocs(inputValue)
            let handleFun:(UITextField)->(Void) = dropdownHandleFunc
            
            textField.showListData(textField, parent: self.view, handle: handleFun, listData: vendorLocationList, width: 200)
        }
        
        return true
    }
    
    func dropdownHandleFunc(textField: UITextField) {
        
        if textField == self.vendorInput {
            
            let vendorOnFilter = vendors.filter({ $0.displayName == textField.text })
            
            if vendorOnFilter.count > 0 {
                let vendorOn = vendorOnFilter[0]
                let vendorLocFilter = vendorLocs.filter({ $0.vdrId == vendorOn.vdrId})
                
                if vendorLocFilter.count > 0 {
                    let vendorLoc = vendorLocFilter[0]
                    self.vendorLocationInput.text = vendorLoc.locationCode
                }
            }
        }else if textField == self.vendorLocationInput {
            
            let vendorLocFilter = vendorLocs.filter({ $0.locationCode == textField.text })
            
            if vendorLocFilter.count > 0 {
                let vendorLocOn = vendorLocFilter[0]
                let vendorOnFilter = vendors.filter({ $0.vdrId == vendorLocOn.vdrId})
                
                if vendorOnFilter.count > 0 {
                    let vendor = vendorOnFilter[0]
                    self.vendorInput.text = vendor.displayName
                }
            }
        }
    }
}
