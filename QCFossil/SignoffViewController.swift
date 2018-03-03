//
//  SignoffViewController.swift
//  QCFossil
//
//  Created by pacmobile on 22/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

class SignoffViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var inspectorSignInput: SignoffView!
    @IBOutlet weak var vendorSignInput: SignoffView!
    @IBOutlet weak var inspectorSignTap: UIButton!
    @IBOutlet weak var vendorSignTap: UIButton!
    @IBOutlet weak var inspectorSignLabel: UILabel!
    @IBOutlet weak var inspectorSignBoxInput: UITextField!
    @IBOutlet weak var vendorSignLabel: UILabel!
    @IBOutlet weak var vendorSignBoxInput: UITextField!
    @IBOutlet weak var inspectorSignBoxLabel: UILabel!
    @IBOutlet weak var vendorSignBoxLabel: UILabel!
    @IBOutlet weak var inspectorSignClearBtn: UIButton!
    @IBOutlet weak var vendorSignClearBtn: UIButton!
    
    var signInputView:SignoffView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":false])
        
        //load sign images if exsit
        self.inspectorSignTap.hidden = false
        if Cache_Task_On?.inspectionSignImageFile != "" {
            self.inspectorSignInput.image = UIImage.init().fromBase64((Cache_Task_On?.inspectionSignImageFile)!)
            self.inspectorSignTap.hidden = true
        }else{
            let keyValueDataHelper = KeyValueDataHelper()
            let signImageInCode = keyValueDataHelper.getInspectorSignImage(String(Cache_Inspector?.inspectorId))
            
            if signImageInCode != "" {
                self.inspectorSignInput.image = UIImage.init().fromBase64(signImageInCode)
                Cache_Task_On?.inspectionSignImageFile = signImageInCode
                self.inspectorSignTap.hidden = true
            }
        }
        
        self.vendorSignTap.hidden = false
        if Cache_Task_On?.vdrSignImageFile != "" {
            self.vendorSignInput.image = UIImage.init().fromBase64((Cache_Task_On?.vdrSignImageFile)!)
            self.vendorSignTap.hidden = true
        }
        
        /*
        if Cache_Task_On?.vdrSignName == "" {
            let taskDataHelper = TaskDataHelper()
            let vdrConfirmerName = taskDataHelper.getLastVdrConfirmerNameToday((Cache_Task_On?.vdrLocationId!)!)
            
            if vdrConfirmerName != "" {
                self.vendorSignBoxInput.text = vdrConfirmerName
            }else{
                self.vendorSignBoxInput.text = taskDataHelper.getVdrConfirmerNameByTaskId((Cache_Task_On?.taskId!)!)
            }
            
        }else{
            self.vendorSignBoxInput.text = Cache_Task_On?.vdrSignName
        }*/
        
        let taskDataHelper = TaskDataHelper()
        Cache_Task_On?.vdrSignName = taskDataHelper.getLastVdrConfirmerNameToday((Cache_Task_On?.vdrLocationId!)!)
        
        if Cache_Task_On?.vdrSignName == "" {
            Cache_Task_On?.vdrSignName = taskDataHelper.getVdrConfirmerNameByTaskId((Cache_Task_On?.taskId!)!)
        }
        
        self.vendorSignBoxInput.text = Cache_Task_On?.vdrSignName
        self.vendorSignBoxInput.delegate = self
        self.inspectorSignBoxInput.text = Cache_Inspector?.inspectorName
        
        updateLocalizedString()
        
        self.vendorSignBoxInput.addTarget(self, action: #selector(SignoffViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    func textFieldDidChange(textField: UITextField) {
        
        Cache_Task_On?.vdrSignName = textField.text
    }
    
    override func viewDidAppear(animated: Bool) {
        //if Cache_Task_On?.taskStatus == GetTaskStatusId(caseId: "Confirmed").rawValue {
        self.view.disableAllFunsForView(self.view)
        //}
    }
    
    func updateLocalizedString() {
        self.inspectorSignLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspector")
        self.vendorSignLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Vendor Confirmer")
        self.inspectorSignBoxLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Signature")
        self.vendorSignBoxLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Signature")
        self.inspectorSignTap.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Tap to Sign"), forState: UIControlState.Normal)
        self.vendorSignTap.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Tap to Sign"), forState: UIControlState.Normal)
        self.inspectorSignClearBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Clear"), forState: UIControlState.Normal)
        self.vendorSignClearBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Clear"), forState: UIControlState.Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        NSLog("Signoff View Will Appear")
        self.view.disableAllFunsForView(self.view)
        self.view.setButtonCornerRadius(self.inspectorSignClearBtn)
        self.view.setButtonCornerRadius(self.vendorSignClearBtn)
        
        let myParentTabVC = self.parentViewController?.parentViewController as! TabBarViewController
        myParentTabVC.setLeftBarItem(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel"),actionName: "backToTaskDetailFromSignOffPage")
        myParentTabVC.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Form")
        
        if (Cache_Task_On?.taskStatus != GetTaskStatusId(caseId: "Confirmed").rawValue && Cache_Task_On?.taskStatus != GetTaskStatusId(caseId: "Cancelled").rawValue) || _DEBUG_MODE {
            myParentTabVC.setRightBarItem(MylocalizedString.sharedLocalizeManager.getLocalizedString("Save & Confirm"), actionName: "confirmTask")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        saveSignImages()
    }
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    */
    
    @IBAction func backMenuButton(sender: UIBarButtonItem) {
        NSLog("Back Menu Click")
        //self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func confirmMenuButton(sender: UIBarButtonItem) {
        NSLog("Confrim Menu Click")
        
    }
    
    @IBAction func inspectorSignTap(sender: UIButton) {
        NSLog("Inspector Sign Tap")
        //self.view.alpha = 0.3
        sender.hidden = true
        self.inspectorSignBoxInput.resignFirstResponder()
        self.vendorSignBoxInput.resignFirstResponder()
        
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
        
        signInputView = SignoffView()//.init()1.58
        signInputView!.frame = CGRectMake(0,0,650,415)
        signInputView!.center = container.center
        signInputView!.backgroundColor = UIColor.whiteColor()
        signInputView!.userInteractionEnabled = true
        
        let okBtn = UIButton(frame: CGRect(x: 600, y: 750, width: 100, height: 50))
        okBtn.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
        okBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Confirm"), forState: UIControlState.Normal)
        okBtn.addTarget(self, action: #selector(SignoffViewController.confirmInspctorSign), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.setButtonCornerRadius(okBtn)
        
        let clearBtn = UIButton(frame: CGRect(x: 490, y: 750, width: 100, height: 50))
        clearBtn.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
        clearBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Clear"), forState: UIControlState.Normal)
        clearBtn.addTarget(self, action: #selector(SignoffViewController.clearInspctorSign), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.setButtonCornerRadius(clearBtn)
        /*
        let cancelBtn = UIButton(frame: CGRect(x: 380, y: 750, width: 100, height: 50))
        cancelBtn.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
        cancelBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel"), forState: UIControlState.Normal)
        cancelBtn.addTarget(self, action: #selector(SignoffViewController.cancelInspctorSign), forControlEvents: UIControlEvents.TouchUpInside)
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
        if self.inspectorSignInput.image == nil {
            self.inspectorSignTap.hidden = false
        }
        
        if self.vendorSignInput.image == nil {
            self.vendorSignTap.hidden = false
        }
        
        self.view.subviews.forEach({if $0.tag == _MASKVIEWTAG {$0.removeFromSuperview()} })
    }
    
    func clearInspctorSign(){
        signInputView?.image = nil
    }
    
    func confirmInspctorSign() {
        if signInputView?.image == nil {
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Signature"))
            return
        }
        
        self.inspectorSignInput.image = signInputView?.image
        Cache_Task_On?.inspectionSignImageFile = self.inspectorSignInput.image?.toBase64()
        
        self.view.subviews.forEach({if $0.tag == _MASKVIEWTAG {$0.removeFromSuperview()} })
    }
    
    func confirmVendorSign() {
        if signInputView?.image == nil {
            self.view.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Please Signature"))
            return
        }
        
        self.vendorSignInput.image = signInputView?.image
        Cache_Task_On?.vdrSignImageFile = self.vendorSignInput.image?.toBase64()
        Cache_Task_On?.vdrSignName = self.vendorSignBoxInput.text
        Cache_Task_On?.vdrSignDate = self.view.getCurrentDateTime()
        
        self.view.subviews.forEach({if $0.tag == _MASKVIEWTAG {$0.removeFromSuperview()} })
    }
    
    @IBAction func vendorSignTap(sender: UIButton) {
        NSLog("Vendor Sign Tap")
        sender.hidden = true
        self.inspectorSignBoxInput.resignFirstResponder()
        self.vendorSignBoxInput.resignFirstResponder()
        
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
        
        signInputView = SignoffView()//.init()
        signInputView!.frame = CGRectMake(0,0,650,415)
        signInputView!.center = container.center
        signInputView!.backgroundColor = UIColor.whiteColor()
        signInputView!.userInteractionEnabled = true
        
        let okBtn = UIButton(frame: CGRect(x: 600, y: 750, width: 100, height: 50))
        okBtn.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
        okBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Confirm"), forState: UIControlState.Normal)
        okBtn.addTarget(self, action: #selector(SignoffViewController.confirmVendorSign), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.setButtonCornerRadius(okBtn)
        
        let clearBtn = UIButton(frame: CGRect(x: 490, y: 750, width: 100, height: 50))
        clearBtn.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
        clearBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Clear"), forState: UIControlState.Normal)
        clearBtn.addTarget(self, action: #selector(SignoffViewController.clearInspctorSign), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.setButtonCornerRadius(clearBtn)
        /*
        let cancelBtn = UIButton(frame: CGRect(x: 380, y: 750, width: 100, height: 50))
        cancelBtn.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
        cancelBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel"), forState: UIControlState.Normal)
        cancelBtn.addTarget(self, action: #selector(SignoffViewController.cancelInspctorSign), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.setButtonCornerRadius(cancelBtn)
        */
        //Use the Regular Size Image
        container.addSubview(signInputView!)
        container.addSubview(okBtn)
        container.addSubview(clearBtn)
        //container.addSubview(cancelBtn)
        
        self.view.addSubview(container)
    }
    
    @IBAction func clearInspectorSign(sender: UIButton) {
        inspectorSignInput.image = nil
        Cache_Task_On?.inspectionSignImageFile = ""
        inspectorSignTap.hidden = false
    }
    
    @IBAction func clearVendorSign(sender: UIButton) {
        vendorSignInput.image = nil
        Cache_Task_On?.vdrSignImageFile = ""
        vendorSignTap.hidden = false
    }
    
    func saveSignImages() {
        print("Save Sign Image.")
        
        if self.inspectorSignInput.image != nil {
            //saveImageToLocal(self.inspectorSignInput.image!, savePath: Cache_Task_Path!, imageName: _INSPECTORSIGNIMAGE)
            Cache_Task_On?.inspectionSignImageFile = self.inspectorSignInput.image?.toBase64()
        }
        
        if self.vendorSignInput.image != nil {
            //saveImageToLocal(self.vendorSignInput.image!, savePath: Cache_Task_Path!, imageName: _VENDORSIGNIMAGE)
            Cache_Task_On?.vdrSignImageFile = self.vendorSignInput.image?.toBase64()
        }
        
        Cache_Task_On?.vdrSignName = self.vendorSignBoxInput.text
    }
    
}
