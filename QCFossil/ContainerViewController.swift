//
//  ContainerViewController.swift
//  QCFossil
//
//  Created by pacmobile on 18/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController{
    
    // This value matches the left menu's width in the Storyboard
    let leftMenuWidth:CGFloat = 180
    weak var embedContainerController:EmbedContainerController!
    
    @IBOutlet weak var containerScroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Set up a notification for toggleMenu from other page.
        
        //Init Toggle Menu Notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ContainerViewController.toggleMenu), name: "toggleMenu", object: nil)
        //Init Task Search Menu Click Response Notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ContainerViewController.taskSearchMenuClickResponse(_:)), name: "taskSearchMenuClickResponse", object: nil)
        //Init Toggle Scrollable Notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ContainerViewController.setScrollable(_:)), name: "setScrollable", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue()) {
            NSLog("Close Menu.")
            
            self.closeMenu(false)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "toggleMenu", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "taskSearchMenuClickResponse", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "setScrollable", object: nil)
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
        
        if segue.identifier == "embedContainer" {
            self.embedContainerController = segue.destinationViewController as? EmbedContainerController
        }
    }
    
    func closeMenu(animated:Bool = true) {
        containerScroll.setContentOffset(CGPoint(x: leftMenuWidth, y: 0), animated: animated)
    }
    
    func displayMenu(animated:Bool = true) {
        containerScroll.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
    }
    
    func toggleMenu(){
        if self.containerScroll.scrollEnabled {
            containerScroll.contentOffset.x == 0  ? closeMenu() : displayMenu()
        }
    }
    
    func taskSearchMenuClickResponse(notification:NSNotification){
        //closeMenu()
        let userInfo:Dictionary<String,String!> = notification.userInfo as! Dictionary<String,String!>
        let segueIdentifier = userInfo[_SEGUEIDENTIFIER]

        self.embedContainerController!.switchSegue(segueIdentifier!)
    }
    
    func setScrollable(notification:NSNotification) {
        let userInfo:Dictionary<String,Bool!> = notification.userInfo as! Dictionary<String,Bool!>
        let canScroll = userInfo["canScroll"]
        
        if canScroll == false {
            closeMenu()
        }
        
        self.containerScroll.scrollEnabled = canScroll!
    }
}

/*
    Funcs of UIScrollViewDelegate
*/
extension ContainerViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(containerScroll: UIScrollView) {
        //print("scrollView.contentOffset.x:: \(containerScroll.contentOffset.x)")
    }
    
    func scrollViewWillBeginDragging(containerScroll: UIScrollView) {
        //NSLog("pagingEnabled: true")
        containerScroll.pagingEnabled = true
    }
    
    func scrollViewDidEndDecelerating(containerScroll: UIScrollView) {
        //NSLog("pagingEnabled: false")
        containerScroll.pagingEnabled = false
    }
}