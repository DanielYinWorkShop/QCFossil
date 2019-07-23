//
//  QCInfoViewController.swift
//  QCFossil
//
//  Created by pacmobile on 15/7/2019.
//  Copyright © 2019 kira. All rights reserved.
//

import UIKit

class QCInfoViewController: UIViewController, UIScrollViewDelegate {
    
    var ScrollView = UIScrollView()
    
    override func viewDidLoad() {
        let taskQCInfoView = TaskQCInfoView.loadFromNibNamed("TaskQCInfoView")!
        
        self.ScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 50, width: 768, height: 1024))
        
        self.ScrollView.contentSize = CGSize.init(width: 768, height: 1500)
        self.ScrollView.delegate = self
        
        self.view.addSubview(self.ScrollView)
        
        self.ScrollView.addSubview(taskQCInfoView)
    }
    
    
}