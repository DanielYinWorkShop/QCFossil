//
//  TaskTypeSelectionViewController.swift
//  QCFossil
//
//  Created by Yin Huang on 11/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class TaskTypeSelectionViewController: UIViewController {

    @IBOutlet weak var productType: UITextField!
    @IBOutlet weak var inptType: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.view.addSubview(UILabel.init(frame: CGRect(x: 0,y: 0,width: 100,height: 100)))
        
        /*let inputview = TaskTypeSelectionView.loadFromNibNamed("TaskTypeSelectionView")
        inputview?.tag = 1
        inputview?.userInteractionEnabled = true
        self.view.addSubview(inputview!)
        
        self.view.bringSubviewToFront(self.view.viewWithTag(1)!)
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func okButton(sender: UIButton) {
        //let inputview = CreateTaskView.loadFromNibNamed("CreateTaskView")
        //self.view.addSubview(inputview!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
