//
//  UserSettingViewController.swift
//  QCFossil
//
//  Created by pacmobile on 7/12/2016.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class UserSettingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var CPTitle: UILabel!
    @IBOutlet weak var currentPwTitle: UILabel!
    @IBOutlet weak var newPwTitle: UILabel!
    @IBOutlet weak var newPwAgainTitle: UILabel!
    @IBOutlet weak var currentPwInput: UITextField!
    @IBOutlet weak var newPwInput: UITextField!
    @IBOutlet weak var newPwAgainInput: UITextField!
    @IBOutlet weak var changePwBtn: UIButton!
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var imageSizeTitle: UILabel!
    @IBOutlet weak var imageSizeSegment: UISegmentedControl!
    @IBOutlet weak var inspectorSignatureLabel: UILabel!
    @IBOutlet weak var inspectorSignatureInput: UIImageView!
    @IBOutlet weak var inspectorSignatureBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    
    var signInputView:SignoffView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.CPTitle.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Change Password") + " ?"
        self.currentPwTitle.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Current Password")
        self.newPwTitle.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("New Password")
        self.newPwAgainTitle.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("New Password Again")
        self.changePwBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Change Password"), forState: UIControlState.Normal)
        self.imageSizeTitle.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Resolution of Photo from Library or Camera")
        self.inspectorSignatureLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspector Signature")
        
        self.newPwInput.delegate = self
        self.newPwAgainInput.delegate = self
        
        self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("User Setting")
        self.navigationItem.leftBarButtonItem?.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("App Menu")
        
        self.view.setButtonCornerRadius(self.changePwBtn)
        self.view.setButtonCornerRadius(self.clearBtn)
        
        self.inspectorSignatureBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Tap to Sign"), forState: UIControlState.Normal)
        self.clearBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Update Signature"), forState: UIControlState.Normal)
        
        let keyValueDataHelper = KeyValueDataHelper()
        let signImageInCode = keyValueDataHelper.getInspectorSignImage(String(Cache_Inspector?.inspectorId))
        
        if signImageInCode != "" {
            self.inspectorSignatureInput.image = UIImage.init().fromBase64(signImageInCode)
            self.inspectorSignatureBtn.hidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    */
    
    @IBAction func showMenuAction(sender: UIBarButtonItem) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.newPwInput || textField == self.newPwAgainInput {
            
            if string == " " {
                return false
            }
        }
        
        return true
    }
    
    @IBAction func changePwAction(sender: UIButton) {
        
        do{
            self.errorMsg.textColor = UIColor.redColor()
            let inspectorDataHelper = InspectorDataHelper()
            if (inspectorDataHelper.getInspector((Cache_Inspector?.appUserName)!, password: (self.currentPwInput.text?.md5())!) != nil) {
                self.errorMsg.hidden = true
                
                //Check if New password equit to appUsername
                if self.newPwInput.text == Cache_Inspector?.appUserName! {
                    print("new password cant be the same as user login name!")
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.errorMsg.hidden = false
                        self.errorMsg.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Cant use login name as new password!")
                    }
                    
                    return
                }
                
                //Check if New password contains 8 to 15 charators
                if self.newPwInput.text?.characters.count < 8 || self.newPwInput.text?.characters.count > 15 {
                    print("new password should be 8-15 charators")
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.errorMsg.hidden = false
                        self.errorMsg.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("New password should be 8-15 charators!")
                    }
                    
                    return
                }
                
                
                //Check if New password including Numbers
                let tNumRegularExpression = try NSRegularExpression(pattern: "[0-9]", options: .CaseInsensitive)
                let tNumMatchCount = tNumRegularExpression.numberOfMatchesInString(self.newPwInput.text!, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, self.newPwInput.text!.characters.count))
                
                if tNumMatchCount < 1 {
                    print("match Num count: \(tNumMatchCount)")
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.errorMsg.hidden = false
                        self.errorMsg.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("New password need to include Numbers!")
                    }
                    
                    return
                }
                
                //Check if New password including Letters
                let tLetterRegularExpression = try NSRegularExpression(pattern: "[A-Za-z]", options: .CaseInsensitive)
                let tLetterMatchCount = tLetterRegularExpression.numberOfMatchesInString(self.newPwInput.text!, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, self.newPwInput.text!.characters.count))
                
                if tLetterMatchCount < 1 {
                    print("match Letter count: \(tLetterMatchCount)")
                
                    dispatch_async(dispatch_get_main_queue()) {
                        self.errorMsg.hidden = false
                        self.errorMsg.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("New password need to include Letters!")
                    }
                    
                    return
                }
                
                //Check if New password is the same as Confirm password
                if self.newPwInput.text == self.newPwAgainInput.text {
                
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
                                self.errorMsg.hidden = false
                                self.errorMsg.textColor = _FOSSILBLUECOLOR
                                self.errorMsg.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("New password reset Successfully!")
                                
                                let inspectorDataHelper = InspectorDataHelper()
                                Cache_Inspector?.appPassword = self.newPwInput.text!.md5()
                                inspectorDataHelper.updateInspector(Cache_Inspector!)
                                
                            }
                        }else{
                            dispatch_async(dispatch_get_main_queue()) {
                                self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Update failed. Please check internet connection."), handlerFun: { (action:UIAlertAction!) in
                                    
                                    
                                })
                            }
                        }
                    
                    })
                
                }else{
                    dispatch_async(dispatch_get_main_queue()) {
                        self.errorMsg.hidden = false
                        self.errorMsg.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Confirm password is different from the New password!")
                    }
                    
                }
                
            }else{
                dispatch_async(dispatch_get_main_queue()) {
                    self.errorMsg.hidden = false
                    self.errorMsg.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Old password is not Correct!")
                }
            }
            
        }catch {
            print("error: \(error)")
        }
        
    }
    
    @IBAction func imageSizeSegmentAction(sender: UISegmentedControl) {
        
        let selectedSegment = sender.selectedSegmentIndex
        
        switch selectedSegment {
            case 0:
                _RESIZEIMAGEWIDTH = 600
                _RESIZEIMAGEHEIGHT = 800
                break
            case 1:
                _RESIZEIMAGEWIDTH = 800
                _RESIZEIMAGEHEIGHT = 1200
                break
            case 2:
                _RESIZEIMAGEWIDTH = 1200
                _RESIZEIMAGEHEIGHT = 1600
                break
            default:
                _RESIZEIMAGEWIDTH = 600
                _RESIZEIMAGEHEIGHT = 800
        }
    }
    
    @IBAction func inspectorSignTap(sender: UIButton) {
        sender.hidden = true
        NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":false])
        
        let container: UIView = UIView()
        container.tag = _MASKVIEWTAG
        container.hidden = false
        container.frame = self.view.frame
        container.center = self.view.center
        container.backgroundColor = UIColor.clearColor()
        
        let layer = UIView()
        layer.frame = self.view.frame
        layer.center = self.view.center
        layer.backgroundColor = UIColor.blackColor()
        layer.alpha = 0.7
        container.addSubview(layer)
        
        signInputView = SignoffView()
        signInputView!.frame = CGRectMake(0,0,650,415)
        signInputView!.center = container.center
        signInputView!.backgroundColor = UIColor.whiteColor()
        signInputView!.userInteractionEnabled = true
        
        let okBtn = UIButton(frame: CGRect(x: 600, y: 750, width: 100, height: 50))
        okBtn.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
        okBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Confirm"), forState: UIControlState.Normal)
        okBtn.addTarget(self, action: #selector(UserSettingViewController.confirmInspctorSign), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.setButtonCornerRadius(okBtn)
        
        let clearBtn = UIButton(frame: CGRect(x: 490, y: 750, width: 100, height: 50))
        clearBtn.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
        clearBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Clear"), forState: UIControlState.Normal)
        clearBtn.addTarget(self, action: #selector(UserSettingViewController.clearInspctorSign), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.setButtonCornerRadius(clearBtn)
        /*
        let cancelBtn = UIButton(frame: CGRect(x: 380, y: 750, width: 100, height: 50))
        cancelBtn.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
        cancelBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel"), forState: UIControlState.Normal)
        cancelBtn.addTarget(self, action: #selector(UserSettingViewController.cancelInspctorSign), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.setButtonCornerRadius(cancelBtn)
        */
        //Use the Regular Size Image
        container.addSubview(signInputView!)
        container.addSubview(okBtn)
        container.addSubview(clearBtn)
        //container.addSubview(cancelBtn)
        
        self.view.addSubview(container)
    }
    
    func cancelInspctorSign() {
        if self.inspectorSignatureInput.image == nil {
            self.inspectorSignatureBtn.hidden = false
        }
        
        self.view.subviews.forEach({if $0.tag == _MASKVIEWTAG {$0.removeFromSuperview()} })
        NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":true])
    }
    
    func clearInspctorSign(){
        signInputView?.image = nil
    }
    
    func confirmInspctorSign() {
        
        if signInputView?.image == nil {
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Signature"))
            return
        }
        
        self.inspectorSignatureInput.image = signInputView?.image
        
        let keyValueDataHelper = KeyValueDataHelper()
        keyValueDataHelper.saveInspectorSignImage(String(Cache_Inspector?.inspectorId), imageToBase64: (self.inspectorSignatureInput.image?.toBase64())!)
        
        self.view.subviews.forEach({if $0.tag == _MASKVIEWTAG {$0.removeFromSuperview()} })
        
        NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":true])
    }
    
    @IBAction func clearBtnOnClick(sender: UIButton) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":false])
        
        let container: UIView = UIView()
        container.tag = _MASKVIEWTAG
        container.hidden = false
        container.frame = self.view.frame
        container.center = self.view.center
        container.backgroundColor = UIColor.clearColor()
        
        let layer = UIView()
        layer.frame = self.view.frame
        layer.center = self.view.center
        layer.backgroundColor = UIColor.blackColor()
        layer.alpha = 0.7
        container.addSubview(layer)
        
        signInputView = SignoffView()
        signInputView!.frame = CGRectMake(0,0,650,415)
        signInputView!.center = container.center
        signInputView!.backgroundColor = UIColor.whiteColor()
        signInputView!.userInteractionEnabled = true
        
        let okBtn = UIButton(frame: CGRect(x: 600, y: 750, width: 100, height: 50))
        okBtn.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
        okBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Confirm"), forState: UIControlState.Normal)
        okBtn.addTarget(self, action: #selector(UserSettingViewController.confirmInspctorSign), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.setButtonCornerRadius(okBtn)
        
        let clearBtn = UIButton(frame: CGRect(x: 490, y: 750, width: 100, height: 50))
        clearBtn.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
        clearBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Clear"), forState: UIControlState.Normal)
        clearBtn.addTarget(self, action: #selector(UserSettingViewController.clearInspctorSign), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.setButtonCornerRadius(clearBtn)
        
        if self.inspectorSignatureInput.image != nil {
            let cancelBtn = UIButton(frame: CGRect(x: 380, y: 750, width: 100, height: 50))
            cancelBtn.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
            cancelBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel"), forState: UIControlState.Normal)
            cancelBtn.addTarget(self, action: #selector(UserSettingViewController.cancelInspctorSign), forControlEvents: UIControlEvents.TouchUpInside)
            self.view.setButtonCornerRadius(cancelBtn)
            container.addSubview(cancelBtn)
        }
        
        //Use the Regular Size Image
        container.addSubview(signInputView!)
        container.addSubview(okBtn)
        container.addSubview(clearBtn)
        
        self.view.addSubview(container)
        /*
        self.view.alertConfirmView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Clear Signature?"),parentVC:self, handlerFun: { (action:UIAlertAction!) in
            self.inspectorSignatureInput.image = nil
            self.inspectorSignatureBtn.hidden = false
            
            let keyValueDataHelper = KeyValueDataHelper()
            keyValueDataHelper.saveInspectorSignImage(String(Cache_Inspector?.inspectorId), imageToBase64: "")
         
        })*/
    }
    
}
