//
//  ViewController.swift
//  QCFossil
//
//  Created by Yin Huang on 14/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {

    //labels
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    //textfields
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var language: UISegmentedControl!
    
    //buttons
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var forgetUserNameButton: UIButton!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    
    @IBOutlet weak var loginIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginStatusMsg: UILabel!
    @IBOutlet weak var versionCode: UILabel!
    @IBOutlet weak var databaseUsingCode: UILabel!
    
    var newPwInput:UITextField!
    var confirmPwInput:UITextField!
    var validateStatus:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("\(UIDevice.currentDevice().systemVersion)")
        // Do any additional setup after loading the view, typically from a nib.
        self.language.selectedSegmentIndex = 1
        MylocalizedString.sharedLocalizeManager.setMyLanguage("zh-Hans")
        updateLocalizedString()
        // DatabaseManager.sharedDatabaseManager.initDbObj()
        
        //------------------------------------------ Do Any Updating Here before Login if Needed ------------------------------------------
        if _NEEDDATAUPDATE {
            dispatch_async(dispatch_get_main_queue(), {
                self.view.showActivityIndicator(MylocalizedString.sharedLocalizeManager.getLocalizedString("Updating"))
                
                let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
                dispatch_after(time, dispatch_get_main_queue()) {
                    
                    //Upgrade to support multiple inspectors
                    let filemgr = NSFileManager.defaultManager()
                    let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                    let dbDir = dirPaths[0] as String
                    let dbDir2 = dirPaths[0] as String
                    
                    let defaults = NSUserDefaults.standardUserDefaults()
                    if defaults.objectForKey("lastLoginUsername") != nil {
                        let inspectorName = defaults.objectForKey("lastLoginUsername")! as? String
                        let folderPath = _TASKSPHYSICALPATHPREFIX + (inspectorName?.lowercaseString)!
                        let databasePath = dbDir.stringByAppendingString("\(_DBNAME_USING)")
                        let taskPhotosPath = dbDir2.stringByAppendingString("/Tasks")
                        
                        if !filemgr.fileExistsAtPath(folderPath) && filemgr.fileExistsAtPath(databasePath) {
                            
                            do {
                                try NSFileManager.defaultManager().createDirectoryAtPath(folderPath, withIntermediateDirectories: true, attributes: nil)
                                try filemgr.moveItemAtPath(databasePath, toPath: folderPath+"/\(_DBNAME_USING)_\((inspectorName?.lowercaseString)!)")
                                
                                if filemgr.fileExistsAtPath(taskPhotosPath) {
                                    try filemgr.moveItemAtPath(taskPhotosPath, toPath: folderPath+"/Tasks")
                                }
                                
                            } catch let error as NSError {
                                print(error.localizedDescription)
                                
                            }
                        }
                    }
                    //Upgrade to support multiple inspectors End
                    
                    
                    self.view.removeActivityIndicator()
                    _NEEDDATAUPDATE = false
                }
            })
        }
        //--------------------------------------------------------------------------------------------------------------------------------
        
        self.view.setButtonCornerRadius(self.loginButton)
        self.view.setButtonCornerRadius(self.clearButton)
        self.view.setButtonCornerRadius(self.forgetPasswordButton)
        self.view.setButtonCornerRadius(self.forgetUserNameButton)
        self.versionCode.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Version")+" \(_VERSION)"
        
        //self.username.text = "delicate01"
        //self.password.text = "g3271952"
        //self.username.text = "jy01"
        //self.password.text = "wE$6T+8a"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let releaseDate = "20210118"//self.view.getCurrentDate("MMdd")
        _RELEASE = releaseDate as String
        defaults.setObject(releaseDate, forKey: "release_preference")
        
        #if DEBUG
            self.databaseUsingCode.text = "UAT " + releaseDate
            defaults.setObject("UAT", forKey: "serverEnv_preference")
            defaults.setObject(dataSyncUatServer, forKey: "webServiceUrl_preference")
        #else
            self.databaseUsingCode.text = "PRD " + releaseDate
            defaults.setObject("PRD", forKey: "serverEnv_preference")
            defaults.setObject(dataSyncPrdServer, forKey: "webServiceUrl_preference")
        #endif
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.defaultsChanged), name: NSUserDefaultsDidChangeNotification, object: nil)
    }
    
    func defaultsChanged(){
        updateDisplayFromDefaults()
    }
    
    func updateDisplayFromDefaults(){
        
        //Get the defaults, Update Version No.
        let defaults = NSUserDefaults.standardUserDefaults()
                
        //Set the controls to the default values.
        if let imagesize = defaults.stringForKey("imagesize_preference"){
            
            if Int(imagesize) > 1 {
                _RESIZEIMAGEWIDTH = 1200
                _RESIZEIMAGEHEIGHT = 1600
                
            }else if Int(imagesize) > 0 {
                _RESIZEIMAGEWIDTH = 800
                _RESIZEIMAGEHEIGHT = 1200
                
            }else{
                _RESIZEIMAGEWIDTH = 600
                _RESIZEIMAGEHEIGHT = 800
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initLoginStatus() {
        self.loginIndicator.hidden = true
        self.loginStatusMsg.text = ""
        self.password.text = ""
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("lastLoginUsername") != nil {
            self.username.text = defaults.objectForKey("lastLoginUsername")! as? String
        }
        
        updateDisplayFromDefaults()
    }
    
    func startLoginStatus(loginMsg:String = "", textColor:UIColor = _DEFAULTBUTTONTEXTCOLOR){
        self.loginIndicator.hidden = false
        self.loginIndicator.startAnimating()
        self.loginStatusMsg.textColor = textColor
        self.loginStatusMsg.text = loginMsg
    }
    
    func stopLoginStatus(loginMsg:String = "", textColor:UIColor = UIColor.redColor()) {
        self.loginIndicator.hidden = true
        self.loginIndicator.stopAnimating()
        self.loginStatusMsg.textColor = textColor
        self.loginStatusMsg.text = loginMsg
    }
    
    override func viewWillAppear(animated: Bool) {
        initLoginStatus()
    }
    
    @IBAction func changeLanguage(sender: UISegmentedControl) {
        /*
        selectedSegment: 0 - English
        selectedSegment: 1 - Chinese
        */
        let selectedSegment = sender.selectedSegmentIndex;
        
        if (selectedSegment > 0) {
            NSLog("Change language to: %@","中文")
            //singleton instance MylocalizedString.sharedLocalizeManager
            MylocalizedString.sharedLocalizeManager.setMyLanguage("zh-Hans")
            _ENGLISH = false
        }
        else{
            NSLog("Change language to: %@","English")
            //singleton instance MylocalizedString.sharedLocalizeManager
            MylocalizedString.sharedLocalizeManager.setMyLanguage("en")
            _ENGLISH = true
        }
        
        //switch language
        updateLocalizedString()
    }
    
    @IBAction func userLogin(sender: UIButton) {
        NSLog("userLogin")
        
        if _DEBUG_MODE {
            self.performSegueWithIdentifier("TaskSearchNavigatorSegue", sender: self)
            return
        }
        
        self.startLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Login through WS..."))
        
        //if username or password nil, alert
        if(self.username.text == "" || self.password.text == ""){
            self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Username or Password should not be nil!"))
            
        }else{
            
            //Login From Server first, if no network, then use local data
            //Data Sync Login
            var data = "\(_DS_PREFIX){"
            for (key, value) in _DS_USERLOGIN["APIPARA"] as! Dictionary<String,String> {
                data += "\"\(key)\":\"\(value)\","
            }
            data += "}"
            data = data.stringByReplacingOccurrencesOfString(",}", withString: "}")
            data = data.stringByReplacingOccurrencesOfString(_DS_USERNAME, withString: self.username.text!)
            data = data.stringByReplacingOccurrencesOfString(_DS_USERPASSWORD, withString: self.password.text!.md5())
                
            print("password: \(self.password.text!.md5())")
                
            self.makePostRequest(_DS_USERLOGIN["APINAME"] as! String, dataInJson: data, actionNames: _DS_USERLOGIN["ACTIONNAMES"] as! [String], actionFields: _DS_USERLOGIN["ACTIONFIELDS"] as! Dictionary,  handler: { (result, response, totalRecords) -> Void in
                    
                if response == "SUCCESS"{
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        if result![0]["inspector_id"] != nil && result![0]["prod_type_id"] != nil && result![0]["rec_status"] != nil {
                            let inspector = Inspector(inspectorId: Int(result![0]["inspector_id"]!), inspectorName: result![0]["inspector_name"]!, prodTypeId: Int(result![0]["prod_type_id"]!), appUserName: result![0]["app_username"]!, appPassword: result![0]["app_password"]!, serviceToken: result![0]["service_token"]!, reportPrefix: result![0]["report_prefix"]!, reportRunningNo: result![0]["report_running_no"]!, phoneNo: result![0]["phone_no"]!, emailAddr: result![0]["email_addr"]!, typeCode: "")
                                
                            inspector.recStatus = Int(result![0]["rec_status"]!)
                            inspector.createUser = result![0]["create_user"]
                            inspector.createDate = result![0]["create_date"]
                            inspector.modifyUser = result![0]["modify_user"]
                            inspector.modifyDate = result![0]["modify_date"]
                            inspector.deleteFlag = Int(result![0]["deleted_flag"]!)
                            inspector.deleteUser = result![0]["delete_user"]
                            inspector.deleteDate = result![0]["delete_date"]
                            inspector.chgPwdReqDate = result![0]["chg_pwd_req_date"]!
                            
                            var prodType = ProdType()
                            if let typeId = result![1]["type_id"] {
                                prodType.typeId = typeId
                            }
                            
                            if let typeCode = result![1]["type_code"] {
                                prodType.typeCode = typeCode
                            }
                            
                            if let typeNameEn = result![1]["type_name_en"] {
                                prodType.typeNameEn = typeNameEn
                            }
                            
                            if let typeNameCn = result![1]["type_name_cn"] {
                                prodType.typeNameCn = typeNameCn
                            }
                            
                            if let dataEnv = result![1]["data_env"] {
                                prodType.dataEnv = dataEnv
                            }
                            
                            if let recStatus = result![1]["rec_status"] {
                                prodType.recStatus = recStatus
                            }
                            
                            if let createDate = result![1]["create_date"] {
                                prodType.createDate = createDate
                            }
                            
                            if let createUser = result![1]["create_user"] {
                                prodType.createUser = createUser
                            }
                            
                            if let modifyDate = result![1]["modify_date"] {
                                prodType.modifyDate = modifyDate
                            }
                            
                            if let modifyUser = result![1]["modify_user"] {
                                prodType.modifyUser = modifyUser
                            }
                            
                            if let deletedFlag = result![1]["deleted_flag"] {
                                prodType.deletedFlag = deletedFlag
                            }
                            
                            if let deleteDate = result![1]["delete_date"] {
                                prodType.deleteDate = deleteDate
                            }
                            
                            if let deleteUser = result![1]["delete_user"] {
                                prodType.deleteUser = deleteUser
                            }
                            
                            //Update Service Token
                            _DS_SERVICETOKEN = result![0]["service_token"]!
                                
                            //update local DB
                            //DatabaseManager.sharedDatabaseManager.initDbObj("\(_DBNAME_USING)_\((inspector.appUserName?.lowercaseString)!)")
                            
                            //update local DB for Multi User
                            DatabaseManager.sharedDatabaseManager.initDbObj("\((inspector.appUserName?.lowercaseString)!)")
                            
                            let inspectorDataHelper = InspectorDataHelper()
                            inspectorDataHelper.updateInspector(inspector)
                            inspectorDataHelper.updateProdType(prodType)
                            
                            Cache_Inspector = inspectorDataHelper.getInspectorById(inspector.inspectorId ?? 0)
                            if Cache_Inspector == nil {
                                Cache_Inspector = inspector
                                Cache_Inspector?.typeCode = prodType.typeCode
                            }
                            Cache_Inspector?.lastLoginDate = self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm")
                                
                            let keyValueDataHelper = KeyValueDataHelper()
                            keyValueDataHelper.updateLastLoginDatetime(String((Cache_Inspector?.inspectorId)!), datetime: self.view.getCurrentDateTime())
                                
                            _DS_SERVICETOKEN = (Cache_Inspector?.serviceToken)!
                            //7029c6d9-7933-4be7-86e6-8bbc0aac1cb8
                            
                            let defaults = NSUserDefaults.standardUserDefaults()
                            defaults.setObject(Cache_Inspector?.appUserName, forKey: "lastLoginUsername")
                            
                            
                            //------------- Checking Any Update for DB ----------------
                            //add column for vdr_location_mstr table
                            let currDBVersion = keyValueDataHelper.getDBVersionNum()
                            
                            if _VERSION < currDBVersion {
                                self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Database Version is \(currDBVersion), But iPad App Version is \(_VERSION)"))
                                return
                                
                            }else if _VERSION != currDBVersion {
                            
                                let appUpgradeDataHelper = AppUpgradeDataHelper()
                                appUpgradeDataHelper.appUpgradeCode(_VERSION, parentView: self.view, completion: { (result) in
                                    
                                    if result {
                                        keyValueDataHelper.updateDBVersionNum(_VERSION)
                                    }
                                
                                    let DBVersion = keyValueDataHelper.getDBVersionNum()
                                    if _VERSION != DBVersion {
                                        self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Database Version is \(DBVersion), But iPad App Version is \(_VERSION)"))
                                        return
                                    }
                                    
                                    self.copyAppInfoFile(true)
                                    
                                    self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Login success, Redirect..."), textColor: _DEFAULTBUTTONTEXTCOLOR)
                                    if Cache_Inspector?.chgPwdReqDate != "" && Cache_Inspector?.chgPwdReqDate != nil {
                                        self.handlePwChangeBeforeRedirect()
                                        Cache_Inspector?.chgPwdReqDate = ""
                                        let inspectorDataHelper = InspectorDataHelper()
                                        inspectorDataHelper.updateInspector(Cache_Inspector!)
                                    
                                    }else{
                                        self.performSegueWithIdentifier("TaskSearchNavigatorSegue", sender: self)
                                    }

                                })
                            }else{
                                
                                self.copyAppInfoFile()
                                self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Login success, Redirect..."), textColor: _DEFAULTBUTTONTEXTCOLOR)
                                if Cache_Inspector?.chgPwdReqDate != "" && Cache_Inspector?.chgPwdReqDate != nil {
                                    self.handlePwChangeBeforeRedirect()
                                    Cache_Inspector?.chgPwdReqDate = ""
                                    let inspectorDataHelper = InspectorDataHelper()
                                    inspectorDataHelper.updateInspector(Cache_Inspector!)
                                    
                                }else{
                                    
                                    if self.isBackupDateOverNdays() {
                                        self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("You haven't done data sync over 3 days!"), handlerFun: { (UIAlertAction) in
                                            self.performSegueWithIdentifier("TaskSearchNavigatorSegue", sender: self)
                                        })
                                    }else{
                                        self.performSegueWithIdentifier("TaskSearchNavigatorSegue", sender: self)
                                    }
                                    
                                }
                            }
                            //------------------------------------------------
                            
                        }
                    })
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.startLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Login through Local Database..."))
                        if DatabaseManager.sharedDatabaseManager.openLocalDB(self.username.text!.lowercaseString) {
                            
                            let inspectorDataHelper = InspectorDataHelper()
                            Cache_Inspector = inspectorDataHelper.getInspector(self.username.text!, password: self.password.text!.md5())
                        
                            if (Cache_Inspector != nil) {
                                //local login
                                _DS_SERVICETOKEN = (Cache_Inspector?.serviceToken)!
                                Cache_Inspector?.lastLoginDate = self.view.getCurrentDateTime("\(_DATEFORMATTER) HH:mm")
                            
                                let keyValueDataHelper = KeyValueDataHelper()
                                keyValueDataHelper.updateLastLoginDatetime(String((Cache_Inspector?.inspectorId)!), datetime: self.view.getCurrentDateTime())
                            
                                let defaults = NSUserDefaults.standardUserDefaults()
                                defaults.setObject(Cache_Inspector?.appUserName, forKey: "lastLoginUsername")
                                
                                //------------- Checking Any Update for DB ----------------
                                //add column for vdr_location_mstr table
                                let currDBVersion = keyValueDataHelper.getDBVersionNum()
                                
                                if _VERSION < currDBVersion {
                                    self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Database Version is \(currDBVersion), But iPad App Version is \(_VERSION)"))
                                    return
                                    
                                }else if _VERSION != currDBVersion {
                                    
                                    let appUpgradeDataHelper = AppUpgradeDataHelper()
                                    appUpgradeDataHelper.appUpgradeCode(_VERSION, parentView: self.view, completion: { (result) in
                                        
                                        let keyValueDataHelper = KeyValueDataHelper()
                                        if result {
                                            keyValueDataHelper.updateDBVersionNum(_VERSION)
                                        }
                                    
                                        let DBVersion = keyValueDataHelper.getDBVersionNum()
                                        if _VERSION != DBVersion {
                                            self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Database Version is \(DBVersion), But iPad App Version is \(_VERSION)"))
                                            return
                                        }
                                        
                                        self.copyAppInfoFile(true)
                                    
                                        self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Login success, Redirect..."), textColor: _DEFAULTBUTTONTEXTCOLOR)
                                        if Cache_Inspector?.chgPwdReqDate != "" && Cache_Inspector?.chgPwdReqDate != nil {
                                            self.handlePwChangeBeforeRedirect()
                                            Cache_Inspector?.chgPwdReqDate = ""
                                            let inspectorDataHelper = InspectorDataHelper()
                                            inspectorDataHelper.updateInspector(Cache_Inspector!)
                                        
                                        }else{
                                            self.performSegueWithIdentifier("TaskSearchNavigatorSegue", sender: self)
                                        }
                                    })
                                }else{
                                    
                                    self.copyAppInfoFile()
                                    if self.isBackupDateOverNdays() {
                                        self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("You haven't done data sync over 3 days!"), handlerFun: { (UIAlertAction) in
                                            self.performSegueWithIdentifier("TaskSearchNavigatorSegue", sender: self)
                                        })
                                    }else{
                                        self.performSegueWithIdentifier("TaskSearchNavigatorSegue", sender: self)
                                    }
                                    
                                    self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Login success, Redirect..."), textColor: _DEFAULTBUTTONTEXTCOLOR)
                                    if Cache_Inspector?.chgPwdReqDate != "" && Cache_Inspector?.chgPwdReqDate != nil {
                                        self.handlePwChangeBeforeRedirect()
                                        Cache_Inspector?.chgPwdReqDate = ""
                                        let inspectorDataHelper = InspectorDataHelper()
                                        inspectorDataHelper.updateInspector(Cache_Inspector!)
                                        
                                    }else{
                                        self.performSegueWithIdentifier("TaskSearchNavigatorSegue", sender: self)
                                    }
                                    
                                }
                                //------------------------------------------------
                                
                                
                                
                            }else{
                            
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Username or Password is not correct!"))
                                
                                })
                            }
                        }else{
                            dispatch_async(dispatch_get_main_queue(), {
                                self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("Login information incorrect!"))
                            
                            })
                        }
                    })
                }
            })
        }
    }
    
    func handlePwChangeBeforeRedirect() {
        let alert = UIAlertController(title: MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Change Your Password Now"), message: "", preferredStyle: UIAlertControllerStyle.Alert)
        let saveAction = UIAlertAction(title: MylocalizedString.sharedLocalizeManager.getLocalizedString("OK"), style: .Default, handler: { action in
            switch action.style{
            case .Default:
                print("default")
                
                var data = "\(_DS_PREFIX){"
                for (key, value) in _DS_CHANGE_PW["APIPARA"] as! Dictionary<String,String> {
                    data += "\"\(key)\":\"\(value)\","
                }
                data += "}"
                data = data.stringByReplacingOccurrencesOfString(",}", withString: "}")
                data = data.stringByReplacingOccurrencesOfString("new_password", withString: self.newPwInput.text!)
                    
                self.makePostRequest(_DS_CHANGE_PW["APINAME"] as! String, dataInJson: data, actionNames: _DS_CHANGE_PW["ACTIONNAMES"] as! [String], actionFields: _DS_CHANGE_PW["ACTIONFIELDS"] as! Dictionary,  handler: { (result, response, totalRecords) -> Void in
                        
                    if response == "SUCCESS"{
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            let style = NSMutableParagraphStyle()
                            style.alignment = NSTextAlignment.Center
                            let attributedString = NSAttributedString(string: MylocalizedString.sharedLocalizeManager.getLocalizedString("New password reset Successfully!"), attributes: [
                                NSParagraphStyleAttributeName: style,
                                NSFontAttributeName : UIFont.systemFontOfSize(15),
                                NSForegroundColorAttributeName : _DEFAULTBUTTONTEXTCOLOR
                                ])
                            alert.setValue(attributedString, forKey: "attributedMessage")
                            
                            let inspectorDataHelper = InspectorDataHelper()
                            Cache_Inspector?.appPassword = self.newPwInput.text!.md5()
                            inspectorDataHelper.updateInspector(Cache_Inspector!)
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                self.performSegueWithIdentifier("TaskSearchNavigatorSegue", sender: self)
                            }
                        }
                        
                    }else{
                        dispatch_async(dispatch_get_main_queue()) {
                            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Update failed. Please check internet connection."), handlerFun: { (action:UIAlertAction!) in
                                //self.performSegueWithIdentifier("TaskSearchNavigatorSegue", sender: self)
                                self.stopLoginStatus(MylocalizedString.sharedLocalizeManager.getLocalizedString("New Password Update Fail..."))
                            })
                        }
                    }
                        
                })
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
                
            }
        })
        
        saveAction.enabled = false
        
        alert.addTextFieldWithConfigurationHandler(self.configurationNewPwInputTextField)
        alert.addTextFieldWithConfigurationHandler(self.configurationConfirmPwInputTextField)
        alert.addAction(saveAction)
        
        // Adding the notification observer here
        NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidEndEditingNotification, object:alert.textFields?[0], queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            
            let newPwInput = alert.textFields![0]
            self.isValidPw(newPwInput.text!, alert: alert)
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object:alert.textFields?[0], queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            
            let newPwInput = alert.textFields![0]
            let confirmPwInput = alert.textFields![1]
            
            saveAction.enabled = self.isValidPw(newPwInput.text!, alert: alert) && self.isValidConfirmPw(newPwInput.text!, confirmPwInput: confirmPwInput.text!, alert: alert)
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object:alert.textFields?[1], queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
                                                                    
            let newPwInput = alert.textFields![0]
            let confirmPwInput = alert.textFields![1]
            
            saveAction.enabled = self.isValidConfirmPw(newPwInput.text!, confirmPwInput: confirmPwInput.text!, alert: alert)
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidBeginEditingNotification, object:alert.textFields?[1], queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            
            let newPwInput = alert.textFields![0]
            let confirmPwInput = alert.textFields![1]
            
            self.isValidConfirmPw(newPwInput.text!, confirmPwInput: confirmPwInput.text!, alert: alert)
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func isValidConfirmPw(pwInput:String, confirmPwInput:String, alert:UIAlertController) ->Bool {
        
        if pwInput != confirmPwInput {
            
            dispatch_async(dispatch_get_main_queue()) {
                let style = NSMutableParagraphStyle()
                style.alignment = NSTextAlignment.Center
                let attributedString = NSAttributedString(string: MylocalizedString.sharedLocalizeManager.getLocalizedString("Confirm password is different from the New password!"), attributes: [
                    NSParagraphStyleAttributeName: style,
                    NSFontAttributeName : UIFont.systemFontOfSize(15),
                    NSForegroundColorAttributeName : UIColor.redColor()
                    ])
                alert.setValue(attributedString, forKey: "attributedMessage")
                
            }
            
            return false
        }else if !self.isValidPw(newPwInput.text!, alert: alert) {
            
            return false
        }else{
            dispatch_async(dispatch_get_main_queue()) {
                let style = NSMutableParagraphStyle()
                style.alignment = NSTextAlignment.Center
                let attributedString = NSAttributedString(string: "", attributes: [
                    NSParagraphStyleAttributeName: style,
                    NSFontAttributeName : UIFont.systemFontOfSize(15),
                    NSForegroundColorAttributeName : UIColor.redColor()
                    ])
                alert.setValue(attributedString, forKey: "attributedMessage")
                
            }
        }
        
        return true
    }
    
    func isValidPw(pwInput:String, alert:UIAlertController) ->Bool {
        
        //Check if New password equit to appUsername
        if pwInput == Cache_Inspector?.appUserName! {
            print("new password cant be the same as user login name!")
            
            dispatch_async(dispatch_get_main_queue()) {
                let style = NSMutableParagraphStyle()
                style.alignment = NSTextAlignment.Center
                let attributedString = NSAttributedString(string: MylocalizedString.sharedLocalizeManager.getLocalizedString("Cant use login name as new password!"), attributes: [
                    NSParagraphStyleAttributeName: style,
                    NSFontAttributeName : UIFont.systemFontOfSize(15),
                    NSForegroundColorAttributeName : UIColor.redColor()
                    ])
                alert.setValue(attributedString, forKey: "attributedMessage")
                
            }
            
            return false
        }else if pwInput.characters.count < 8 || pwInput.characters.count > 15 {//Check if New password contains 8 to 15 charators
            print("new password should be 8-15 charators")
            
            dispatch_async(dispatch_get_main_queue()) {
                let style = NSMutableParagraphStyle()
                style.alignment = NSTextAlignment.Center
                let attributedString = NSAttributedString(string: MylocalizedString.sharedLocalizeManager.getLocalizedString("New password should be 8-15 charators!"), attributes: [
                    NSParagraphStyleAttributeName: style,
                    NSFontAttributeName : UIFont.systemFontOfSize(15),
                    NSForegroundColorAttributeName : UIColor.redColor()
                    ])
                alert.setValue(attributedString, forKey: "attributedMessage")
                
            }
            
            return false
        }
        
        do{
            //Check if New password including Numbers
            let tNumRegularExpression = try NSRegularExpression(pattern: "[0-9]", options: .CaseInsensitive)
            let tNumMatchCount = tNumRegularExpression.numberOfMatchesInString(pwInput, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, pwInput.characters.count))
        
            if tNumMatchCount < 1 {
                print("match Num count: \(tNumMatchCount)")
            
                dispatch_async(dispatch_get_main_queue()) {
                    let style = NSMutableParagraphStyle()
                    style.alignment = NSTextAlignment.Center
                    let attributedString = NSAttributedString(string: MylocalizedString.sharedLocalizeManager.getLocalizedString("New password need to include Numbers!"), attributes: [
                        NSParagraphStyleAttributeName: style,
                        NSFontAttributeName : UIFont.systemFontOfSize(15),
                        NSForegroundColorAttributeName : UIColor.redColor()
                        ])
                    alert.setValue(attributedString, forKey: "attributedMessage")
                    
                }
            
                return false
            }
            
            //Check if New password including Letters
            let tLetterRegularExpression = try NSRegularExpression(pattern: "[A-Za-z]", options: .CaseInsensitive)
            let tLetterMatchCount = tLetterRegularExpression.numberOfMatchesInString(pwInput, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, pwInput.characters.count))
            
            if tLetterMatchCount < 1 {
                print("match Letter count: \(tLetterMatchCount)")
                
                dispatch_async(dispatch_get_main_queue()) {
                    let style = NSMutableParagraphStyle()
                    style.alignment = NSTextAlignment.Center
                    let attributedString = NSAttributedString(string: MylocalizedString.sharedLocalizeManager.getLocalizedString("New password need to include Letters!"), attributes: [
                        NSParagraphStyleAttributeName: style,
                        NSFontAttributeName : UIFont.systemFontOfSize(15),
                        NSForegroundColorAttributeName : UIColor.redColor()
                        ])
                    alert.setValue(attributedString, forKey: "attributedMessage")
                    
                }
                
                return false
            }
            
        }catch{
            return false
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.Center
            let attributedString = NSAttributedString(string: "", attributes: [
                NSParagraphStyleAttributeName: style,
                NSFontAttributeName : UIFont.systemFontOfSize(15),
                NSForegroundColorAttributeName : UIColor.redColor()
                ])
            alert.setValue(attributedString, forKey: "attributedMessage")
                
        }
        
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.newPwInput || textField == self.confirmPwInput {
            
            if string == " " {
                return false
            }
        }
        
        return true
    }
    
    func configurationNewPwInputTextField(textField: UITextField!) {
        print("configurat hire the TextField")
        
        self.newPwInput = textField!        //Save reference to the UITextField
        self.newPwInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("New Password")
        self.newPwInput.secureTextEntry = true
        self.newPwInput.delegate = self
        
    }
    
    func configurationConfirmPwInputTextField(textField: UITextField!) {
        print("configurat hire the TextField")
        
        self.confirmPwInput = textField!        //Save reference to the UITextField
        self.confirmPwInput.placeholder = MylocalizedString.sharedLocalizeManager.getLocalizedString("Confirm Password")
        self.confirmPwInput.secureTextEntry = true
        self.confirmPwInput.delegate = self
        
    }
    
    func handleCancel(alertView: UIAlertAction!){
        print("User click Cancel button")
        print(self.newPwInput.text)
    }
    
    @IBAction func userClear(sender: UIButton) {
        NSLog("userClear")
        
        self.username.text = ""
        self.password.text = ""
    }
    
    @IBAction func userForgetUsername(sender: UIButton) {
        NSLog("userForgetUsername")
        
    }
    
    @IBAction func userForgetPassword(sender: UIButton) {
        NSLog("userForgetPassword")
       
    }
    
    func updateLocalizedString() {
        NSLog("updateLocalizedString")
        
        self.usernameLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Username")
        self.passwordLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Password")
        self.languageLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Language")
        self.loginButton.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Login"), forState: UIControlState.Normal)
        self.clearButton.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Clear"), forState: UIControlState.Normal)
        self.forgetUserNameButton.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Forget Username?"), forState: UIControlState.Normal)
        self.forgetPasswordButton.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Forget Password?"), forState: UIControlState.Normal)
        self.versionCode.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Version")+" \(_VERSION)"
    }
    
    func isBackupDateOverNdays(N:Double = 3) ->Bool {
        
        let keyValueDataHelper = KeyValueDataHelper()
        let lastDownloadDateInString = keyValueDataHelper.getLastDownloadDatetimeByUserId(String((Cache_Inspector?.inspectorId)!))
        
        if lastDownloadDateInString != "" {
        
            let now = NSDate.init()
        
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
            let lastDownloadDate = dateFormatter.dateFromString(lastDownloadDateInString)
            let NDaysAgo = now.dateByAddingTimeInterval(-60*60*(24*N))
            let timeBetween3Days = now.timeIntervalSinceDate(NDaysAgo)
            let timeBetweenBacupDays = now.timeIntervalSinceDate(lastDownloadDate!)
            
            if timeBetween3Days < timeBetweenBacupDays {
            
                return true
            }
        }
        
        let lastUploadDateInString = keyValueDataHelper.getLastUploadDatetimeByUserId(String((Cache_Inspector?.inspectorId)!))
        
        if lastUploadDateInString != "" {
            
            let now = NSDate.init()
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
            let lastUploadDate = dateFormatter.dateFromString(lastUploadDateInString)
            let NDaysAgo = now.dateByAddingTimeInterval(-60*60*(24*N))
            let timeBetween3Days = now.timeIntervalSinceDate(NDaysAgo)
            let timeBetweenBacupDays = now.timeIntervalSinceDate(lastUploadDate!)
            
            if timeBetween3Days < timeBetweenBacupDays {
                
                return true
            }
        }
        
        return false
    }
    
    func calculateTimeDifferenceWithStartDate(startDate:NSDate, endDate:NSDate) ->NSDateComponents {
        
        let calendar = NSCalendar.currentCalendar()
        let unitFlags = NSCalendarUnit.Day
        
        return calendar.components(unitFlags, fromDate: startDate, toDate: endDate, options: NSCalendarOptions.init(rawValue: 0))
    }
    
    func copyAppInfoFile(needUpdate:Bool = false) {
        //CPY App Info XML to Inspector Folder
        let filemgr = NSFileManager.defaultManager()
        do{
            /*
             if filemgr.fileExistsAtPath("\(NSHomeDirectory())/Documents/\((Cache_Inspector?.appUserName?.lowercaseString)!)/AppInfo") {
             try filemgr.removeItemAtPath("\(NSHomeDirectory())/Documents/\((Cache_Inspector?.appUserName?.lowercaseString)!)/AppInfo")
             try filemgr.copyItemAtPath(self.view.getPreferencesFilePath()!, toPath: "\(NSHomeDirectory())/Documents/\((Cache_Inspector?.appUserName?.lowercaseString)!)/AppInfo")
             }else{
             try filemgr.copyItemAtPath(self.view.getPreferencesFilePath()!, toPath: "\(NSHomeDirectory())/Documents/\((Cache_Inspector?.appUserName?.lowercaseString)!)/AppInfo")
             }*/
            
            if needUpdate {
                if filemgr.fileExistsAtPath("\(NSHomeDirectory())/Documents/\((Cache_Inspector?.appUserName?.lowercaseString)!)/AppInfo") {
                    try filemgr.removeItemAtPath("\(NSHomeDirectory())/Documents/\((Cache_Inspector?.appUserName?.lowercaseString)!)/AppInfo")
                }
                
                if filemgr.fileExistsAtPath(self.view.getPreferencesFilePath()!) {
                    try filemgr.copyItemAtPath(self.view.getPreferencesFilePath()!, toPath: "\(NSHomeDirectory())/Documents/\((Cache_Inspector?.appUserName?.lowercaseString)!)/AppInfo")
                }
                
            }else if !filemgr.fileExistsAtPath("\(NSHomeDirectory())/Documents/\((Cache_Inspector?.appUserName?.lowercaseString)!)/AppInfo") {
                
                if filemgr.fileExistsAtPath(self.view.getPreferencesFilePath()!) {
                    try filemgr.copyItemAtPath(self.view.getPreferencesFilePath()!, toPath: "\(NSHomeDirectory())/Documents/\((Cache_Inspector?.appUserName?.lowercaseString)!)/AppInfo")
                }
            }
            
        }catch let error as NSError{
            self.view.alertView("CPY App Info: "+error.localizedDescription)
        }
    }
}

