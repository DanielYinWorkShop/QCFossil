//
//  DataCtrlViewController.swift
//  QCFossil
//
//  Created by Yin Huang on 6/5/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class DataCtrlViewController: UIViewController, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate, SSZipArchiveDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backupListTableView: UITableView!
    @IBOutlet weak var loginUserLabel: UILabel!
    @IBOutlet weak var lastLoginDate: UILabel!
    @IBOutlet weak var lastDownload: UILabel!
    @IBOutlet weak var lastUpdate: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var loginUserInput: UILabel!
    @IBOutlet weak var lastLoginDateInput: UILabel!
    @IBOutlet weak var lastDownloadInput: UILabel!
    @IBOutlet weak var lastUpdateInput: UILabel!
    @IBOutlet weak var backupBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var restoreDataBtn: UIButton!
    @IBOutlet weak var restoreBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var backupDesc: UITextView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var btnsPanel: UIView!
    @IBOutlet weak var activityActor: UIActivityIndicatorView!
    @IBOutlet weak var backupHistoryLabel: UILabel!
    @IBOutlet weak var upperLine: UILabel!
    @IBOutlet weak var downLine: UILabel!

    typealias CompletionHandler = (obj:AnyObject?, success: Bool?) -> Void
    var filePath = NSHomeDirectory() + "/Documents"
    var zipPath5 = NSHomeDirectory() + "/task.zip"
    var buffer:NSMutableData = NSMutableData()
    var expectedContentLength = 0
    var bgSession: NSURLSession?
    var fgSession: NSURLSession?
    var sessionDownloadTask: NSURLSessionDownloadTask?
    var backupFileList = [BackupFile]()
    var selectedBackupFile:BackupFile!
    var pWInput:UITextField!
    let typeListBackupFiles = "L"
    let typeBackup = "B"
    let typeRestore = "R"
    var typeNow = ""
    
    struct BackupFile {
        var appRealse:String
        var appVersion:String
        var backupProcessDate:String
        var backupRemarks:String
        var backupSyncId:String
        var deviceId:String
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateLocalizedString()
        
        var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForRequest = 300
        configuration.timeoutIntervalForResource = 300
        configuration.sessionSendsLaunchEvents = false
        configuration.discretionary = true
        
        fgSession = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.pacmobile.fossilqc")
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        configuration.sessionSendsLaunchEvents = true
        configuration.discretionary = true
        
        bgSession = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        if Cache_Inspector?.appUserName == "" {
            self.view.alertView("No Login User Found!")
            return
        }
        
        initPage()
    
    }
    /*
    var defaultSession: NSURLSession {
        struct MydefaultSession {
            static var defaultSessionStaticSelf: DataCtrlViewController!
            static var defaultSessionInstance: NSURLSession = {
                
                var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
                configuration.timeoutIntervalForRequest = 300
                configuration.timeoutIntervalForResource = 300
                configuration.sessionSendsLaunchEvents = true
                configuration.discretionary = true
                
                return NSURLSession(configuration: configuration, delegate: defaultSessionStaticSelf, delegateQueue: nil)
            }()
        }
        MydefaultSession.defaultSessionStaticSelf = self
        return MydefaultSession.defaultSessionInstance
    }
    
    var backgroundSession: NSURLSession {
        struct MybackgroundSession {
            static var backgroundSessionStaticSelf: DataCtrlViewController!
            static var backgroundSessionInstance: NSURLSession = {
                
                var configuration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.pacmobile.fossilqc.dataCtrl")
                configuration.timeoutIntervalForRequest = 60
                configuration.timeoutIntervalForResource = 60
                configuration.sessionSendsLaunchEvents = true
                configuration.discretionary = true
                
                return NSURLSession(configuration: configuration, delegate: backgroundSessionStaticSelf, delegateQueue: nil)
            }()
        }
        MybackgroundSession.backgroundSessionStaticSelf = self
        return MybackgroundSession.backgroundSessionInstance
    }*/
    
    func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
        print("All tasks are finished")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let completionHandler = appDelegate.backgroundSessionCompletionHandler {
            appDelegate.backgroundSessionCompletionHandler = nil
            completionHandler()
        }
        
        print("All tasks are finished")
    }
    
    func updateButtonsStatus(status:Bool) {
        self.backupBtn.enabled = status
        self.removeBtn.enabled = status
        self.restoreBtn.enabled = status
        self.restoreDataBtn.enabled = status
        
        dispatch_async(dispatch_get_main_queue(), {
            
        if status {
            self.backupBtn.backgroundColor = _FOSSILBLUECOLOR
            self.removeBtn.backgroundColor = _FOSSILBLUECOLOR
            self.restoreBtn.backgroundColor = _FOSSILBLUECOLOR
            self.restoreDataBtn.backgroundColor = _FOSSILBLUECOLOR
            
            NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":true])
        }else{
            self.backupBtn.backgroundColor = UIColor.grayColor()
            self.removeBtn.backgroundColor = UIColor.grayColor()
            self.restoreBtn.backgroundColor = UIColor.grayColor()
            self.restoreDataBtn.backgroundColor = UIColor.grayColor()
            
            NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":false])
        }
            
        })
    }
    
    func initPage() {
        
        self.backupHistoryLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup History")
        self.errorMsg.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please input description for backup data.")
        self.descLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup Remarks")
        self.loginUserLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Login User")
        self.lastLoginDate.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Last Login")
        self.lastDownload.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Last Restore")
        self.lastUpdate.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Last Backup")
        self.passwordLabel.text = ""
        self.backupBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup Data"), forState: UIControlState.Normal)
        self.restoreDataBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup History List"), forState: UIControlState.Normal)
        self.restoreBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Restore"), forState: UIControlState.Normal)
        self.lastLoginDateInput.text = Cache_Inspector?.lastLoginDate
        self.removeBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete Login User Data"), forState: UIControlState.Normal)
        
        let keyValueDataHelper = KeyValueDataHelper()
        self.lastUpdateInput.text = keyValueDataHelper.getLastBackupDatetimeByUserId(String(Cache_Inspector?.inspectorId))
        self.lastDownloadInput.text = keyValueDataHelper.getLastRestoreDatetimeByUserId(String(Cache_Inspector?.inspectorId))
        self.loginUserInput.text = Cache_Inspector?.appUserName!
        
        self.view.setButtonCornerRadius(self.backupBtn)
        self.view.setButtonCornerRadius(self.restoreDataBtn)
        self.view.setButtonCornerRadius(self.restoreBtn)
        self.view.setButtonCornerRadius(self.clearBtn)
        self.view.setButtonCornerRadius(self.removeBtn)
        self.activityActor.hidden = true
        
        let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
        zipPath5 = path + "/task.zip"
        filePath = filePath + "/\((Cache_Inspector?.appUserName?.lowercaseString)!)"
        
        self.backupListTableView.delegate = self
        self.backupListTableView.dataSource = self
        self.backupListTableView.rowHeight = 120
        self.backupListTableView.hidden = true
        self.backupHistoryLabel.hidden = true
        self.restoreBtn.hidden = true
        self.upperLine.hidden = true
        self.downLine.hidden = true
        
        self.typeNow = self.typeListBackupFiles
        self.buffer.setData(NSMutableData())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLocalizedString(){
        self.navigationItem.leftBarButtonItem?.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("App Menu")
        self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Data Control")
        
    }
    
    func zipArchiveProgressEvent(loaded: UInt64, total: UInt64) {
        print("loaded: \(loaded) total: \(total)")
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
        //dispatch_async(dispatch_get_main_queue(), {
            let percentageUploaded = Float(loaded) / Float(total)
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.progressBar.progress = percentageUploaded
                
                if loaded == total {
                //if lroundf(100*percentageUploaded) == 100 {
                    self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Restore Complete")
                    
                    let keyValueDataHelper = KeyValueDataHelper()
                    keyValueDataHelper.updateLastRestoreDatetime(String(Cache_Inspector?.inspectorId), datetime: self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm"))
                    
                    
                    self.lastDownloadInput.text = self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm")
                    self.updateButtonsStatus(true)
                    self.backupListTableView.hidden = true
                    self.backupHistoryLabel.hidden = true
                    self.restoreBtn.hidden = true
                    self.upperLine.hidden = true
                    self.downLine.hidden = true
                    
                }else{
                    self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Decompressing")) \(String(lroundf(100*percentageUploaded)))%"
                    
                }
            })
        }
    }
    
    //在Caches文件夹下随机创建一个文件夹，并返回路径
    func tempDestPath() -> String? {
        var path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0]
        path += "/\(NSUUID().UUIDString)"
        let url = NSURL(fileURLWithPath: path)
        
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil)
            
        } catch {
            return nil
            
        }
        
        if let path = url.path {
            print("path:\(path)")
            return path
        }
        
        return nil
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func MenuButton(sender: UIBarButtonItem) {
        NSLog("Toggle Menu")
        
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }
    
    @IBAction func backupDataClick(sender: UIButton) {
        
        self.typeNow = self.typeBackup
        self.view.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup Data")+"?",parentVC:self, handlerFun: { (action:UIAlertAction!) in
            
            if self.backupDesc.text == "" {
                self.errorMsg.hidden = false
                return
                
            }else{
                self.errorMsg.hidden = true
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.activityActor.hidden = false
                self.activityActor.startAnimating()
                self.updateButtonsStatus(false)
                self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Compressing Data...")
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityActor.hidden = true
                    self.activityActor.stopAnimating()
                    self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Done")
                    //---------------------------- Backup Data First ------------------------------
                    //需要压缩的文件夹啊
                    SSZipArchive.createZipFileAtPath(self.zipPath5, withContentsOfDirectory: self.filePath)
                    //-----------------------------------------------------------------------------
                    
                    var param = _DS_UPLOADDBBACKUP["APIPARA"] as! [String:String]
                    param["service_token"] = _DS_SERVICETOKEN
                    param["db_filename"] = "task.zip"
                    param["db_file"] = self.zipPath5
                    param["backup_remarks"] = self.backupDesc.text
                    param["app_version"] = String(_VERSION)
                    param["app_release"] = _RELEASE
                    
                    let request = self.createBackupRequest(param, url: NSURL(string: _DS_UPLOADDBBACKUP["APINAME"] as! String)!)
                    let state = UIApplication.sharedApplication().applicationState
                    
                    if state == .Background {
                        
                        // background
                        self.sessionDownloadTask = self.bgSession?.downloadTaskWithRequest(request)
                        self.sessionDownloadTask?.resume()
                    }
                    else if state == .Active {
                        
                        // foreground
                        self.sessionDownloadTask = self.fgSession?.downloadTaskWithRequest(request)
                        self.sessionDownloadTask?.resume()
                    }
                })
            })
        })
    }
    
    func createBackupRequest (param: [String: String], url:NSURL) -> NSURLRequest {
        
        let boundary = self.generateBoundaryString()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = createBackupBodyWithParameters(param, boundary: boundary)
        
        return request
    }
    
    func createBackupBodyWithParameters(parameters: [String: String], boundary: String) -> NSData {
        let body = NSMutableData()
        
        //if parameters != nil {
        for (key, value) in parameters {
            if key != "db_file" {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }else{
                
                let url = NSURL(fileURLWithPath: value)
                let data = NSData(contentsOfURL: url)
                
                if data == nil {
                    self.view.alertView("No Zip File Found!")
                    return NSMutableData()
                }
                
                let mimetype = mimeTypeForPath(value)
                
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"task.zip\"\r\n")
                body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                body.appendData(data!)
                body.appendString("\r\n")
            }
        }
        //}
        
        body.appendString("--\(boundary)--\r\n")
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func mimeTypeForPath(path: String) -> String {
        return  "application/zip"
        //return "application/x-sqlite3";
    }
    
    func createRequest (param:String, url: NSURL) -> NSURLRequest {
        
        let boundary = self.generateBoundaryString()
        let body = NSMutableData()
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"req_msg\"\r\n\r\n")
        body.appendString("\(param)\r\n")
        body.appendString("--\(boundary)--\r\n")
        
        let request = NSMutableURLRequest(URL: url)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.timeoutInterval = 300
        request.HTTPBody = body
        request.HTTPShouldHandleCookies = false
        
        return request
    }
    
    @IBAction func removeOnClick(sender: UIButton) {
        
        self.view.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Data Cleanup?"),parentVC:self, handlerFun: { (action:UIAlertAction!) in
            
            self.handlePwChangeBeforeRedirect()
            
        })
    }
    
    func handlePwChangeBeforeRedirect() {
        let alert = UIAlertController(title: MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Input Your Password"), message: "", preferredStyle: UIAlertControllerStyle.Alert)
        let saveAction = UIAlertAction(title: MylocalizedString.sharedLocalizeManager.getLocalizedString("OK"), style: .Default, handler: { action in
            switch action.style{
            case .Default:
                print("default")
                
                let inspectorDataHelper = InspectorDataHelper()
                let inspector = inspectorDataHelper.getInspector((Cache_Inspector?.appUserName!)!, password: self.pWInput.text!.md5())
                
                if (inspector == nil) {
                    self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Password Not Correct!"))
                    return
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(), {
                        self.view.showActivityIndicator()
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            //remove file before restortion
                            let filemgr = NSFileManager.defaultManager()
                            let taskFilePath = self.filePath
                    
                            do {
                                if filemgr.fileExistsAtPath(taskFilePath) {
                                    let fileNames = try filemgr.contentsOfDirectoryAtPath("\(taskFilePath)")
                                    print("all files in folder: \(fileNames)")
                                    for fileName in fileNames {
                                        let filePathName = "\(taskFilePath)/\(fileName)"
                                        try filemgr.removeItemAtPath(filePathName)
                                
                                    }
                                    //delete folder
                                    try filemgr.removeItemAtPath(taskFilePath)
                                }
                        
                                self.view.removeActivityIndicator()
                                self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete Suceess."), handlerFun: { action in
                                    self.dismissViewControllerAnimated(true, completion: nil)
                            
                                })
                            } catch {
                                print("Could not clear temp folder: \(error)")
                            }
                        })
                    })
                }
 
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
                
            }
        })
        
        alert.addTextFieldWithConfigurationHandler(self.configurationPwInputTextField)
        alert.addAction(saveAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func configurationPwInputTextField(textField: UITextField!) {
        print("configurat hire the TextField")
        
        self.pWInput = textField!        //Save reference to the UITextField
        self.pWInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Input Your Password")
        self.pWInput.secureTextEntry = true
        
    }
    
    @IBAction func restoreDataOnClick(sender: UIButton) {
        
        self.typeNow = self.typeListBackupFiles
        
        dispatch_async(dispatch_get_main_queue(), {
            self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Listing Backup Files..."))"
        })
        
        //self.view.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Restore Data")+"?",parentVC:self, handlerFun: { (action:UIAlertAction!) in
            
            var param = "{"
            for (key, value) in _DS_LISTDBBACKUP["APIPARA"] as! Dictionary<String,String> {
                
                if key == "service_token" {
                    param += "\"\(key)\":\"\(_DS_SERVICETOKEN)\","
                }else if key == "app_version" {
                    param += "\"\(key)\":\"\(String(_VERSION))\","
                }else if key == "app_release" {
                    param += "\"\(key)\":\"\(_RELEASE)\","
                }else{
                    param += "\"\(key)\":\"\(value)\","
                }
                
            }
            param += "}"
            param = param.stringByReplacingOccurrencesOfString(",}", withString: "}")
            self.updateButtonsStatus(false)
        
            let request = self.createRequest(param, url: NSURL(string: _DS_LISTDBBACKUP["APINAME"] as! String)!)
            let state = UIApplication.sharedApplication().applicationState
        
            if state == .Background {
            
                // background
                self.sessionDownloadTask = self.bgSession?.downloadTaskWithRequest(request)
                self.sessionDownloadTask?.resume()
            }else if state == .Active {
            
                // foreground
                self.sessionDownloadTask = self.fgSession?.downloadTaskWithRequest(request)
                self.sessionDownloadTask?.resume()
            }
    }
    
    //------------------------------------- Delegate Funcs --------------------------------------------------------
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        
        //here you can get full lenth of your content
        expectedContentLength = Int(response.expectedContentLength)
        print("expectedContentLength: \(expectedContentLength)")
        completionHandler(NSURLSessionResponseDisposition.Allow)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("bytesSent: \(bytesSent) totalBytesSent: \(totalBytesSent) totalBytesExpectedToSend: \(totalBytesExpectedToSend)")
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            let percentageUploaded = 0.9 * Float(totalBytesSent) / Float(totalBytesExpectedToSend)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Uploading Backup File:")) \(String(lroundf(100*percentageUploaded)))%"
                self.progressBar.progress = percentageUploaded
            })
        }
    }
    
    func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
        self.bgSession!.finishTasksAndInvalidate()
        self.fgSession!.finishTasksAndInvalidate()
        print("Complete, Clear Session")
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        print("下载完成")
        
        buffer.setData(NSData.init(contentsOfURL: location)!)
        
        if self.typeNow == self.typeRestore {
        
        if Cache_Inspector?.appUserName == "" {
            self.view.alertView("No Login User Found.")
            return
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup Local Data...")
        })
        
        //dispatch_async(dispatch_get_main_queue(), {
        //---------------------------- Backup Data First ------------------------------
        //需要压缩的文件夹啊
        SSZipArchive.createZipFileAtPath(self.zipPath5, withContentsOfDirectory: self.filePath)
            
        //remove file before restortion
        let filemgr = NSFileManager.defaultManager()
        let taskFilePath = self.filePath //+ "/Tasks/"
            
        do {
            if filemgr.fileExistsAtPath(taskFilePath) {
                let fileNames = try filemgr.contentsOfDirectoryAtPath("\(taskFilePath)")
                print("all files in folder: \(fileNames)")
                for fileName in fileNames {
                    let filePathName = "\(taskFilePath)/\(fileName)"
                    try filemgr.removeItemAtPath(filePathName)
                    
                }
                //delete folder
                try filemgr.removeItemAtPath(taskFilePath)
            }
                
        } catch {
            print("Could not clear temp folder: \(error)")
            self.updateButtonsStatus(true)
        }
            
                    
        dispatch_async(dispatch_get_main_queue(), {
            self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Restore In Progress...")
        })
        
        //begin restore
        do {
            try SSZipArchive.unzipFileAtPath(location.path!, toDestination: self.filePath, overwrite: true, password: "", delegate: self)
            
            //Remove Zip File Here
            self.removeLocalBackupZipFile()
            
          
        } catch {
            
            do{
                try SSZipArchive.unzipFileAtPath(self.zipPath5, toDestination: self.filePath, overwrite: true, password: "", delegate: self)
                    
                //Remove Zip File Here
                self.removeLocalBackupZipFile()
                    
            }catch{
                print(error)
                dispatch_async(dispatch_get_main_queue(), {
                    self.passwordLabel.text = "\(error)"
                })
            }
            
            print(error)
            dispatch_async(dispatch_get_main_queue(), {
                self.passwordLabel.text = "\(error)"
            })
        }
        
        self.updateButtonsStatus(true)
        //Send local notification for Task Done.
        self.presentLocalNotification("Data Restore Complete.")
        }
    }
    
    //Download Task Process
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("正在下载 \(totalBytesWritten)/\(totalBytesExpectedToWrite)")
        
        print("totalBytesSent: \(totalBytesWritten) totalBytesExpectedToSend: \(totalBytesExpectedToWrite)")
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            let percentageUploaded = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if lroundf(100*percentageUploaded) >= 100 {
                    
                    if self.typeNow == self.typeRestore {
                        self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Restore In Progress..."))"
                    }else if self.typeNow == self.typeBackup {
                        
                        self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup In Progress..."))"
                    }
                    
                }else{
                    
                    if self.typeNow == self.typeRestore {
                        self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Downloading Backup File:")) \(String(lroundf(100*percentageUploaded)))%"
                    }else if self.typeNow == self.typeBackup {
                        self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Uploading Backup File:")) \(String(lroundf(100*percentageUploaded)))%"
                        
                    }
                    
                }
                
                self.progressBar.progress = percentageUploaded
            })
        }
    }
    
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        
        if(error != nil) {
            
            buffer.setData(NSMutableData())
            
            if error?.code == NSURLErrorTimedOut {
                let errorMsg = "The network connection was lost."
                print("\(errorMsg)")
                self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString(errorMsg))"
                
            }else if error?.code == NSURLErrorNotConnectedToInternet || error?.code == NSURLErrorCannotConnectToHost {
                let errorMsg = "The internet connection appears to be offline."
                
                print("\(errorMsg)")
                self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString(errorMsg))"
                
                
            }else{
                print("error: \(error!.localizedDescription), error code: \(error?.code)")
                
                self.passwordLabel.text = "\(error!.localizedDescription)"
            }
            
            self.updateButtonsStatus(true)
            
        }else if self.typeNow == self.typeListBackupFiles {
            
            do {
                if let responseDictionary = try NSJSONSerialization.JSONObjectWithData(buffer, options: []) as? NSDictionary {
                    print("success == \(responseDictionary)")
                    
                    if responseDictionary.count > 0 {
                        print("Name: \(responseDictionary["app_db_backup_list"])")
                        self.backupFileList = [BackupFile]()
                        let appBackupList = responseDictionary["app_db_backup_list"] as! [[String : String]]
                        for info in appBackupList {
                            
                            let backupFile = BackupFile(appRealse: info["app_release"]!, appVersion: info["app_version"]!, backupProcessDate: info["backup_process_date"]!, backupRemarks: info["backup_remarks"]!, backupSyncId: info["backup_sync_id"]!, deviceId: info["device_id"]!)
                            self.backupFileList.append(backupFile)
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.updateButtonsStatus(true)
                            self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("List Backup History Complete")
                            self.backupListTableView.reloadData()
                            self.backupListTableView.hidden = false
                            self.backupHistoryLabel.hidden = false
                            self.restoreBtn.hidden = false
                            self.upperLine.hidden = false
                            self.downLine.hidden = false
                            
                        })
                    }
                }
                
            } catch {
                dispatch_async(dispatch_get_main_queue(), {
                    let error = error as NSError
                    self.updateButtonsStatus(true)
                    self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString(error.localizedDescription))"
                    
                })
            }
            
            buffer.setData(NSMutableData())
            
        }else if self.typeNow == self.typeBackup {
            
            do {
                
                if let responseDictionary = try NSJSONSerialization.JSONObjectWithData(buffer, options: []) as? NSDictionary {
                    
                    if responseDictionary.count > 0 {
                        
                        let result = (UIViewController.init().nullToNil(responseDictionary["ul_result"]) == nil) ? "": responseDictionary["ul_result"] as! String
                        
                        if result == "OK" {
                            let keyValueDataHelper = KeyValueDataHelper()
                            keyValueDataHelper.updateLastBackupDatetime(String(Cache_Inspector?.inspectorId), datetime: self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm"))
                            self.lastUpdateInput.text = self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm")
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Complete")
                                self.updateButtonsStatus(true)
                                self.backupDesc.text = ""
                                self.backupListTableView.hidden = true
                                self.backupHistoryLabel.hidden = true
                                self.upperLine.hidden = true
                                
                                //Send local notification for Task Done.
                                self.presentLocalNotification("Data Backup Complete.")
                            })
                            
                            //Remove Zip File Here
                            self.removeLocalBackupZipFile()
                            
                            
                        }
                    }
                }
                
            } catch {
                dispatch_async(dispatch_get_main_queue(), {
                    print(error)
                    
                    let error = error as NSError
                    self.passwordLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup failed."))\(MylocalizedString.sharedLocalizeManager.getLocalizedString(error.localizedDescription))"
                    
                    self.removeLocalBackupZipFile()
                    let responseString = NSString(data: self.buffer, encoding: NSUTF8StringEncoding)
                    print("responseString = \(responseString)")
                })
            }
            
            buffer.setData(NSMutableData())
        }
        /*
        dispatch_async(dispatch_get_main_queue(), {
            self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Done")
            self.progressBar.progress = 100
            
        })*/
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("从 \(fileOffset) 处恢复下载，一共 \(expectedTotalBytes)")
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.backupFileList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let backupFile = self.backupFileList[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("BackupFileCell", forIndexPath: indexPath) as! BackupTableViewCell
        
        cell.appReleaseInput.text = backupFile.appRealse
        cell.appVersionInput.text = backupFile.appVersion
        cell.backupProcessDateInput.text = backupFile.backupProcessDate
        cell.backupRemarksInput.text = backupFile.backupRemarks
        cell.loginUserNameInput.text = Cache_Inspector?.appUserName
        
        if backupFile.backupProcessDate != "" {
            let dateFormatter:NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "\(_DATEFORMATTER) HH:mm"
            
            let locale2:NSLocale = NSLocale(localeIdentifier: "en_US")
            let timezone2:NSTimeZone = NSTimeZone(forSecondsFromGMT: 28800)
            let dateFormatter2:NSDateFormatter = NSDateFormatter()
            dateFormatter2.dateFormat = "\(_DATEFORMATTER) hh:mm:ss a"
            dateFormatter2.locale = locale2
            dateFormatter2.timeZone = timezone2
            
            cell.backupProcessDateInput.text = dateFormatter.stringFromDate(dateFormatter2.dateFromString(backupFile.backupProcessDate)!)
        }
        
        if backupFile.appRealse != "" {
            let dateTmp = backupFile.backupProcessDate
            let dateTmpArray = dateTmp.characters.split{$0 == " "}.map(String.init)
            
            if dateTmpArray.count>0 {
                cell.appReleaseInput.text = dateTmpArray[0]
                
                let dateFormatter:NSDateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = _DATEFORMATTER
                cell.appReleaseInput.text = dateFormatter.stringFromDate(dateFormatter.dateFromString(cell.appReleaseInput.text!)!)
            }
        }
        
        cell.backupRemarksInput.font = UIFont.systemFontOfSize(17)
        
        return cell
    }
    
    @IBAction func restoreBtnOnClick(sender: UIButton) {
        
        self.typeNow = self.typeRestore
        
        if self.selectedBackupFile == nil {
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Select Backup First"))
            return
        }
        
        self.view.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Restore Data")+"?",parentVC:self, handlerFun: { (action:UIAlertAction!) in
            
            let backupFile = self.selectedBackupFile
            
            var param = "{"
            for (key, value) in _DS_DBBACKUPDOWNLOAD["APIPARA"] as! Dictionary<String,String> {
                
                if key == "service_token" {
                    param += "\"\(key)\":\"\(_DS_SERVICETOKEN)\","
                }else if key == "backup_sync_id" {
                    param += "\"\(key)\":\"\(backupFile.backupSyncId)\","
                }else{
                    param += "\"\(key)\":\"\(value)\","
                }
                
            }
            param += "}"
            param = param.stringByReplacingOccurrencesOfString(",}", withString: "}")
            
            self.updateButtonsStatus(false)
            let request = self.createRequest(param, url: NSURL(string: _DS_DBBACKUPDOWNLOAD["APINAME"] as! String)!)
            let state = UIApplication.sharedApplication().applicationState
            
            if state == .Background {
                
                // background
                self.sessionDownloadTask = self.bgSession?.downloadTaskWithRequest(request)
                self.sessionDownloadTask!.resume()
            }else if state == .Active {
                
                // foreground
                self.sessionDownloadTask = self.fgSession?.downloadTaskWithRequest(request)
                self.sessionDownloadTask!.resume()
            }
            
            
            
            //self.sessionDownloadTask = self.session?.downloadTaskWithRequest(request)
            //self.sessionDownloadTask?.resume()
        })
    }
    
    @IBAction func clearBackupHistory(sender: UIButton) {
        self.backupListTableView.hidden = true
        self.backupHistoryLabel.hidden = true
        self.restoreBtn.hidden = true
        self.upperLine.hidden = true
        self.downLine.hidden = true
    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedBackupFile = self.backupFileList[indexPath.row]
    }
    
    func removeLocalBackupZipFile() {
        //Remove Zip File Here
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            print("Remove Zip File Here on the Background Queue.")
            let filemgr = NSFileManager.defaultManager()
            do {
                
                if filemgr.fileExistsAtPath(self.zipPath5) {
                    try filemgr.removeItemAtPath(self.zipPath5)
                }
                
            } catch {
                print("Could not clear Zip file: \(error)")
                self.updateButtonsStatus(true)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                print("Zip File has been Removed Successfully!")
            })
        })
    }
}
