//
//  InputModeICMaster.swift
//  QCFossil
//
//  Created by pacmobile on 2/2/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class InputModeICMaster:UIView {
    
    //Db
    var refRecordId:Int?
    var inspElmId:Int?=0
    var inspPostId:Int?=0
    var resultValueId:Int = 0
    var requiredElementFlag:Int = 0
    var inspectZoneValueId:Int?
    
    //UI
    var photoAdded = false
    var photoNeeded = false
    var cellIdx = 0
    var cellPhysicalIdx = 0
    var cellCatIdx = 0
    var cellCatName = ""
    var elementDbId = 0
    var taskInspDataRecordId:Int?
    var requestSectionId:Int?
    var showDropdownView = false
    
    //Inspect Image
    weak var parentView:InputModeSCMaster!
    var inspPhotos = [Photo]()
    var inspReqCatText = ""
    var inspCatText = ""
    var inspAreaText = ""
    var inspItemText = ""
    
    func updatePhotoNeededStatus(resultValue:String) {
        if resultValue.lowercaseString.rangeOfString("c.a.") != nil || resultValue.lowercaseString.rangeOfString("fail") != nil || resultValue.lowercaseString.rangeOfString("hold") != nil || resultValue.lowercaseString.rangeOfString("有条件批准") != nil || resultValue.lowercaseString.rangeOfString("不合格") != nil || resultValue.lowercaseString.rangeOfString("保留") != nil {
            self.photoNeeded = true
        }else{
            self.photoNeeded = false
        }
    }
    
    func updateCellIndex(cell:InputModeICMaster, index:Int) {
        cell.cellIdx = index+1
        cell.cellPhysicalIdx = index
    }
    
    func updatePhotoAddediConStatus(resultValue:String="", photoTakenIcon:UIImageView) {
        if resultValue != "" {
            self.updatePhotoNeededStatus(resultValue)
        }
        
        //need photo and photo added
        if self.photoAdded && self.photoNeeded {
            photoTakenIcon.hidden = false
            if let image = UIImage(named: "have_photo") {
                photoTakenIcon.image = image
            }
        }else if self.photoNeeded && !self.photoAdded{//need photo but not yet added
            photoTakenIcon.hidden = false
            if let image = UIImage(named: "need_photo_icon") {
                photoTakenIcon.image = image
            }
        }else if self.photoAdded{
            photoTakenIcon.hidden = false
            if let image = UIImage(named: "have_photo") {
                photoTakenIcon.image = image
            }
        }else{
            photoTakenIcon.hidden = true
        }
    }
    
    func deleteTaskInspDataRecord(id:Int) {
        let taskDataHelper = TaskDataHelper()
        taskDataHelper.deleteTaskInspDataRecordById(id)
    }
    
    func deleteTaskPhotos(deletePhoto:Bool=false) {
        if deletePhoto {
            //Delete Relative Photos
            let photoDataHelper = PhotoDataHelper()
            let RmvPhotos = photoDataHelper.getPhotosByInspElmtId(self.taskInspDataRecordId!, dataType:PhotoDataType(caseId: "INSPECT").rawValue)
            
            for RmvPhoto in RmvPhotos! {
                UIImage.init().removeImageFromLocal(RmvPhoto, path: Cache_Task_Path!)
            }
        }else{
            //Update Photos DataType , for be using in Defect List
            let photoDataHelper = PhotoDataHelper()
            let udPhotos = photoDataHelper.getPhotosByInspElmtId(self.taskInspDataRecordId!)
            
            for udPhoto in udPhotos! {
                photoDataHelper.updatePhotoDatas(udPhoto.photoId!, dataType:PhotoDataType(caseId: "TASK").rawValue, dataRecordId:0)
            }
        }
    }
    
    func saveMyselfToGetId() {
        //Save self to DB to get the taskDataRecordId
        let taskDataHelper = TaskDataHelper()
        let taskInspDataRecord = TaskInspDataRecord.init(recordId: self.taskInspDataRecordId,taskId: (Cache_Task_On?.taskId)!, refRecordId: self.refRecordId!, inspectSectionId: self.cellCatIdx, inspectElementId: self.inspElmId!, inspectPositionId: self.inspPostId!, inspectPositionDesc: "", inspectDetail: "", inspectRemarks: "", resultValueId: self.resultValueId, requestSectionId: 0, requestElementDesc: "", createUser: (Cache_Inspector?.appUserName)!, createDate: self.getCurrentDateTime(), modifyUser: (Cache_Inspector?.appUserName)!, modifyDate: self.getCurrentDateTime())
        
        if self.taskInspDataRecordId < 1 {
            self.taskInspDataRecordId = taskDataHelper.insertTaskInspDataRecord(taskInspDataRecord!)
        }else{
            taskDataHelper.updateInspDataRecord(taskInspDataRecord!)
        }
    }
    
    func isDefectItemAdded(defectListVC:DefectListViewController) ->Bool {
        let defectItems = Cache_Task_On?.defectItems
        let isDCAddedCheck = defectItems!.filter({ $0.inspectRecordId == taskInspDataRecordId })
        
        let inspSectionCells = defectListVC.defectCells
        let isDCAdded = inspSectionCells.filter({$0.sectionId == cellCatIdx && $0.itemId == cellIdx})
        
        if inspSectionCells.count>0 && isDCAdded.count<1 {
            return false
        }else if inspSectionCells.count<1 && isDCAddedCheck.count<1 {
            return false
        }else if isDCAddedCheck.count<1 && isDCAdded.count<1 {
            return false
        }else{
            return true
        }
    }
}
