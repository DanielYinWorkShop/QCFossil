//
//  EmbedContainerController.swift
//  QCFossil
//
//  Created by pacmobile on 18/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

class EmbedContainerController: UIViewController {

    var currentSegueIdentifier = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        /*
            1. _SEGUEIDENTIFIERTASKSEARCH
            2. _SEGUEIDENTIFIERTASKDETAIL
        */
        self.currentSegueIdentifier = _SEGUEIDENTIFIERTASKSEARCH
        self.performSegueWithIdentifier(self.currentSegueIdentifier, sender: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EmbedContainerController.switchToTaskSearch), name: "switchToTaskSearch", object: nil)
        
        //addClearDropdownListTapGesture()
    }
    
    /*
    func addClearDropdownListTapGesture() {
        //Add Tap Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("gestureRecognizer:"))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        print("trigger gesture!")
        if touch.view!.isKindOfClass(UITextField().classForCoder) || String(touch.view!.classForCoder) == "UITableViewCellContentView" {
            self.view.resignFirstResponderByTextField(self.view)
            print("trigger gesture: resignFirstResponderByTextField!")
            
        }else {
            
            if (touch.view!.parentVC?.classForCoder)! == TaskSearchViewController.classForCoder() || (touch.view!.parentVC?.classForCoder)! == TaskDetailsViewController.classForCoder() || (touch.view!.parentVC?.classForCoder)! == POSearchViewController.classForCoder() {
                self.view.clearDropdownviewForSubviews(self.view)
                print("trigger gesture: clearDropdownviewForSubviews!")
                
            }
        }
        
        return false
    }
    */
    override func viewDidDisappear(animated: Bool) {
        print("Remove Observer From EmbedContainerVC Now")
        
        //NSNotificationCenter.defaultCenter().removeObserver(self, name: "switchToTaskSearch", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //self.view.subviews.forEach({ $0.removeFromSuperview() })
        
        let destVC = segue.destinationViewController as! UINavigationController
        let destVCChildVC = destVC.childViewControllers[0]
        
        var added = false
        for childVC in self.childViewControllers {
            let childChildVC = childVC.childViewControllers[0]
                
            if childChildVC.classForCoder == destVCChildVC.classForCoder {
                added = true
            }
        }
        
        if !added {
            self.addChildViewController(segue.destinationViewController)
                
            let destView = segue.destinationViewController.view
            destView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            self.view.addSubview(destView)
            segue.destinationViewController.didMoveToParentViewController(self)
                
        }else{
            for childVC in self.childViewControllers {
                let childChildVC = childVC.childViewControllers[0]
                
                if childChildVC.classForCoder == destVCChildVC.classForCoder {
                    self.view.addSubview(childVC.view)
                    
                    if childChildVC.classForCoder == TaskSearchViewController.classForCoder() {
                        let taskSearchVC = childChildVC as! TaskSearchViewController
                        /*
                        if Cache_Task_On?.taskId > 0 {
                            
                            let taskOnArray = taskSearchVC.tasks.filter({$0.taskId == Cache_Task_On?.taskId})
                            if taskOnArray.count < 1 {
                                taskSearchVC.tasks.append(Cache_Task_On!)
                            }
                            
                            let taskSetOnArray = taskSearchVC.taskSet.filter({$0.taskId == Cache_Task_On?.taskId})
                            if taskSetOnArray.count < 1 {
                                taskSearchVC.taskSet.append(Cache_Task_On!)
                            }
                        }*/
                        
                        taskSearchVC.reloadTaskSearchTableView()
                        //taskSearchVC.taskItemTableView.reloadData()
                    }else if childChildVC.classForCoder == POSearchViewController.classForCoder() {
                        let poSearchVC = childChildVC as! POSearchViewController
                        poSearchVC.reloadPoSearchTableView()
                        
                    }
                }
                
                if childChildVC.classForCoder == DataSyncViewController.classForCoder() && destVCChildVC.classForCoder != DataSyncViewController.classForCoder() {
                    let dataSyncVC = childChildVC as! DataSyncViewController
                    dataSyncVC.resetSession()
                }
            }
        }
    }
    
    func switchSegue(segueIdentifier:String) {
        //NSLog("Switch Segue: %@",segueIdentifier)
        dispatch_async(dispatch_get_main_queue(), {
            self.view.showActivityIndicator("Loading")
            
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.currentSegueIdentifier = segueIdentifier
                self.performSegueWithIdentifier(self.currentSegueIdentifier, sender: nil)
            }
        })
    }
    
    func switchToTaskSearch() {
        self.currentSegueIdentifier = _SEGUEIDENTIFIERTASKSEARCH
        self.performSegueWithIdentifier(self.currentSegueIdentifier, sender: nil)
    }
    
}
