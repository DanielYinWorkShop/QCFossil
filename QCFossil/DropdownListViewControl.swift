//
//  DropdownListViewControl.swift
//  QCFossil
//
//  Created by Yin Huang on 20/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class DropdownListViewControl: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var tableView = UITableView()
    var dropdownData = [String]()
    var dropdownDataFilter = [String]()
    weak var myParentTextField:UITextField!
    var sizeWidth = 0
    var sizeHeight = 0
    var selectedTableViewCell = [UITableViewCell]()
    var handleFun:((UITextField)->(Void))? = nil
    var allowManuallyInput = false
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func longPressed(sender: UIGestureRecognizer) {
        if let cell = sender.view as? UITableViewCell {
            let popoverContent = PopoverViewController()
            popoverContent.preferredContentSize = CGSizeMake(320,150 + _NAVIBARHEIGHT)
            
            popoverContent.dataType = _POPOVERNOTITLE
            popoverContent.selectedValue = cell.textLabel?.text ?? ""
            
            let nav = UINavigationController(rootViewController: popoverContent)
            nav.modalPresentationStyle = UIModalPresentationStyle.Popover
            nav.navigationBar.barTintColor = UIColor.whiteColor()
            nav.navigationBar.tintColor = UIColor.blackColor()
 
            let popover = nav.popoverPresentationController
            popover?.delegate = nil
            popover?.sourceView = sender.view
            popover?.sourceRect = CGRectMake(0,(sender.view?.parentVC?.view.frame.origin.y)!,sender.view!.frame.size.width,sender.view!.frame.size.height)
            
            sender.view?.parentVC!.presentViewController(nav, animated: true, completion: nil)
        }
    }
    
    override func didMoveToSuperview() {
        if (self.parentVC == nil) {
            // a removeFromSuperview situation
            return
        }
        
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 5
        
        tableView.frame = CGRect.init(x: 0, y: 0, width: sizeWidth, height: sizeHeight)
        self.addSubview(tableView)
        
        dropdownDataFilter = dropdownData
        
        let selectedValues = myParentTextField?.text!.stringByReplacingOccurrencesOfString(", ", withString: ",")
        
        let cells = selectedValues!.characters.split{$0 == ","}.map(String.init)
        for cell in cells {
            let cellObj = UITableViewCell.init()
            cellObj.textLabel?.text = cell as String
            self.selectedTableViewCell.append(cellObj)
        }
        
        self.tableView.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropdownDataFilter.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.textLabel?.text = dropdownDataFilter[indexPath.row] as String
        
        self.selectedTableViewCell.forEach({
            if $0.textLabel?.text == cell.textLabel?.text {
                cell.textLabel?.textColor = UIColor.whiteColor()
                cell.contentView.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
                tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            }
        })
        
        if indexPath.row % 2 == 0{
            cell.backgroundColor = _TABLECELL_BG_COLOR1
        }else{
            cell.backgroundColor = _TABLECELL_BG_COLOR2
        }
        
        if tableView.allowsMultipleSelection == true {
            updateBgColor(cell)
        }
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DropdownListViewControl.longPressed(_:)))
        cell.addGestureRecognizer(longPressRecognizer)
        
        return cell
    }
    
    func updateBgColor(cell:UITableViewCell) {
        let bgColorView = UIView()
        bgColorView.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
        cell.selectedBackgroundView = bgColorView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.allowsMultipleSelection == true {
            let selectedCell = tableView.cellForRowAtIndexPath(indexPath)!
            var selected = false
            for cell in selectedTableViewCell {
               
                if selectedCell.textLabel!.text == cell.textLabel!.text {
                    selected = true
                }
            }
            
            if !selected {
                selectedTableViewCell.append(tableView.cellForRowAtIndexPath(indexPath)!)
                selectedCell.contentView.backgroundColor = _DEFAULTBUTTONTEXTCOLOR
                selectedCell.textLabel?.textColor = UIColor.whiteColor()
            
                if myParentTextField != nil {
                    let text = String(dropdownDataFilter[indexPath.row])
                    //myParentTextField!.text! += text+", "
                    
                    if myParentTextField!.text == "" {
                        myParentTextField!.text! += text
                    }else{
                        myParentTextField!.text! += ", "+text
                    }
                    
                    if (handleFun != nil){
                        handleFun!(myParentTextField!)
                    }
                }
            }
            
        }else {
            if self.allowManuallyInput {
                
                if myParentTextField != nil {
                    guard let oldText = myParentTextField?.text else {
                        myParentTextField?.text = String(dropdownDataFilter[indexPath.row])

                        if (handleFun != nil){
                            handleFun!(myParentTextField!)
                        }
                        return
                    }
                    
                    myParentTextField!.text = oldText + String(dropdownDataFilter[indexPath.row])
                    handleFun?(myParentTextField!)
                }
                
                
            } else {
            
                if myParentTextField != nil {
                    myParentTextField?.text = String(dropdownDataFilter[indexPath.row])
                    handleFun?(myParentTextField!)
                }
            }
            
            Cache_Dropdown_Instance = nil
            self.removeFromSuperview()
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.allowsMultipleSelection == true {
        let cell = (tableView.cellForRowAtIndexPath(indexPath)!)
        cell.textLabel?.textColor = UIColor.blackColor()
        if indexPath.row % 2 == 0{
            cell.contentView.backgroundColor = _TABLECELL_BG_COLOR1
        }else{
            cell.contentView.backgroundColor = _TABLECELL_BG_COLOR2
        }
        
        for idx in 0...selectedTableViewCell.count-1 {
            if selectedTableViewCell[idx].textLabel?.text == cell.textLabel?.text {
                //Remove Text From Parent TextField
                
                if idx < 1 && selectedTableViewCell.count > 1 {
                    myParentTextField?.text = myParentTextField?.text!.stringByReplacingOccurrencesOfString((cell.textLabel?.text)!+", ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                }else if idx < 1 && selectedTableViewCell.count < 2 {
                    myParentTextField?.text = myParentTextField?.text!.stringByReplacingOccurrencesOfString((cell.textLabel?.text)!, withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                }else{
                    myParentTextField?.text = myParentTextField?.text!.stringByReplacingOccurrencesOfString(", "+(cell.textLabel?.text)!, withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                }
                
                selectedTableViewCell.removeAtIndex(idx)
                break
            }
        }
            
        if (handleFun != nil){
            handleFun!(myParentTextField!)
        }
        }
    }
    
    func dismissMyself() {
        self.removeFromSuperview()
    }
}
