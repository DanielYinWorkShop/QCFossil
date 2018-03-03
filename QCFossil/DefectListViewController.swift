//
//  DefectListViewController.swift
//  QCFossil
//
//  Created by pacmobile on 6/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class DefectListViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet weak var sectionSegmentControl: UISegmentedControl!
    @IBOutlet weak var defectTableView: UITableView!
    @IBOutlet weak var inptNoLabel: UILabel!
    var defectCells = [InputModeDFMaster2]()
    var defectItems = [TaskInspDefectDataRecord]()
    var defectSectionCellsCount = [Int]()
    let sectionWidth = 768
    let sectionHeight = 80
    let cellWidth = 768
    var cellHeight = 225
    var cellHeight2 = 225
    var currentHeaderIdx = 0
    var fromSectionIdx = 0
    var fromItemIdx = 0
    weak var currentCell:InputModeDFMaster2!//InputModeDFMaster()
    var keyboardHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if self.parentViewController?.parentViewController?.classForCoder == TabBarViewController.self {
            let parentVC = self.parentViewController?.parentViewController as! TabBarViewController
            parentVC.defectListViewController = self
        }
        
        inptNoLabel.text = Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo
        
        defectTableView.delegate = self
        defectTableView.dataSource = self
        defectTableView.rowHeight = 225
        defectTableView.allowsSelection = false
        
        sectionSegmentControl.setTitle(_ENGLISH ? "All" : "全部", forSegmentAtIndex: 0)
        
        var index = 1
        for section in (Cache_Task_On?.inspSections)! {
            sectionSegmentControl.setTitle(_ENGLISH ? section.sectionNameEn! : section.sectionNameCn!, forSegmentAtIndex: index)
            index += 1
        }
        
        sectionSegmentControl.selectedSegmentIndex = 0
        sectionSegmentControl.layer.cornerRadius = 5.0
        sectionSegmentControl.setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(16)], forState: UIControlState.Normal)
        sectionSegmentControl.backgroundColor = _FOSSILYELLOWCOLOR
        sectionSegmentControl.tintColor = _FOSSILBLUECOLOR
        sectionSegmentControl.addTarget(self, action: #selector(DefectListViewController.sectionSegmentOnchange), forControlEvents:.ValueChanged)
        
        var sortingDictionary = Dictionary<String, Int>()
        
        for defectItem in (Cache_Task_On?.defectItems)! {
            
            if defectItem.inspElmt.cellCatIdx < 1 && defectItem.inspElmt.cellIdx < 1 {
                for inspSection in (Cache_Task_On?.inspSections)! {
                    if inspSection.sectionId == defectItem.sectObj.sectionId {
                        var idx = 1
                        for inspElmt in inspSection.taskInspDataRecords {
                            if inspElmt.inspectElementId == defectItem.inspectElementId {
                                
                                defectItem.inspElmt.cellCatIdx = inspSection.sectionId!
                                defectItem.inspElmt.cellIdx = idx
                                defectItem.inspElmt.cellCatName = (_ENGLISH ? inspSection.sectionNameEn : inspSection.sectionNameCn)!
                                defectItem.inspElmt.inspCatText = (_ENGLISH ? inspSection.sectionNameEn : inspSection.sectionNameCn)!
                                defectItem.inspElmt.inspAreaText = (_ENGLISH ? inspElmt.postnObj?.positionNameEn : inspElmt.postnObj?.positionNameCn)!
                                
                                if defectItem.inputMode == _INPUTMODE03 {
                                    defectItem.inspElmt.inspReqCatText = (_ENGLISH ? inspElmt.reqSectObj?.sectionNameEn : inspElmt.reqSectObj?.sectionNameCn)!
                                    defectItem.inspElmt.inspItemText = inspElmt.requestElementDesc
                                }else{
                                    defectItem.inspElmt.inspItemText = (_ENGLISH ? inspElmt.elmtObj?.elementNameEn : inspElmt.elmtObj?.elementNameCn)!
                                }
                            }
                            idx += 1
                        }
                    }
                }
            }
            
            if (sortingDictionary["\(defectItem.inspElmt.cellCatIdx)-\(defectItem.inspElmt.cellIdx)"] != nil) {
                sortingDictionary["\(defectItem.inspElmt.cellCatIdx)-\(defectItem.inspElmt.cellIdx)"] = sortingDictionary["\(defectItem.inspElmt.cellCatIdx)-\(defectItem.inspElmt.cellIdx)"]! + 1
            }else{
                sortingDictionary["\(defectItem.inspElmt.cellCatIdx)-\(defectItem.inspElmt.cellIdx)"] = 0
            }
            
            defectItem.cellIdx = sortingDictionary["\(defectItem.inspElmt.cellCatIdx)-\(defectItem.inspElmt.cellIdx)"]!
            defectItem.sortNum = getSortingNum(defectItem.inspElmt.cellCatIdx, elmtFtor: defectItem.inspElmt.cellIdx, cellFtor: defectItem.cellIdx)
    
        }
        
        defectItems = (Cache_Task_On?.defectItems)!
        
        updateContentView()
    }
    
    func getSortingNum(secFtor:Int, elmtFtor:Int, cellFtor:Int) ->Int {

        return secFtor*1000000 + elmtFtor*1000 + cellFtor
    }
    
    func initNotificationCenter() {
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DefectListViewController.deleteDefectItemsByInspItem(_:)), name: "deleteDefectItemsByInspItem", object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DefectListViewController.updateCellInfo(_:)), name: "updateCellInfo", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.view.disableAllFunsForView(self.view)
        if self.defectTableView.frame.size.height < 860 {
            self.defectTableView.frame.size.height += keyboardHeight - 45
        }
    }
    
    func deleteDefectItemsByInspItem(notification:NSNotification) {
        let inspElmt:Dictionary<String,InputModeICMaster> = notification.userInfo as! Dictionary<String,InputModeICMaster>
        let parentInspElmt = inspElmt["inspElmt"]
        
        /*let index = Cache_Task_On?.defectItems.indexOf({ $0.inspElmt.cellCatIdx == parentInspElmt!.cellCatIdx && $0.inspElmt.cellIdx == parentInspElmt!.cellIdx })
        
        if index != nil {
            Cache_Task_On?.defectItems.removeAtIndex(index!)
        }*/
        
        let defectItemsArray = Cache_Task_On?.defectItems.filter({ $0.inspElmt.cellCatIdx == parentInspElmt!.cellCatIdx && $0.inspElmt.cellIdx == parentInspElmt!.cellIdx })
        
        if defectItemsArray?.count > 0 {
            for defectItem in defectItemsArray! {
                let index = Cache_Task_On?.defectItems.indexOf({ $0.inspElmt.cellCatIdx == defectItem.inspElmt.cellCatIdx && $0.inspElmt.cellIdx == defectItem.inspElmt.cellIdx && $0.cellIdx == defectItem.cellIdx })
                Cache_Task_On?.defectItems.removeAtIndex(index!)
                
                //remove DB data
                if defectItem.photoNames != nil && defectItem.photoNames?.count>0 {
                    for photoName in defectItem.photoNames! {
                        //Remove defect photo to Photo Album
                        let photoDataHelper = PhotoDataHelper()
                        photoDataHelper.updatePhotoDatasByPhotoName(photoName, dataType:PhotoDataType(caseId: "TASK").rawValue, dataRecordId:0)
                    }
                }
                
                //Delete Record From DB
                if defectItem.recordId > 0 {
                    let taskDataHelper = TaskDataHelper()
                    taskDataHelper.deleteTaskInspDefectDataRecordById(defectItem.recordId!)
                }
            }
        }
    }
    
    func setDefectPhotos(inputMode:String, defectCell:InputModeDFMaster, photos:[Photo]) {
        
        for photo in photos {
            if photo.photo?.image != nil {
                defectCell.setSelectedPhoto(photo,needSave: false)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func sectionSegmentOnchange(/*sender: UISegmentedControl*/) {
        
        let sectionName = sectionSegmentControl?.titleForSegmentAtIndex((sectionSegmentControl?.selectedSegmentIndex)!)!
        
        if sectionSegmentControl?.selectedSegmentIndex < 1 {
            self.defectItems = (Cache_Task_On?.defectItems)!
        }else{
            self.defectItems = (Cache_Task_On?.defectItems.filter({ $0.inspElmt.cellCatName == sectionName }))!
        }
        
        //self.defectItems.forEach({ $0.sortNum = getSortingNum($0.sectObj.sectionId, elmtFtor: $0.inspElmt.elementDbId, cellFtor: $0.cellIdx) })
        
        self.defectItems.sortInPlace({ $0.sortNum < $1.sortNum })
        self.defectTableView?.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        updateContentView()
        
        let myParentTabVC = self.parentViewController?.parentViewController as! TabBarViewController
        myParentTabVC.setLeftBarItem("< "+MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Form"),actionName: "backToTaskDetailFromPADF")
        
        if !self.view.disableFuns(self.view) {
            myParentTabVC.setRightBarItem(MylocalizedString.sharedLocalizeManager.getLocalizedString("Save"), actionName: "updateTask:")
        }else{
            myParentTabVC.setRightBarItem("", actionName: "noAction")
        }
        
        myParentTabVC.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Findings")
        
        NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":false])
    }
    
    func updateContentView() {
        
        Cache_Task_On?.defectItems.sortInPlace({ $0.sortNum < $1.sortNum })
        
        sectionSegmentOnchange()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "PhotoAlbumSegueFromDF" {
            
            weak var destVC = segue.destinationViewController as? PhotoAlbumViewController
            destVC!.pVC = self.currentCell

        }
    }
    
    func inputCellInit(inputMode:String, isHidden:Bool=true, idxLabel:String, iaLabel:String, iiLabel:String, sectionId:Int, itemId:Int, dfDesc:String="",dfQty:String="", criticalQty:String="", majorQty:String="", minorQty:String="", inspItem:AnyObject) ->AnyObject {
        
        switch inputMode {
        case _INPUTMODE01:
            weak var inputCell = InputMode01DefectCellView.loadFromNibNamed("InputMode01DefectCell")
            
            inputCell?.pVC = self
            inputCell?.inspItem = inspItem as? InputMode01CellView
            inputCell?.dismissDescButton.hidden = isHidden
            inputCell?.indexLabel.text = idxLabel
            inputCell?.iiInput.text = iiLabel
            inputCell?.sectionId = sectionId
            inputCell?.itemId = itemId
            inputCell?.cellIdx = self.defectCells.count
            inputCell?.inputMode = _INPUTMODE01
            inputCell?.idInput.text = dfDesc
            inputCell?.dfQtyInput.text = dfQty
            inputCell?.frame = CGRectMake(CGFloat(0), CGFloat(0), CGFloat(768), CGFloat(225))
            
            return inputCell!
        case _INPUTMODE02:
            weak var inputCell = InputMode02DefectCellView.loadFromNibNamed("InputMode02DefectCell")
            
            inputCell?.pVC = self
            inputCell?.inspItem = inspItem as? InputMode02CellView
            inputCell?.indexLabel.text = idxLabel
            inputCell?.dpInput.text = iaLabel
            inputCell?.dppInput.text = iiLabel
            inputCell?.sectionId = sectionId
            inputCell?.itemId = itemId
            inputCell?.cellIdx = self.defectCells.count
            inputCell?.inputMode = _INPUTMODE02
            inputCell?.dfDescInput.text = dfDesc
            inputCell?.totalInput.text = dfQty
            inputCell?.criticalInput.text = criticalQty
            inputCell?.majorInput.text = majorQty
            inputCell?.minorInput.text = minorQty
            inputCell?.frame = CGRectMake(CGFloat(0), CGFloat(0), CGFloat(768), CGFloat(225))
            
            return inputCell!
        case _INPUTMODE03:
            weak var inputCell = InputMode03DefectCellView.loadFromNibNamed("InputMode03DefectCell")
            
            inputCell?.pVC = self
            inputCell?.inspItem = inspItem as? InputMode03CellView
            inputCell?.indexLabel.text = idxLabel
            inputCell?.icInput.text = iaLabel
            inputCell?.iiInput.text = iiLabel
            inputCell?.sectionId = sectionId
            inputCell?.itemId = itemId
            inputCell?.cellIdx = self.defectCells.count
            inputCell?.inputMode = _INPUTMODE03
            inputCell?.ddInput.text = dfDesc
            inputCell?.dfQtyInput.text = dfQty
            inputCell?.frame = CGRectMake(CGFloat(0), CGFloat(0), CGFloat(768), CGFloat(225))
            
            return inputCell!
        case _INPUTMODE04:
            weak var inputCell = InputMode04DefectCellView.loadFromNibNamed("InputMode04DefectCell")
            
            inputCell?.pVC = self
            inputCell?.inspItem = inspItem as? InputMode04CellView
            inputCell?.dismissDescButton.hidden = isHidden
            inputCell?.indexLabel.text = idxLabel
            inputCell?.iaInput.text = iaLabel
            inputCell?.iiInput.text = iiLabel
            inputCell?.sectionId = sectionId
            inputCell?.itemId = itemId
            inputCell?.cellIdx = self.defectCells.count
            inputCell?.inputMode = _INPUTMODE04
            inputCell?.dfdescInput.text = dfDesc
            inputCell?.dfQtyInput.text = dfQty
            inputCell?.frame = CGRectMake(CGFloat(0), CGFloat(0), CGFloat(768), CGFloat(225))
            
            return inputCell!
        default:return false
        }
    }
    
    func setCellStyle(cellObj:UIView, index:Int, level:Int, idx:Int) {
        let cellOffset = (level-index-1)*cellHeight2 + (index+1)*sectionHeight
        cellObj.frame = CGRect.init(x: 0, y: cellOffset, width: cellWidth, height: cellHeight)
        
        setBackgroundColor(cellObj,idx: idx)
    }
    
    func setBackgroundColor(inputCellObj:UIView,idx:Int) {
        if idx%2 == 0 {
            inputCellObj.backgroundColor = _TABLECELL_BG_COLOR1
        }else{
            inputCellObj.backgroundColor = _TABLECELL_BG_COLOR2
        }
    }
    
    func getIdxLabel(itemId:Int, sectionId:Int) ->String {
        let result = self.defectItems.filter({$0.inspElmt.cellIdx == itemId && $0.inspElmt.cellCatIdx == sectionId})
        
        return String(result.count)
    }
    
    func addDefectCellWithSection(inputMode:String, idxLabel:String, iaLabel:String, iiLabel:String, sectionId:Int, itemId:Int, inspItem:AnyObject, cellIdx:Int = 0) {
        print("add defect cell with section")
        
        let newDfItem = TaskInspDefectDataRecord(taskId: (Cache_Task_On?.taskId)!, inspectRecordId: (inspItem as! InputModeICMaster).taskInspDataRecordId, refRecordId: 0, inspectElementId: (inspItem as! InputModeICMaster).elementDbId, defectDesc: "", defectQtyCritical: 0, defectQtyMajor: 0, defectQtyMinor: 0, defectQtyTotal: 0, createUser: Cache_Inspector?.appUserName, createDate: self.view.getCurrentDateTime(), modifyUser: Cache_Inspector?.appUserName, modifyDate: self.view.getCurrentDateTime())
        
        newDfItem?.inputMode = inputMode
        newDfItem?.inspElmt = inspItem as! InputModeICMaster
        newDfItem?.sectObj = SectObj(sectionId:sectionId, sectionNameEn: (inspItem as! InputModeICMaster).cellCatName, sectionNameCn: (inspItem as! InputModeICMaster).cellCatName,inputMode: inputMode)
        newDfItem?.elmtObj = ElmtObj(elementId:itemId,elementNameEn:"", elementNameCn:"", reqElmtFlag: 0)
        newDfItem?.cellIdx = cellIdx
        newDfItem?.sortNum = (newDfItem?.inspElmt.cellCatIdx)!*1000000 + (newDfItem?.inspElmt.cellIdx)!*1000 + cellIdx
        newDfItem?.photoNames = [String]()
        
        Cache_Task_On?.defectItems.append(newDfItem!)
        
        updateContentView()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {

    }
    
    @IBAction func backButtonOnClick(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func saveButtonOnClick(sender: UIBarButtonItem) {
        
    }
    
    func duplicate(view: AnyObject) ->AnyObject{
        let temArchive = NSKeyedArchiver.archivedDataWithRootObject(view)
        let imageview = NSKeyedUnarchiver.unarchiveObjectWithData(temArchive)
        return imageview!
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return (Cache_Task_On?.defectItems.count)!
        return self.defectItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let defectItem = Cache_Task_On?.defectItems[indexPath.row]
        let defectItem = self.defectItems[indexPath.row]
        
        if defectItem.inputMode! == _INPUTMODE04 {
            
            let cellMode4 = tableView.dequeueReusableCellWithIdentifier("DefectCell", forIndexPath: indexPath) as! DefectListTableViewCell
            
            cellMode4.pVC = self
            cellMode4.sectionName.text = defectItem.inspElmt.cellCatName
            cellMode4.taskDefectDataRecordId = defectItem.recordId!
            cellMode4.inspItem = defectItem.inspElmt as? InputMode04CellView
            cellMode4.iaInput.text = defectItem.inspElmt.inspAreaText
            cellMode4.iiInput.text = defectItem.inspElmt.inspItemText
            cellMode4.sectionId = defectItem.inspElmt.cellCatIdx
            cellMode4.itemId = defectItem.inspElmt.cellIdx
            cellMode4.cellIdx = defectItem.cellIdx
            cellMode4.indexLabel.text = "\(defectItem.inspElmt.cellIdx).\(defectItem.cellIdx)"
            cellMode4.inputMode = _INPUTMODE04
            cellMode4.dfDescInput.text = defectItem.defectDesc!
            cellMode4.dfQtyInput.text = defectItem.defectQtyTotal < 1 ? "" : String(defectItem.defectQtyTotal)
            cellMode4.defectPhoto1.image = nil
            cellMode4.defectPhoto2.image = nil
            cellMode4.defectPhoto3.image = nil
            cellMode4.defectPhoto4.image = nil
            cellMode4.defectPhoto5.image = nil
            cellMode4.dismissPhotoButton1.hidden = true
            cellMode4.dismissPhotoButton2.hidden = true
            cellMode4.dismissPhotoButton3.hidden = true
            cellMode4.dismissPhotoButton4.hidden = true
            cellMode4.dismissPhotoButton5.hidden = true
            
            self.view.disableFuns(cellMode4.dismissPhotoButton1)
            self.view.disableFuns(cellMode4.dismissPhotoButton2)
            self.view.disableFuns(cellMode4.dismissPhotoButton3)
            self.view.disableFuns(cellMode4.dismissPhotoButton4)
            self.view.disableFuns(cellMode4.dismissPhotoButton5)
            self.view.disableFuns(cellMode4.addDefectPhotoButton)
            
            if defectItem.photoNames != nil && defectItem.photoNames?.count > 0 {
                
                var idx = 0
                cellMode4.photoNameAtIndex = ["","","","",""]
                for photoName in defectItem.photoNames! {
         
                    if photoName != "" && idx < 5 {
                        
                        let pathForImage = Cache_Task_Path! + "/" + _THUMBSPHYSICALNAME + "/" + photoName
                        let image = UIImage(contentsOfFile: pathForImage)
                        cellMode4.photoNameAtIndex[idx] = photoName
                        idx += 1
                        
                        if cellMode4.defectPhoto1.image == nil {
                            cellMode4.defectPhoto1.image = image
                            cellMode4.dismissPhotoButton1.hidden = false
                            
                        }else if cellMode4.defectPhoto2.image == nil {
                            cellMode4.defectPhoto2.image = image
                            cellMode4.dismissPhotoButton2.hidden = false
                            
                        }else if cellMode4.defectPhoto3.image == nil {
                            cellMode4.defectPhoto3.image = image
                            cellMode4.dismissPhotoButton3.hidden = false
                            
                        }else if cellMode4.defectPhoto4.image == nil {
                            cellMode4.defectPhoto4.image = image
                            cellMode4.dismissPhotoButton4.hidden = false
                            
                        }else if cellMode4.defectPhoto5.image == nil {
                            cellMode4.defectPhoto5.image = image
                            cellMode4.dismissPhotoButton5.hidden = false
                            
                        }
                    }
                }
            }
            
            if indexPath.row % 2 == 0 {
                cellMode4.backgroundColor = _TABLECELL_BG_COLOR2
            }else{
                cellMode4.backgroundColor = _TABLECELL_BG_COLOR1
            }
            
            return cellMode4
            
        }else /*if defectItem!.inputMode! == _INPUTMODE03*/ {
            let cellMode3 = tableView.dequeueReusableCellWithIdentifier("DefectCellMode3", forIndexPath: indexPath) as! DefectListTableViewCellMode3
            
            cellMode3.pVC = self
            cellMode3.sectionName.text = defectItem.inspElmt.cellCatName
            cellMode3.taskDefectDataRecordId = defectItem.recordId!
            cellMode3.inspItem = defectItem.inspElmt as? InputMode03CellView
            cellMode3.icInput.text = defectItem.inspElmt.inspReqCatText
            cellMode3.iiInput.text = defectItem.inspElmt.inspItemText
            cellMode3.sectionId = defectItem.inspElmt.cellCatIdx
            cellMode3.itemId = defectItem.inspElmt.cellIdx
            cellMode3.cellIdx = defectItem.cellIdx
            cellMode3.indexLabel.text = "\(defectItem.inspElmt.cellIdx).\(defectItem.cellIdx)"
            cellMode3.inputMode = _INPUTMODE03
            cellMode3.ddInput.text = defectItem.defectDesc!
            cellMode3.dfQtyInput.text = defectItem.defectQtyTotal < 1 ? "" : String(defectItem.defectQtyTotal)
            cellMode3.defectPhoto1.image = nil
            cellMode3.defectPhoto2.image = nil
            cellMode3.defectPhoto3.image = nil
            cellMode3.defectPhoto4.image = nil
            cellMode3.defectPhoto5.image = nil
            cellMode3.dismissPhotoButton1.hidden = true
            cellMode3.dismissPhotoButton2.hidden = true
            cellMode3.dismissPhotoButton3.hidden = true
            cellMode3.dismissPhotoButton4.hidden = true
            cellMode3.dismissPhotoButton5.hidden = true
            
            self.view.disableFuns(cellMode3.dismissPhotoButton1)
            self.view.disableFuns(cellMode3.dismissPhotoButton2)
            self.view.disableFuns(cellMode3.dismissPhotoButton3)
            self.view.disableFuns(cellMode3.dismissPhotoButton4)
            self.view.disableFuns(cellMode3.dismissPhotoButton5)
            self.view.disableFuns(cellMode3.addDefectPhotoButton)
            
            if defectItem.photoNames != nil && defectItem.photoNames?.count > 0 {
                
                var idx = 0
                cellMode3.photoNameAtIndex = ["","","","",""]
                for photoName in defectItem.photoNames! {
                    
                    if photoName != "" && idx < 5 {
                        let pathForImage = Cache_Task_Path! + "/" + _THUMBSPHYSICALNAME + "/" + photoName
                        let image = UIImage(contentsOfFile: pathForImage)
                        cellMode3.photoNameAtIndex[idx] = photoName
                        idx += 1
                        
                        if cellMode3.defectPhoto1.image == nil {
                            cellMode3.defectPhoto1.image = image
                            cellMode3.dismissPhotoButton1.hidden = false
                            
                        }else if cellMode3.defectPhoto2.image == nil {
                            cellMode3.defectPhoto2.image = image
                            cellMode3.dismissPhotoButton2.hidden = false
                            
                        }else if cellMode3.defectPhoto3.image == nil {
                            cellMode3.defectPhoto3.image = image
                            cellMode3.dismissPhotoButton3.hidden = false
                            
                        }else if cellMode3.defectPhoto4.image == nil {
                            cellMode3.defectPhoto4.image = image
                            cellMode3.dismissPhotoButton4.hidden = false
                            
                        }else if cellMode3.defectPhoto5.image == nil {
                            cellMode3.defectPhoto5.image = image
                            cellMode3.dismissPhotoButton5.hidden = false
                            
                        }
                    }
                }
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
