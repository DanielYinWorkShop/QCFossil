//
//  InputMode01View.swift
//  QCFossil
//
//  Created by Yin Huang on 18/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class InputMode01View: InputModeSCMaster {

    @IBOutlet weak var scrollCellView: UIScrollView!
    @IBOutlet weak var applyToAllButton: UIButton!
    @IBOutlet weak var result: UITextField!
    @IBOutlet weak var addCellButton: UIButton!
    var inputCells = [InputMode01CellView]()
    let inputCellCount = 6
    let cellWidth = 768
    let cellHeight = 140

    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func didMoveToSuperview() {
        if (self.parentVC == nil) {
            // a removeFromSuperview situation
            
            return
        }
        
        let photoDataHelper = PhotoDataHelper()
        let taskDataHelper = TaskDataHelper()
        var idx = 1
        
        self.optInspElmsMaster = taskDataHelper.getOptInspSecElementsByIds(inspSection!.prodTypeId!, inspTypeId: inspSection!.inspectTypeId!, inspSectionId: inspSection!.sectionId!)!
        self.optInspPostsMaster = taskDataHelper.getOptInspSecPositionByIds(inspSection!.prodTypeId!, inspTypeId: inspSection!.inspectTypeId!, sectionId: inspSection!.sectionId!)!
        self.optInspElms = self.optInspElmsMaster
        self.optInspPosts = self.optInspPostsMaster
        
        var inspElmNames = [String]()
        for taskInspDataRecord in (inspSection?.taskInspDataRecords)! {
            
            let inputCell = inputCellInit(idx, sectionId: categoryIdx, sectionName: categoryName, idxLabelText: String(idx),inspItemText: (_ENGLISH ? taskInspDataRecord.elmtObj?.elementNameEn:taskInspDataRecord.elmtObj?.elementNameCn)!,inspDetailText: taskInspDataRecord.inspectDetail!, inspRemarksText: taskInspDataRecord.inspectRemarks!,dismissBtnHidden: true, elementDbId: (taskInspDataRecord.elmtObj?.elementId)!, refRecordId: taskInspDataRecord.refRecordId!, inspElmId: (taskInspDataRecord.elmtObj?.elementId)!, inspPostId:taskInspDataRecord.postnObj!.positionId, resultValueObj: taskInspDataRecord.resultObj!, taskInspDataRecordId: taskInspDataRecord.recordId!, inspItemInputText:"" , requiredElementFlag: taskInspDataRecord.elmtObj!.reqElmtFlag)
            
            
            inputCell.photoAdded = photoDataHelper.checkPhotoAddedByInspDataRecordId(taskInspDataRecord.recordId!)
            inputCell.updatePhotoNeededStatus((taskInspDataRecord.resultObj?.resultValueNameEn)!)
            
            let defectItems = Cache_Task_On!.defectItems.filter({$0.taskId == taskInspDataRecord.taskId && $0.inspectRecordId == taskInspDataRecord.recordId})
            
            for defectItem in defectItems {
                defectItem.inspElmt = inputCell
            }
            
            self.optInspElms = self.optInspElms.filter({ $0.elementId != taskInspDataRecord.elmtObj?.elementId})
            inputCells.append(inputCell)
            inspElmNames.append(_ENGLISH ? (taskInspDataRecord.elmtObj?.elementNameEn)! : (taskInspDataRecord.elmtObj?.elementNameCn)!)
        
            idx += 1
        }
        
        if inputCells.count < 1 {
        //    return
        }
        
        self.updateOptionalInspElmts(inspElmNames)
        self.updateContentView()
        self.initSegmentControlView(self.InputMode,apyToAllBtn: self.applyToAllButton)
    }
    
    func applyRstToAll() {
        let taskDataHelper = TaskDataHelper()
        let resultValueId = taskDataHelper.getResultValueIdByResultValue(resultForAll, prodTypeId: (Cache_Task_On?.prodTypeId)!, inspTypeId: (Cache_Task_On?.inspectionTypeId)!)
        
        for cell in inputCells {
            cell.cellResultInput.text = resultForAll
            cell.updatePhotoAddediConStatus(resultForAll,photoTakenIcon: cell.photoAddedIcon)
            cell.resultValueId = resultValueId
        }
        
        Cache_Task_On?.didModify = true
        updateContentView()
    }
    
    func updateContentView() {
        
        if inputCells.count < 1 {
            return
        }
        
        for index in 0...inputCells.count-1 {
            let cell = inputCells[index]
            cell.updateCellIndex(cell,index: index)
            cell.cellIndexLabel.text = String(cell.cellIdx)
            cell.frame = CGRect.init(x: 0, y: index * cellHeight, width: cellWidth, height: cellHeight)
            
            if index % 2 == 0 {
                cell.backgroundColor = _TABLECELL_BG_COLOR1
            }else{
                cell.backgroundColor = _TABLECELL_BG_COLOR2
            }
            
            if cell.cellPhysicalIdx < inputCells.count {
                self.scrollCellView.addSubview(inputCells[cell.cellPhysicalIdx])
            }
        }
        
        self.addCellButton.frame = CGRect.init(x: 8, y: inputCells.count*cellHeight+10, width: 50, height: 50)
        self.scrollCellView.addSubview(self.addCellButton)
        resizeScrollView(CGSize.init(width: self.scrollCellView.frame.size.width, height: CGFloat(inputCells.count*cellHeight+500)))
    }
    
    func resizeScrollView(size:CGSize) {
        self.scrollCellView.contentSize = size
    }
    
    func inputCellInit(index:Int, sectionId:Int, sectionName:String, idxLabelText:String, inspItemText:String, inspDetailText:String,inspRemarksText:String, dismissBtnHidden:Bool, elementDbId:Int, refRecordId:Int, inspElmId:Int, inspPostId:Int, resultValueObj:ResultValueObj=ResultValueObj(resultValueId:0,resultValueNameEn: "",resultValueNameCn: ""), taskInspDataRecordId:Int=0, inspItemInputText:String="", userInteractive:Bool=false, requiredElementFlag:Int=0) -> InputMode01CellView {
        
        let inputCellViewObj = InputMode01CellView.loadFromNibNamed("InputMode01Cell")
        
        inputCellViewObj?.parentView = self
        inputCellViewObj?.cellIndexLabel.text = idxLabelText
        inputCellViewObj?.cellCatIdx = sectionId
        inputCellViewObj?.cellCatName = sectionName
        inputCellViewObj?.cellIdx = index
        inputCellViewObj?.cellPhysicalIdx = index-1
        inputCellViewObj?.elementDbId = elementDbId
        inputCellViewObj?.inptItemInput.text = inspItemText
        inputCellViewObj?.inptDetailInput.text = inspDetailText
        inputCellViewObj?.cellRemarksInput.text = inspRemarksText
        inputCellViewObj?.cellResultInput.text = _ENGLISH ? resultValueObj.resultValueNameEn : resultValueObj.resultValueNameCn
        
        //for Save DB
        inputCellViewObj?.refRecordId = refRecordId
        inputCellViewObj?.inspElmId = inspElmId
        inputCellViewObj?.inspPostId = inspPostId
        inputCellViewObj?.resultValueId = resultValueObj.resultValueId
        inputCellViewObj?.taskInspDataRecordId = taskInspDataRecordId
        inputCellViewObj?.inspReqCatText = sectionName
        inputCellViewObj?.inspAreaText = inspItemText
        inputCellViewObj?.inspItemText = inspItemInputText
        
        if !userInteractive {
            inputCellViewObj?.inptItemInput.userInteractionEnabled = false
        }
        
        if !dismissBtnHidden || requiredElementFlag < 1{
            inputCellViewObj?.showDismissButton()
        }
        
        return inputCellViewObj!
    }
    
    @IBAction func addCellBtnOnClick(sender: UIButton) {
        NSLog("Add Cell")
        
        if self.optInspElms.count > 0 {
            let usedInspItems = self.inputCells.filter({ $0.requiredElementFlag == 0 })
            var usedInspItemNames = [String]()
            
            for usedInspItem in usedInspItems {
                usedInspItemNames.append(usedInspItem.inptItemInput.text!)
            }
            
            let optInspElm = self.optInspElms[0]
            usedInspItemNames.append((_ENGLISH ? optInspElm.elementNameEn:optInspElm.elementNameCn)!)
            
            let inputCell = inputCellInit(inputCells.count+1, sectionId: categoryIdx, sectionName: categoryName, idxLabelText: String(inputCells.count+1),inspItemText: (_ENGLISH ? optInspElm.elementNameEn:optInspElm.elementNameCn)!, inspDetailText: "", inspRemarksText: "", dismissBtnHidden: false, elementDbId: 0, refRecordId: 0, inspElmId: optInspElm.elementId!, inspPostId: 0, userInteractive: true)
            inputCells.append(inputCell)
            
            inputCell.inspReqCatText = categoryName
            inputCell.inspAreaText = (_ENGLISH ? optInspElm.elementNameEn:optInspElm.elementNameCn)!
            //inputCell.inspItemText = (_ENGLISH ? optInspElm.elementNameEn:optInspElm.elementNameCn)!
            self.updateContentView()
            self.updateOptionalInspElmts(usedInspItemNames)
        }
    }

    func updateOptionalInspElmts(inspElmtNames:[String]=[], action:String="filter") {
        
        if action == "filter" {
            self.optInspElms = self.optInspElmsMaster
            for inspElmtName in inspElmtNames {
                self.optInspElms = self.optInspElms.filter({ _ENGLISH ? $0.elementNameEn != inspElmtName : $0.elementNameCn != inspElmtName })
            }
        }else{
            for inspElmtName in inspElmtNames {
                let inspElmt = self.optInspElmsMaster.filter({ _ENGLISH ? $0.elementNameEn == inspElmtName : $0.elementNameCn == inspElmtName })
                
                if inspElmt.count>0{
                    self.optInspElms.append(inspElmt[0])
                }
            }
        }
        
        if self.optInspElms.count < 1 {
            self.addCellButton.hidden = true
        }else{
            self.addCellButton.hidden = false
        }
    }
}
