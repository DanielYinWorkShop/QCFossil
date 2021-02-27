//
//  PopoverViewController.swift
//  QCFossil
//
//  Created by Yin Huang on 13/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {

    //var pVC = TaskTypeViewController()
    var parentView:UIView!
    weak var parentTextFieldView:UITextField!
    var inputview = PopoverViewsInput()
    var calenderview = CalenderPickerViewInput()
    var shapepreview = ShapePreviewViewInput()
    var sourceType:String!
    var dataType:String! = _POPOVERDATATPYE
    var selectedValue:String = ""
    var didPickCompletion:(()->(Void))?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        if dataType == _POPOVERDATETPYE {
            calenderview = CalenderPickerViewInput.loadFromNibNamed("CalenderPickerView")!
            calenderview.frame = CGRectMake(0, _NAVIBARHEIGHT, 325, 350+_NAVIBARHEIGHT)
            
            self.view.addSubview(calenderview)
 
            
        }else if dataType == _POPOVERPRODDESC {
            self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Prod Desc")
            
            var descView = UITextView.init(frame: CGRect(x: 0,y: 0,width: 325,height: 500))
            if #available(iOS 13.0, *) {
                descView = UITextView.init(frame: CGRect(x: 0,y: _NAVIBARHEIGHT,width: 325,height: 500))
            }
            descView.text = selectedValue
            descView.userInteractionEnabled = false
            
            self.view.addSubview(descView)
            
        }else if dataType == _POPOVERPOPDRSD {
            self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("OPD/RSD")
            
            self.automaticallyAdjustsScrollViewInsets = false
            
            let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: _NAVIBARHEIGHT, width: 325, height: 150+_NAVIBARHEIGHT))
            scrollView.contentSize = CGSize.init(width: 325, height: 150+_NAVIBARHEIGHT)
            
            self.view.addSubview(scrollView)
            
            let poItemString = selectedValue
            let poItemNames = poItemString.characters.split{$0 == ","}.map(String.init)
            
            if poItemNames.count>0 {
                for idx in 0...poItemNames.count-1 {
                    
                    let poItem = UILabel.init(frame: CGRect(x: 10,y: idx*20+10,width: 325,height: 21))
                    //poItem.font = UIFont(name: "", size: 30)
                    poItem.text = poItemNames[idx]
                    
                    scrollView.addSubview(poItem)
                }
                
                let newHeight:CGFloat = CGFloat(poItemNames.count*21)
                scrollView.contentSize = CGSize.init(width: 325, height: newHeight+_NAVIBARHEIGHT)
            }
            
            let rightButton=UIBarButtonItem()
            rightButton.title=MylocalizedString.sharedLocalizeManager.getLocalizedString("Close")
            rightButton.tintColor = UIColor.blackColor()
            rightButton.style=UIBarButtonItemStyle.Plain
            rightButton.target=self
            rightButton.action=#selector(PopoverViewController.cancelPick)
            self.navigationItem.rightBarButtonItem=rightButton
            
            return
        }else if dataType == _POPOVERTASKSTATUSDESC {
            self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Refused")
            
            let descView = UITextView.init(frame: CGRect(x: 0,y: 0,width: 325,height: 500))
            descView.text = selectedValue
            descView.userInteractionEnabled = false 
            
            self.view.addSubview(descView)
            
        }else if dataType == _POPOVERPOITEMTYPE || dataType == _POPOVERPOITEMTYPESHIPWIN {
            if dataType == _POPOVERPOITEMTYPE {
                self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("PO List/Material")
            }else{
                self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("SW/Req. Ex-fty Date")
            }
            
            self.automaticallyAdjustsScrollViewInsets = false
            
            let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: _NAVIBARHEIGHT, width: 325, height: 150+_NAVIBARHEIGHT))
            scrollView.contentSize = CGSize.init(width: 325, height: 150+_NAVIBARHEIGHT)
            
            self.view.addSubview(scrollView)
            
            let poItemString = selectedValue
            let poItemNames = poItemString.characters.split{$0 == ","}.map(String.init)
            
            if poItemNames.count>0 {
                for idx in 0...poItemNames.count-1 {
            
                    let poItem = UILabel.init(frame: CGRect(x: 10,y: idx*20+10,width: 325,height: 21))
                    //poItem.font = UIFont(name: "", size: 30)
                    poItem.text = poItemNames[idx]
            
                    scrollView.addSubview(poItem)
                }
                
                let newHeight:CGFloat = CGFloat(poItemNames.count*21)
                scrollView.contentSize = CGSize.init(width: 325, height: newHeight+_NAVIBARHEIGHT)
            }
            
            let rightButton=UIBarButtonItem()
            rightButton.title=MylocalizedString.sharedLocalizeManager.getLocalizedString("Close")
            rightButton.tintColor = UIColor.blackColor()
            rightButton.style=UIBarButtonItemStyle.Plain
            rightButton.target=self
            rightButton.action=#selector(PopoverViewController.cancelPick)
            self.navigationItem.rightBarButtonItem=rightButton
            
            return
        }else if dataType == _SHAPEDATATYPE {
            shapepreview = ShapePreviewViewInput.loadFromNibNamed("ShapePreviewView")!
            shapepreview.frame = CGRectMake(0, _NAVIBARHEIGHT, 330, /*220+_NAVIBARHEIGHT*/330+_NAVIBARHEIGHT)
            shapepreview.parentView = self.parentView
            self.view.addSubview(shapepreview)
            
            self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Shape Types")
            
            let rightButton=UIBarButtonItem()
            rightButton.title=MylocalizedString.sharedLocalizeManager.getLocalizedString("Close")
            rightButton.tintColor = UIColor.blackColor()
            rightButton.style=UIBarButtonItemStyle.Plain
            rightButton.target=self
            rightButton.action=#selector(PopoverViewController.cancelPick)
            self.navigationItem.rightBarButtonItem=rightButton
            
            return
        }else if dataType == _DEFECTPPDESC {
        
            self.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("Defect Position Point(s)")
            
            let descView = UITextView.init(frame: CGRect(x: 0,y: 0,width: 325,height: 500))
            descView.text = selectedValue
            descView.userInteractionEnabled = false
            
            self.view.addSubview(descView)
            
            self.automaticallyAdjustsScrollViewInsets = false
            
            let scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: _NAVIBARHEIGHT, width: 325, height: 150+_NAVIBARHEIGHT))
            scrollView.contentSize = CGSize.init(width: 325, height: 150+_NAVIBARHEIGHT)
            
            self.view.addSubview(scrollView)
            
            let poItemString = selectedValue
            let poItemNames = poItemString.characters.split{$0 == ","}.map(String.init)
            
            if poItemNames.count>0 {
                for idx in 0...poItemNames.count-1 {
                    
                    let poItem = UILabel.init(frame: CGRect(x: 10,y: idx*20+10,width: 325,height: 21))
                    
                    if idx < 1 {
                        poItem.text = "\((idx+1)).  \(poItemNames[idx])"
                    }else{
                        poItem.text = "\((idx+1)). \(poItemNames[idx])"
                    }
                    
                    scrollView.addSubview(poItem)
                }
                
                let newHeight:CGFloat = CGFloat(poItemNames.count*21)
                scrollView.contentSize = CGSize.init(width: 325, height: newHeight+_NAVIBARHEIGHT)
            }
            
            return
        }else if dataType == _POPOVERNOTITLE {
            if let nav = self.parentViewController as? UINavigationController {
                nav.setNavigationBarHidden(true, animated: false)
            }
            
            let descView = UITextView.init(frame: CGRect(x: 0,y: 0,width: 325,height: 500))
            descView.text = selectedValue
            descView.userInteractionEnabled = false
            descView.font = UIFont.systemFontOfSize(18.0)
            
            self.view.addSubview(descView)
            
            return
        } else if dataType == _DOWNLOADTASKSTATUSDESC {
            if let nav = self.parentViewController as? UINavigationController {
                nav.setNavigationBarHidden(true, animated: false)
            }
            
            let descView = UITextView.init(frame: CGRect(x: 0,y: 0,width: 640, height: 320))
            descView.text = selectedValue
            descView.userInteractionEnabled = true
            descView.font = UIFont.systemFontOfSize(18.0)
            self.view.addSubview(descView)
        
        } else{
            inputview = PopoverViewsInput.loadFromNibNamed("PopoverViews")!
            inputview.initData(sourceType)
            inputview.typeSelection.frame = CGRectMake(0, _NAVIBARHEIGHT, _POPOVERVIEWSIZE_S.width, _POPOVERVIEWSIZE_S.height)
            inputview.addSubview((inputview.typeSelection)!)
            self.view.addSubview(inputview)
            
        }
        
        let leftButton=UIBarButtonItem()
        leftButton.title=MylocalizedString.sharedLocalizeManager.getLocalizedString("Cancel")
        leftButton.tintColor = UIColor.whiteColor()
        leftButton.style=UIBarButtonItemStyle.Plain
        leftButton.target=self
        leftButton.action=#selector(PopoverViewController.cancelPick)
        self.navigationItem.leftBarButtonItem=leftButton
        
        let rightButton=UIBarButtonItem()
        rightButton.title=MylocalizedString.sharedLocalizeManager.getLocalizedString("Done")
        rightButton.tintColor = UIColor.whiteColor()
        rightButton.style=UIBarButtonItemStyle.Plain
        rightButton.target=self
        rightButton.action=#selector(PopoverViewController.didPick)
        self.navigationItem.rightBarButtonItem=rightButton
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
    
    func cancelPick() {
        print("cancel pick")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didPick() {
        print("did pick: \(self.selectedValue)")
        //pVC.productType.text = self.inputview.selectedValue
        
        parentTextFieldView?.text = selectedValue
        
        /*if self.selectedValue != nil {
            setValueBySourceType(sourceType, selectedValue: self.selectedValue)
        }*/
        self.didPickCompletion?()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
