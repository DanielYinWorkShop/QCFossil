//
//  DataSyncViewController.swift
//  QCFossil
//
//  Created by pacmobile on 12/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class DataSyncViewController: UIViewController, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate {
    
    @IBOutlet weak var loginUserLabel: UILabel!
    @IBOutlet weak var lastLoginDateLabel: UILabel!
    @IBOutlet weak var dataDownloadLabel: UILabel!
    @IBOutlet weak var masterDataLabel: UILabel!
    @IBOutlet weak var inspectSDLabel: UILabel!
    @IBOutlet weak var fgpoDataLabel: UILabel!
    @IBOutlet weak var taskBookingDataLabel: UILabel!
    @IBOutlet weak var lastDDateLabel: UILabel!
    @IBOutlet weak var dataUploadLabel: UILabel!
    @IBOutlet weak var taskResultDataLabel: UILabel!
    @IBOutlet weak var taskResultPhotoLabel: UILabel!
    @IBOutlet weak var lastUploadDateLabel: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var downloadProcessBar: UIProgressView!
    @IBOutlet weak var uploadProcessBar: UIProgressView!
    @IBOutlet weak var downloadProcessLabel: UILabel!
    @IBOutlet weak var uploadProcessLabel: UILabel!
    @IBOutlet weak var lastDownloadDatetime: UILabel!
    @IBOutlet weak var lastUploadDatetime: UILabel!
    @IBOutlet weak var masterDataProcessBar: UIProgressView!
    @IBOutlet weak var setupDataProcessBar: UIProgressView!
    @IBOutlet weak var fgpoDataProcessBar: UIProgressView!
    @IBOutlet weak var taskDataProcessBar: UIProgressView!
    @IBOutlet weak var inspectorName: UILabel!
    @IBOutlet weak var inspectorLastLoginDate: UILabel!
    @IBOutlet weak var taskResultDataProcessBar: UIProgressView!
    @IBOutlet weak var taskPhotoProcessBar: UIProgressView!
    @IBOutlet weak var mstrDataStatus: UILabel!
    @IBOutlet weak var inspSetupDataStatus: UILabel!
    @IBOutlet weak var fgpoDataStatus: UILabel!
    @IBOutlet weak var taskDataStatus: UILabel!
    @IBOutlet weak var taskUploadDataStatus: UILabel!
    @IBOutlet weak var taskPhotoUploadStatus: UILabel!
    @IBOutlet weak var deviceIdLabel: UILabel!
    @IBOutlet weak var taskStatusDataLabel: UILabel!
    @IBOutlet weak var taskStatusDataProcessBar: UIProgressView!
    @IBOutlet weak var taskStatusDataStatus: UILabel!
    @IBOutlet weak var lastUploadTasksLabel: UILabel!
    @IBOutlet weak var lastUploadTasksCount: UILabel!
    @IBOutlet weak var cleanTaskLabel: UILabel!
    @IBOutlet weak var cleanTaskProcessBar: UIProgressView!
    @IBOutlet weak var cleanTaskStatus: UILabel!
    @IBOutlet weak var stylePhotoLabel: UILabel!
    @IBOutlet weak var stylePhotoPrecessBar: UIProgressView!
    @IBOutlet weak var stylePhotoStatus: UILabel!
    @IBOutlet weak var stylePhotoCleanLabel: UILabel!
    @IBOutlet weak var stylePhotoCleanProcessBar: UIProgressView!
    @IBOutlet weak var stylePhotoCleanStatus: UILabel!
    
    
    var subCounter = 1
    var totalDLRecords:Int = 4
    var percentage:Float = 0
    var currentCounter = 1
    var totalULPhotos:Int = 0
    var currULPhotoIndex:Int = 0
    var failULPhotoCount:Int = 0
    
    //NSURLSession URL Request
    var bgSession: NSURLSession?
    var fgSession: NSURLSession?
    var sessionDownloadTask: NSURLSessionDownloadTask?
    var buffer:NSMutableData = NSMutableData()
    var expectedContentLength = 0
    var dsDataObj:AnyObject?
    var dataSet = [Dictionary<String, String>]()
    var taskStatusList = [[String:String]]()
    var stylePhotoDeletePaths = [String]()
    var actionType = 0 //0: Download Action 1: Upload Action
    var uploadPhotos = [Photo]()
    var _UPDATE_DB_DATA = false
    
    //for PO download only
    var ainit_service_session = ""
    var totalReqCnt = 0
    var downloadReqCnt = 0
    
    var cleanTaskCnt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //bgSession = backgroundSession
        //fgSession = defaultSession
        initSessionObj()
        
        
        // Do any additional setup after loading the view.
        updateLocalizedString()
    }
    
    func initSessionObj() {
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 300
        configuration.timeoutIntervalForResource = 300
        //configuration.sessionSendsLaunchEvents = true
        //configuration.discretionary = true
        
        fgSession = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.pacmobile.fossilqc")
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        configuration.sessionSendsLaunchEvents = true
        configuration.discretionary = true
        
        bgSession = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func resetSession() {
        
        //session = backgroundSession
        buffer = NSMutableData()
        dsDataObj = nil
        dataSet = [Dictionary<String, String>]()
        taskStatusList = [[String:String]]()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func updateLocalizedString(){
        self.navigationItem.leftBarButtonItem?.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("App Menu")
        self.loginUserLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Login User")
        self.dataDownloadLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Data Download")
        self.masterDataLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("-Master Data")
        self.inspectSDLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("-Inspection Setup Data")
        self.fgpoDataLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("-FGPO Data")
        self.taskBookingDataLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("-Task Booking Data")
        self.taskStatusDataLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("-Task Status Data")
        self.lastLoginDateLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Last Login Date")
        self.lastDDateLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Last Download")
        self.downloadBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Download"), forState: UIControlState.Normal )
        self.uploadBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Upload"), forState: UIControlState.Normal )
        
        self.dataUploadLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString ("Data Upload")
        self.taskResultDataLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString ("-Task Result Data")
        self.taskResultPhotoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString ("-Task Result Photo")
        
        self.lastUploadTasksLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString ("Last Uploaded Task Count")
        self.lastUploadDateLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Last Upload")
        self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Data Sync")
        self.cleanTaskLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString ("-Clean Task")
        self.stylePhotoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString ("-Style Photo")
        self.stylePhotoCleanLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString ("-Clean Style Photo")
        
        self.view.setButtonCornerRadius(self.downloadBtn)
        self.view.setButtonCornerRadius(self.uploadBtn)
        
        self.inspectorName.text = Cache_Inspector?.appUserName
        
        let keyValueDataHelper = KeyValueDataHelper()
        self.inspectorLastLoginDate.text = Cache_Inspector?.lastLoginDate
        self.lastDownloadDatetime.text = keyValueDataHelper.getLastDownloadDatetimeByUserId(String((Cache_Inspector?.inspectorId)!))
        self.lastUploadDatetime.text = keyValueDataHelper.getLastUploadDatetimeByUserId(String((Cache_Inspector?.inspectorId)!))
        self.lastUploadTasksCount.text = keyValueDataHelper.getLastUploadTasksCountByUserId(String((Cache_Inspector?.inspectorId)!))
        self.deviceIdLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Device ID:") + " \(UIDevice.currentDevice().identifierForVendor!.UUIDString)"
        
        self.downloadProcessBar.progress = 0.0
        self.uploadProcessBar.progress = 0.0
        self.masterDataProcessBar.progress = 0.0
        self.setupDataProcessBar.progress = 0.0
        self.fgpoDataProcessBar.progress = 0.0
        self.taskDataProcessBar.progress = 0.0
        self.taskResultDataProcessBar.progress = 0.0
        self.taskPhotoProcessBar.progress = 0.0
        self.taskStatusDataProcessBar.progress = 0.0
        self.cleanTaskProcessBar.progress = 0.0
        self.stylePhotoPrecessBar.progress = 0.0
        self.stylePhotoCleanProcessBar.progress = 0.0
        self.downloadProcessBar.hidden = true
        self.uploadProcessBar.hidden = true
        self.downloadProcessLabel.hidden = true
        self.uploadProcessLabel.hidden = true
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DataSyncViewController.updateDBData), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    func menuButton(sender: UIBarButtonItem) {
        NSLog("Toggle Menu")
        
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }
    
    @IBAction func downloadDataOnClick(sender: UIButton) {
        self.downloadProcessBar.hidden = true
        self.downloadProcessLabel.hidden = false
        
        self.actionType = 0
        self.currentCounter = 1
        self.totalDLRecords = 4
        self.percentage = 0
        
        self.downloadProcessBar.progress = 0.0
        self.uploadProcessBar.progress = 0.0
        self.masterDataProcessBar.progress = 0.0
        self.setupDataProcessBar.progress = 0.0
        self.fgpoDataProcessBar.progress = 0.0
        self.taskDataProcessBar.progress = 0.0
        self.taskStatusDataProcessBar.progress = 0.0
        self.cleanTaskProcessBar.progress = 0.0
        self.stylePhotoPrecessBar.progress = 0.0
        self.stylePhotoCleanProcessBar.progress = 0.0
        
        self.totalReqCnt = 0
        self.downloadReqCnt = 0
        self.ainit_service_session = ""
        
        _DS_RECORDS = [
            "_DS_MSTRDATA" : [String](),
            "_DS_INPTSETUP" : [String](),
            "_DS_FGPODATA" : [String](),
            "_DS_TASKDATA" : [String](),
            "_DS_DL_TASK_STATUS" : [String](),
            "_DS_DL_STYLE_PHOTO" : [String]()
        ]
        
        updateButtonStatus("Disable",btn: self.downloadBtn)
        updateDLProcessLabel("Send Request...")
        
        dataSet = [Dictionary<String, String>]()
        
        makeDLPostRequest(_DS_MSTRDATA)
        
        self.lastDownloadDatetime.text = self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm")
        let keyValueDataHelper = KeyValueDataHelper()
        keyValueDataHelper.updateLastDownloadDatetime(String((Cache_Inspector?.inspectorId)!), datetime: self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm"))
        
        NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":false])
    }
    
    func updateButtonStatus(status:String,btn:UIButton) {
        
        if status == "Enable" {
            dispatch_async(dispatch_get_main_queue(), {
                
                self.downloadBtn.enabled = true
                self.downloadBtn.backgroundColor = _FOSSILBLUECOLOR
                
                self.uploadBtn.enabled = true
                self.uploadBtn.backgroundColor = _FOSSILBLUECOLOR
                
                NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":true])
            })
            
            
        }else{
            dispatch_async(dispatch_get_main_queue(), {
                
                self.downloadBtn.enabled = false
                self.downloadBtn.backgroundColor = UIColor.grayColor()
                
                self.uploadBtn.enabled = false
                self.uploadBtn.backgroundColor = UIColor.grayColor()
                
                self.mstrDataStatus.text = ""
                self.inspSetupDataStatus.text = ""
                self.fgpoDataStatus.text = ""
                self.taskDataStatus.text = ""
                self.taskStatusDataStatus.text = ""
                self.cleanTaskStatus.text = ""
                self.stylePhotoStatus.text = ""
                self.stylePhotoCleanStatus.text = ""
            })
        }
    }
    
    func updateDLProcessLabel(text:String){
        dispatch_async(dispatch_get_main_queue(), {
            self.downloadProcessLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString(text)
        })
    }
    
    func updateULProcessLabel(text:String){
        dispatch_async(dispatch_get_main_queue(), {
            self.uploadProcessLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString(text)
        })
    }
    
    func updateULPhotoStatus(index:Int, total:Int, fail:Int=0){
        dispatch_async(dispatch_get_main_queue(), {
            self.taskPhotoUploadStatus.text = "\(index)/\(total)"
            
            if fail>0 {
                self.taskPhotoUploadStatus.text = "\(index)/\(total) \(fail) \(MylocalizedString.sharedLocalizeManager.getLocalizedString("fail"))"
            }
            
            self.lastUploadDatetime.text = self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm")
            self.lastUploadTasksCount.text = String(_DS_UPLOADEDTASKCOUNT)
        })
    }
    
    func makeULRequest(dsDataMstr:AnyObject,Service_Session:String) {
        
        makeULPostRequest(dsDataMstr)
        
        if "Master Data Download" == self.dsDataObj!["NAME"] as! String {
            self.makeULPostRequest(_DS_INPTSETUP)
        }else if "Inspection Setup Data Download" == self.dsDataObj!["NAME"] as! String {
            self.makeULPostRequest(_DS_FGPODATA)
        }else if "FGPO Data Download" == self.dsDataObj!["NAME"] as! String {
            self.makeULPostRequest(_DS_TASKDATA)
        }else{
            dispatch_async(dispatch_get_main_queue(), {
                self.updateDLProcessLabel("Complete")
                self.updateButtonStatus("Enable",btn: self.downloadBtn)
                self.lastDownloadDatetime.text = self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm")
                
                let keyValueDataHelper = KeyValueDataHelper()
                keyValueDataHelper.updateLastDownloadDatetime(String((Cache_Inspector?.inspectorId)!), datetime: self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm"))
            })
        }
    }
    
    func processingDownloadData(apiName:String, jsonData:NSDictionary) {
        
        let dataSyncDataHelper = DataSyncDataHelper()
        let actionNames = self.dsDataObj!["ACTIONNAMES"] as! [String]
        let actionFields:Dictionary<String, [String]> = self.dsDataObj!["ACTIONFIELDS"] as! Dictionary
        let actionTables:Dictionary<String, String> = self.dsDataObj!["ACTIONTABLES"] as! Dictionary
        let ackName = self.dsDataObj!["ACKNAME"]
        dataSet = [Dictionary<String, String>]()
        
        if actionNames.count > 0 {
            for idx in 0...actionNames.count-1 {
                var dataObj = Dictionary<String, String>()
                dataObj["tableName"] = actionNames[idx]
                
                if let mstrData = jsonData[actionNames[idx]] as? [[String: AnyObject]] {
                    for data in mstrData {
                        for idx2 in 0...actionFields[actionNames[idx]]!.count-1 {
                            if let value = data[actionFields[actionNames[idx]]![idx2]] as? String {
                                dataObj[actionFields[actionNames[idx]]![idx2]] = value
                            }
                        }
                        
                        dataSet.append(dataObj)
                    }
                    
                }else if let mstrData = jsonData[actionNames[idx]] as? [String: AnyObject] {
                    for (key, value) in mstrData {
                        
                        dataObj[key] = value as? String
                    }
                    
                    dataSet.append(dataObj)
                }
            }
        }
        
        //updateDLProcessLabel("Processing Data...")
        
        var recCountInTable = Dictionary<String, Int>()
        var currActTable = ""
        var currCount = 1
        let clearBeforeUpdateTables = ["inspect_task_tmpl_field","inspect_task_tmpl_section","inspect_task_tmpl_position","inspect_task_field_select_val","inspect_section_element","inspect_position_element","inspect_element_detail_select_val","result_set_value"]
        
        dataSet = dataSet.reverse()
        while let data = dataSet.popLast() {
            //outerloop: for data in dataSet {
            
            if currActTable != actionTables[data["tableName"]!]! {
                currCount = 1
            }
            
            currActTable = actionTables[data["tableName"]!]!
            
            //Below Table Need to Delete Exsiting Records
            if apiName == "_DS_INPTSETUP" && clearBeforeUpdateTables.contains(currActTable) {
                
                var dbAction = ""
                if (data[actionFields[data["tableName"]!]![0]] != nil) {
                    
                    dbAction = "DELETE FROM \(currActTable) WHERE \(actionFields[data["tableName"]!]![0]) = \(data[actionFields[data["tableName"]!]![0]]!)"
                }
                let filterResult = _DS_RECORDS[apiName]?.filter({ $0 == dbAction })
                
                if filterResult?.count < 1 {
                    _DS_RECORDS[apiName]!.append("\(dbAction)")
                }
            }
            
            
            var dbFields = ""
            var dbValues = ""
            //-------------------------
            var poLineNeedInsert = true
            var poItemId = ""
            var refTaskIdInTaskStatus = ""
            var dbActionForTaskStatus = ""
            var taskStatusFromServer = ""
            var refTaskIdInTaskBookingData = ""
            
            for idx in 0...actionFields[data["tableName"]!]!.count-1 {
                
                if var value = data[actionFields[data["tableName"]!]![idx]] {
                    value = value.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")
                    
                    if apiName == "_DS_TASKDATA" && actionFields[data["tableName"]!]![idx] == "ref_task_id" && data["tableName"] != "inspect_task_qc_info_list" {
                        
                        refTaskIdInTaskBookingData = value
                        dbFields += "task_id"
                        dbValues += "(SELECT task_id FROM inspect_task WHERE ref_task_id = \(value))"
                        
                        if data["tableName"]! == "inspect_task_list" {
                            dbFields += ","+actionFields[data["tableName"]!]![idx]
                            dbValues += ",\"\(value)\""
                        }
                    }else if apiName == "_DS_DL_TASK_STATUS" && actionFields[data["tableName"]!]![idx] == "ref_task_id" {
                        
                        refTaskIdInTaskStatus = value
                        
                    }else if apiName == "_DS_DL_TASK_STATUS" {
                        
                        if actionFields[data["tableName"]!]![idx] != "task_id" {
                            dbActionForTaskStatus += "\(actionFields[data["tableName"]!]![idx])=\"\(value)\","
                        }
                        
                        if actionFields[data["tableName"]!]![idx] == "task_status" {
                            taskStatusFromServer = value
                        }
                        
                    }else if apiName == "_DS_MSTRDATA" && actionFields[data["tableName"]!]![idx] == "vdr_sign_name" {
                        
                        for sIdx in 0...actionFields[data["tableName"]!]!.count-1 {
                            if actionFields[data["tableName"]!]![sIdx] == "location_id" {
                                let locationId = data[actionFields[data["tableName"]!]![sIdx]]!
                                
                                dbFields += "\(actionFields[data["tableName"]!]![idx])"
                                dbValues += " CASE WHEN ((SELECT vdr_sign_name FROM vdr_location_mstr WHERE location_id = \(locationId))  == '' OR (SELECT vdr_sign_name FROM vdr_location_mstr WHERE location_id = \(locationId)) IS NULL) THEN \"\(value)\" ELSE  (SELECT vdr_sign_name FROM vdr_location_mstr WHERE location_id = \(locationId)) END "
                            }
                        }
                        
                    }else if apiName == "_DS_DL_STYLE_PHOTO" && actionFields[data["tableName"]!]![idx] == "ss_photo_file" {
                    
                        for sIdx in 0...actionFields[data["tableName"]!]!.count-1 {
                            if actionFields[data["tableName"]!]![sIdx] == "ss_photo_name" {
                                let imageName = data[actionFields[data["tableName"]!]![sIdx]]!
                                
                                if value == "" && imageName != "" {
                                    
                                    // Add to delete list
                                    let photoPath = Cache_Inspector?.typeCode == TypeCode.WATCH.rawValue ? _WATCHSSPHOTOSPHYSICALPATH : _JEWELRYSSPHOTOSPHYSICALPATH
                                    self.stylePhotoDeletePaths.append(photoPath + imageName)
                                    
                                } else if value != "" {
                                
                                    //Save images to physical local storage
                                    let savePath = Cache_Inspector?.typeCode == TypeCode.WATCH.rawValue ? _WATCHSSPHOTOSPHYSICALPATH : _JEWELRYSSPHOTOSPHYSICALPATH
                                    UIImage().saveImageToLocal(savePath, image: UIImage().fromBase64(value), imageName: imageName)
                                }
                                break
                            }
                        }
                        
                    }else if apiName == "_DS_DL_STYLE_PHOTO" && actionFields[data["tableName"]!]![idx] == "cb_photo_file" {
                        
                        for sIdx in 0...actionFields[data["tableName"]!]!.count-1 {
                            if actionFields[data["tableName"]!]![sIdx] == "cb_photo_name" {
                                let imageName = data[actionFields[data["tableName"]!]![sIdx]]!
                                
                                if value == "" && imageName != "" {
                                    
                                    // Add to delete list
                                    self.stylePhotoDeletePaths.append(_CASEBACKPHOTOSPHYSICALPATH + imageName)
                                    
                                } else if value != "" {
                                
                                    //Save images to physical local storage
                                    UIImage().saveImageToLocal(_CASEBACKPHOTOSPHYSICALPATH, image: UIImage().fromBase64(value), imageName: imageName)
                                }
                                break
                            }
                        }
                        
                    }else{
                        dbFields += actionFields[data["tableName"]!]![idx]
                        dbValues += "\"\(value)\""
                    }
                    
                    if idx < actionFields[data["tableName"]!]!.count-1 && actionFields[data["tableName"]!]![idx] != "ss_photo_file" && actionFields[data["tableName"]!]![idx] != "cb_photo_file" {
                        dbFields += ","
                        dbValues += ","
                    }
                    
                    // extra special considering on fields
                    if apiName == "_DS_FGPODATA" && actionFields[data["tableName"]!]![idx] == "app_ready_purge_date" && value != "" {
                        poLineNeedInsert = false
                        
                    }else if apiName == "_DS_FGPODATA" && actionFields[data["tableName"]!]![idx] == "item_id" {
                        poItemId = value
                        
                    }
                }
            }
            
            dbActionForTaskStatus += "]!@#$*&^"
            dbActionForTaskStatus = dbActionForTaskStatus.stringByReplacingOccurrencesOfString(",]!@#$*&^", withString: "")
            
            var dbAction = ""
            if apiName == "_DS_DL_TASK_STATUS" {
                
                dbAction = "UPDATE \(actionTables[data["tableName"]!]!) SET \(dbActionForTaskStatus) WHERE ref_task_id = \(refTaskIdInTaskStatus) AND task_status <> \(taskStatusFromServer)"
                
            }else if apiName == "_DS_FGPODATA" {
                
                if poLineNeedInsert {
                    dbAction = "INSERT OR REPLACE INTO \(actionTables[data["tableName"]!]!)"
                    dbAction += "(\(dbFields)) VALUES (\(dbValues))"
                    
                }else{
                    dbAction = "INSERT OR REPLACE INTO \(actionTables[data["tableName"]!]!) (\(dbFields)) SELECT \(dbValues) WHERE EXISTS (SELECT po_item_id FROM inspect_task_item WHERE po_item_id = \(poItemId))"
                    
                }
                
            }
            else if apiName == "_DS_TASKDATA" {
                
                dbAction = "INSERT OR REPLACE INTO \(actionTables[data["tableName"]!]!) (\(dbFields))"
                
                // Skip to update inspect_task, inspect_task_inspector and inspect_task_item if task status is not pending anymore
                if actionTables[data["tableName"]!] == "inspect_task" || actionTables[data["tableName"]!] == "inspect_task_inspector" || actionTables[data["tableName"]!] == "inspect_task_item" {
                    dbAction += " SELECT \(dbValues) WHERE (NOT EXISTS (SELECT * FROM inspect_task WHERE ref_task_id = \(refTaskIdInTaskBookingData)) OR EXISTS (SELECT * FROM inspect_task WHERE ref_task_id = \(refTaskIdInTaskBookingData) AND task_status = \(GetTaskStatusId(caseId: "Pending").rawValue)))"
                
                } else {
                    dbAction += " VALUES (\(dbValues))"
                }
            
            } else{
                dbAction = "INSERT OR REPLACE INTO \(actionTables[data["tableName"]!]!)"
                dbAction += "(\(dbFields)) VALUES (\(dbValues))"
                
            }
            
            recCountInTable[actionTables[data["tableName"]!]!+"_count"] = currCount
            currCount += 1
            
             if apiName == "_DS_DL_TASK_STATUS" {
                print("action: \(dbAction)")
             }
            
            _DS_RECORDS[apiName]!.append("\(dbAction)")
            
        }
        
        if self.dsDataObj!["NAME"] as! String == "FGPO Data Download" {
            /*if self.downloadReqCnt < 1 {
                self.updateProgressBar(0.6)
            }
            */
        }else{
            self.updateProgressBar(0.6)
            //sleep(1)
        }
        
        if apiName == "_DS_FGPODATA" {
            let totalReqCnt = Int("\(jsonData["total_req_cnt"]!)")
            let downloadReqCnt = Int("\(jsonData["download_req_cnt"]!)")
            
            #if DEBUG
            print("total: \(totalReqCnt), download: \(downloadReqCnt)")
            #endif
            
            self.totalReqCnt = totalReqCnt!
            self.downloadReqCnt = downloadReqCnt!
            
            if totalReqCnt > downloadReqCnt {
                
                let progress = 30+(Float(downloadReqCnt!) / Float(totalReqCnt!))*30
                print("progress: \(progress*0.01)")
                self.updateProgressBar(progress*0.01)
                
                recCountInTable["service_session"] = Int(_DS_SESSION)
                self.makeULACKPostRequest(ackName, coutDic: recCountInTable)
                return
                
            }else{
                self.updateProgressBar(0.6)
                //sleep(1)
            }
            
        }
        
        dataSyncDataHelper.updateTableRecordsByScript(self, apiName: apiName, sqlScript: _DS_RECORDS[apiName]!, handler: { result in
            if result {
                self.updateDLProcessLabel("Sending \(apiName) Acknowledgement...")
                
                recCountInTable["service_session"] = Int(_DS_SESSION)
                self.updateProgressBar(0.8)
                //sleep(1)
            
                if apiName == "_DS_FGPODATA" {
                    //sleep(1)
                    print("PO Download 0.8")
                }else{
                    //sleep(1)
                }
            
                self.makeULACKPostRequest(ackName, coutDic: recCountInTable)
            } else {
                self.updateButtonStatus("Enable",btn: self.downloadBtn)
                self.updateButtonStatus("Enable",btn: self.uploadBtn)
                
                
                
                self.updateDLProcessLabel("\(self.getCurrentPODataTitle(apiName)) \(MylocalizedString.sharedLocalizeManager.getLocalizedString("cannot be imported due to Error Occurred"))")
            }
        })
    }
    
    func getCurrentPODataTitle(apiName:String) ->String {
        switch apiName {
            case "_DS_MSTRDATA":
                return MylocalizedString.sharedLocalizeManager.getLocalizedString("Master Data")
            case "_DS_INPTSETUP":
                return MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Setup Data")
            case "_DS_FGPODATA":
                return MylocalizedString.sharedLocalizeManager.getLocalizedString("FGPO Data")
            case "_DS_TASKDATA":
                return MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Booking Data")
            case "_DS_DL_TASK_STATUS":
                return MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Status Data")
            case "_DS_DL_STYLE_PHOTO":
                return MylocalizedString.sharedLocalizeManager.getLocalizedString("Style Photo")
            default:return ""
        }
    }
    
    func createUploadData() ->String {
        //var uploadData = "\(_DS_PREFIX){"
        var uploadData = "{"
        uploadData += "\"service_token\" : \"\(_DS_SERVICETOKEN)\","
        uploadData += "\"device_id\" : \"\(UIDevice.currentDevice().identifierForVendor!.UUIDString)\","
        uploadData += "\"service_type\" : \"Task Result Data Upload\","
        
        let dataSyncDataHelper = DataSyncDataHelper()
        let taskDataObj = _DS_ULTASKDATA
        
        //1. Construct Task Data from inspect_task_list
        let taskFields = taskDataObj["ACTIONFIELDS"]!["inspect_task_list"] as! Dictionary<String, String>
        let tasks = dataSyncDataHelper.getAllInspectTasks(taskFields)
        
        var recordsCount = 0
        var tasklist = "["
        for task in tasks {
            
            var data = "{"
            for (key, value) in task {
                
                if key == "inspector_sign_image_file" || key == "vdr_sign_image_file" {
                    data += "\"\(key)\":\"\(value)\","
                }else{
                    data += "\"\(key)\":\"\(value.urlEncode!)\","
                }
            }
            data += "},"
            
            tasklist += data
            recordsCount += 1
        }
        //Get the tasks count for the last data upload
        _DS_UPLOADEDTASKCOUNT = recordsCount
        
        tasklist += "]"
        tasklist = tasklist.stringByReplacingOccurrencesOfString(",}", withString: "}")
        tasklist = tasklist.stringByReplacingOccurrencesOfString(",]", withString: "]")
        
        uploadData += "\"inspect_task_list\":\(tasklist),"
        
        _DS_TOTALRECORDS_DB["inspect_task_count"] = String(recordsCount)
        recordsCount = 0
        
        
        //2. Construct Task Inspector from inspect_task_inspector_list
        let taskInspectorFields = taskDataObj["ACTIONFIELDS"]!["inspect_task_inspector_list"] as! Dictionary<String, String>
        let taskInspectors = dataSyncDataHelper.getAllInspectTaskInspectors(taskInspectorFields)
        
        var taskInspectorlist = "["
        for taskInspector in taskInspectors {
            
            var data = "{"
            for (key, value) in taskInspector {
                data += "\"\(key)\":\"\(value.urlEncode!)\","
            }
            data += "},"
            
            taskInspectorlist += data
            
            recordsCount += 1
        }
        
        taskInspectorlist += "]"
        taskInspectorlist = taskInspectorlist.stringByReplacingOccurrencesOfString(",}", withString: "}")
        taskInspectorlist = taskInspectorlist.stringByReplacingOccurrencesOfString(",]", withString: "]")
        
        uploadData += "\"inspect_task_inspector_list\":\(taskInspectorlist),"
        _DS_TOTALRECORDS_DB["inspect_task_inspector_count"] = String(recordsCount)
        recordsCount = 0
        
        //3. Construct Task Inspector from inspect_task_item_list
        let taskItemFields = taskDataObj["ACTIONFIELDS"]!["inspect_task_item_list"] as! Dictionary<String, String>
        let taskItems = dataSyncDataHelper.getAllInspectTaskItems(taskItemFields)
        
        var taskItemlist = "["
        for taskItem in taskItems {
            
            var data = "{"
            for (key, value) in taskItem {
                data += "\"\(key)\":\"\(value.urlEncode!)\","
            }
            data += "},"
            
            taskItemlist += data
            
            recordsCount += 1
        }
        
        taskItemlist += "]"
        taskItemlist = taskItemlist.stringByReplacingOccurrencesOfString(",}", withString: "}")
        taskItemlist = taskItemlist.stringByReplacingOccurrencesOfString(",]", withString: "]")
        
        uploadData += "\"inspect_task_item_list\":\(taskItemlist),"
        _DS_TOTALRECORDS_DB["inspect_task_item_count"] = String(recordsCount)
        recordsCount = 0
        
        
        //4. Construct Task Inspect Field Value from task_inspect_field_value_list
        let taskIFVFields = taskDataObj["ACTIONFIELDS"]!["task_inspect_field_value_list"] as! Dictionary<String, String>
        let taskIFVs = dataSyncDataHelper.getAllInspectTaskIFVs(taskIFVFields)
        
        var taskIFVlist = "["
        for taskIFV in taskIFVs {
            
            var data = "{"
            for (key, value) in taskIFV {
                data += "\"\(key)\":\"\(value.urlEncode!)\","
            }
            data += "},"
            
            taskIFVlist += data
            
            recordsCount += 1
        }
        
        taskIFVlist += "]"
        taskIFVlist = taskIFVlist.stringByReplacingOccurrencesOfString(",}", withString: "}")
        taskIFVlist = taskIFVlist.stringByReplacingOccurrencesOfString(",]", withString: "]")
        
        uploadData += "\"task_inspect_field_value_list\":\(taskIFVlist),"
        _DS_TOTALRECORDS_DB["task_inspect_field_value_count"] = String(recordsCount)
        recordsCount = 0
        
        
        //5. Construct Task Inspect Data Record from task_inspect_data_record_list
        let taskIDRFields = taskDataObj["ACTIONFIELDS"]!["task_inspect_data_record_list"] as! Dictionary<String, String>
        let taskIDRs = dataSyncDataHelper.getAllInspectTaskIDRs(taskIDRFields)
        
        var taskIDRlist = "["
        for taskIDR in taskIDRs {
            
            var data = "{"
            for (key, value) in taskIDR {
                data += "\"\(key)\":\"\(value.urlEncode!)\","
            }
            data += "},"
            
            taskIDRlist += data
            
            recordsCount += 1
        }
        
        taskIDRlist += "]"
        taskIDRlist = taskIDRlist.stringByReplacingOccurrencesOfString(",}", withString: "}")
        taskIDRlist = taskIDRlist.stringByReplacingOccurrencesOfString(",]", withString: "]")
        
        uploadData += "\"task_inspect_data_record_list\":\(taskIDRlist),"
        _DS_TOTALRECORDS_DB["task_inspect_data_record_count"] = String(recordsCount)
        recordsCount = 0
        
        print("upload Data: \(taskIDRlist)")
        
        //6. Construct Task Inspect Data Record from task_inspect_position_point_list
        let taskIPPFields = taskDataObj["ACTIONFIELDS"]!["task_inspect_position_point_list"] as! Dictionary<String, String>
        let taskIPPs = dataSyncDataHelper.getAllInspectTaskIPPs(taskIPPFields)
        
        var taskIPPlist = "["
        for taskIPP in taskIPPs {
            
            var data = "{"
            for (key, value) in taskIPP {
                data += "\"\(key)\":\"\(value.urlEncode!)\","
            }
            data += "},"
            
            taskIPPlist += data
            
            recordsCount += 1
        }
        
        taskIPPlist += "]"
        taskIPPlist = taskIPPlist.stringByReplacingOccurrencesOfString(",}", withString: "}")
        taskIPPlist = taskIPPlist.stringByReplacingOccurrencesOfString(",]", withString: "]")
        
        uploadData += "\"task_inspect_position_point_list\":\(taskIPPlist),"
        _DS_TOTALRECORDS_DB["task_inspect_position_point_count"] = String(recordsCount)
        recordsCount = 0
        
        
        //7. Construct Task Defect Data Record from task_defect_data_record_list
        let taskDDRFields = taskDataObj["ACTIONFIELDS"]!["task_defect_data_record_list"] as! Dictionary<String, String>
        let taskDDRs = dataSyncDataHelper.getAllInspectTaskDDRs(taskDDRFields)
        
        var taskDDRlist = "["
        for taskDDR in taskDDRs {
            
            var data = "{"
            for (key, value) in taskDDR {
                data += "\"\(key)\":\"\(value.urlEncode!)\","
            }
            data += "},"
            
            taskDDRlist += data
            
            recordsCount += 1
        }
        
        taskDDRlist += "]"
        taskDDRlist = taskDDRlist.stringByReplacingOccurrencesOfString(",}", withString: "}")
        taskDDRlist = taskDDRlist.stringByReplacingOccurrencesOfString(",]", withString: "]")
        
        uploadData += "\"task_defect_data_record_list\":\(taskDDRlist),"
        _DS_TOTALRECORDS_DB["task_defect_data_record_count"] = String(recordsCount)
        recordsCount = 0
        
        
        //8. Construct Task Defect Data Record from task_inspect_photo_file_list
        let taskIPFFields = taskDataObj["ACTIONFIELDS"]!["task_inspect_photo_file_list"] as! Dictionary<String, String>
        let taskIPFs = dataSyncDataHelper.getAllInspectTaskIPFs(taskIPFFields)
        
        var taskIPFlist = "["
        for taskIPF in taskIPFs {
            
            var data = "{"
            for (key, value) in taskIPF {
                data += "\"\(key)\":\"\(value.urlEncode!)\","
            }
            data += "},"
            
            taskIPFlist += data
            
            recordsCount += 1
        }
        
        taskIPFlist += "]"
        taskIPFlist = taskIPFlist.stringByReplacingOccurrencesOfString(",}", withString: "}")
        taskIPFlist = taskIPFlist.stringByReplacingOccurrencesOfString(",]", withString: "]")
        taskIPFlist = taskIPFlist.stringByReplacingOccurrencesOfString(">", withString: "")
        taskIPFlist = taskIPFlist.stringByReplacingOccurrencesOfString("<", withString: "")
        
        uploadData += "\"task_inspect_photo_file_list\":\(taskIPFlist)}"
        _DS_TOTALRECORDS_DB["task_inspect_photo_file_count"] = String(recordsCount)
        
        //print("upload Data: \(uploadData)")
        
        return uploadData
    }
    
    @IBAction func uploadDataOnClick(sender: UIButton) {
        
        self.uploadProcessLabel.hidden = false
        self.uploadProcessBar.progress = 0.0
        self.taskResultDataProcessBar.progress = 0.0
        self.taskPhotoProcessBar.progress = 0.0
        self.currULPhotoIndex = 0
        self.failULPhotoCount = 0
        self.actionType = 1 //Current Action is Upload
        
        self.updateButtonStatus("Disable",btn: self.uploadBtn)
        self.updateULProcessLabel("Sending Request...")
        self.buffer = NSMutableData()
        
        //session = backgroundSession
        makeULPostRequest(_DS_ULTASKDATA)
        
        self.lastUploadDatetime.text = self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm")
        let keyValueDataHelper = KeyValueDataHelper()
        keyValueDataHelper.updateLastUploadDatetime(String((Cache_Inspector?.inspectorId)!), datetime: self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm"))
        
        NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":false])
    }
    
    //-------------------------------------- upload photo ------------------------------------
    func createPhotoULRequest (photo:Photo) -> NSURLRequest {
        self.dsDataObj = _DS_ULTASKPHOTO
        
        let boundary = self.generateBoundaryString()
        
        let url = NSURL(string: "\(dataSyncServerUsing)ul_task_photo.aspx")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let dbDir = dirPaths[0] as String
        
        let photoFile = dbDir.stringByAppendingString("/\((Cache_Inspector?.appUserName?.lowercaseString)!)/Tasks/"+photo.taskBookingNo!+"/"+photo.photoFile)
        let thumbFile = dbDir.stringByAppendingString("/\((Cache_Inspector?.appUserName?.lowercaseString)!)/Tasks/"+photo.taskBookingNo!+"/Thumbs/"+photo.photoFile)
        
        let param = [
            "service_token"  : "\(_DS_SERVICETOKEN)",
            "device_id"    : "\(UIDevice.currentDevice().identifierForVendor!.UUIDString)",
            "task_id" : "\(photo.taskId)",
            "photo_id" : "\(photo.photoId!)",
            "photo_filename" : "\(photo.photoFilename)",
            "photo_file" : "\(photoFile)",
            "thumb_filename" : "\(photo.thumbFile!)",
            "thumb_file" : "\(thumbFile)"
        ]
        
        request.HTTPBody = createBodyWithParameters(param, boundary: boundary)
        
        return request
    }
    
    func createBodyWithParameters(parameters: [String: String]?, boundary: String) -> NSData {
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                if key != "photo_file" && key != "thumb_file" {
                    body.appendString("--\(boundary)\r\n")
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString("\(value)\r\n")
                }else{
                    
                    let url = NSURL(fileURLWithPath: value)
                    let filename = url.lastPathComponent
                    let data = NSData(contentsOfURL: url)
                    let mimetype = mimeTypeForPath(value)
                    
                    //print("filename: \(url), data: \(data?.length)")
                    
                    body.appendString("--\(boundary)\r\n")
                    body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename!)\"\r\n")
                    body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                    
                    if data != nil {
                        body.appendData(data!)
                    }else{
                        
                        body.appendData(NSData())
                        
                        return NSMutableData()
                    }
                    
                    body.appendString("\r\n")
                }
            }
        }
        
        body.appendString("--\(boundary)--\r\n")
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func mimeTypeForPath(path: String) -> String {
        return "image/jpg";
    }
    //------------------------------------- end upload photo --------------------------------------------
    func makeDLPostRequest(dsData:AnyObject) {
        updateDLProcessLabel("Sending Request...")
        
        let state = UIApplication.sharedApplication().applicationState
        
        if state == .Active {
            
            // foreground
            sessionDownloadTask = fgSession?.downloadTaskWithRequest(createDLRequest(dsData))
            sessionDownloadTask?.resume()
            
        }else{
            
            // background
            sessionDownloadTask = bgSession?.downloadTaskWithRequest(createDLRequest(dsData))
            sessionDownloadTask?.resume()
        }
    }
    
    func createDLRequest(dsData:AnyObject) -> NSURLRequest {
        self.dsDataObj = dsData
        
        var param = "\(_DS_PREFIX){"
        for (key, value) in dsData["APIPARA"] as! Dictionary<String,String> {
            if key == "service_token" {
                param += "\"\(key)\":\"\(_DS_SERVICETOKEN)\","
            }else if key == "init_service_session" {
                param += "\"\(key)\":\"\(self.ainit_service_session)\","
            }else{
                param += "\"\(key)\":\"\(value)\","
            }
        }
        param += "}"
        param = param.stringByReplacingOccurrencesOfString(",}", withString: "}")
        
        if self.dsDataObj!["NAME"] as! String == "FGPO Data Download" {
            if self.downloadReqCnt < 1 {
                self.updateProgressBar(0.10)
                ////sleep(1)
            }
            
        }else{
            self.updateProgressBar(0.10)
            ////sleep(1)
            
        }
        
        #if DEBUG
        print("Download Request: \(param)")
        #endif
            
        let request = NSMutableURLRequest(URL: NSURL(string: dsData["APINAME"] as! String)!)
        request.HTTPMethod = "POST"
        request.timeoutInterval = 300
        request.HTTPBody = param.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPShouldHandleCookies = false
        
        return request
    }
    
    func makeULACKPostRequest(dsData:AnyObject, coutDic:Dictionary<String,Int>) {
        
        let state = UIApplication.sharedApplication().applicationState
        
        if state == .Active {
            
            // foreground
            sessionDownloadTask = fgSession?.downloadTaskWithRequest(createULACKRequest(dsData, coutDic: coutDic))
            sessionDownloadTask?.resume()
            
        }else{
            
            // background
            sessionDownloadTask = bgSession?.downloadTaskWithRequest(createULACKRequest(dsData, coutDic: coutDic))
            sessionDownloadTask?.resume()
        }
    }
    
    func createULACKRequest(dsData:AnyObject, coutDic:Dictionary<String,Int>) -> NSURLRequest {
        self.dsDataObj = dsData
        
        var param = "\(_DS_PREFIX){"
        for (key, value) in dsData["APIPARA"] as! Dictionary<String,String> {
            if coutDic[key] != nil {
                param += "\"\(key)\":\"\(coutDic[key]!)\","
            }else{
                if key == "service_token" {
                    param += "\"\(key)\":\"\(_DS_SERVICETOKEN)\","
                }else{
                    param += "\"\(key)\":\"\(value)\","
                }
            }
        }
        param += "}"
        param = param.stringByReplacingOccurrencesOfString(",}", withString: "}")
        
        #if DEBUG
        print("param: \(param), Name: \(self.dsDataObj!["NAME"])")
        #endif
            
        if self.dsDataObj!["NAME"] as! String == "FGPO Data Download Acknowledgement" {
            if self.downloadReqCnt == self.totalReqCnt {
                self.updateProgressBar(0.9)
                //sleep(1)
                print("PO Download 0.9")
            }
            
        }else{
            self.updateProgressBar(0.9)
            //sleep(1)
        }
        
        #if DEBUG
        print("\(dsData["APINAME"] as! String) ACK Response: \(param)")
        #endif
        
        let request = NSMutableURLRequest(URL: NSURL(string: dsData["APINAME"] as! String)!)
        request.HTTPMethod = "POST"
        request.timeoutInterval = 300
        request.HTTPBody = param.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPShouldHandleCookies = false
        
        return request
    }
    
    func makeULPostRequest(dsData:AnyObject) {
        let state = UIApplication.sharedApplication().applicationState
        
        if state == .Active {
            
            // foreground
            sessionDownloadTask = fgSession?.downloadTaskWithRequest(createULRequest(dsData))
            sessionDownloadTask?.resume()
            
        }else{
            
            // background
            sessionDownloadTask = bgSession?.downloadTaskWithRequest(createULRequest(dsData))
            sessionDownloadTask?.resume()
        }
    }
    
    func createULRequest(dsData:AnyObject) -> NSURLRequest {
        self.dsDataObj = dsData
        
        let boundary = self.generateBoundaryString()
        let body = NSMutableData()
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"req_msg\"\r\n\r\n")
        body.appendString("\(createUploadData())\r\n")
        body.appendString("--\(boundary)--\r\n")
        
        if self.dsDataObj!["NAME"] as! String == "FGPO Data Download" {
            if self.downloadReqCnt < 1 {
                self.updateProgressBar(0.2)
            }
            
        }else{
            self.updateProgressBar(0.2)
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: dsData["APINAME"] as! String)!)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.timeoutInterval = 60
        request.HTTPBody = body
        request.HTTPShouldHandleCookies = false
        
        return request
    }
    
    //------------------------------------- Delegate Funcs --------------------------------------------------------
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("bytesSent: \(bytesSent) totalBytesSent: \(totalBytesSent) totalBytesExpectedToSend: \(totalBytesExpectedToSend)")
        
        if "Task Result Data Upload" == self.dsDataObj!["NAME"] as! String {
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                
                var percentageUploaded = 55 + (Float(totalBytesSent) / Float(totalBytesExpectedToSend))*5
                percentageUploaded = percentageUploaded*0.01
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.taskUploadDataStatus.text = "\(String(lroundf(100*percentageUploaded)))%"
                    self.taskResultDataProcessBar.progress = percentageUploaded
                })
            }
            
        }else if "Task Photo Data Upload" == self.dsDataObj!["NAME"] as! String {
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                let percentageUploaded = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.taskPhotoProcessBar.progress = percentageUploaded
                })
            }
            
        }else if (self.dsDataObj!["NAME"] as! String).containsString("Acknowledgement") {
            //dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                //let percentageUploaded = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
                
              //  dispatch_async(dispatch_get_main_queue(), {
                    /*if percentageUploaded > 0.99999 {
                        if self.dsDataObj!["NAME"] as! String == "FGPO Data Download Acknowledgement" {
                            if self.downloadReqCnt == self.totalReqCnt {
                                self.updateProgressBar(0.95)
                                //sleep(1)
                                print("PO Download 0.95")
                            }
                            
                        }else{
                            self.updateProgressBar(0.95)
                            //sleep(1)
                        }
                        
                        self.updateDLProcessLabel("Waiting Response...")
                    }*/
                    
                    if totalBytesSent == totalBytesExpectedToSend {
                        if self.dsDataObj!["NAME"] as! String == "FGPO Data Download Acknowledgement" {
                            if self.downloadReqCnt == self.totalReqCnt {
                                self.updateProgressBar(0.95)
                                sleep(1)
                                print("PO Download 0.95")
                            }
                            
                        }else{
                            self.updateProgressBar(0.95)
                            //sleep(1)
                        }
                        
                        self.updateDLProcessLabel("Waiting Response...")
                    }
               // })
            //}
            
        }else{
           // dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                //let percentageUploaded = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
                
             //   dispatch_async(dispatch_get_main_queue(), {
                    /*if percentageUploaded > 0.99999 {
                        if self.dsDataObj!["NAME"] as! String == "FGPO Data Download" {
                            if self.downloadReqCnt < 1 {
                                self.updateProgressBar(0.15)
                                //sleep(1)
                            }
                            
                        }else{
                            self.updateProgressBar(0.15)
                            //sleep(1)
                            
                        }
                        
                        self.updateDLProcessLabel("Waiting Response...")
                    }*/
                    
                    if totalBytesSent == totalBytesExpectedToSend {
                        if self.dsDataObj!["NAME"] as! String == "FGPO Data Download" {
                            if self.downloadReqCnt < 1 {
                                self.updateProgressBar(0.15)
                                //sleep(1)
                            }
                            
                        }else{
                            self.updateProgressBar(0.15)
                            //sleep(1)
                            
                        }
                        
                        self.updateDLProcessLabel("Waiting Response...")
                    }
               // })
            //}
            
        }
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        
        //here you can get full lenth of your content
        expectedContentLength = Int(response.expectedContentLength)
        
        #if DEBUG
        print("expectedContentLength: \(expectedContentLength)")
        #endif
        
        completionHandler(NSURLSessionResponseDisposition.Allow)
    }
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let completionHandler = appDelegate.backgroundSessionCompletionHandler {
            appDelegate.backgroundSessionCompletionHandler = nil
            completionHandler()
        }
        
        #if DEBUG
        print("All tasks are finished")
        #endif
    }
    
    func errorMsgByCode(code:Int) ->String {
        var errorDesc = "";
        switch(code) {
            case 3840:
                errorDesc = MylocalizedString.sharedLocalizeManager.getLocalizedString("cannot be downloaded due to Server Not Available.")
                break
            default:
                errorDesc = ""
        }
        
        return errorDesc
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        //use buffer here.Download is done
        //progress.progress = 1.0   // download 100% complete
        
        if(error != nil) {
            
            buffer.setData(NSMutableData())
            
            if error?.code == NSURLErrorTimedOut {
                let errorMsg = "\(self.dsDataObj!["NAME"]) \(MylocalizedString.sharedLocalizeManager.getLocalizedString("cannot be downloaded due to Network Issue."))"
                print("\(errorMsg)")
                updateButtonStatus("Enable",btn: self.downloadBtn)
                updateDLProcessLabel(errorMsg)
                updateButtonStatus("Enable",btn: self.uploadBtn)
                updateULProcessLabel(errorMsg)
                
            }else if error?.code == NSURLErrorNotConnectedToInternet || error?.code == NSURLErrorCannotConnectToHost {
                let errorMsg = MylocalizedString.sharedLocalizeManager.getLocalizedString("App is in Offline Mode and unable to proceed Data Download.")
                
                print("\(errorMsg)")
                updateButtonStatus("Enable",btn: self.downloadBtn)
                updateDLProcessLabel(errorMsg)
                updateButtonStatus("Enable",btn: self.uploadBtn)
                updateULProcessLabel(errorMsg)
                
            }else{
                print("error: \(error!.localizedDescription), error code: \(error?.code)")
                updateButtonStatus("Enable",btn: self.downloadBtn)
                updateDLProcessLabel(error!.localizedDescription)
                updateButtonStatus("Enable",btn: self.uploadBtn)
                updateULProcessLabel(error!.localizedDescription)
                
            }
            
        }else if self.dsDataObj != nil && self.dsDataObj!["NAME"] as! String == "Master Data Download" {
            
            do {
                /*
                 dispatch_async(dispatch_get_main_queue(), {
                 self.mstrDataStatus.text =  "100%"
                 self.masterDataProcessBar.progress = 100
                 })*/
                
                updateDLProcessLabel("Preparing Master Data...")
                let dataJson = try NSData(contentsOfFile: getDataJsonPath(), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonData = try NSJSONSerialization.JSONObjectWithData(dataJson, options: .AllowFragments) as! NSDictionary
                //buffer.setData(NSMutableData())
                
                _DS_SESSION = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                
                var session_result = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                session_result += (self.nullToNil(jsonData["action_result"]) == nil) ? "": jsonData["action_result"] as! String
                
                #if DEBUG
                print("session result: \(session_result)")
                #endif
                    
                self.processingDownloadData("_DS_MSTRDATA", jsonData: jsonData)
            } catch {
                
                #if DEBUG
                print("error serializing JSON: \(error)")
                #endif
                
                if self.actionType < 1 {
                    updateButtonStatus("Enable",btn: self.downloadBtn)
                    updateDLProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Master Data")) \(errorMsgByCode((error as NSError).code))")
                }else {
                    updateButtonStatus("Enable",btn: self.uploadBtn)
                    updateULProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Master Data")) \(errorMsgByCode((error as NSError).code))")
                }
            }
            
        }else if self.dsDataObj != nil && self.dsDataObj!["NAME"] as! String == "Master Data Download Acknowledgement" {
            //print("Master Data Download Acknowledgement Response")
            //buffer.setData(NSMutableData())
            
            do {
                updateDLProcessLabel("Sending Master Data Download Acknowledgement...")
                let dataJson = try NSData(contentsOfFile: getDataJsonPath(), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonData = try NSJSONSerialization.JSONObjectWithData(dataJson, options: .AllowFragments) as! NSDictionary
                //buffer.setData(NSMutableData())
                
                _DS_SESSION = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                
                var session_result = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                session_result += (self.nullToNil(jsonData["ack_result"]) == nil) ? "": jsonData["ack_result"] as! String
                
                #if DEBUG
                print("session result: \(session_result)")
                #endif
                        
                self.updateProgressBar(1)
                
                self.makeDLPostRequest(_DS_INPTSETUP)
            }
            catch {
                #if DEBUG
                print("error serializing JSON: \(error)")
                #endif
                
                if self.actionType < 1 {
                    updateButtonStatus("Enable",btn: self.downloadBtn)
                    updateDLProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Master Data")) ACK \(errorMsgByCode((error as NSError).code))")
                }else {
                    updateButtonStatus("Enable",btn: self.uploadBtn)
                    updateULProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Master Data")) ACK \(errorMsgByCode((error as NSError).code))")
                }
            }
            
        }else if self.dsDataObj != nil && self.dsDataObj!["NAME"] as! String == "Inspection Setup Data Download" {
            
            do {/*
                 dispatch_async(dispatch_get_main_queue(), {
                 self.inspSetupDataStatus.text =  "100%"
                 self.setupDataProcessBar.progress = 100
                 })*/
                
                updateDLProcessLabel("Preparing Inspection Setup Data...")
                let dataJson = try NSData(contentsOfFile: getDataJsonPath(), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonData = try NSJSONSerialization.JSONObjectWithData(dataJson, options: .AllowFragments) as! NSDictionary
                
                #if DEBUG
                print("jsonData: \(jsonData)")
                #endif
                
                _DS_SESSION = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                
                var session_result = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                session_result += (self.nullToNil(jsonData["action_result"]) == nil) ? "": jsonData["action_result"] as! String
                
                #if DEBUG
                print("session result: \(session_result)")
                #endif
                
                self.processingDownloadData("_DS_INPTSETUP", jsonData: jsonData)
                //self.processingDownloadData("Inspection Setup Data Download", jsonData: jsonData)
            }
            catch {
                #if DEBUG
                print("error serializing JSON: \(error)")
                #endif
                
                if self.actionType < 1 {
                    updateButtonStatus("Enable",btn: self.downloadBtn)
                    updateDLProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Setup Data")) \(errorMsgByCode((error as NSError).code))")
                }else {
                    updateButtonStatus("Enable",btn: self.uploadBtn)
                    updateULProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Setup Data")) \(errorMsgByCode((error as NSError).code))")
                }
            }
            
        }else if self.dsDataObj != nil && self.dsDataObj!["NAME"] as! String == "Inspection Setup Data Download Acknowledgement" {
            //buffer.setData(NSMutableData())
            
            do {
                updateDLProcessLabel("Sending Inspection Setup Data Download Acknowledgement...")
                let dataJson = try NSData(contentsOfFile: getDataJsonPath(), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonData = try NSJSONSerialization.JSONObjectWithData(dataJson, options: .AllowFragments) as! NSDictionary
                //buffer.setData(NSMutableData())
                
                _DS_SESSION = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                
                var session_result = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                session_result += (self.nullToNil(jsonData["ack_result"]) == nil) ? "": jsonData["ack_result"] as! String
                
                #if DEBUG
                print("session result: \(session_result)")
                #endif
                    
                self.updateProgressBar(1)
                
                self.makeDLPostRequest(_DS_FGPODATA)
            }
            catch {
                #if DEBUG
                print("error serializing JSON: \(error)")
                #endif
                    
                if self.actionType < 1 {
                    updateButtonStatus("Enable",btn: self.downloadBtn)
                    updateDLProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Setup Data")) ACK \(errorMsgByCode((error as NSError).code))")
                }else {
                    updateButtonStatus("Enable",btn: self.uploadBtn)
                    updateULProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspection Setup Data")) ACK \(errorMsgByCode((error as NSError).code))")
                }
            }
            
            
        }else if self.dsDataObj != nil && self.dsDataObj!["NAME"] as! String == "FGPO Data Download" {
            
            do {
                updateDLProcessLabel("Preparing FGPO Data...")
                let dataJson = try NSData(contentsOfFile: getDataJsonPath(), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonData = try NSJSONSerialization.JSONObjectWithData(dataJson, options: .AllowFragments) as! NSDictionary
                //buffer.setData(NSMutableData())
                
                
                _DS_SESSION = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                
                if self.ainit_service_session == "" {
                    self.ainit_service_session = _DS_SESSION
                }
                
                var session_result = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                session_result += (self.nullToNil(jsonData["action_result"]) == nil) ? "": jsonData["action_result"] as! String
                
                #if DEBUG
                print("session result: \(session_result)")
                #endif
                
                self.processingDownloadData("_DS_FGPODATA", jsonData: jsonData)
                //self.processingDownloadData("FGPO Data Download", jsonData: jsonData)
            }
            catch {
                #if DEBUG
                print("error serializing JSON: \(error)")
                #endif
                
                if self.actionType < 1 {
                    updateButtonStatus("Enable",btn: self.downloadBtn)
                    updateDLProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("FGPO Data")) \(errorMsgByCode((error as NSError).code))")
                }else {
                    updateButtonStatus("Enable",btn: self.uploadBtn)
                    updateULProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("FGPO Data")) \(errorMsgByCode((error as NSError).code))")
                }
            }
            
        }else if self.dsDataObj != nil && self.dsDataObj!["NAME"] as! String == "FGPO Data Download Acknowledgement" {
            //buffer.setData(NSMutableData())
            
            do {
                updateDLProcessLabel("Sending FGPO Data Download Acknowledgement...")
                let dataJson = try NSData(contentsOfFile: getDataJsonPath(), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonData = try NSJSONSerialization.JSONObjectWithData(dataJson, options: .AllowFragments) as! NSDictionary
                //buffer.setData(NSMutableData())
                
                _DS_SESSION = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                
                var session_result = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                session_result += (self.nullToNil(jsonData["ack_result"]) == nil) ? "": jsonData["ack_result"] as! String
                
                if self.totalReqCnt > self.downloadReqCnt {
                    self.makeDLPostRequest(_DS_FGPODATA)
                    return
                }
                
                #if DEBUG
                print("session result: \(session_result)")
                #endif
                
                self.updateProgressBar(1)
                
                self.makeDLPostRequest(_DS_TASKDATA)
            }
            catch {
                #if DEBUG
                print("error serializing JSON: \(error)")
                #endif
                
                if self.actionType < 1 {
                    updateButtonStatus("Enable",btn: self.downloadBtn)
                    updateDLProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("FGPO Data")) ACK \(errorMsgByCode((error as NSError).code))")
                }else {
                    updateButtonStatus("Enable",btn: self.uploadBtn)
                    updateULProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("FGPO Data")) ACK \(errorMsgByCode((error as NSError).code))")
                }
            }
            
            
        }else if self.dsDataObj != nil && self.dsDataObj!["NAME"] as! String == "Task Booking Data Download" {
            
            do {/*
                 dispatch_async(dispatch_get_main_queue(), {
                 self.taskDataStatus.text =  "100%"
                 self.taskDataProcessBar.progress = 100
                 })*/
                
                updateDLProcessLabel("Preparing Task Booking Data...")
                
//                let jsonString = "{\"service_session\":\"42530\",\"inspect_task_list\":[{\"ref_task_id\":\"14285\",\"prod_type_id\":\"1\",\"inspect_type_id\":\"1\",\"booking_no\":\"RPT-0000014285\",\"booking_date\":\"10/30/2020 12:00:00 AM\",\"vdr_location_id\":\"42\",\"report_inspector_id\":\"\",\"report_prefix\":\"\",\"report_running_no\":\"\",\"inspection_no\":\"\",\"inspection_date\":\"\",\"inspect_setup_id\":\"1\",\"tmpl_id\":\"2\",\"task_remarks\":\"\",\"vdr_notes\":\"\",\"inspect_result_value_id\":\"\",\"inspector_sign_image_file\":\"\",\"vdr_sign_name\":\"\",\"vdr_sign_image_file\":\"\",\"task_status\":\"2\",\"rec_status\":\"0\",\"deleted_flag\":\"0\",\"delete_date\":\"\",\"delete_user\":\"\",\"create_date\":\"10/29/2020 4:51:26 PM\",\"create_user\":\"admin1\",\"modify_date\":\"10/29/2020 4:51:27 PM\",\"modify_user\":\"admin1\"}],\"inspect_task_inspector_list\":[{\"ref_task_id\":\"14285\",\"inspector_id\":\"121\",\"inspect_enable_flag\":\"1\",\"create_date\":\"10/29/2020 4:51:26 PM\",\"create_user\":\"admin1\",\"modify_date\":\"10/29/2020 4:51:26 PM\",\"modify_user\":\"admin1\"}],\"inspect_task_item_list\":[{\"ref_task_id\":\"14285\",\"po_item_id\":\"89247\",\"ref_qc_plan_line_id\":\"\",\"target_inspect_qty\":\"250\",\"avail_inspect_qty\":\"\",\"sampling_qty\":\"\",\"inspect_enable_flag\":\"1\",\"item_barcode\":\"\",\"retail_price\":\"\",\"currency\":\"\",\"style_size\":\"ES4255\",\"substr_style_size\":\"\",\"create_date\":\"10/29/2020 4:51:26 PM\",\"create_user\":\"admin1\",\"modify_date\":\"10/29/2020 4:51:27 PM\",\"modify_user\":\"admin1\"}],\"inspect_task_qc_info_list\":[]}"
//                let dataJson = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
//                
                let dataJson = try NSData(contentsOfFile: getDataJsonPath(), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonData = try NSJSONSerialization.JSONObjectWithData(dataJson, options: .AllowFragments) as! NSDictionary
                
                
                //buffer.setData(NSMutableData())
                
                _DS_SESSION = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                
                var session_result = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                session_result += (self.nullToNil(jsonData["action_result"]) == nil) ? "": jsonData["action_result"] as! String
                
                #if DEBUG
                print("session result: \(session_result)")
                #endif
                    
                self.processingDownloadData("_DS_TASKDATA", jsonData: jsonData)
                //self.processingDownloadData("Task Booking Data Download", jsonData: jsonData)
            }
            catch {
                #if DEBUG
                print("error serializing JSON: \(error)")
                #endif
                    
                if self.actionType < 1 {
                    updateButtonStatus("Enable",btn: self.downloadBtn)
                    updateDLProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Booking Data")) \(errorMsgByCode((error as NSError).code))")
                }else {
                    updateButtonStatus("Enable",btn: self.uploadBtn)
                    updateULProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Booking Data")) \(errorMsgByCode((error as NSError).code))")
                }
            }
            
        }else if self.dsDataObj != nil && self.dsDataObj!["NAME"] as! String == "Task Booking Data Download Acknowledgement" {
            //buffer.setData(NSMutableData())
            
            do {
                updateDLProcessLabel("Sending Task Booking Data Download Acknowledgement...")
                let dataJson = try NSData(contentsOfFile: getDataJsonPath(), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonData = try NSJSONSerialization.JSONObjectWithData(dataJson, options: .AllowFragments) as! NSDictionary
                //buffer.setData(NSMutableData())
                
                _DS_SESSION = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                
                var session_result = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                session_result += (self.nullToNil(jsonData["ack_result"]) == nil) ? "": jsonData["ack_result"] as! String
                
                self.updateProgressBar(1)
                //task status download request
                self.makeDLPostRequest(_DS_DL_TASK_STATUS)
                
            }
            catch {
                #if DEBUG
                print("error serializing JSON: \(error)")
                #endif
                
                if self.actionType < 1 {
                    updateButtonStatus("Enable",btn: self.downloadBtn)
                    updateDLProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Booking Data")) ACK \(errorMsgByCode((error as NSError).code))")
                }else {
                    updateButtonStatus("Enable",btn: self.uploadBtn)
                    updateULProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Booking Data")) ACK \(errorMsgByCode((error as NSError).code))")
                }
            }
            
        }else if self.dsDataObj != nil && self.dsDataObj!["NAME"] as! String == "Task Status Data Download" {
            
            do {/*
                 dispatch_async(dispatch_get_main_queue(), {
                 self.taskStatusDataStatus.text =  "100%"
                 self.taskStatusDataProcessBar.progress = 100
                 })*/
                
                updateDLProcessLabel("Preparing Task Status Data...")
                
//                let jsonString = "{\"service_session\":\"42257\",\"inspect_task_list\":[{\"task_id\":\"\",\"inspection_no\":\"\",\"inspection_date\":null,\"app_ready_purge_date\":\"\",\"ref_task_id\":\"14285\",\"inspect_result_value_id\":\"\",\"task_status\":\"0\",\"review_remarks\":\"\",\"review_user\":\"\",\"review_date\":\"\",\"rec_status\":\"0\",\"modify_date\":\"10/29/2020 4:54:04 PM\",\"modify_user\":\"admin1\",\"deleted_flag\":\"0\",\"delete_date\":\"\",\"delete_user\":\"\"}]}"
//                let dataJson = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
                let dataJson = try NSData(contentsOfFile: getDataJsonPath(), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonData = try NSJSONSerialization.JSONObjectWithData(dataJson, options: .AllowFragments) as! NSDictionary
                //buffer.setData(NSMutableData())
                
                _DS_SESSION = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                
                var session_result = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                session_result += (self.nullToNil(jsonData["action_result"]) == nil) ? "": jsonData["action_result"] as! String
                
                #if DEBUG
                    print("session result: \(session_result)")
                #endif
                
                self.processingDownloadData("_DS_DL_TASK_STATUS", jsonData: jsonData)
                //self.processingDownloadData("Task Status Data Download", jsonData: jsonData)
            }
            catch {
                #if DEBUG
                    print("error serializing JSON: \(error)")
                #endif
                
                if self.actionType < 1 {
                    updateButtonStatus("Enable",btn: self.downloadBtn)
                    updateDLProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Status Data")) \(errorMsgByCode((error as NSError).code))")
                }else {
                    updateButtonStatus("Enable",btn: self.uploadBtn)
                    updateULProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Status Data")) \(errorMsgByCode((error as NSError).code))")
                }
            }
            
        } else if self.dsDataObj != nil && self.dsDataObj!["NAME"] as! String == "Task Status Data Download Acknowledgement" {
            //buffer.setData(NSMutableData())
            
            do {
                updateDLProcessLabel("Sending Task Status Data Download Acknowledgement...")
                let dataJson = try NSData(contentsOfFile: getDataJsonPath(), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonData = try NSJSONSerialization.JSONObjectWithData(dataJson, options: .AllowFragments) as! NSDictionary
                //buffer.setData(NSMutableData())
                
                _DS_SESSION = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                
                var session_result = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                session_result += (self.nullToNil(jsonData["ack_result"]) == nil) ? "": jsonData["ack_result"] as! String
                
                //Send local notification for Task Done.
                self.updateProgressBar(1)
                
                //Handel Tasks Delete Here
                let dataSyncDataHelper = DataSyncDataHelper()
                let taskIds = dataSyncDataHelper.selectTaskIdsCanDelete()
                
                self.cleanTaskCnt = 0
                for taskId in taskIds {
                    print("delete \(taskId)");
                    self.view.deleteTask(taskId)
                    self.cleanTaskCnt += 1
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.updateDLProcessLabel("Task Cleaning...")
                        
                        self.cleanTaskStatus.text = "\(self.cleanTaskCnt)"
                        let percent = Float(self.cleanTaskCnt)/Float(taskIds.count)
                        
                        self.cleanTaskProcessBar.progress = percent
                    })
                    
                }
                
                if self.cleanTaskCnt < 1 {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.cleanTaskStatus.text = "0"
                        self.cleanTaskProcessBar.progress = 1.0
                    })
                }
                
                //clear invalid tasks
                let taskDataHelper = TaskDataHelper()
                var invalidTaskIds = taskDataHelper.getAllInvalidTaskId()
                
                while let id = invalidTaskIds.popLast() {
                    self.view.deleteTask(id)
                }
                
                let fileManager = NSFileManager.defaultManager()
                if fileManager.fileExistsAtPath(getDataJsonPath()) {
                    try fileManager.removeItemAtPath(getDataJsonPath())
                }
                
                //Send local notification for Task Done.
                self.updateProgressBar(1)
                self.makeDLPostRequest(_DS_DL_STYLE_PHOTO)

            }
            catch {
                #if DEBUG
                    print("error serializing JSON: \(error)")
                #endif
                
                if self.actionType < 1 {
                    updateButtonStatus("Enable",btn: self.downloadBtn)
                    updateDLProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Status Data")) ACK \(errorMsgByCode((error as NSError).code))")
                }else {
                    updateButtonStatus("Enable",btn: self.uploadBtn)
                    updateULProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Status Data")) ACK \(errorMsgByCode((error as NSError).code))")
                }
            }
        }else if self.dsDataObj != nil && self.dsDataObj!["NAME"] as! String == "Style Photo Download" {
            
            do {
                
                updateDLProcessLabel("Preparing Style Photo Data...")
                let dataJson = try NSData(contentsOfFile: getDataJsonPath(), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonData = try NSJSONSerialization.JSONObjectWithData(dataJson, options: .AllowFragments) as! NSDictionary
                
                _DS_SESSION = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                
                var session_result = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                session_result += (self.nullToNil(jsonData["action_result"]) == nil) ? "": jsonData["action_result"] as! String
                
                #if DEBUG
                    print("session result: \(session_result)")
                #endif
                
                self.processingDownloadData("_DS_DL_STYLE_PHOTO", jsonData: jsonData)
            }
            catch {
                #if DEBUG
                    print("error serializing JSON: \(error)")
                #endif
                
                if self.actionType < 1 {
                    updateButtonStatus("Enable",btn: self.downloadBtn)
                    updateDLProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Style Photo")) \(errorMsgByCode((error as NSError).code))")
                }else {
                    updateButtonStatus("Enable",btn: self.uploadBtn)
                    updateULProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Style Photo")) \(errorMsgByCode((error as NSError).code))")
                }
            }
            
        } else if self.dsDataObj != nil && self.dsDataObj!["NAME"] as! String == "Style Photo Download Acknowledgement" {
            
            do {
                updateDLProcessLabel("Sending Style Photo Data Download Acknowledgement...")
                let dataJson = try NSData(contentsOfFile: getDataJsonPath(), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonData = try NSJSONSerialization.JSONObjectWithData(dataJson, options: .AllowFragments) as! NSDictionary
                
                _DS_SESSION = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                
                var session_result = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                session_result += (self.nullToNil(jsonData["ack_result"]) == nil) ? "": jsonData["ack_result"] as! String
                
                self.updateProgressBar(1)
                
                // Delete Style Photos
                let photoDataHelper = PhotoDataHelper()
                var paths = photoDataHelper.selectStylePhotosToRemove()
                
                // Merge all paths
                while let path = paths.popLast() {
                    if !self.stylePhotoDeletePaths.contains(path) {
                        self.stylePhotoDeletePaths.append(path)
                    }
                }
                let totalDeletePhotosCount = self.stylePhotoDeletePaths.count
                
                // clean style photos
                // case 1, photo_name exist, photo_file no value
                
                // case 2, deleted_flag is 1 in style_photo table, remove photo and record
                // clean SS style photos
                
                self.updateDLProcessLabel("Style Photo Cleaning...")
                var cleanStylePhotoCount = 0
                while let path = self.stylePhotoDeletePaths.popLast() {
                    dispatch_async(dispatch_get_main_queue(), {
                        if UIImage().removeImageFromLocalByPath(path) {
                            cleanStylePhotoCount += 1
                        }
                    
                        dispatch_async(dispatch_get_main_queue(), {
                            self.stylePhotoCleanStatus.text = "\(cleanStylePhotoCount)"
                            let percent = Float(cleanStylePhotoCount)/Float(totalDeletePhotosCount)
                            
                            self.stylePhotoCleanProcessBar.progress = percent
                        })
                    })
                }
                
                // remove all records deleted flag is 1
                photoDataHelper.removeStylePhotosMarkDeleted()
                
                if cleanStylePhotoCount < 1 {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.stylePhotoCleanStatus.text = "0"
                        self.stylePhotoCleanProcessBar.progress = 1.0
                    })
                }
                
                //Send local notification for Task Done.
                self.presentLocalNotification("Data Download Complete.")
                
                self.updateDLProcessLabel("Complete")
                self.updateButtonStatus("Enable",btn: self.downloadBtn)
            }
            catch {
                #if DEBUG
                    print("error serializing JSON: \(error)")
                #endif
                
                if self.actionType < 1 {
                    updateButtonStatus("Enable",btn: self.downloadBtn)
                    updateDLProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Status Data")) ACK \(errorMsgByCode((error as NSError).code))")
                }else {
                    updateButtonStatus("Enable",btn: self.uploadBtn)
                    updateULProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Status Data")) ACK \(errorMsgByCode((error as NSError).code))")
                }
            }
        } else if self.dsDataObj != nil && self.dsDataObj!["NAME"] as! String == "Task Result Data Upload" {
            //Handle data in NSData type
            updateULProcessLabel("Processing Response...")
    
            do {
                dispatch_async(dispatch_get_main_queue(), {
                    self.taskUploadDataStatus.text = "100%"
                    self.taskResultDataProcessBar.progress = 100
                })
    
                let dataJson = try NSData(contentsOfFile: getDataJsonPath(), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonData = try NSJSONSerialization.JSONObjectWithData(dataJson, options: .AllowFragments) as! NSDictionary
    
                if jsonData.count > 0 {
    
                    for (key,value) in jsonData {
                        //print("key: \(key) value: \(value)")
    
                        if key as! String == "task_status_list" {
                            //Remove reviewed task here
                            //Get Delete Flag Here
                            //let taskStatusList = try NSJSONSerialization.JSONObjectWithData(value as! NSData, options: .AllowFragments) as! NSDictionary
                            taskStatusList = value as! [[String : String]]
    
                        }else{
                            if value as? String != _DS_TOTALRECORDS_DB[key as! String] && (key as! String) != "service_session" {
                                print("\(key) mismatch response value: \(value), but \(_DS_TOTALRECORDS_DB[key as! String])")
                            }
                        }
                    }
                    
                    _DS_SESSION = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                    
                    var result = (self.nullToNil(jsonData["service_session"]) == nil) ? "": jsonData["service_session"] as! String
                    result += (self.nullToNil(jsonData["action_result"]) == nil) ? "": jsonData["action_result"] as! String
                    
                    
                    /*if !result.containsString("OK") {
                     updateULProcessLabel("Waiting for Response Data from Server, need few minutes...")
                     }*/
                    
                } else{
                    var result = (self.nullToNil(jsonData["action_result"]) == nil) ? "": jsonData["action_result"] as! String
                    result += (self.nullToNil(jsonData["ack_result"]) == nil) ? "": jsonData["ack_result"] as! String
                }
                
                //Update Task Status
                let dataSyncHelper = DataSyncDataHelper()
                
                let confirmedTaskIds = dataSyncHelper.getAllConfirmedTaskIds()
                var includeTaskIds = "("
                for taskId in confirmedTaskIds {
                    includeTaskIds += "\(taskId),"
                }
                includeTaskIds += ")"
                includeTaskIds = includeTaskIds.stringByReplacingOccurrencesOfString(",)", withString: ")")
                
                let refusedTaskIds = getRefusedTaskIdAndUpdateConfirmUploadDate()
                var excludeTaskIds = "("
                for taskId in refusedTaskIds{
                    excludeTaskIds += "\(taskId),"
                }
                excludeTaskIds += ")"
                excludeTaskIds = excludeTaskIds.stringByReplacingOccurrencesOfString(",)", withString: ")")
                
                self.updateProgressBar(0.8)
                //start upload task photo here
                
                uploadPhotos = dataSyncHelper.getAllPhotos(includeTaskIds, excludeTaskIds: excludeTaskIds)!
                self.totalULPhotos = uploadPhotos.count
                uploadPhotos = uploadPhotos.reverse()
                
                if self.totalULPhotos>0 {
                    self.updateULPhotoStatus(self.currULPhotoIndex, total: self.totalULPhotos)
                    
                    if let photo = uploadPhotos.popLast() {
                        let state = UIApplication.sharedApplication().applicationState
                        
                        if state == .Active {
                            
                            // foreground
                            sessionDownloadTask = self.fgSession?.downloadTaskWithRequest(createPhotoULRequest(photo))
                            sessionDownloadTask?.resume()
                            
                        }else{
                            
                            // background
                            sessionDownloadTask = self.bgSession?.downloadTaskWithRequest(createPhotoULRequest(photo))
                            sessionDownloadTask?.resume()
                            
                        }
                        
                    }
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.taskPhotoProcessBar.progress = 1.0
                    })
                    
                    self.updateULPhotoStatus(self.currULPhotoIndex, total: self.totalULPhotos)
                    updateTaskStatus()
                    updateULProcessLabel("Complete")
                    updateButtonStatus("Enable",btn: self.uploadBtn)
                    
                    //Send local notification for Task Done.
                    self.presentLocalNotification("Data Upload Complete.")
                    
                }
                
                //resultSet = dataSet
            } catch {
                #if DEBUG
                print("error serializing JSON: \(error)")
                #endif
                
                if self.actionType < 1 {
                    updateButtonStatus("Enable",btn: self.downloadBtn)
                    updateDLProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Result Data")) \(errorMsgByCode((error as NSError).code))")
                }else {
                    updateButtonStatus("Enable",btn: self.uploadBtn)
                    updateULProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Result Data")) \(errorMsgByCode((error as NSError).code))")
                }
            }
        }else if self.dsDataObj != nil && self.dsDataObj!["NAME"] as! String == "Task Photo Data Upload" {
            //Handle data in NSData type
            updateULProcessLabel("Photo Uploading...")
            
            var dataSet = [Dictionary<String, String>]()
            self.currULPhotoIndex += 1
            self.updateULPhotoStatus(self.currULPhotoIndex, total: self.totalULPhotos)
            
            if self.currULPhotoIndex == self.totalULPhotos {
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.taskPhotoProcessBar.progress = 100
                })
                
                updateTaskStatus()
                updateULProcessLabel("Complete")
                updateButtonStatus("Enable",btn: self.uploadBtn)
                
                //Send local notification for Task Done.
                self.presentLocalNotification("Data Upload Complete.")
                
                let keyValueDataHelper = KeyValueDataHelper()
                keyValueDataHelper.updateLastUploadDatetime(String((Cache_Inspector?.inspectorId)!), datetime: self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm"))
                keyValueDataHelper.updateLastUploadTasksCount(String((Cache_Inspector?.inspectorId)!), tasksCount: _DS_UPLOADEDTASKCOUNT)
            }
            
            do {
                let dataJson = try NSData(contentsOfFile: getDataJsonPath(), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonData = try NSJSONSerialization.JSONObjectWithData(dataJson, options: .AllowFragments) as! NSDictionary
                //buffer.setData(NSMutableData())
                
                if jsonData.count > 0 {
                    var dataObj = Dictionary<String, String>()
                    
                    for (key,value) in jsonData {
                        dataObj[key as! String] = value as? String
                        
                    }
                    
                    dataSet.append(dataObj)
                    
                    var result = (self.nullToNil(jsonData["ul_result"]) == nil) ? "": jsonData["ul_result"] as! String
                    result += (self.nullToNil(jsonData["ul_result"]) == nil) ? "": jsonData["ul_result"] as! String
                    
                    #if DEBUG
                    print("result: \(result)")
                    #endif
                    
                    //update photo upload date
                    if (Int(dataObj["photo_id"]!) != nil && result.containsString("OK")) {
                        let photoIdUploaded = Int(dataObj["photo_id"]!)
                        let dataSyncDataHelper = DataSyncDataHelper()
                        dataSyncDataHelper.updatePhotoUploadDateByPhotoId(photoIdUploaded!)
                    }else{
                        failULPhotoCount += 1
                        self.updateULPhotoStatus(self.currULPhotoIndex, total: self.totalULPhotos, fail: failULPhotoCount)
                    }
                    
                } else{
                    var result = (self.nullToNil(jsonData["ul_result"]) == nil) ? "": jsonData["ul_result"] as! String
                    result += (self.nullToNil(jsonData["ul_result"]) == nil) ? "": jsonData["ul_result"] as! String
                    
                }
                
                if let photo = uploadPhotos.popLast() {
                    let state = UIApplication.sharedApplication().applicationState
                    
                    if state == .Active {
                        
                        // foreground
                        sessionDownloadTask = self.fgSession?.downloadTaskWithRequest(createPhotoULRequest(photo))
                        sessionDownloadTask?.resume()
                        
                    }else{
                        
                        // background or inactive
                        sessionDownloadTask = self.bgSession?.downloadTaskWithRequest(createPhotoULRequest(photo))
                        sessionDownloadTask?.resume()
                        
                    }
                }
                
            } catch {
                #if DEBUG
                print("error serializing JSON: \(error)")
                #endif
                
                if self.actionType < 1 {
                    updateButtonStatus("Enable",btn: self.downloadBtn)
                    updateDLProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Photo Upload")) \(errorMsgByCode((error as NSError).code))")
                    
                }else {
                    updateButtonStatus("Enable",btn: self.uploadBtn)
                    updateULProcessLabel("\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Photo Upload")) \(errorMsgByCode((error as NSError).code))")
                    
                }
            }
        }
        
        self.sessionDownloadTask = nil
        
    }
    
    func getRefusedTaskIdAndUpdateConfirmUploadDate() ->[Int] {
        let dataSyncDataHelper = DataSyncDataHelper()
        var taskRefused = [Int]()
        
        for taskStatus in taskStatusList {
            if taskStatus["task_id"] != nil && taskStatus["task_status"] != nil && taskStatus["data_refuse_desc"] != nil {
                if Int(taskStatus["task_status"]!)! == GetTaskStatusId(caseId: "Refused").rawValue || Int(taskStatus["task_status"]!)! == GetTaskStatusId(caseId: "Confirmed").rawValue {
                    taskRefused.append(Int(taskStatus["task_id"]!)!)
                } else if Int(taskStatus["task_status"]!)! == GetTaskStatusId(caseId: "Uploaded").rawValue {
                    //Set value to confirm_upload_date for confirmed task (not cancelled)
                    dataSyncDataHelper.updateInspectTaskConfirmUploadDate(Int(taskStatus["task_id"]!)!)
                }
            }
        }
        
        return taskRefused
    }
    
    func updateTaskStatus() {
        let dataSyncDataHelper = DataSyncDataHelper()
        
        for taskStatus in taskStatusList {
            
            if taskStatus["task_id"] != nil && taskStatus["ref_task_id"] != nil && taskStatus["task_status"] != nil && taskStatus["data_refuse_desc"] != nil {
                
                dataSyncDataHelper.updateTaskStatus(Int(taskStatus["task_id"]!)!, status: Int(taskStatus["task_status"]!)!, refuseDesc: taskStatus["data_refuse_desc"]!, ref_task_id: Int(taskStatus["ref_task_id"]!)!)
                
                if Cache_Task_On?.taskId == Int(taskStatus["task_id"]!)! {
                    Cache_Task_On?.taskStatus = Int(taskStatus["task_status"]!)!
                    Cache_Task_On?.dataRefuseDesc = taskStatus["data_refuse_desc"]!
                    Cache_Task_On?.refTaskId = Int(taskStatus["ref_task_id"]!)!
                }
                
            }
        }
        
        self.updateProgressBar(1)
    }
    
    func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
        self.bgSession?.finishTasksAndInvalidate()
        self.fgSession?.finishTasksAndInvalidate()
    }
    
    func getDataJsonPath() ->String {
        return "\(NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0])/response.json"
    }
    
    //didBecomeInvalidWithError
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        print("下载完成")
        
        do {
            
            let fileManager = NSFileManager.defaultManager()
            let path = getDataJsonPath()
            
            if fileManager.fileExistsAtPath(path) {
                try fileManager.removeItemAtPath(path)
            }
            
            try fileManager.copyItemAtPath(location.path!, toPath: path)
            
            //let dataFromLocation = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            
            /*
             let dataFromLocation = try NSData(contentsOfURL: location, options: NSDataReadingOptions.DataReadingMappedIfSafe)
             self.buffer.setData(dataFromLocation)
             */
            
        } catch{
            print("path error: \(error)")
            //self.buffer.setData(NSData.init())
        }
        
    }
    
    //Download Task Process
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("正在下载 \(totalBytesWritten)/\(totalBytesExpectedToWrite)")
        
        let percentageDownloaded = 15 + (Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))*15
        
        //self.updateProgressBar(percentageDownloaded*0.01)
        
        if "FGPO Data Download" == self.dsDataObj!["NAME"] as! String {
            if self.downloadReqCnt < 1 {
                self.updateProgressBar(percentageDownloaded*0.01)
            }
        }else{
        
            self.updateProgressBar(percentageDownloaded*0.01)
        }
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("从 \(fileOffset) 处恢复下载，一共 \(expectedTotalBytes)")
        
    }
    
    func updateProgressBar(percentageDownloaded:Float = 0) {
        print("dsDataObj: \(self.dsDataObj!["NAME"] as! String)")
        if "Master Data Download" == self.dsDataObj!["NAME"] as! String {
            updateDLProcessLabel("Downloading Data...")
            dispatch_async(dispatch_get_main_queue(), {
                self.mstrDataStatus.text = "\(String(lroundf(100*percentageDownloaded)))%"
                self.masterDataProcessBar.progress =  percentageDownloaded
                
            })
            
        }else if "Inspection Setup Data Download" == self.dsDataObj!["NAME"] as! String {
            updateDLProcessLabel("Downloading Data...")
            dispatch_async(dispatch_get_main_queue(), {
                self.inspSetupDataStatus.text = "\(String(lroundf(100*percentageDownloaded)))%"
                self.setupDataProcessBar.progress =  percentageDownloaded
                
            })
            
        }else if "FGPO Data Download" == self.dsDataObj!["NAME"] as! String {
            //if self.downloadReqCnt < 1 {
                updateDLProcessLabel("Downloading Data...")
                dispatch_async(dispatch_get_main_queue(), {
                    self.fgpoDataStatus.text = "\(String(lroundf(100*percentageDownloaded)))%"
                    self.fgpoDataProcessBar.progress =  percentageDownloaded
                    
                })
            //}
            
        }else if "Task Booking Data Download" == self.dsDataObj!["NAME"] as! String {
            updateDLProcessLabel("Downloading Data...")
            dispatch_async(dispatch_get_main_queue(), {
                self.taskDataStatus.text = "\(String(lroundf(100*percentageDownloaded)))%"
                self.taskDataProcessBar.progress =  percentageDownloaded
                
            })
        }else if "Task Status Data Download" == self.dsDataObj!["NAME"] as! String {
            updateDLProcessLabel("Downloading Data...")
            dispatch_async(dispatch_get_main_queue(), {
                self.taskStatusDataStatus.text = "\(String(lroundf(100*percentageDownloaded)))%"
                self.taskStatusDataProcessBar.progress =  percentageDownloaded
                
            })
        }else if "Style Photo Download" == self.dsDataObj!["NAME"] as! String {
            updateDLProcessLabel("Downloading Data...")
            dispatch_async(dispatch_get_main_queue(), {
                self.stylePhotoStatus.text = "\(String(lroundf(100*percentageDownloaded)))%"
                self.stylePhotoPrecessBar.progress =  percentageDownloaded
    
            })
        }else if "FGPO Data Download Acknowledgement" == self.dsDataObj!["NAME"] as! String {
            
            dispatch_async(dispatch_get_main_queue(), {
                if /*self.downloadReqCnt == self.totalReqCnt && */self.fgpoDataProcessBar.progress < percentageDownloaded {
                    self.fgpoDataStatus.text = "\(String(lroundf(100*percentageDownloaded)))%"
                    self.fgpoDataProcessBar.progress =  percentageDownloaded
                    print("PO Download 1")
                }
            })
    
        }else if "Master Data Download Acknowledgement" == self.dsDataObj!["NAME"] as! String {
            
            dispatch_async(dispatch_get_main_queue(), {
                if self.masterDataProcessBar.progress < percentageDownloaded {
                    self.mstrDataStatus.text = "\(String(lroundf(100*percentageDownloaded)))%"
                    self.masterDataProcessBar.progress = percentageDownloaded
                }
            })
        }else if "Inspection Setup Data Download Acknowledgement" == self.dsDataObj!["NAME"] as! String {
            
            dispatch_async(dispatch_get_main_queue(), {
                if self.setupDataProcessBar.progress < percentageDownloaded {
                    self.inspSetupDataStatus.text = "\(String(lroundf(100*percentageDownloaded)))%"
                    self.setupDataProcessBar.progress = percentageDownloaded
                }
                
            })
        }else if "Task Booking Data Download Acknowledgement" == self.dsDataObj!["NAME"] as! String {
            
            dispatch_async(dispatch_get_main_queue(), {
                if self.taskDataProcessBar.progress < percentageDownloaded {
                    self.taskDataStatus.text = "\(String(lroundf(100*percentageDownloaded)))%"
                    self.taskDataProcessBar.progress = percentageDownloaded
                }
                
            })
        }else if "Task Status Data Download Acknowledgement" == self.dsDataObj!["NAME"] as! String {
            
            dispatch_async(dispatch_get_main_queue(), {
                if self.taskStatusDataProcessBar.progress < percentageDownloaded{
                    self.taskStatusDataStatus.text = "\(String(lroundf(100*percentageDownloaded)))%"
                    self.taskStatusDataProcessBar.progress = percentageDownloaded
                }
                
            })
        }else if "Style Photo Download Acknowledgement" == self.dsDataObj!["NAME"] as! String {
            dispatch_async(dispatch_get_main_queue(), {
                if self.stylePhotoPrecessBar.progress < percentageDownloaded{
                    self.stylePhotoStatus.text = "\(String(lroundf(100*percentageDownloaded)))%"
                    self.stylePhotoPrecessBar.progress = percentageDownloaded
                }
                
            })
        }
    }
    
}