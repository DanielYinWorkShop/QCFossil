//
//  InputModeSCMaster.swift
//  QCFossil
//
//  Created by pacmobile on 3/2/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class InputModeSCMaster:UIView {
    
    var idx = 0
    var categoryIdx = 0
    var categoryName = ""
    var inspSection:InspSection?
    var InputMode = ""
    var resultSetId = 0
    var resultValues = [String]()
    var resultForAll = ""
    var optInspElmsMaster = [InspSectionElement]()
    var optInspPostsMaster = [InspSectionPosition]()
    var optInspElms = [InspSectionElement]()
    var optInspPosts = [InspSectionPosition]()
    var resultKeyValues = [String:Int]()
    
    func initSegmentControlView(inputMode:String, apyToAllBtn:UIButton) {
        let taskDataHelper = TaskDataHelper()
        let otherInspSecTmp = Cache_Task_On?.inspSections.filter({$0.inputModeCode == inputMode})
        var otherInspSec = otherInspSecTmp
        
        if otherInspSec!.count > 0 {
            
            resultSetId = otherInspSec![0].resultSetId!
            resultValues = taskDataHelper.getResultSetValueBySetId(resultSetId)!
            resultKeyValues = taskDataHelper.getResultKeyValueBySetId(resultSetId)!

            if resultValues.count>0 {
                
                resultForAll = resultValues[0]
                
                let segmentedControl = UISegmentedControl.init(items: resultValues)
                
                segmentedControl.selectedSegmentIndex = 0
                segmentedControl.layer.cornerRadius = 5.0
                
                let font = UIFont.systemFontOfSize(16)
                segmentedControl.setTitleTextAttributes([NSFontAttributeName: font],
                    forState: UIControlState.Normal)
                
                segmentedControl.backgroundColor = _FOSSILYELLOWCOLOR
                segmentedControl.tintColor = _FOSSILBLUECOLOR
                
                let frame = UIScreen.mainScreen().bounds
                segmentedControl.frame = CGRectMake(frame.minX + 5, frame.minY + 24,
                    frame.width*2/3, 30)
                
                segmentedControl.addTarget(self, action: #selector(InputModeSCMaster.resultSelect(_:)), forControlEvents:.ValueChanged)
                self.addSubview(segmentedControl)
                
                apyToAllBtn.frame = CGRectMake(segmentedControl.frame.size.width+20, frame.minY + 24, 120, 30)
                apyToAllBtn.addTarget(self, action: Selector("applyRstToAll"), forControlEvents: UIControlEvents.TouchUpInside)
                self.addSubview(apyToAllBtn)
                
                apyToAllBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Apply to All"), forState: UIControlState.Normal )
                setButtonCornerRadius(apyToAllBtn)
            }
            
            if self.idx < 1 {
                let moveRightBtn = CustomButton()
                let moveRightIcon = UIImage.init(named: "arrow_icon_right")
                moveRightBtn.frame = CGRectMake(705, 0, 80, 80)
                moveRightBtn.setImage(moveRightIcon, forState: UIControlState.Normal)
                moveRightBtn.tintColor = _FOSSILBLUECOLOR
                moveRightBtn.addTarget(self, action: #selector(InputModeSCMaster.moveToRight(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.addSubview(moveRightBtn)
                
            }else if self.idx < otherInspSec!.count {
                let moveLeftBtn = CustomButton()
                let moveLeftIcon = UIImage.init(named: "arrow_icon_left")
                moveLeftBtn.frame = CGRectMake(645, 0, 80, 80)
                moveLeftBtn.setImage(moveLeftIcon, forState: UIControlState.Normal)
                moveLeftBtn.tintColor = _FOSSILBLUECOLOR
                moveLeftBtn.addTarget(self, action: #selector(InputModeSCMaster.moveToLeft(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.addSubview(moveLeftBtn)
                
                let moveRightBtn = CustomButton()
                let moveRightIcon = UIImage.init(named: "arrow_icon_right")
                moveRightBtn.frame = CGRectMake(705, 0, 80, 80)
                moveRightBtn.setImage(moveRightIcon, forState: UIControlState.Normal)
                moveRightBtn.tintColor = _FOSSILBLUECOLOR
                moveRightBtn.addTarget(self, action: #selector(InputModeSCMaster.moveToRight(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.addSubview(moveRightBtn)
                
            }else{
                let moveLeftBtn = CustomButton()
                let moveLeftIcon = UIImage.init(named: "arrow_icon_left")
                moveLeftBtn.frame = CGRectMake(645, 0, 80, 80)
                moveLeftBtn.setImage(moveLeftIcon, forState: UIControlState.Normal)
                moveLeftBtn.tintColor = _FOSSILBLUECOLOR
                moveLeftBtn.addTarget(self, action: #selector(InputModeSCMaster.moveToLeft(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                self.addSubview(moveLeftBtn)
            }
        }
    }
    
    func moveToLeft(sender: UIButton) {
        let parentView = (sender.parentVC as! TaskDetailsViewController).ScrollView.viewWithTag(_TASKINSPCATVIEWTAG)
        (parentView as! InspectionViewInput).scrollToPosition(self.idx-1)
    }
    
    func moveToRight(sender: UIButton) {
        let parentView = (sender.parentVC as! TaskDetailsViewController).ScrollView.viewWithTag(_TASKINSPCATVIEWTAG)
        (parentView as! InspectionViewInput).scrollToPosition(self.idx+1)
    }

    func resultSelect(sender: UISegmentedControl) {
        resultForAll = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!
    }
    
}
