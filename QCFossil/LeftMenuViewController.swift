//
//  LeftMenuViewController.swift
//  QCFossil
//
//  Created by pacmobile on 21/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController {
    
    @IBOutlet weak var taskSearchBtn: UIButton!
    @IBOutlet weak var poSearchBtn: UIButton!
    @IBOutlet weak var dataSyncBtn: UIButton!
    @IBOutlet weak var userLogoutBtn: UIButton!
    @IBOutlet weak var dataControlBtn: UIButton!
    @IBOutlet weak var userSettingBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLocalizedString()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLocalizedString(){
        
        self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Version") + " \(_VERSION)"
        
        self.taskSearchBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Search"), forState: UIControlState.Normal)
        self.poSearchBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("PO Search"), forState: UIControlState.Normal)
        self.dataSyncBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Data Sync"), forState: UIControlState.Normal)
        self.userLogoutBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("User Logout"), forState: UIControlState.Normal)
        self.dataControlBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Data Control"), forState: UIControlState.Normal)
        self.userSettingBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("User Setting"), forState: UIControlState.Normal)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func TaskSearchMenuClick(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("taskSearchMenuClickResponse", object: nil, userInfo: [_SEGUEIDENTIFIER:_SEGUEIDENTIFIERTASKSEARCH])
    }
    
    @IBAction func poSearchMenuClick(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("taskSearchMenuClickResponse", object: nil, userInfo: [_SEGUEIDENTIFIER:_SEGUEIDENTIFIERPOSEARCH])
    }
    
    @IBAction func dataSyncMenuClick(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("taskSearchMenuClickResponse", object: nil, userInfo: [_SEGUEIDENTIFIER:_SEGUEIDENTIFIERDATASYNC])
    }
    
    @IBAction func userLogoutMenuClick(sender: UIButton) {
        Cache_Task_On = nil
        Cache_Inspector = nil
        Cache_Task_Path = ""
        Cache_Thumb_Path = ""
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func DataControlMenuClick(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("taskSearchMenuClickResponse", object: nil, userInfo: [_SEGUEIDENTIFIER:_SEGUEIDENTIFIERDATACTRL])
    }
    
    @IBAction func UserSettingMenuClick(sender: UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("taskSearchMenuClickResponse", object: nil, userInfo: [_SEGUEIDENTIFIER:_SEGUEIDENTIFIERUSERSETTING])
    }
}
