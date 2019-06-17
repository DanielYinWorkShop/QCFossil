//
//  InptCategoryCell.swift
//  QCFossil
//
//  Created by Yin Huang on 14/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class InptCategoryCell: UIView {

    @IBOutlet weak var resultValue1: UILabel!
    @IBOutlet weak var resultValue2: UILabel!
    @IBOutlet weak var resultValue3: UILabel!
    @IBOutlet weak var resultValue4: UILabel!
    @IBOutlet weak var resultValue5: UILabel!
    @IBOutlet weak var resultValueTotal: UILabel!
    
    @IBOutlet weak var inptCatButton: CustomButton!
    weak var parentView:TaskDetailViewInput!
    var resultSetValueFrames = [ResultValueFrame]()
    var resultSetValues = [SummaryResultValue]()
    var resultValueLabels = [UILabel]()
    var frameWidth:CGFloat = 90.0
    var frameHeight:CGFloat = 21.0
    var frameTop:CGFloat = 9
    var sectionId:Int?
    
    let marginX1:CGFloat = 191
    let marginX2:CGFloat = 289
    let marginX3:CGFloat = 387
    let marginX4:CGFloat = 484
    let marginX5:CGFloat = 582
    let marginX6:CGFloat = 680
    
    struct ResultValueFrame {
        var xPos:CGFloat
        var yPos:CGFloat
        var width:CGFloat
        var height:CGFloat
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        let resultValueFrame1 = ResultValueFrame(xPos: marginX1, yPos: frameTop, width: frameWidth, height: frameHeight)
        let resultValueFrame2 = ResultValueFrame(xPos: marginX2, yPos: frameTop, width: frameWidth, height: frameHeight)
        let resultValueFrame3 = ResultValueFrame(xPos: marginX3, yPos: frameTop, width: frameWidth, height: frameHeight)
        let resultValueFrame4 = ResultValueFrame(xPos: marginX4, yPos: frameTop, width: frameWidth, height: frameHeight)
        let resultValueFrame5 = ResultValueFrame(xPos: marginX5, yPos: frameTop, width: frameWidth, height: frameHeight)
        let resultValueFrame6 = ResultValueFrame(xPos: marginX6, yPos: frameTop, width: frameWidth, height: frameHeight)
        
        resultSetValueFrames.append(resultValueFrame1)
        resultSetValueFrames.append(resultValueFrame2)
        resultSetValueFrames.append(resultValueFrame3)
        resultSetValueFrames.append(resultValueFrame4)
        resultSetValueFrames.append(resultValueFrame5)
        resultSetValueFrames.append(resultValueFrame6)
        
        resultValue1.frame = CGRectMake(marginX1, frameTop, frameWidth, frameHeight)
        resultValue1.textAlignment = .Center
        resultValueLabels.append(resultValue1)
        
        resultValue2.frame = CGRectMake(marginX2, frameTop, frameWidth, frameHeight)
        resultValue2.textAlignment = .Center
        resultValueLabels.append(resultValue2)
        
        resultValue3.frame = CGRectMake(marginX3, frameTop, frameWidth, frameHeight)
        resultValue3.textAlignment = .Center
        resultValueLabels.append(resultValue3)
        
        resultValue4.frame = CGRectMake(marginX4, frameTop, frameWidth, frameHeight)
        resultValue4.textAlignment = .Center
        resultValueLabels.append(resultValue4)
        
        resultValue5.frame = CGRectMake(marginX5, frameTop, frameWidth, frameHeight)
        resultValue5.textAlignment = .Center
        resultValueLabels.append(resultValue5)
        
        resultValueTotal.frame = CGRectMake(marginX6, frameTop, frameWidth, frameHeight)
        resultValueTotal.textAlignment = .Center
        resultValueLabels.append(resultValueTotal)
    }
    
    override func didMoveToSuperview() {
        if self.parentVC == nil {
            return
        }
        
        self.setButtonCornerRadius(self.inptCatButton)
        updateSummaryResultValues(resultSetValues)
    }
    
    func updateSummaryResultValues(resultSetValues:[SummaryResultValue]) {
        
        var totalCount = 0
        for idx in 0...resultSetValues.count {
            if idx < resultValueLabels.count {
            let resultValueLabel = resultValueLabels[idx]
            
            resultValueLabel.font = resultValueTotal.font.fontWithSize(14)
            if idx == resultSetValues.count {
                
                if resultSetValues.count < 5 {
                    resultValueLabel.frame.origin.x = marginX6
                }
                
                resultValueLabel.text = "\(MylocalizedString.sharedLocalizeManager.getLocalizedString("Total"))(\(totalCount))"
                
            }else{
                let resultSetValue = resultSetValues[idx]
                
                resultValueLabel.text = "\(resultSetValue.valueName)(\(resultSetValue.resultCount))"
                totalCount += resultSetValue.resultCount
            }
            
            self.addSubview(resultValueLabel)
            }
        }
        
    }
    
    @IBAction func inptCatButton(sender: UIButton) {
        let myParentVC = self.parentVC as! TaskDetailsViewController
        myParentVC.startTask(sender.tag)
    }
}