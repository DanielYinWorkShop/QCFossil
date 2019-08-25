//
//  CustomExtensionObjects.swift
//  QCFossil
//
//  Created by Yin Huang on 18/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit
import AssetsLibrary
import ImageIO

/* Input Mode 04 */
extension InputMode04View {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> InputMode04View? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? InputMode04View
    }
}

extension InputMode04CellView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> InputMode04CellView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? InputMode04CellView
    }
}

extension DefectHeaderView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> DefectHeaderView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? DefectHeaderView
    }
}

extension InputMode04DefectCellView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> InputMode04DefectCellView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? InputMode04DefectCellView
    }
}

extension CreateTaskView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> CreateTaskView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? CreateTaskView
    }
}

extension POSearchView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> POSearchView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? POSearchView
    }
}

extension PopoverViewsInput {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> PopoverViewsInput? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? PopoverViewsInput
    }
}

extension InptCategoryCell {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> InptCategoryCell? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? InptCategoryCell
    }
}

extension TaskDetailViewInput {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> TaskDetailViewInput? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? TaskDetailViewInput
    }
}

extension TaskQCInfoView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> TaskQCInfoView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? TaskQCInfoView
    }
}

extension POInfoView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> POInfoView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? POInfoView
    }
}

/* Input Mode 01 */
extension InputMode01View {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> InputMode01View? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? InputMode01View
    }
}

extension InputMode01CellView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> InputMode01CellView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? InputMode01CellView
    }
}

extension InputMode01DefectCellView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> InputMode01DefectCellView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? InputMode01DefectCellView
    }
}


/* Input Mode 02 */
extension InputMode02View {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> InputMode02View? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? InputMode02View
    }
}

extension InputMode02CellView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> InputMode02CellView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? InputMode02CellView
    }
}

extension InputMode02DefectCellView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> InputMode02DefectCellView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? InputMode02DefectCellView
    }
}


/* Input Mode 03 */
extension InputMode03View {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> InputMode03View? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? InputMode03View
    }
}

extension InputMode03CellView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> InputMode03CellView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? InputMode03CellView
    }
}

extension InputMode03DefectCellView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> InputMode03DefectCellView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? InputMode03DefectCellView
    }
}

extension DropdownListViewControl {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> DropdownListViewControl? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? DropdownListViewControl
    }
}

extension InspectionViewInput {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> InspectionViewInput? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? InspectionViewInput
    }
}

extension POCellViewInput {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> POCellViewInput? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? POCellViewInput
    }
}

extension ImagePreviewViewInput {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> ImagePreviewViewInput? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? ImagePreviewViewInput
    }
}

extension CalenderPickerViewInput {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> CalenderPickerViewInput? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? CalenderPickerViewInput
    }
}

extension DataControlView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> DataControlView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? DataControlView
    }
}

extension ShapePreviewViewInput {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> ShapePreviewViewInput? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? ShapePreviewViewInput
    }
}

class DownloadRequester:NSObject, NSURLSessionDelegate, NSURLSessionDownloadDelegate {
    
    var session: NSURLSession?
    var buffer:NSMutableData = NSMutableData()
    var expectedContentLength = 0
    var dsDataObj:AnyObject?
    var dataSet = [Dictionary<String, String>]()
    
    override init() {
        
        super.init()
        
        /*let imageURL = NSURL(string: "http://tw.mjjq.com/pic/20070510/20070510032908935.jpg")!
        session = NSURLSession(configuration: NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("taask"), delegate: self, delegateQueue: nil)
        
        session?.downloadTaskWithURL(imageURL).resume()
        */
        
        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
        
    }
    
    func makeDLRequest(dsData:AnyObject) {
        let task = session?.dataTaskWithRequest(createDLRequest(dsData))
        task!.resume()
    }
    
    func createDLRequest(dsData:AnyObject) -> NSURLRequest {
        self.dsDataObj = dsData
        
        var param = "\(_DS_PREFIX){"
        for (key, value) in dsData["APIPARA"] as! Dictionary<String,String> {
            param += "\"\(key)\":\"\(value)\","
        }
        param += "}"
        param = param.stringByReplacingOccurrencesOfString(",}", withString: "}")
        
        let request = NSMutableURLRequest(URL: NSURL(string: dsData["APINAME"] as! String)!)
        request.HTTPMethod = "POST"
        request.timeoutInterval = 60
        request.HTTPBody = param.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPShouldHandleCookies = false
        
        return request
    }
    
    //------------------------------------- Delegate Funcs --------------------------------------------------------
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        
        buffer.appendData(data)
        
        let percentageDownloaded = Float(buffer.length) / Float(expectedContentLength)
        print("progress: \(Float(buffer.length)) \(percentageDownloaded)")
        //progress.progress =  percentageDownloaded
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        
        //here you can get full lenth of your content
        expectedContentLength = Int(response.expectedContentLength)
        print("expectedContentLength: \(expectedContentLength)")
        completionHandler(NSURLSessionResponseDisposition.Allow)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        //use buffer here.Download is done
        //progress.progress = 1.0   // download 100% complete
        
        if(error != nil) {
            print(error!.localizedDescription)
            let jsonStr = NSString(data: buffer, encoding: NSUTF8StringEncoding)
            print("Error could not parse JSON: '\(jsonStr)'")
        }
        else {
            
            do {
                let jsonData = try NSJSONSerialization.JSONObjectWithData(buffer, options: .AllowFragments) as! NSDictionary
                let actionNames = self.dsDataObj!["ACTIONNAMES"] as! [String]
                let actionFields:Dictionary<String, [String]> = self.dsDataObj!["ACTIONFIELDS"] as! Dictionary
            
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
                    
                    print("records: \(dataSet)")
                    
                    print("下载完成!")
                    
                } else{
                
                }
            }
            catch {
                    print("error serializing JSON: \(error)")
            }
            
        }
        
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
}

extension UIViewController {
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }
    
    /*
     Error Code: 
     kCFURLErrorUnknown   = -998,
     kCFURLErrorCancelled = -999,
     kCFURLErrorBadURL    = -1000,
     kCFURLErrorTimedOut  = -1001,
     kCFURLErrorUnsupportedURL = -1002,
     kCFURLErrorCannotFindHost = -1003,
     kCFURLErrorCannotConnectToHost    = -1004,
     kCFURLErrorNetworkConnectionLost  = -1005,
     kCFURLErrorDNSLookupFailed        = -1006,
     kCFURLErrorHTTPTooManyRedirects   = -1007,
     kCFURLErrorResourceUnavailable    = -1008,
     kCFURLErrorNotConnectedToInternet = -1009,
     kCFURLErrorRedirectToNonExistentLocation = -1010,
     kCFURLErrorBadServerResponse             = -1011,
     kCFURLErrorUserCancelledAuthentication   = -1012,
     kCFURLErrorUserAuthenticationRequired    = -1013,
     kCFURLErrorZeroByteResource        = -1014,
     kCFURLErrorCannotDecodeRawData     = -1015,
     kCFURLErrorCannotDecodeContentData = -1016,
     kCFURLErrorCannotParseResponse     = -1017,
     kCFURLErrorInternationalRoamingOff = -1018,
     kCFURLErrorCallIsActive               = -1019,
     kCFURLErrorDataNotAllowed             = -1020,
     kCFURLErrorRequestBodyStreamExhausted = -1021,
     kCFURLErrorFileDoesNotExist           = -1100,
     kCFURLErrorFileIsDirectory            = -1101,
     kCFURLErrorNoPermissionsToReadFile    = -1102,
     kCFURLErrorDataLengthExceedsMaximum   = -1103
     */
    func makePostRequest(urlPath:String, dataInJson:String, method:String="POST", actionNames:[String]=[], actionFields:Dictionary<String, [String]>, type:String="DL", handler:(result:[Dictionary<String, String>]?,response:String,totalRecords:Int)-> Void) {
        
        let urlPath = urlPath
        let url = NSURL(string: urlPath)
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = method
        let jsonStringPost = dataInJson
        let data = jsonStringPost.dataUsingEncoding(NSUTF8StringEncoding)
        
        request.timeoutInterval = 60
        request.HTTPBody = data
        request.HTTPShouldHandleCookies = false
        
        let queue:NSOperationQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{
            (response, data, error) in
            
            if error != nil {
                //Handle Error here
                print("error data \(data) , response \(response)")
                
                if (error?.code)! == NSURLErrorCannotConnectToHost {
                    handler(result: nil, response: "Fail", totalRecords: 0)
                }else if (error?.code)! == NSURLErrorNotConnectedToInternet {
                    handler(result: nil, response: "Fail", totalRecords: 0)
                }else if (error?.code)! == NSURLErrorCannotFindHost {
                    handler(result: nil, response: "Fail", totalRecords: 0)
                }else if (error?.code)! == NSURLErrorNetworkConnectionLost {
                    handler(result: nil, response: "Fail", totalRecords: 0)
                }else{
                    handler(result: nil, response: "Fail", totalRecords: 0)
                    //self.view.alertView("Login Error: \(error) Error Code: \((error?.code)!)")
                }
            }else{
                
                if type == "UL" {
                    self.getULResponseData(actionNames, data: data!, handler: handler)
                }else{
                    self.getResponseData(actionNames, actionFields: actionFields, data: data!, handler: handler)
                }
            }
        })
    }
    
    func sendRequestData(actionNames:[String], actionFields:Dictionary<String, [String]>, data:NSData, handler:(result:[Dictionary<String, String>]?,response:String)-> Void) {
    }
    
    func getResponseData(actionNames:[String], actionFields:Dictionary<String, [String]>, data:NSData, handler:(result:[Dictionary<String, String>]?,response:String,totalRecords:Int)-> Void) {
        
        //Handle data in NSData type
        var dataSet = [Dictionary<String, String>]()
        
        do {
            let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
            var recordCount = 0
            
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
                            
                            recordCount += 1
                            dataSet.append(dataObj)
                        }
                        
                    }else if let mstrData = jsonData[actionNames[idx]] as? [String: AnyObject] {
                        for (key, value) in mstrData {
                            
                            dataObj[key] = value as? String
                            recordCount += 1
                        }
                        
                        dataSet.append(dataObj)
                    }
                }
                
                var session_result = (jsonData["service_session"] == nil) ? "": jsonData["service_session"] as! String
                session_result += (self.nullToNil(jsonData["action_result"]) == nil) ? "": jsonData["action_result"] as! String
                
                handler(result: dataSet, response: session_result, totalRecords: recordCount)
            } else{
                var session_result = (jsonData["action_result"] == nil) ? "": jsonData["action_result"] as! String
                session_result += (self.nullToNil(jsonData["ack_result"]) == nil) ? "": jsonData["ack_result"] as! String
                
                handler(result: dataSet, response: session_result, totalRecords: 0)
            }
            
            //resultSet = dataSet
        } catch {
            print("error serializing JSON: \(error)")
        }
        
    }
    
    func getULResponseData(actionFields:[String], data:NSData, handler:(result:[Dictionary<String, String>]?,response:String,totalRecords:Int)-> Void) {
        
        //Handle data in NSData type
        var dataSet = [Dictionary<String, String>]()
        
        do {
            let jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
            var recordCount = 0
            
            if jsonData.count > 0 {
                var dataObj = Dictionary<String, String>()
                
                for (key,value) in jsonData {
                    dataObj[key as! String] = value as? String
                    
                    recordCount += 1
                }
                
                dataSet.append(dataObj)
                
                var result = (jsonData["service_session"] == nil) ? "": jsonData["service_session"] as! String
                result += (self.nullToNil(jsonData["action_result"]) == nil) ? "": jsonData["action_result"] as! String
                
                handler(result: dataSet, response: result, totalRecords: recordCount)
            } else{
                var result = (jsonData["action_result"] == nil) ? "": jsonData["action_result"] as! String
                result += (self.nullToNil(jsonData["ack_result"]) == nil) ? "": jsonData["ack_result"] as! String
                
                handler(result: dataSet, response: result, totalRecords: 0)
            }
            
            //resultSet = dataSet
        } catch {
            print("error serializing JSON: \(error)")
        }
        
    }
    
    func requestUrl(urlString: String){
        let url: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{
            (response, data, error) -> Void in
            
            if error != nil {
                //Handle Error here
                print("error data \(data) , response \(response)")
            }else{
                //Handle data in NSData type
                print("data \(data) , response \(response)")
            }
            
        })
    }
    
    func presentLocalNotification(message:String) {
        //Send local notification for Task Done.
        let localNotification = UILocalNotification()
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 0)
        localNotification.alertBody = MylocalizedString.sharedLocalizeManager.getLocalizedString(message)
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
        UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
    }
}

extension UIView {
    weak var parentVC: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.nextResponder()
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func getCurrentDate(dateFormat:String=_DATEFORMATTER) ->String {
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateFormat
       // dateFormatter.timeZone = NSTimeZone.localTimeZone()
        let locale:NSLocale = NSLocale(localeIdentifier: "en_US")
        let timezone:NSTimeZone = NSTimeZone(forSecondsFromGMT: 28800)
        dateFormatter.locale = locale
        dateFormatter.timeZone = timezone
        
        return dateFormatter.stringFromDate(todaysDate)
    }
    
    func getCurrentDateTime(dateFormat:String=_DATEFORMATTER + " hh:mm:ss a") ->String {
        
        
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        //dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = dateFormat //dateFormat + " HH:mm a"
        
        let locale:NSLocale = NSLocale(localeIdentifier: "en_US")
        let timezone:NSTimeZone = NSTimeZone(forSecondsFromGMT: 28800)
        dateFormatter.locale = locale
        dateFormatter.timeZone = timezone

        return dateFormatter.stringFromDate(todaysDate)
        
        /*
        var timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        
        //if !_ENGLISH {
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Jan", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Jan"))
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Feb", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Feb"))
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Mar", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Mar"))
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Apr", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Apr"))
            
            timestamp = timestamp.stringByReplacingOccurrencesOfString("May", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("May"))
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Jun", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Jun"))
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Jul", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Jul"))
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Aug", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Aug"))
            
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Sep", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Sep"))
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Oct", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Oct"))
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Nov", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Nov"))
            timestamp = timestamp.stringByReplacingOccurrencesOfString("Dec", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("Dec"))
            
            timestamp = timestamp.stringByReplacingOccurrencesOfString("AM", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("am"))
            timestamp = timestamp.stringByReplacingOccurrencesOfString("PM", withString: MylocalizedString.sharedLocalizeManager.getLocalizedString("pm"))
        //}
        
        return timestamp*/
    }
    
    func getFormattedStringByDateString(dateString: String) ->String {
        
        let dateFormatter = NSDateFormatter()
        var localeId = dateFormatter.locale.localeIdentifier
        if !localeId.hasSuffix("_POSIX") {
            localeId = localeId + ("_POSIX")
            dateFormatter.locale = NSLocale(localeIdentifier: localeId)
        }
        dateFormatter.dateFormat = "\(_DATEFORMATTER) hh:mm:ss a"
        
        let formattedDate = dateFormatter.dateFromString(dateString)
        /*
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "\(_DATEFORMATTER) hh:mm:ss a"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_HK_POSIX")
        dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0)
        
        dateFormatter.dateFormat = "\(_DATEFORMATTER) hh:mm:ss a"
        let formattedDate = dateFormatter.dateFromString(dateString)
        */
        let dfmatter2 = NSDateFormatter()
        dfmatter2.dateFormat = "\(_DATEFORMATTER) HH:mm:ss a"
 
        guard let newFormattedDate = formattedDate else{
            return ""
        }
        
        return dfmatter2.stringFromDate(newFormattedDate)
    }
    
    func showActivityIndicator(title:String="Loading") {
        let container: UIView = UIView()
        container.tag = _MASKVIEWTAG
        container.hidden = false
        container.frame = self.frame
        container.center = self.center
        container.backgroundColor = UIColor.clearColor()
        container.alpha = 0.7
        //container.backgroundColor = UIColor.whiteColor()
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = self.center
        loadingView.backgroundColor = UIColor.blackColor()
        loadingView.alpha = 1.0
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        label.text = MylocalizedString.sharedLocalizeManager.getLocalizedString(title)
        label.font =  label.font.fontWithSize(14)
        label.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2+25)
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        actInd.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2)
        
        loadingView.addSubview(actInd)
        loadingView.addSubview(label)
        container.addSubview(loadingView)
        self.addSubview(container)
        actInd.startAnimating()
    }
    
    func removeActivityIndicator() {
        self.subviews.forEach({if $0.tag == _MASKVIEWTAG {$0.removeFromSuperview()} })
    }
    
    func alertView(title:String, handlerFun:((UIAlertAction)->Void)?=nil) {
        let alertController = UIAlertController(title: title, message:
            "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: MylocalizedString.sharedLocalizeManager.getLocalizedString("OK"), style: UIAlertActionStyle.Default,handler: handlerFun))
        
        self.parentVC?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func alertConfirmView(title:String, message:String="",parentVC:UIViewController, handlerFun:((UIAlertAction)->Void)?=nil, handlerFunCancel:((UIAlertAction)->Void)?=nil) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okButton = UIAlertAction(title: MylocalizedString.sharedLocalizeManager.getLocalizedString("OK"), style: UIAlertActionStyle.Default, handler: handlerFun)
        let cancelButton = UIAlertAction(title: MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel"), style: .Cancel, handler: handlerFunCancel)
        alertController.addAction(cancelButton)
        alertController.addAction(okButton)
        
        parentVC.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func alertConfirmViewStyle3(title:String, message:String="",parentVC:UIViewController, handlerFunYes:((UIAlertAction)->Void)?=nil, handlerFunNo:((UIAlertAction)->Void)?=nil, handlerFunCancel:((UIAlertAction)->Void)?=nil) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        
        let yesButton = UIAlertAction(title: MylocalizedString.sharedLocalizeManager.getLocalizedString("Yes"), style: UIAlertActionStyle.Default, handler: handlerFunYes)
        let noButton = UIAlertAction(title: MylocalizedString.sharedLocalizeManager.getLocalizedString("No"), style: UIAlertActionStyle.Default, handler: handlerFunNo)
        let cancelButton = UIAlertAction(title: MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel"), style: UIAlertActionStyle.Default/*.Cancel*/, handler: handlerFunCancel)
        
        alertController.addAction(yesButton)
        alertController.addAction(noButton)
        alertController.addAction(cancelButton)
        
        parentVC.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func clearDropdownviewForSubviews(view:UIView) {
        Cache_Dropdown_Instance = nil
        
        // Get the subviews of the view
        let subviews = view.subviews
        
        // Return if there are no subviews
        if subviews.count < 1 {
            return
        }
        
        subviews.forEach({
            if $0.classForCoder == DropdownListViewControl.classForCoder() {
                ($0 as! DropdownListViewControl).myParentTextField?.endEditing(true)
                $0.removeFromSuperview()
            }else if $0.classForCoder == UITextField.classForCoder() /*|| $0.classForCoder == UITextView.classForCoder()*/ {
                $0.resignFirstResponder()
            }
            
            clearDropdownviewForSubviews($0)
        })
    }
    
    func ifExistingSubviewByViewTag(view:UIView, tag:Int) ->Bool {
        
        if (view.viewWithTag(tag) != nil) {
            return true
        }
        
        return false
    }
    
    func resignFirstResponderByTextField(view:UIView) {
        
        // Get the subviews of the view
        let subviews = view.subviews
        
        // Return if there are no subviews
        if subviews.count < 1 {
            return
        }
        
        subviews.forEach({
            if $0.classForCoder == UITextField.classForCoder() || $0.classForCoder == UITextView.classForCoder() {
                $0.resignFirstResponder()
            }
            
            resignFirstResponderByTextField($0)
        })
    }
    
    func disableAllFunsForView(view:UIView) {
        // Get the subviews of the view
        let subviews = view.subviews
        
        // Return if there are no subviews
        if subviews.count < 1 {
            return
        }
        
        subviews.forEach({
            
            if $0.classForCoder == CustomControlButton.classForCoder() || $0.classForCoder == UIButton.classForCoder() || $0.classForCoder == UITextField.classForCoder() || $0.classForCoder == SignoffView.classForCoder() || $0.classForCoder == CustomTextView.classForCoder() {
                disableFuns($0)
            }
            
            disableAllFunsForView($0)
        })
    }
    
    func disableFuns(obj:AnyObject = UIButton()) ->Bool {
        if (Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Confirmed").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Cancelled").rawValue) && !_DEBUG_MODE {
            if obj.classForCoder == UIButton.classForCoder() {
                (obj as! UIButton).removeTarget(nil, action:nil, forControlEvents:UIControlEvents.AllEvents)
                (obj as! UIButton).addTarget(self, action: #selector(UIView.btnFunDisble), forControlEvents: UIControlEvents.TouchUpInside)
            }else if obj.classForCoder == UITextField.classForCoder() {
                (obj as! UITextField).userInteractionEnabled = false
            }else if obj.classForCoder == SignoffView.classForCoder() {
                (obj as! SignoffView).userInteractionEnabled = false
            }else if obj.classForCoder == CustomTextView.classForCoder() {
                (obj as! CustomTextView).userInteractionEnabled = false
            }

            return true
        }else if (Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Reviewed").rawValue || Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Refused").rawValue) {
            
            if obj.classForCoder == UIButton.classForCoder() {
                (obj as! UIButton).removeTarget(nil, action:nil, forControlEvents:UIControlEvents.AllEvents)
                (obj as! UIButton).addTarget(self, action: #selector(UIView.btnFunDisbleForUploaded), forControlEvents: UIControlEvents.TouchUpInside)
                
            }else if obj.classForCoder == CustomControlButton.classForCoder() {
                (obj as! CustomControlButton).removeTarget(nil, action:nil, forControlEvents:UIControlEvents.AllEvents)
                (obj as! CustomControlButton).addTarget(self, action: #selector(UIView.btnFunDisbleForUploaded), forControlEvents: UIControlEvents.TouchUpInside)
            
            }else if obj.classForCoder == UITextField.classForCoder() {
                (obj as! UITextField).userInteractionEnabled = false
            }else if obj.classForCoder == SignoffView.classForCoder() {
                (obj as! SignoffView).userInteractionEnabled = false
            }else if obj.classForCoder == CustomTextView.classForCoder() {
                (obj as! CustomTextView).userInteractionEnabled = false
            }
            
            return true
        }
        
        return false
    }
    
    func setButtonCornerRadius(button:UIButton) {
        button.layer.cornerRadius = 6
    }
    
    func btnFunDisble() {
        self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cannot update Confirmed or Cancelled Task!"))
    }
    
    func btnFunDisbleForUploaded() {
        self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cannot update Uploaded, Reviewed or Refused Task!"))
    }
    
    func createTaskFolderById(bookingNo:String) ->Bool {
        
        let taskPath = _TASKSPHYSICALPATH+bookingNo
        
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(taskPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
        let taskThumbsPath = taskPath + "/" + _THUMBSPHYSICALNAME
        
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(taskThumbsPath, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
        return true
    }
    
    func deleteTask(taskId:Int){
        
        let taskDataHelper = TaskDataHelper()
        
        let taskFderName = taskDataHelper.getBookingNoByTaskId(taskId)
        
        if taskFderName == "" {
            print("No task Fder found for taskId: \(taskId)")
            return
        }
        
        let filemgr = NSFileManager.defaultManager()
        let taskFilePath = _TASKSPHYSICALPATH+"\(taskFderName)"
        let taskThumbFilePath = taskFilePath+"/Thumbs"
        do {
            
            if filemgr.fileExistsAtPath(taskFilePath) {
                let fileNames = try filemgr.contentsOfDirectoryAtPath("\(taskFilePath)")
                print("all files in folder: \(fileNames)")
                for fileName in fileNames {
                    
                    if (fileName.hasSuffix(".jpg"))
                    {
                        let filePathName = "\(taskFilePath)/\(fileName)"
                        try filemgr.removeItemAtPath(filePathName)
                    }
                }
                //delete folder
                try filemgr.removeItemAtPath(taskFilePath)
            }
            
            if filemgr.fileExistsAtPath(taskThumbFilePath) {
                let fileThumbs = try filemgr.contentsOfDirectoryAtPath("\(taskThumbFilePath)")
                for fileName in fileThumbs {
                
                    if (fileName.hasSuffix(".jpg"))
                    {
                        let filePathName = "\(taskThumbFilePath)/\(fileName)"
                        try filemgr.removeItemAtPath(filePathName)
                    }
                }
                //delete folder
                try filemgr.removeItemAtPath(taskThumbFilePath)
            }
            
            let taskDataHelper = TaskDataHelper()
            if !taskDataHelper.deleteTaskById(taskId) {
                UIView.init().alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Delete Fail!"))
            }
            
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    func currentFirstResponder() -> UIResponder? {
        if self.isFirstResponder() {
            return self
        }
        
        for view in self.subviews {
            if let responder = view.currentFirstResponder() {
                return responder
            }
        }
        
        return nil
    }
    
    //Get File in Preferences
    func getPreferencesFilePath() ->String? {
        let path = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
        let url = NSURL(fileURLWithPath: path)
        
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(url, withIntermediateDirectories: true, attributes: nil)
            
        } catch {
            return nil
            
        }
        
        if let path = url.path {
            
            return "\(path)/Preferences"
        }
        
        return nil
    }
    
    func sortStringArrayByName(arrayString:[String]) ->[String] {
        let locale = _ENGLISH ? NSLocale(localeIdentifier: "en_HK") : NSLocale(localeIdentifier: "zh_HK")
        return arrayString.sort({$0.compare($1, locale: locale) == .OrderedAscending})
    }
}

extension UIImageView {
    func previewImage(index:Int,imageName:String,senderImageView:UIImageView,parentItem:InputModeDFMaster2) {
        let container: UIView = UIView()
        container.tag = _MASKVIEWTAG
        container.hidden = false
        container.frame = self.parentVC!.view.frame
        container.center = self.parentVC!.view.center
        container.backgroundColor = UIColor.clearColor()
        
        let layer = UIView()
        layer.frame = self.parentVC!.view.frame
        layer.center = self.parentVC!.view.center
        layer.backgroundColor = UIColor.blackColor()
        layer.alpha = 0.7
        container.addSubview(layer)
        
        let preview = ImagePreviewViewInput.loadFromNibNamed("ImagePreviewView")
        preview!.frame = CGRectMake(0,0,600,850)
        preview?.center = container.center
        preview?.photoIndex = index
        preview?.parentView = container
        preview?.parentImageView = senderImageView
        preview?.parentDefectItem = parentItem
        preview?.imageName = imageName
        
        //Use the Regular Size Image
        let path = Cache_Task_Path!+"/"+imageName
        preview?.imageView.image = UIImage(contentsOfFile: path)
        
        preview?.imageView.frame = CGRect(x: 0,y: 0,width: 600,height: 800)
        //preview?.imageView.frame = CGRect(x: 0,y: 0.5*(preview!.frame.size.height - (preview?.imageView.image?.size.height)!)-25,width: (preview?.imageView.image?.size.width)!,height: (preview?.imageView.image!.size.height)!)
        
        preview?.BackgroundView.addSubview((preview?.imageView)!)
        
        container.addSubview(preview!)
        
        self.parentVC?.view.addSubview(container)
    }
    
    func saveEndEditImage(image:UIImage) ->UIImage {
        UIGraphicsBeginImageContext(image.size)
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resultImage
    }
}

extension UIImage {
    
    func initPhotoObj(image:UIImageView?, photoId:Int=0, taskId:Int, refPhotoId:Int?, orgFileName:String?, imageName:String, photoDesc:String?,dataRecordId:Int?,createUser:String?,createDate:String?,modifyUser:String?,modifyDate:String?,dataType:Int?) ->Photo? {
        
        let photo = Photo(photo: image,photoFilename: imageName,taskId: taskId, photoFile: imageName)
        
        photo?.refPhotoId = refPhotoId
        photo?.orgFileName = orgFileName
        photo?.thumbFile = imageName
        photo?.photoDesc = photoDesc
        photo?.dataRecordId = dataRecordId
        photo?.createUser = createUser
        photo?.createDate = createDate
        photo?.modifyUser = modifyUser
        photo?.modifyDate = modifyDate
        photo?.dataType = dataType
        
        return photo
    }
    /*
    func processImage(image: UIImage, size: CGSize, completion: (image: UIImage) -> Void) {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            UIGraphicsBeginImageContextWithOptions(size, true, 0)
            image.drawInRect(CGRect(origin: CGPoint.zero, size: size))
            let tempImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            completion(image: tempImage)
        }
    }*/
    /*
    func resizeImage(image:UIImage, imageWidth:CGFloat=_RESIZEIMAGEWIDTH, imageHeight:CGFloat=_RESIZEIMAGEHEIGHT, completion: (image: UIImage) -> Void)/* ->UIImage*/ {
        
        let widthRatio = imageWidth / image.size.width
        let heightRatio = imageHeight / image.size.height
        let scale = min(widthRatio, heightRatio)
        let newWidth = scale * image.size.width
        let newHeight = scale * image.size.height
    
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //return newImage
        completion(image: newImage)
        
    }*/
    
    func rotateImage(image:UIImage, angle:CGFloat, flipVertical:CGFloat, flipHorizontal:CGFloat) -> UIImage? {
        let ciImage = CoreImage.CIImage(image: image)
        
        let filter = CIFilter(name: "CIAffineTransform")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setDefaults()
        
        let newAngle = angle * CGFloat(-1)
        
        var transform = CATransform3DIdentity
        transform = CATransform3DRotate(transform, CGFloat(newAngle), 0, 0, 1)
        transform = CATransform3DRotate(transform, CGFloat(Double(flipVertical) * M_PI), 0, 1, 0)
        transform = CATransform3DRotate(transform, CGFloat(Double(flipHorizontal) * M_PI), 1, 0, 0)
        
        let affineTransform = CATransform3DGetAffineTransform(transform)
        
        filter?.setValue(NSValue(CGAffineTransform: affineTransform), forKey: "inputTransform")
        
        let contex = CIContext(options: [kCIContextUseSoftwareRenderer:true])
        
        let outputImage = filter?.outputImage
        let cgImage = contex.createCGImage(outputImage!, fromRect: (outputImage?.extent)!)
        
        let result = UIImage(CGImage: cgImage)
        return result
    }
    
    func resizeImage(image:UIImage, imageWidth:CGFloat=_RESIZEIMAGEWIDTH, imageHeight:CGFloat=_RESIZEIMAGEHEIGHT) ->UIImage {
        var sourceImage = image
        sourceImage = sourceImage.fixOrientation()
        
        if sourceImage.size.width > sourceImage.size.height/* || image.imageOrientation == UIImageOrientation.Left || image.imageOrientation == UIImageOrientation.Right */{
            sourceImage = sourceImage.rotateImage(sourceImage, angle: (CGFloat)(90*M_PI / 180), flipVertical: 0, flipHorizontal: 0)!
        }
        
        let widthRatio = imageWidth / sourceImage.size.width
        let heightRatio = imageHeight / sourceImage.size.height
        let scale = min(widthRatio, heightRatio)
        let newWidth = scale * sourceImage.size.width
        let newHeight = scale * sourceImage.size.height
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        sourceImage.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func rotateImage(image:UIImage) ->UIImage {
        var sourceImage = image
        sourceImage = sourceImage.fixOrientation()
        
        if sourceImage.size.width > sourceImage.size.height{
            sourceImage = sourceImage.rotateImage(sourceImage, angle: (CGFloat)(90*M_PI / 180), flipVertical: 0, flipHorizontal: 0)!
        }
        
        return sourceImage
    }
    
    func cropToBounds(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
        
        let contextImage: UIImage = UIImage(CGImage: image.CGImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRectMake(posX, posY, cgwidth, cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(CGImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    func saveImageToLocal(sourceImage:UIImage, photoFileName:String="",photoId:Int?=0, savePath:String, taskId:Int, bookingNo:String, inspectorName:String, dataRecordId:Int?=0, dataType:Int, currentDate:String, originFileName:String="", sourceThumbImage:UIImage = UIImage.init()) ->Photo {
        
        //Resize Image
        var image = sourceImage
        if _NEEDRESIZEIMAGE {
            image = resizeImage(sourceImage)
            
        }else{
            image = rotateImage(sourceImage)
            
        }
        
        let thumbImageBefore = cropToBounds(image, width: _THUMBNAILWIDTH, height: _THUMBNAILHEIGHT)
        let thumbImage = resizeImage(thumbImageBefore, imageWidth: _THUMBNAILWIDTH, imageHeight: _THUMBNAILHEIGHT)
        
        let dataInPNG:NSData = UIImageJPEGRepresentation(image, 1.0)!
        let dataInPNG_thumb:NSData = UIImageJPEGRepresentation(thumbImage, 0.1)!
        
        var imageName = ""
        var saveObjFullPath = ""
        var saveObjFullThumbPath = ""
        
        //let fileManager:NSFileManager = NSFileManager.defaultManager()
        let photoDataHelper = PhotoDataHelper()
        
        //Photo Status From Task to Defect
        if photoFileName != "" {
            saveObjFullPath = savePath+"/"+photoFileName
            saveObjFullThumbPath = savePath+"/"+_THUMBSPHYSICALNAME+"/"+photoFileName
            
            dataInPNG.writeToFile(saveObjFullPath, atomically: true)
            dataInPNG_thumb.writeToFile(saveObjFullThumbPath, atomically: true)
            
            let photo =  photoDataHelper.updatePhotoDatas(photoId!, dataType: dataType, dataRecordId: dataRecordId!)!
            
            return photo
        }else{
            //Update db and Get the photo Id, then using the photo id as name
            //Update DB
            var photo = initPhotoObj(nil,taskId: taskId, refPhotoId: 0, orgFileName: "", imageName: "", photoDesc: "",dataRecordId:dataRecordId,createUser:inspectorName,createDate:currentDate,modifyUser:Cache_Inspector?.appUserName,modifyDate:currentDate, dataType: dataType)
            
            photo = photoDataHelper.savePhoto(photo!)
            
            //Update Photo Name
            imageName = String((photo?.photoId)!)+".jpg"
            var prefixs = 14
            let nameLen = imageName.characters.count
            
            while prefixs - nameLen > 0 {
                imageName = "0"+imageName
                prefixs -= 1
            }
            
            photo?.orgFileName = originFileName
            photo?.photoFilename = imageName
            photo?.photoFile = imageName
            photo?.thumbFile = imageName
            photo = photoDataHelper.savePhoto(photo!)
            
            saveObjFullPath = savePath+"/"+imageName
            saveObjFullThumbPath = savePath+"/"+_THUMBSPHYSICALNAME+"/"+imageName
            
            dataInPNG.writeToFile(saveObjFullPath, atomically: true)
            dataInPNG_thumb.writeToFile(saveObjFullThumbPath, atomically: true)
            
            return photo!
        }
    }

    
    func getNameBySaveImageToLocal(sourceImage:UIImage, photoFileName:String="",photoId:Int?=0, savePath:String, taskId:Int, bookingNo:String, inspectorName:String, dataRecordId:Int?=0, dataType:Int, currentDate:String, originFileName:String="", sourceThumbImage:UIImage = UIImage.init()) ->String {
    
        //Resize Image
        var image = sourceImage
        if _NEEDRESIZEIMAGE {
            image = resizeImage(sourceImage)
        
        }else{
            image = rotateImage(sourceImage)
            
        }
        
        let thumbImageBefore = cropToBounds(image, width: _THUMBNAILWIDTH, height: _THUMBNAILHEIGHT)
        let thumbImage = resizeImage(thumbImageBefore, imageWidth: _THUMBNAILWIDTH, imageHeight: _THUMBNAILHEIGHT)
        
        let dataInPNG:NSData = UIImageJPEGRepresentation(image, 1.0)!
        let dataInPNG_thumb:NSData = UIImageJPEGRepresentation(thumbImage, 0.1)!
        
        var imageName = ""
        var saveObjFullPath = ""
        var saveObjFullThumbPath = ""
        
        //let fileManager:NSFileManager = NSFileManager.defaultManager()
        let photoDataHelper = PhotoDataHelper()
        
        //Photo Status From Task to Defect
        if photoFileName != "" {
            saveObjFullPath = savePath+"/"+photoFileName
            saveObjFullThumbPath = savePath+"/"+_THUMBSPHYSICALNAME+"/"+photoFileName
            
            dataInPNG.writeToFile(saveObjFullPath, atomically: true)
            dataInPNG_thumb.writeToFile(saveObjFullThumbPath, atomically: true)
            
            if (photoDataHelper.updatePhotoDatas(photoId!, dataType: dataType, dataRecordId: dataRecordId!) != nil) {
                
                return photoFileName
            }else{
                return ""
            }
            
        }else{
            //Update db and Get the photo Id, then using the photo id as name
            //Update DB
            var photo = initPhotoObj(nil,taskId: taskId, refPhotoId: 0, orgFileName: "", imageName: "", photoDesc: "",dataRecordId:dataRecordId,createUser:inspectorName,createDate:currentDate,modifyUser:Cache_Inspector?.appUserName,modifyDate:currentDate, dataType: dataType)
            
            photo = photoDataHelper.savePhoto(photo!)
            //photo!.photo = UIImageView.init(image: thumbImage)
            
            
            //Update Photo Name
            imageName = String((photo?.photoId)!)+".jpg"
            var prefixs = 14
            let nameLen = imageName.characters.count
            
            while prefixs - nameLen > 0 {
                imageName = "0"+imageName
                prefixs -= 1
            }
            
            photo?.orgFileName = originFileName
            photo?.photoFilename = imageName
            photo?.photoFile = imageName
            photo?.thumbFile = imageName
            if (photoDataHelper.savePhoto(photo!) != nil) {
            
                saveObjFullPath = savePath+"/"+imageName
                saveObjFullThumbPath = savePath+"/"+_THUMBSPHYSICALNAME+"/"+imageName
            
                dataInPNG.writeToFile(saveObjFullPath, atomically: true)
                dataInPNG_thumb.writeToFile(saveObjFullThumbPath, atomically: true)
            
                return imageName
            }else{
                return ""
            }
        }
    }

    func removeImageFromLocalByPath(path:String) ->Bool {
        let fileManager = NSFileManager.defaultManager()
        
        if fileManager.fileExistsAtPath(path) {
            do {
                try fileManager.removeItemAtPath(path)
                return true
            }catch _ as NSError {
                return false
            }
        }
        
        return false
    }
    
    func removeImageFromLocal(photo:Photo, path:String) ->Bool {
        //Remove From DB
        let photoDataHelper = PhotoDataHelper()
        photoDataHelper.deletePhotoByPhotoId(photo.photoId!)
        
        //Remove From Local
        let fileManager = NSFileManager.defaultManager()
        
        do {
            let fullImagePath = path+"/"+photo.photoFile
            try fileManager.removeItemAtPath(fullImagePath)
            
            print("Removed Image With Path: \(fullImagePath)")
        }
        catch let error as NSError {
            print("Removing Image... Something went wrong: \(error)")
        }
        
        do {
            let fullImagePath = path+"/"+_THUMBSPHYSICALNAME+"/"+photo.photoFile
            try fileManager.removeItemAtPath(fullImagePath)
            
            print("Removed Thumb Image With Path: \(fullImagePath)")
        }
        catch let error as NSError {
            print("Removing Thumb Image... Something went wrong: \(error)")
        }
        
        return true
    }
    
    func toBase64()->String{
        
        if let imageData = UIImagePNGRepresentation(self) {
            let base64String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            return base64String
        }
        
        return ""
    }
    
    func fromBase64(base64String:String) ->UIImage {
        
        if let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
            if let decodedimage = UIImage(data: decodedData) {
                return decodedimage
            }
        }
        
        return UIImage.init()
    }
    
    func saveImageToLocal(savePath:String, image:UIImage, imageName:String) {
        let dataInPNG:NSData = UIImageJPEGRepresentation(image, 1.0)!
        let path = savePath+imageName
        let filemgr = NSFileManager.defaultManager()
        
        if !filemgr.fileExistsAtPath(savePath) {
            
            do {
                try filemgr.createDirectoryAtPath(savePath, withIntermediateDirectories: true, attributes: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        dataInPNG.writeToFile(path, atomically: true)
    }
    
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(CGImage: image.CGImage!)
    }
    
    func fixOrientation() -> UIImage {
        
        // No-op if the orientation is already correct
        if ( self.imageOrientation == UIImageOrientation.Up ) {
            return UIImage(CGImage: CGImage!, scale: scale, orientation: imageOrientation)
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransformIdentity
        
        if ( self.imageOrientation == UIImageOrientation.Down || self.imageOrientation == UIImageOrientation.DownMirrored ) {
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
        }
        
        if ( self.imageOrientation == UIImageOrientation.Left || self.imageOrientation == UIImageOrientation.LeftMirrored ) {
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        }
        
        if ( self.imageOrientation == UIImageOrientation.Right || self.imageOrientation == UIImageOrientation.RightMirrored ) {
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform,  CGFloat(-M_PI_2));
        }
        
        if ( self.imageOrientation == UIImageOrientation.UpMirrored || self.imageOrientation == UIImageOrientation.DownMirrored ) {
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
        }
        
        if ( self.imageOrientation == UIImageOrientation.LeftMirrored || self.imageOrientation == UIImageOrientation.RightMirrored ) {
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContextRef = CGBitmapContextCreate(nil, Int(self.size.width), Int(self.size.height), CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), CGImageGetBitmapInfo(self.CGImage).rawValue)!
        
        CGContextConcatCTM(ctx, transform)
        
        if ( self.imageOrientation == UIImageOrientation.Left ||
            self.imageOrientation == UIImageOrientation.LeftMirrored ||
            self.imageOrientation == UIImageOrientation.Right ||
            self.imageOrientation == UIImageOrientation.RightMirrored ) {
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage)
        } else {
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage)
        }
        
        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(CGImage: CGBitmapContextCreateImage(ctx)!)
    }
}

extension NSDate {
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: NSTimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.dateByAddingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
    
    func returnDateForMonth(month:NSInteger, year:NSInteger, day:NSInteger)->NSDate{
        let comp = NSDateComponents()
        comp.month = month
        comp.year = year
        comp.day = day
        
        let grego = NSCalendar.currentCalendar()
        return grego.dateFromComponents(comp)!
    }
    
    func firstDateOfMonth(date:NSDate=NSDate()) -> String {
        let calendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: date)
        let firstDay = self.returnDateForMonth(dateComponents.month, year: dateComponents.year, day: 1)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = _DATEFORMATTER
        
        return dateFormatter.stringFromDate(firstDay)
    }
    
    func getWeekDateByDate(date:String) ->Int {
        let dateStyler = NSDateFormatter()
        dateStyler.dateFormat = _DATEFORMATTER
        
        let myDate = dateStyler.dateFromString(date)!
        
        let myWeekday = NSCalendar.currentCalendar().components(NSCalendarUnit.Weekday, fromDate: myDate).weekday
        
        return myWeekday
    }
}

extension UITextField {
    func showListData(sender: UITextField, parent:UIView, handle:((UITextField)->(Void))?=nil, listData:NSArray, width:CGFloat=250, height:CGFloat=250, allowMulpSel:Bool=false, tag:Int = 100000, allowManuallyInput:Bool=false) /*->DropdownListViewControl*/ {
        
        if listData.count > 0 {
            //return Cache_Dropdown_Instance!
            Cache_Dropdown_Instance?.removeFromSuperview()
            
            if Cache_Dropdown_Instance == nil {
                Cache_Dropdown_Instance = DropdownListViewControl.loadFromNibNamed("DropdownListView")!
            }
            
            Cache_Dropdown_Instance!.dropdownData = listData as! [String]
            
            let actualHeight = CGFloat(listData.count*50)
            let adjustheight = actualHeight < height ? actualHeight : height
            var actualMinX = sender.frame.minX
            
            if actualMinX + width > 768 {
                actualMinX = 768 - width
            }
            
            var minY = sender.superview!.frame.minY+sender.frame.minY+sender.frame.size.height
            
            if String(sender.superview!.classForCoder) != nil {
                let classCode = String(sender.superview!.classForCoder)
                
                if classCode == "UITableViewCellContentView" {
                    minY = sender.superview!.superview!.frame.minY+sender.superview!.frame.minY+sender.frame.minY+sender.frame.size.height
                }
            }
            
            let absolutePoint = sender.convertRect(sender.bounds, toView: nil)
            let adjustMinY = absolutePoint.origin.y + 50 + sender.frame.size.height + adjustheight
            if adjustMinY > 1024 {
                minY -= adjustMinY - 1024
            }

            Cache_Dropdown_Instance!.frame = CGRect.init(x: actualMinX, y: minY, width: width, height: adjustheight)
            
            Cache_Dropdown_Instance!.sizeWidth = Int(width)
            Cache_Dropdown_Instance!.sizeHeight = Int(adjustheight) //Int(height)
            
            Cache_Dropdown_Instance!.myParentTextField = sender
            Cache_Dropdown_Instance!.layer.cornerRadius = 5.0
            Cache_Dropdown_Instance!.tableView.allowsMultipleSelection = allowMulpSel
            Cache_Dropdown_Instance?.allowManuallyInput = allowManuallyInput
            Cache_Dropdown_Instance!.tableView.rowHeight = 50
            Cache_Dropdown_Instance!.handleFun = handle
            Cache_Dropdown_Instance?.tag = tag
            
            parent.addSubview(Cache_Dropdown_Instance!)
        }else{
            Cache_Dropdown_Instance?.removeFromSuperview()
        }
    }
 
    func numberOnlyCheck(textField:UITextField, sourceText:String) ->Bool {
        if textField.text!.characters.count >= _MAXIMUNINT {
            textField.text = String(textField.text!.characters.dropLast())
            return false
        }
        
        var inputValue = ""
        if textField.text!.characters.count < 2 && sourceText == "" {
            inputValue = ""
        }else if sourceText == ""{
            inputValue = String(textField.text!.characters.dropLast())
        }else {
            inputValue = textField.text! + sourceText
        }
        
        if inputValue != "" && (Int(inputValue) == nil || Int(inputValue) < 1) {
            return false
        }
        
        let aSet = NSCharacterSet(charactersInString:"0123456789").invertedSet
        let compSepByCharInSet = sourceText.componentsSeparatedByCharactersInSet(aSet)
        let numberFiltered = compSepByCharInSet.joinWithSeparator("")
        
        return sourceText == numberFiltered
    }
    
    func showDatePicker(sender: UITextField) {
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSizeMake(320,350 + _NAVIBARHEIGHT)
        
        popoverContent.parentTextFieldView = sender
        popoverContent.sourceType = _BOOKINGDATEFROMDATETYPE
        popoverContent.dataType = _POPOVERDATETPYE
        
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        nav.navigationBar.barTintColor = UIColor.blackColor()
        
        let popover = nav.popoverPresentationController
        popover!.delegate = sender.parentVC as! PopoverMaster
        popover!.sourceView = sender.parentVC?.view
        popover!.sourceRect = CGRectMake(sender.frame.midX,sender.frame.minY,sender.frame.size.width,sender.frame.size.height)
        
        sender.parentVC!.presentViewController(nav, animated: true, completion: nil)
    }
}

extension String {
    func md5() -> String {
        var digest = [UInt8](count: Int(CC_MD5_DIGEST_LENGTH), repeatedValue: 0)
        if let data = self.dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }
        
        var digestHex = ""
        for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
            digestHex += String(format: "%02x", digest[index])
        }
        
        return digestHex
    }
    
    // url encode
    var urlEncode:String? {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    }
    
    // url decode
    var urlDecode :String? {
        return self.stringByRemovingPercentEncoding
    }
}


extension NSMutableData {
    
    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}

class Weak<T: AnyObject> {
    weak var value : T?
    init (value: T) {
        self.value = value
    }
}

extension Array where Element:Weak<AnyObject> {
    mutating func reap () {
        self = self.filter { nil != $0.value }
    }
}

extension UIBezierPath {
    
    class func arrow(from start: CGPoint, to end: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> Self {
        let length = hypot(end.x - start.x, end.y - start.y)
        let tailLength = length - headLength
        
        func p(x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        var points: [CGPoint] = [
            p(0, tailWidth / 2),
            p(tailLength, tailWidth / 2),
            p(tailLength, headWidth / 2),
            p(length, 0),
            p(tailLength, -headWidth / 2),
            p(tailLength, -tailWidth / 2),
            p(0, -tailWidth / 2)
        ]
        
        let cosine = (end.x - start.x) / length
        let sine = (end.y - start.y) / length
        var transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
        
        let path = CGPathCreateMutable()
        CGPathAddLines(path, &transform, &points, points.count)
        CGPathCloseSubpath(path)
        
        return self.init(CGPath: path)
    }
    
}