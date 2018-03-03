//
//  DataControlView.swift
//  QCFossil
//
//  Created by Yin Huang on 6/5/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class DataControlView: UIView, NSURLSessionDelegate, NSURLSessionDownloadDelegate, SSZipArchiveDelegate, UITableViewDelegate, UITableViewDataSource {

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
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var backupDesc: UITextView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var btnsPanel: UIView!
    @IBOutlet weak var activityActor: UIActivityIndicatorView!
    
    
    typealias CompletionHandler = (obj:AnyObject?, success: Bool?) -> Void
    let filePath = NSHomeDirectory() + "/Documents"
    var zipPath5 = NSHomeDirectory() + "/task.zip"
    var buffer:NSMutableData = NSMutableData()
    var expectedContentLength = 0
    var session: NSURLSession?
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
        initPage()
        
    }
    
    func initPage() {
        
        self.errorMsg.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Please input description for backup data.")
        self.descLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Description")
        self.loginUserLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Login User")
        self.lastLoginDate.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Last Login Date")
        self.lastDownload.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Last Rstore Date")
        self.lastUpdate.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Last Backup Date")
        self.passwordLabel.text = ""
        self.backupBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup Data"), forState: UIControlState.Normal)
        self.restoreDataBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Restore Data"), forState: UIControlState.Normal)
        self.lastLoginDateInput.text = Cache_Inspector?.lastLoginDate
        
        let keyValueDataHelper = KeyValueDataHelper()
        self.lastUpdateInput.text = keyValueDataHelper.getLastBackupDatetimeByUserId(String(Cache_Inspector?.inspectorId))
        self.lastDownloadInput.text = keyValueDataHelper.getLastRestoreDatetimeByUserId(String(Cache_Inspector?.inspectorId))
        
        self.setButtonCornerRadius(self.backupBtn)
        self.setButtonCornerRadius(self.restoreDataBtn)
        self.activityActor.hidden = true
        
        let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory,
                                                       .UserDomainMask, true)[0]
        zipPath5 = path + "/task.zip"
        
    }
    
    func zipArchiveProgressEvent(loaded: UInt64, total: UInt64) {
        print("loaded: \(loaded) total: \(total)")
        
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            let percentageUploaded = Float(loaded) / Float(total)
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.progressBar.progress = percentageUploaded
                
                if lroundf(100*percentageUploaded) == 100 {
                    self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Complete")
                    let keyValueDataHelper = KeyValueDataHelper()
                    keyValueDataHelper.updateLastRestoreDatetime(String(Cache_Inspector?.inspectorId), datetime: self.getCurrentDateTime())
                    
                    self.lastDownloadInput.text = self.getCurrentDateTime()
                    
                }else{
                    self.passwordLabel.text = "Decompressing \(String(lroundf(100*percentageUploaded)))%"
                }
            })
        }
    }
    
    //在Caches文件夹下随机创建一个文件夹，并返回路径
    func tempDestPath() -> String? {
        var path = NSSearchPathForDirectoriesInDomains(.CachesDirectory,
            .UserDomainMask, true)[0]
        path += "/\(NSUUID().UUIDString)"
        let url = NSURL(fileURLWithPath: path)
        
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(url,
                withIntermediateDirectories: true, attributes: nil)
        } catch {
            return nil
        }
        
        if let path = url.path {
            print("path:\(path)")
            return path
        }
        
        return nil
    }
    
    @IBAction func backupDataClick(sender: UIButton) {
        /*UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.btnsPanel.center.y += 90
            self.descLabel.alpha = 1
            self.backupDesc.alpha = 1
            self.layoutIfNeeded()
            
            }, completion: {(action:UIAlertAction!) in
        
        })*/
        
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Backup Data")+"?",parentVC:self.parentVC!, handlerFun: { (action:UIAlertAction!) in
        
            if self.backupDesc.text == "" {
                self.errorMsg.hidden = false
                return
                
            }else{
                self.errorMsg.hidden = true
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.activityActor.hidden = false
                self.activityActor.startAnimating()
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
                    param["db_filename"] = "task.zip"
                    param["db_file"] = self.zipPath5
                    param["backup_remarks"] = self.backupDesc.text
                    param["app_version"] = String(_VERSION)
                    param["app_release"] = _RELEASE
                    
                    let request = self.createRequest(param, url: NSURL(string: _DS_UPLOADDBBACKUP["APINAME"] as! String)!)
                
                    let task = self.session!.dataTaskWithRequest(request) { data, response, error in
                        if error != nil {
                        
                            print(error)
                            self.passwordLabel.text = "\(error)"
                            return
                        }
                    
                        do {
                            if let responseDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                                print("success == \(responseDictionary)")
                                
                                if responseDictionary.count > 0 {
                                
                                let result = (UIViewController.init().nullToNil(responseDictionary["ul_result"]) == nil) ? "": responseDictionary["ul_result"] as! String
                                
                                if result == "OK" {
                                    let keyValueDataHelper = KeyValueDataHelper()
                                    keyValueDataHelper.updateLastBackupDatetime(String(Cache_Inspector?.inspectorId), datetime: self.getCurrentDateTime("\(_DATEFORMATTER) HH:mm"))
                                    self.lastUpdateInput.text = self.getCurrentDateTime("\(_DATEFORMATTER) HH:mm")
                                    
                                    dispatch_async(dispatch_get_main_queue(), {
                                        self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Complete")
                                    })
                                    
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
                                        }
                                        
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            print("Zip File has been Removed Successfully!")
                                        })
                                    })
                                }
                            }
                        }
                        
                        } catch {
                            dispatch_async(dispatch_get_main_queue(), {
                                print(error)
                                self.passwordLabel.text = "\(error)"
                                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                                print("responseString = \(responseString)")
                            })
                        }
                    }
                
                    task.resume()
                })
            })
        })
    }
    
    func createRequest (param: [String: String], url:NSURL) -> NSURLRequest {
   
        let boundary = self.generateBoundaryString()
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = createBodyWithParameters(param, boundary: boundary)
        
        return request
    }
    
    func createBodyWithParameters(parameters: [String: String], boundary: String) -> NSData {
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
                        self.alertView("No Zip File Found!")
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
    
    func createBackupListRequest () -> NSURLRequest {
        
        let boundary = self.generateBoundaryString()
        let body = NSMutableData()
        
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
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"req_msg\"\r\n\r\n")
        body.appendString("\(param)\r\n")
        body.appendString("--\(boundary)--\r\n")
        
        let request = NSMutableURLRequest(URL: NSURL(string: _DS_LISTDBBACKUP["APINAME"] as! String)!)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.timeoutInterval = 60
        request.HTTPBody = body
        request.HTTPShouldHandleCookies = false
        
        return request
    }
    
    @IBAction func removeOnClick(sender: UIButton) {
        
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Delete?"),parentVC:self.parentVC!, handlerFun: { (action:UIAlertAction!) in
            
            if "12" != "123" {
                self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Password Not Correct!"))
                return
                
            }else{
                self.removeFromSuperview()
            }
        })
    }
    
    @IBAction func restoreDataOnClick(sender: UIButton) {
        
        self.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Restore Data")+"?",parentVC:self.parentVC!, handlerFun: { (action:UIAlertAction!) in
            
            let request = self.createBackupListRequest()
            let task = self.session!.dataTaskWithRequest(request) { data, response, error in
                if error != nil {
                    
                    print(error)
                    self.passwordLabel.text = "\(error)"
                    return
                }
                
                do {
                    if let responseDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                        print("success == \(responseDictionary)")
                        
                        if responseDictionary.count > 0 {
                            print("Name: \(responseDictionary["app_db_backup_list"])")
                            
                            let appBackupList = responseDictionary["app_db_backup_list"] as! [[String : String]]
                            for info in appBackupList {
                                print("\(info["app_release"])")
                                print("\(info["app_version"])")
                                print("\(info["backup_process_date"])")
                                print("\(info["backup_remarks"])")
                                print("\(info["backup_sync_id"])")
                                print("\(info["device_id"])")
                            }
                        }
                    }
                    
                } catch {
                    dispatch_async(dispatch_get_main_queue(), {
                        print(error)
                        self.passwordLabel.text = "\(error)"
                        let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print("responseString = \(responseString)")
                    })
                }
            }
            
            task.resume()
            
            /*
            do {
                
                try SSZipArchive.unzipFileAtPath(self.zipPath5, toDestination: self.filePath, overwrite: true, password: "", delegate: self)
                
                /*
                // 服务器上zip文件地址
                let url = NSURL(string: "http://localhost:8080/MJServer/resources/videos/videos.zip")
                // 发送请求，下载文件
                let task = NSURLSession.sharedSession().downloadTaskWithURL(url!) { (location, response, error) -> Void in
            
                // 解压缩zip文件
                SSZipArchive.unzipFileAtPath((location?.path)!, toDestination: self.filePath)
                }
            
                // 开始下载
                task.resume()
                */
                
            }catch {
                print(error)
                self.passwordLabel.text = "\(error)"
            }
            */
        })
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
            let percentageUploaded = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.passwordLabel.text = "\(String(lroundf(100*percentageUploaded)))%"
                self.progressBar.progress = percentageUploaded
            })
        }
    }
    
    func URLSession(session: NSURLSession, didBecomeInvalidWithError error: NSError?) {
        self.session!.finishTasksAndInvalidate()
        print("Complete, Clear Session")
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        print("下载完成")
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("正在下载 \(totalBytesWritten)/\(totalBytesExpectedToWrite)")
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        print("从 \(fileOffset) 处恢复下载，一共 \(expectedTotalBytes)")
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        
        return cell
    }
}
