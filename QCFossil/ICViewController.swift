//
//  ICViewController.swift
//  QCFossil
//
//  Created by pacmobile on 30/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

class ICViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSLog("IC View Will Disappear")
        NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":true])
    }
    
    override func viewWillAppear(animated: Bool) {
        NSLog("IC View Will Appear")
        NSNotificationCenter.defaultCenter().postNotificationName("setScrollable", object: nil,userInfo: ["canScroll":false])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    var oldContentOffset = CGPoint(x: 0.0,y: 0.0)
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.oldContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x != self.oldContentOffset.x {
            scrollView.pagingEnabled = true
            scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x,self.oldContentOffset.y)
        } else {
            scrollView.pagingEnabled = false
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.oldContentOffset = scrollView.contentOffset
    }
    
    
}
