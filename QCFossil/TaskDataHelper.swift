//
//  TaskDataHelper.swift
//  QCFossil
//
//  Created by pacmobile on 26/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation
import UIKit

class TaskDataHelper:DataHelperMaster{
    
    func getAllTaskItems() ->[TaskItem]? {
        //let sql = "SELECT iti.* FROM inspect_task_item iti INNER JOIN inspect_task_inspector iti2 ON iti.task_id = iti2.task_id WHERE iti2.inspector_id = ? GROUP BY iti.task_id ORDER BY iti.modify_date DESC"
        let sql = "SELECT iti.* FROM inspect_task_item iti INNER JOIN inspect_task_inspector iti2 ON iti.task_id = iti2.task_id INNER JOIN inspect_task it ON iti.task_id = it.task_id WHERE iti2.inspector_id = ? GROUP BY iti.task_id ORDER BY iti.modify_date DESC"
        var taskItems = [TaskItem]()
        
        if db.open() {
            if let rs = db.executeQuery(sql, withArgumentsInArray: [(Cache_Inspector?.inspectorId)!]) {
            
            while rs.next() {
                let taskId = Int(rs.intForColumn("task_id"))
                let poItemId = Int(rs.intForColumn("po_item_id"))
                let targetInspectQty = Int(rs.intForColumn("target_inspect_qty"))
                let availInspectQty = Int(rs.intForColumn("avail_inspect_qty"))
                let inspectEnableFlag = Int(rs.intForColumn("inspect_enable_flag"))
                let createUser = rs.stringForColumn("create_user")
                let createDate = rs.stringForColumn("create_date")
                let modifyUser = rs.stringForColumn("modify_user")
                let modifyDate = rs.stringForColumn("modify_date")
                let samplingQty = Int(rs.intForColumn("sampling_qty"))
                
                let taskItem = TaskItem(taskId: taskId, poItemId: poItemId, targetInspectQty: targetInspectQty, availInspectQty: availInspectQty, inspectEnableFlag: inspectEnableFlag, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, samplingQty: samplingQty)
                
                taskItems.append(taskItem)
            }
            }
            
            db.close()
            
            return taskItems
        }
        
        return nil
    }
    
    func getTaskById(taskId:Int) ->Task? {
        let sql = "SELECT * FROM inspect_task WHERE task_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var task:Task!
        
        //extension
        var inspTypeId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId]) {
            
            if rs.next() {
                let taskId = Int(rs.intForColumn("task_id"))
                let prodTypeId = Int(rs.intForColumn("prod_type_id"))
                let inspectionTypeId = Int(rs.intForColumn("inspect_type_id"))
                let bookingNo = rs.stringForColumn("booking_no")
                var bookingDate = rs.stringForColumn("booking_date")
                let vdrLocationId = Int(rs.intForColumn("vdr_location_id"))
                let reportInspectorId = Int(rs.intForColumn("report_inspector_id"))
                let reportPrefix = rs.stringForColumn("report_prefix")
                let inspectionNo = rs.stringForColumn("inspection_no")
                var inspectionDate = rs.stringForColumn("inspection_date")
                let taskRemarks = rs.stringForColumn("task_remarks")
                let vdrNotes = rs.stringForColumn("vdr_notes")
                let inspectionResultValueId = Int(rs.intForColumn("inspect_result_value_id"))
                let inspectionSignImageFile = rs.stringForColumn("inspector_sign_image_file")
                let vdrSignName = rs.stringForColumn("vdr_sign_name")
                let vdrSignImageFile = rs.stringForColumn("vdr_sign_image_file")
                let taskStatus = Int(rs.intForColumn("task_status"))
                let uploadInspectorId = Int(rs.intForColumn("upload_inspector_id"))
                let uploadDeviceId = rs.stringForColumn("upload_device_id")
                let refTaskId = Int(rs.intForColumn("ref_task_id"))
                let recStatus = Int(rs.intForColumn("rec_status"))
                let createUser = rs.stringForColumn("create_user")
                let createDate = rs.stringForColumn("create_date")
                let modifyUser = rs.stringForColumn("modify_user")
                let modifyDate = rs.stringForColumn("modify_date")
                let deleteFlag = Int(rs.intForColumn("deleted_flag"))
                let deleteUser = rs.stringForColumn("delete_user")
                let deleteDate = rs.stringForColumn("delete_date")
                let tmplId = Int(rs.intForColumn("tmpl_id"))
                var cancelDate = rs.stringForColumn("cancel_date")
                let dataRefuseDesc = rs.stringForColumn("data_refuse_desc")
                
                if bookingDate != nil && bookingDate != "" {
                    let bookingDateTmp = bookingDate
                    let bookingDateTmpArray = bookingDateTmp.characters.split{$0 == " "}.map(String.init)
                    
                    if bookingDateTmpArray.count>0 {
                        bookingDate = bookingDateTmpArray[0]
                        
                        let dateFormatter:NSDateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = _DATEFORMATTER
                        bookingDate = dateFormatter.stringFromDate(dateFormatter.dateFromString(bookingDate)!)
                    }
                }
                
                if inspectionDate != nil {
                    let inspectionDateTmp = inspectionDate
                    let inspectionDateTmpArray = inspectionDateTmp.characters.split{$0 == " "}.map(String.init)
                    
                    if inspectionDateTmpArray.count>0 {
                        inspectionDate = inspectionDateTmpArray[0]
                        
                        let dateFormatter:NSDateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = _DATEFORMATTER
                        inspectionDate = dateFormatter.stringFromDate(dateFormatter.dateFromString(inspectionDate)!)
                    }
                }
                
                if cancelDate == nil {
                    cancelDate = ""
                }
                
                var sortingNum = 0
                if bookingNo != nil {
                    let bookingNoTmp = bookingNo
                    let bookingNoTmpArray = bookingNoTmp.characters.split{$0 == "-"}.map(String.init)
                    
                    if bookingNoTmpArray.count > 1 {
                        if Int(bookingNoTmpArray[1]) != nil {
                            sortingNum = Int(bookingNoTmpArray[1])!
                        }
                    
                    }
                }
                
                //extension
                inspTypeId = inspectionTypeId
                
                task = Task(taskId: taskId, prodTypeId: prodTypeId, inspectionTypeId: inspectionTypeId, bookingNo: bookingNo, bookingDate: bookingDate, vdrLocationId: vdrLocationId, reportInspectorId: reportInspectorId, reportPrefix: reportPrefix, inspectionNo: inspectionNo, inspectionDate: inspectionDate, taskRemarks: taskRemarks, vdrNotes: vdrNotes, inspectionResultValueId: inspectionResultValueId, inspectionSignImageFile: inspectionSignImageFile, vdrSignName: vdrSignName, vdrSignImageFile: vdrSignImageFile, taskStatus: taskStatus, uploadInspectorId: uploadInspectorId, uploadDeviceId: uploadDeviceId, refTaskId: refTaskId, recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deleteFlag: deleteFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                
                task.tmplId = tmplId
                task.cancelDate = cancelDate
                task.dataRefuseDesc =  dataRefuseDesc == nil ? "" : dataRefuseDesc
                task.sortingNum = sortingNum
            }
            }
            
            db.close()
        }
        
        //extension
        if task != nil {
        let poDataHelper = PoDataHelper()
        task.poItems = poDataHelper.getPoByTaskId(taskId)
        
        if task.poItems.count>0 {
            let poItem = task.poItems[0]
            
            task.vendor = poItem.vdrDisplayName
            task.vendorLocation = poItem.vdrLocationCode
            task.brand = poItem.brandName
            task.style = poItem.styleNo
            task.shipWin = poItem.shipWin
            task.opdRsd = poItem.opdRsd
            
            /*
            var poNo = poItem.poNo
            if task.poItems.count>1 {
                for idx in 1...task.poItems.count-1 {
                    poNo! += ","+task.poItems[idx].poNo!
                }
            }*/
            
            var poNos = [String]()
            for poNo in task.poItems {
                if poNo.isEnable == 1 || task.taskStatus == GetTaskStatusId(caseId: "Cancelled").rawValue || (task.taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue && task.cancelDate != "") {
                    poNos.append(poNo.poNo!)
                }
            }
            
            var shipWins = [String]()
            for poItem in task.poItems {
                if poItem.isEnable == 1 || task.taskStatus == GetTaskStatusId(caseId: "Cancelled").rawValue || (task.taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue && task.cancelDate != "") {
                    shipWins.append(poItem.shipWin)
                }
            }
            
            var opdRsds = [String]()
            for poItem in task.poItems {
                if poItem.isEnable == 1 || task.taskStatus == GetTaskStatusId(caseId: "Cancelled").rawValue || (task.taskStatus == GetTaskStatusId(caseId: "Uploaded").rawValue && task.cancelDate != "") {
                    opdRsds.append(poItem.opdRsd)
                }
            }
            
            if poItem.dimen2 != nil && poItem.prodDesc != nil {
                let prodDesc = "\(poItem.dimen2!) / \(poItem.prodDesc!)"
                task.prodDesc = prodDesc
            }
            
            var uniquePoNos = Array(Set(poNos))
            var uniqueShipWins = Array(Set(shipWins))
            var uniqueOpdRsds = Array(Set(opdRsds))
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = _DATEFORMATTER
            
            uniquePoNos.sortInPlace({ Int($0) < Int($1) })
            uniqueShipWins.sortInPlace({ dateFormatter.dateFromString($0)!.isGreaterThanDate(dateFormatter.dateFromString($1)!) })
            uniqueOpdRsds.sortInPlace({ $0 != "" && $1 != "" && dateFormatter.dateFromString($0)!.isGreaterThanDate(dateFormatter.dateFromString($1)!) })
            
            task.poNo = uniquePoNos.joinWithSeparator(",")
            task.shipWin = uniqueShipWins.joinWithSeparator(",")
            task.opdRsd = uniqueOpdRsds.joinWithSeparator(",")
        }
        
        task.inspectionType = getInspTypeByInspTypeId(inspTypeId)
        task.inspSections = getInspSectionsByTaskId(taskId)!
        }
        return task
    }
    
    func setupTaskInspDataRcords(inspSec:InspSection) {
        for taskInspDataRecord in inspSec.taskInspDataRecords {
            
            if taskInspDataRecord.inspectSectionId>0 {
                let section = getInspSectionsById(taskInspDataRecord.inspectSectionId!)
                if section != nil {
                taskInspDataRecord.sectObj = SectObj(sectionId:(section?.sectionId)!, sectionNameEn: (section?.sectionNameEn)!, sectionNameCn: (section?.sectionNameCn)!,inputMode: (section?.inputModeCode)!)
                }else{
                    taskInspDataRecord.sectObj = SectObj(sectionId:0, sectionNameEn: "", sectionNameCn: "",inputMode: "")
                }
            }else{
                taskInspDataRecord.sectObj = SectObj(sectionId:0, sectionNameEn: "", sectionNameCn: "",inputMode: "")
            }
            
            if taskInspDataRecord.requestSectionId>0 {
                let section = getInspSectionsById(taskInspDataRecord.requestSectionId)
                if section != nil {
                taskInspDataRecord.reqSectObj = SectObj(sectionId:(section?.sectionId)!, sectionNameEn: (section?.sectionNameEn)!, sectionNameCn: (section?.sectionNameCn)!,inputMode: (section?.inputModeCode)!)
                }else{
                    taskInspDataRecord.reqSectObj = SectObj(sectionId:0, sectionNameEn: "", sectionNameCn: "",inputMode: "")
                }
            }else{
                taskInspDataRecord.reqSectObj = SectObj(sectionId:0, sectionNameEn: "", sectionNameCn: "",inputMode: "")
            }
            
            if taskInspDataRecord.inspectElementId>0 {
                let element = getInspSecElementById(taskInspDataRecord.inspectElementId!)
                if element != nil {
                    taskInspDataRecord.elmtObj = ElmtObj(elementId:(element?.elementId)!,elementNameEn:(element?.elementNameEn)!, elementNameCn:(element?.elementNameCn)!, reqElmtFlag: (element?.requiredElementFlag)!)
                }else{
                    taskInspDataRecord.elmtObj = ElmtObj(elementId:0,elementNameEn:"", elementNameCn:"", reqElmtFlag: 0)
                }
            }else{
                taskInspDataRecord.elmtObj = ElmtObj(elementId:0,elementNameEn:"", elementNameCn:"", reqElmtFlag: 0)
            }
            
            if taskInspDataRecord.inspectPositionId>0 {
                let position = getInspSecPositionById(taskInspDataRecord.inspectPositionId!)
                if position != nil {
                taskInspDataRecord.postnObj = PositObj(positionId:(position?.positionId)!, positionNameEn:(position?.positionNameEn)!,positionNameCn:(position?.positionNameCn)!)
                }else{
                    taskInspDataRecord.postnObj = PositObj(positionId:0, positionNameEn:"",positionNameCn:"")
                }
            }else{
                taskInspDataRecord.postnObj = PositObj(positionId:0, positionNameEn:"",positionNameCn:"")
            }
            
            if taskInspDataRecord.resultValueId>0 {
                let resultValue = getResultValueById(taskInspDataRecord.resultValueId)
                if resultValue != nil {
                taskInspDataRecord.resultObj = ResultValueObj(resultValueId:(resultValue?.resultValueId)!, resultValueNameEn:resultValue!.resultValueNameEn, resultValueNameCn:resultValue!.resultValueNameCn)
                }else{
                    taskInspDataRecord.resultObj = ResultValueObj(resultValueId:0, resultValueNameEn:"", resultValueNameCn:"")
                }
            }else{
                taskInspDataRecord.resultObj = ResultValueObj(resultValueId:0, resultValueNameEn:"", resultValueNameCn:"")
            }
        }
    }
    
    func getTaskDetailByTask(task:Task) ->Task {
        //Init PO Items
        let poDataHelper = PoDataHelper()
        task.poItems = poDataHelper.getPoByTaskId(task.taskId!)
        
        //Init Task From TaskInspDataRecord
        for inspSec in task.inspSections{
            
            let taskInspDateRecords = getTaskInspDataRecords(task.taskId!, inspectSecId: inspSec.sectionId!)
            
            if taskInspDateRecords!.count > 0{
                
                inspSec.taskInspDataRecords = taskInspDateRecords!
                
                setupTaskInspDataRcords(inspSec)
                
                //If not yet init, just init the Task and add TaskInspDataRecords into DB
            }else{
                
                let inspSecElms = getInspSecElementsByPTIdITId(inspSec.sectionId!, inputMode: inspSec.inputModeCode!)
                
                var taskInspDataRecords = [TaskInspDataRecord]()
                for inspSecElm in inspSecElms! {
                    
                    let taskInspDataRecord = TaskInspDataRecord.init(taskId: inspSec.taskId!, refRecordId: 0, inspectSectionId: inspSec.sectionId!, inspectElementId: inspSecElm.elementId!, inspectPositionId: inspSecElm.inspectPositionId!, inspectPositionDesc: "", inspectDetail: "", inspectRemarks: "", resultValueId: inspSecElm.resultValueId, requestSectionId: 0, requestElementDesc: "", createUser: (Cache_Inspector?.appUserName)!, createDate: UIView.init().getCurrentDateTime(), modifyUser: (Cache_Inspector?.appUserName)!, modifyDate: UIView.init().getCurrentDateTime())
                    
                    taskInspDataRecords.append(taskInspDataRecord!)
                }
                
                inspSec.taskInspDataRecords = updateInspDataRecord(taskInspDataRecords)
                setupTaskInspDataRcords(inspSec)
            }
        }
        
        //Init Defect List
        let thumbNailPath = _TASKSPHYSICALPATH+(Cache_Task_On!.bookingNo!.isEmpty ? Cache_Task_On!.inspectionNo : Cache_Task_On!.bookingNo)!+"/"+_THUMBSPHYSICALNAME
        let taskDefectDateRecords = getTaskDefectDataRecords(task.taskId!)
        task.defectItems = [TaskInspDefectDataRecord]()
        
        for taskDefectDateRecord in taskDefectDateRecords! {
            
            //init InputMode base on Element
            taskDefectDateRecord.inputMode = getInputModeCodeByTaskDefectDataId(taskDefectDateRecord.recordId!)
            
            if taskDefectDateRecord.inspectElementId>0 {
                //init Element
                let element = getInspSecElementById(taskDefectDateRecord.inspectElementId!)
                
                if element != nil {
                    taskDefectDateRecord.elmtObj = ElmtObj(elementId:(element?.elementId)!,elementNameEn:(element?.elementNameEn)!, elementNameCn:(element?.elementNameCn)!, reqElmtFlag: (element?.requiredElementFlag)!)
                }else{
                    taskDefectDateRecord.elmtObj = ElmtObj(elementId:0,elementNameEn:"", elementNameCn:"", reqElmtFlag: 0)
                }
                
                //init Sections
                let sectionId = getSectionIdByElementId(taskDefectDateRecord.inspectElementId!)
                let section = getInspSectionsById(sectionId)
                
                if section != nil {
                    taskDefectDateRecord.sectObj = SectObj(sectionId:(section?.sectionId)!, sectionNameEn: (section?.sectionNameEn)!, sectionNameCn: (section?.sectionNameCn)!,inputMode: (section?.inputModeCode)!)
                }else{
                    taskDefectDateRecord.sectObj = SectObj(sectionId:0, sectionNameEn: "", sectionNameCn: "",inputMode: "")
                }
                
                //init Positions
                let positionId = getPositionIdByElementId(taskDefectDateRecord.inspectElementId!, inputMode: taskDefectDateRecord.inputMode!)
                let position = getInspSecPositionById(positionId)
                
                if position != nil {
                    taskDefectDateRecord.postnObj = PositObj(positionId:(position?.positionId)!, positionNameEn:(position?.positionNameEn)!,positionNameCn:(position?.positionNameCn)!)
                }else{
                    taskDefectDateRecord.postnObj = PositObj(positionId:0, positionNameEn:"",positionNameCn:"")
                }
                
                //init Defect Photos
                let photoDataHelper = PhotoDataHelper()
                //taskDefectDateRecord.photoObjs = photoDataHelper.getDefectPhotosById(taskDefectDateRecord.taskId!, dataRecordId: taskDefectDateRecord.recordId!, taskPath: thumbNailPath)
                
                taskDefectDateRecord.photoNames = photoDataHelper.getDefectPhotoNamesById(taskDefectDateRecord.taskId!, dataRecordId: taskDefectDateRecord.recordId!, taskPath: thumbNailPath)
                
            }else{
                //If no relative element
                taskDefectDateRecord.elmtObj = ElmtObj(elementId:0,elementNameEn:"", elementNameCn:"", reqElmtFlag: 0)
                taskDefectDateRecord.postnObj = PositObj(positionId:0, positionNameEn:"",positionNameCn:"")
                
                let section = getSectionByTaskInspDataId(taskDefectDateRecord.inspectRecordId!)
                if section != nil {
                    taskDefectDateRecord.sectObj = SectObj(sectionId:(section?.sectionId)!, sectionNameEn: (section?.sectionNameEn)!, sectionNameCn: (section?.sectionNameCn)!,inputMode: (section?.inputModeCode)!)
                }else{
                    taskDefectDateRecord.sectObj = SectObj(sectionId:0, sectionNameEn: "", sectionNameCn: "",inputMode: "")
                }
    
                //init Defect Photos
                let photoDataHelper = PhotoDataHelper()
                //taskDefectDateRecord.photoObjs = photoDataHelper.getDefectPhotosById(taskDefectDateRecord.taskId!, dataRecordId: taskDefectDateRecord.recordId!, taskPath: thumbNailPath)
                
                taskDefectDateRecord.photoNames = photoDataHelper.getDefectPhotoNamesById(taskDefectDateRecord.taskId!, dataRecordId: taskDefectDateRecord.recordId!, taskPath: thumbNailPath)
            }
            
            task.defectItems.append(taskDefectDateRecord)
        }
        
        return task
    }
    
    func getPoNoByTaskId(taskId:Int) ->String {
        let poDataHelper = PoDataHelper()
        
        return poDataHelper.getPoNoByPoId(getPoIdByTaskId(taskId))
    }
    
    func getPoStyleByTaskId(taskId:Int) ->String {
        let poDataHelper = PoDataHelper()
        
        return poDataHelper.getPoStyleByPoId(getPoIdByTaskId(taskId))
    }
    
    func getPoIdByTaskId(taskId:Int) ->Int {
        let sql = "SELECT po_item_id FROM inspect_task_item WHERE task_id = ?"
        var poId:Int = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId]) {
            
                if rs.next() {
                    poId = Int(rs.intForColumnIndex(0))
                }
            }
            
            db.close()
        }
        
        return poId
    }
    
    func getInspTypeByInspTypeId(inspTypeId:Int) ->String {
        let sql = "SELECT type_name_en,type_name_cn FROM inspect_type_mstr WHERE type_id = ? AND rec_status = 0 AND deleted_flag = 0"
        var inspType:String = "null"
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [inspTypeId]) {
                if rs.next() {
                    inspType = _ENGLISH ? rs.stringForColumn("type_name_en") : rs.stringForColumn("type_name_cn")
                }
            }
            db.close()
        }
        
        return inspType
    }
    
    func getAllInspType() ->[String] {
        let sql = "SELECT type_name_en,type_name_cn FROM inspect_type_mstr WHERE rec_status = 0 AND deleted_flag = 0"
        var inspType = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: nil) {
                while rs.next() {
                    inspType.append(_ENGLISH ? rs.stringForColumn("type_name_en") : rs.stringForColumn("type_name_cn"))
                }
            }
            db.close()
        }
        
        return inspType
    }
    
    func getAllTmplType() ->[String] {
        let sql = "SELECT tmpl_name_en, tmpl_name_cn FROM inspect_task_tmpl_mstr ittm INNER JOIN inspect_type_mstr itm ON ittm.inspect_type_id = itm.type_id WHERE ittm.prod_type_id = ? AND (itm.type_name_en = ? OR itm.type_name_cn = ?) AND itm.rec_status = 0 AND itm.deleted_flag = 0 AND ittm.rec_status = 0 AND ittm.deleted_flag = 0"
        var tmplType = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [(Cache_Inspector?.prodTypeId)!, (Cache_Inspector?.selectedInspType)!, (Cache_Inspector?.selectedInspType)!]) {
                while rs.next() {
                    tmplType.append( _ENGLISH ? rs.stringForColumn("tmpl_name_en") : rs.stringForColumn("tmpl_name_cn"))
                }
            }
            db.close()
        }
        
        return tmplType
    }
    
    func getTmplIdByName(tmplName:String) ->Int {
        let sql = "SELECT tmpl_id FROM inspect_task_tmpl_mstr WHERE (tmpl_name_en = ? OR tmpl_name_cn = ?) AND rec_status = 0 AND deleted_flag = 0"
        var tmplId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [tmplName, tmplName]) {
                if rs.next() {
                    tmplId = Int(rs.intForColumn("tmpl_id"))
                }
            }
            
            db.close()
        }
        
        return tmplId
    }
    
    func getInspSetupIdByName(tmplName:String) ->Int {
        let sql = "SELECT inspect_setup_id FROM inspect_task_tmpl_mstr WHERE (tmpl_name_en = ? OR tmpl_name_cn = ?) AND rec_status = 0 AND deleted_flag = 0"
        var inspSetupId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [tmplName, tmplName]) {
                if rs.next() {
                    inspSetupId = Int(rs.intForColumn("inspect_setup_id"))
                }
            }
            
            db.close()
        }
        
        return inspSetupId
    }

    
    func getAllProdType() ->[String] {
        let sql = "SELECT type_name_en, type_name_cn FROM prod_type_mstr WHERE rec_status = 0 AND deleted_flag = 0"
        var inspType = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: nil) {
                while rs.next() {
                    inspType.append( _ENGLISH ? rs.stringForColumn("type_name_en") : rs.stringForColumn("type_name_cn"))
                }
            }
            db.close()
        }
        
        return inspType
    }
    
    func getInspectorIdByTaskId(taskId:Int) ->Int {
        let sql = "SELECT inspector_id FROM inspect_task_inspector WHERE task_id = ?"
        var insptorId:Int = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId]) {
            
                if rs.next() {
                    insptorId = Int(rs.intForColumnIndex(0))
                }
            }
            
            db.close()
        }
        
        return insptorId
    }
    
    func getInspectorByTaskId(taskId:Int) ->String {
        let sql = "SELECT inspector_name FROM inspector_mstr WHERE inspector_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var insptorName:String = ""
        let insptorId = getInspectorIdByTaskId(taskId)
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [insptorId]) {
            
                if rs.next() {
                    insptorName = rs.stringForColumnIndex(0)
                }
            }
                
            db.close()
        }
        
        return insptorName
    }
    
    func getProdTypeIdByTaskId(taskId:Int) ->Int {
        let sql = "SELECT prod_type_id FROM inspect_task WHERE task_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var prodTypeId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId]) {
            
                if rs.next() {
                    prodTypeId = Int(rs.intForColumnIndex(0))
                }
            }
            
            db.close()
        }
        
        return prodTypeId
    }
    
    func getInspTypeIdByTaskId(taskId:Int) ->Int {
        let sql = "SELECT inspect_type_id FROM inspect_task WHERE task_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var inspTypeId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId]) {
            
                if rs.next() {
                    inspTypeId = Int(rs.intForColumnIndex(0))
                }
            }
            
            db.close()
        }
        
        return inspTypeId
    }
    
    func getInspSectionsByTaskId(taskId:Int) ->[InspSection]? {
        /*let sql = "SELECT * FROM inspect_section_mstr WHERE prod_type_id = ? AND inspect_type_id = ? ORDER BY display_order ASC"
        var inspSections = [InspSection]()
        let prodTypeId = getProdTypeIdByTaskId(taskId)
        let inspTypeId = getInspTypeIdByTaskId(taskId)
        */
        let sql = "SELECT * FROM inspect_task_tmpl_mstr ittm INNER JOIN inspect_task it ON ittm.tmpl_id = it.tmpl_id INNER JOIN inspect_task_tmpl_section itts ON ittm.tmpl_id = itts.tmpl_id INNER JOIN inspect_section_mstr ism ON itts.inspect_section_id = ism.section_id WHERE it.task_id = ? AND ittm.rec_status = 0 AND ittm.deleted_flag = 0 ORDER BY ism.display_order ASC"
        var inspSections = [InspSection]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId]) {
                
            while rs.next() {
                let sectionId = Int(rs.intForColumn("section_id"))
                let inspectSetupId = 0//Int(rs.intForColumn("inspect_setup_id"))
                let sectionNameEn = rs.stringForColumn("section_name_en")
                let sectionNameCn = rs.stringForColumn("section_name_cn")
                let prodTypeId = Int(rs.intForColumn("prod_type_id"))
                let inspectTypeId = Int(rs.intForColumn("inspect_type_id"))
                let displayOrder = Int(rs.intForColumn("display_order"))
                let resultSetId = Int(rs.intForColumn("result_set_id"))
                let inputModeCode = rs.stringForColumn("input_mode_code")
                let optionalEnableFlag = Int(rs.intForColumn("optional_enable_flag"))
                let adhoSelectFlag = Int(rs.intForColumn("adhoc_select_flag"))
                let recStatus = Int(rs.intForColumn("rec_status"))
                let createUser = rs.stringForColumn("create_user")
                let createDate = rs.stringForColumn("create_date")
                let modifyUser = rs.stringForColumn("modify_user")
                let modifyDate = rs.stringForColumn("modify_date")
                let deletedFlag = Int(rs.intForColumn("deleted_flag"))
                let deleteUser = rs.stringForColumn("delete_user")
                let deleteDate = rs.stringForColumn("delete_date")
                
                let inspSection = InspSection(taskId: taskId, sectionId: sectionId, inspectSetupId: inspectSetupId, sectionNameEn: sectionNameEn, sectionNameCn: sectionNameCn, prodTypeId: prodTypeId, inspectTypeId: inspectTypeId, displayOrder: displayOrder, resultSetId: resultSetId, inputModeCode: inputModeCode, optionalEnableFlag: optionalEnableFlag, adhocSelectFlag: adhoSelectFlag, recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                
                inspSections.append(inspSection)
            }
            }
            
            db.close()
            
            return inspSections
        }
        
        return nil
    }
    
    func getInspSecElementsByPTIdITId(inspSectionId:Int, inputMode:String = _INPUTMODE04) ->[InspSectionElement]? {
        
        var sql = "SELECT * FROM inspect_element_mstr iem INNER JOIN inspect_position_element ipe ON iem.element_id = ipe.inspect_element_id INNER JOIN inspect_section_element ise ON iem.element_id = ise.inspect_element_id WHERE ise.inspect_section_id = ? AND iem.required_element_flag = 1 ORDER BY iem.display_order ASC"
        
        if inputMode == _INPUTMODE01 {
            sql = "SELECT * FROM inspect_element_mstr iem INNER JOIN inspect_section_element ise ON iem.element_id = ise.inspect_element_id WHERE ise.inspect_section_id = ? AND iem.required_element_flag = 1 ORDER BY iem.display_order ASC"
        }else if inputMode == _INPUTMODE02 {
            return [InspSectionElement]()
        }
        
        var inspSecElms = [InspSectionElement]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [inspSectionId]) {
                
                while rs.next() {
                    
                    let elementId = Int(rs.intForColumn("element_id"))
                    let inspectSetupId = 0//Int(rs.intForColumn("inspect_setup_id"))
                    let elementNameEn = rs.stringForColumn("element_name_en")
                    let elementNameCn = rs.stringForColumn("element_name_cn")
                    let prodTypeId = Int(rs.intForColumn("prod_type_id"))
                    let inspectTypeId = Int(rs.intForColumn("inspect_type_id"))
                    let elementType = Int(rs.intForColumn("element_type"))
                    let inspectSectionId = Int(rs.intForColumn("inspect_section_id"))
                    let inspectPositionId = Int(rs.intForColumn("inspect_position_id"))
                    let displayOrder = Int(rs.intForColumn("display_order"))
                    let resultSetId = Int(rs.intForColumn("result_set_id"))
                    let requiredElementFlag = Int(rs.intForColumn("required_element_flag"))
                    let detailDefaultValue = rs.stringForColumn("detail_default_value")
                    var detailRequiredResultList = rs.stringForColumn("detail_required_result_set_id")
                    let detailSuggestFlag = Int(rs.intForColumn("detail_suggest_flag"))
                    let recStatus = Int(rs.intForColumn("rec_status"))
                    let createUser = rs.stringForColumn("create_user")
                    let createDate = rs.stringForColumn("create_date")
                    let modifyUser = rs.stringForColumn("modify_user")
                    let modifyDate = rs.stringForColumn("modify_date")
                    let deletedFlag = Int(rs.intForColumn("deleted_flag"))
                    let deleteUser = rs.stringForColumn("delete_user")
                    let deleteDate = rs.stringForColumn("delete_date")
                    
                    if (detailRequiredResultList == nil) {
                        detailRequiredResultList = ""
                    }
                    
                    let inspSecElm = InspSectionElement(elementId: elementId, inspectSetupId: inspectSetupId, elementNameEn: elementNameEn, elementNameCn: elementNameCn, prodTypeId: prodTypeId, inspectTypeId: inspectTypeId, elementType: elementType, inspectSectionId: inspectSectionId, inspectPositionId: inspectPositionId, displayOrder: displayOrder, resultSetId: resultSetId, requiredElementFlag: requiredElementFlag, detailDefaultValue: detailDefaultValue, detailRequiredResultList: detailRequiredResultList, detailSuggestFlag: detailSuggestFlag, recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                    
                    inspSecElms.append(inspSecElm)
                }
            }
            
            db.close()
            
            return inspSecElms
        }
        
        return nil
    }
    
    func getInspSecPositionByIds(prodTypeId:Int, inspectTypeId:Int) ->[InspSectionPosition]? {
        //let sql = "SELECT * FROM inspect_position_mstr WHERE prod_type_id = ? AND inspect_type_id = ? AND parent_position_id < 1"
        let sql = "SELECT * FROM inspect_task_tmpl_position ittp INNER JOIN inspect_task_tmpl_mstr ittm ON ittp.tmpl_id = ittm.tmpl_id INNER JOIN inspect_position_mstr ipm ON ittp.inspect_position_id = ipm.position_id WHERE ittm.prod_type_id = ? AND ittm.inspect_type_id = ? AND ittm.rec_status = 0 AND ittm.deleted_flag = 0 AND ipm.rec_status = 0 AND ipm.deleted_flag = 0 AND ipm.parent_position_id < 1 ORDER BY ipm.display_order ASC"
        var inspSecPostns = [InspSectionPosition]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [prodTypeId, inspectTypeId]) {
            
            while rs.next() {
                
                let positionId = Int(rs.intForColumn("position_id"))
                let inspectSetupId = 0//Int(rs.intForColumn("inspect_setup_id"))
                let positionCode = rs.stringForColumn("position_code")
                let positionNameEn = rs.stringForColumn("position_name_en")
                let positionNameCn = rs.stringForColumn("position_name_cn")
                let prodTypeId = Int(rs.intForColumn("prod_type_id"))
                let inspectTypeId = Int(rs.intForColumn("inspect_type_id"))
                let currentLevel = Int(rs.intForColumn("current_level"))
                let parentPositionId = Int(rs.intForColumn("parent_position_id"))
                let displayOrder = Int(rs.intForColumn("display_order"))
                let recStatus = Int(rs.intForColumn("rec_status"))
                let createUser = rs.stringForColumn("create_user")
                let createDate = rs.stringForColumn("create_date")
                let modifyUser = rs.stringForColumn("modify_user")
                let modifyDate = rs.stringForColumn("modify_date")
                let deletedFlag = Int(rs.intForColumn("deleted_flag"))
                let deleteUser = rs.stringForColumn("delete_user")
                let deleteDate = rs.stringForColumn("delete_date")
                
                let inspSecPostn = InspSectionPosition(positionId: positionId, inspectSetupId: inspectSetupId, positionCode: positionCode, positionNameEn: positionNameEn, positionNameCn: positionNameCn, prodTypeId: prodTypeId, inspectTypeId: inspectTypeId, currentLevel: currentLevel, parentPositionId: parentPositionId, displayOrder: displayOrder, recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                
                inspSecPostns.append(inspSecPostn)
            }
            }
            
            db.close()
            
            return inspSecPostns
        }
        
        return nil
    }
    
    func getResultSetIdByElmId(elmId:Int) ->Int {
        let sql = "SELECT result_set_id FROM inspect_element_mstr WHERE element_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var resultSetId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [elmId]) {
            
                if rs.next() {
                    resultSetId = Int(rs.intForColumnIndex(0))
                }
            }
            
            db.close()
        }
        
        return resultSetId
    }
    
    func getResultSetValueByElmId(elmId:Int) ->[String]? {
        let sql = "SELECT v.value_name_en,v.value_name_cn FROM result_set_value as s INNER JOIN result_value_mstr as v ON s.value_id=v.value_id WHERE s.set_id = ? AND (v.rec_status = 0 AND v.deleted_flag = 0) ORDER BY v.display_order"
        var resultSetValues = [String]()
        let rsId = getResultSetIdByElmId(elmId)
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [rsId]) {
            
            while rs.next() {
                
                if _ENGLISH {
                    resultSetValues.append(rs.stringForColumn("value_name_en"))
                }else{
                    resultSetValues.append(rs.stringForColumn("value_name_cn"))
                }
            }
            }
            
            db.close()
            
            return resultSetValues
        }
        
        return nil
    }
    
    func getResultSetValueBySetId(rsId:Int) ->[String]? {
        let sql = "SELECT v.value_name_en,v.value_name_cn FROM result_set_value as s INNER JOIN result_value_mstr as v ON s.value_id=v.value_id WHERE s.set_id = ? AND (v.rec_status = 0 AND v.deleted_flag = 0) ORDER BY v.display_order"
        var resultSetValues = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [rsId]) {
            
            while rs.next() {
                
                if _ENGLISH {
                    resultSetValues.append(rs.stringForColumn("value_name_en"))
                }else{
                    resultSetValues.append(rs.stringForColumn("value_name_cn"))
                }
            }
            }
            
            db.close()
            
            return resultSetValues
        }
        
        return nil
    }
    
    func updateInspDataRecord(inspDataRecords:[TaskInspDataRecord]) ->[TaskInspDataRecord] {
        
        if db.open() && inspDataRecords.count > 0 {
            db.beginTransaction()
            
            for inspDataRecord in inspDataRecords {
                let sql = "INSERT OR REPLACE INTO task_inspect_data_record  ('record_id','task_id','ref_record_id','inspect_section_id','inspect_element_id','inspect_position_id','inspect_position_desc','inspect_detail','inspect_remarks','result_value_id','create_user','create_date','modify_user','modify_date','request_section_id','request_element_desc') VALUES ((SELECT record_id FROM task_inspect_data_record WHERE record_id = ?),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
                
                if db.executeUpdate(sql, withArgumentsInArray: [notNilObject(inspDataRecord.recordId)!,inspDataRecord.taskId!,inspDataRecord.refRecordId!,inspDataRecord.inspectSectionId!,inspDataRecord.inspectElementId!,inspDataRecord.inspectPositionId!,inspDataRecord.inspectPositionDesc!,inspDataRecord.inspectDetail!,inspDataRecord.inspectRemarks!,inspDataRecord.resultValueId,inspDataRecord.createUser!,inspDataRecord.createDate!,inspDataRecord.modifyUser!,inspDataRecord.modifyDate!,notNilObject(inspDataRecord.requestSectionId)!,notNilObject(inspDataRecord.requestElementDesc)!]) {
                
                    inspDataRecord.recordId = Int(db.lastInsertRowId())
                }else{
                    //UIView.init().alertView("Saving Inspect Items Error!")
                    db.rollback()
                    db.close()
                    
                    return inspDataRecords
                }
            }
            
            db.commit()
            db.close()
        }
        
        return inspDataRecords
    }
    
    func updateInspDataRecord(inspDataRecord:TaskInspDataRecord) ->TaskInspDataRecord {
        
        if db.open() {
            db.beginTransaction()
            
            
            let sql = "INSERT OR REPLACE INTO task_inspect_data_record  ('record_id','task_id','ref_record_id','inspect_section_id','inspect_element_id','inspect_position_id','inspect_position_desc','inspect_detail','inspect_remarks','result_value_id','create_user','create_date','modify_user','modify_date','request_section_id','request_element_desc') VALUES ((SELECT record_id FROM task_inspect_data_record WHERE record_id = ?),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
                
            if db.executeUpdate(sql, withArgumentsInArray: [notNilObject(inspDataRecord.recordId)!,inspDataRecord.taskId!,inspDataRecord.refRecordId!,inspDataRecord.inspectSectionId!,inspDataRecord.inspectElementId!,inspDataRecord.inspectPositionId!,inspDataRecord.inspectPositionDesc!,inspDataRecord.inspectDetail!,inspDataRecord.inspectRemarks!,inspDataRecord.resultValueId,inspDataRecord.createUser!,inspDataRecord.createDate!,inspDataRecord.modifyUser!,inspDataRecord.modifyDate!,notNilObject(inspDataRecord.requestSectionId)!,notNilObject(inspDataRecord.requestElementDesc)!]) {
                    
                inspDataRecord.recordId = Int(db.lastInsertRowId())
            }else{
                //UIView.init().alertView("Saving Inspect Items Error!")
                db.rollback()
                db.close()
                    
                return inspDataRecord
            }
            
            
            db.commit()
            db.close()
        }
        
        return inspDataRecord
    }
    
    func checkAllInspDataRecordDone() ->Bool {
        let sql = "SELECT 1 FROM task_inspect_data_record WHERE task_id = ? AND result_value_id < 1"
        var result = true
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [(Cache_Task_On?.taskId)!]) {
                if rs.next() {
                    result = false
                }
            }
            
            db.close()
        }
        
        return result
    }
    
    func getOptInspSecElementsByIds(prodTypeId:Int, inspTypeId:Int, inspSectionId:Int) ->[InspSectionElement]? {
        //let sql = "SELECT * FROM inspect_element_mstr WHERE prod_type_id = ? AND inspect_type_id = ? AND inspect_section_id = ? AND required_element_flag = 0 ORDER BY element_name_en ASC"
        let sql = "SELECT * FROM inspect_element_mstr iem INNER JOIN inspect_section_element ise ON iem.element_id = ise.inspect_element_id WHERE ise.inspect_section_id = ? AND iem.required_element_flag = 0 AND (iem.rec_status = 0 AND iem.deleted_flag = 0) ORDER BY iem.element_name_en ASC"
        var inspSecElms = [InspSectionElement]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [prodTypeId, inspTypeId, inspSectionId]) {
            
            while rs.next() {
                
                let elementId = Int(rs.intForColumn("element_id"))
                let inspectSetupId = 0//Int(rs.intForColumn("inspect_setup_id"))
                let elementNameEn = rs.stringForColumn("element_name_en")
                let elementNameCn = rs.stringForColumn("element_name_cn")
                let prodTypeId = Int(rs.intForColumn("prod_type_id"))
                let inspectTypeId = Int(rs.intForColumn("inspect_type_id"))
                let elementType = Int(rs.intForColumn("element_type"))
                let inspectSectionId = Int(rs.intForColumn("inspect_section_id"))
                let inspectPositionId = Int(rs.intForColumn("inspect_position_id"))
                let displayOrder = Int(rs.intForColumn("display_order"))
                let resultSetId = Int(rs.intForColumn("result_set_id"))
                let requiredElementFlag = Int(rs.intForColumn("required_element_flag"))
                let detailDefaultValue = rs.stringForColumn("detail_default_value")
                let detailRequiredResultList = rs.stringForColumn("detail_required_result_set_id")
                let detailSuggestFlag = Int(rs.intForColumn("detail_suggest_flag"))
                let recStatus = Int(rs.intForColumn("rec_status"))
                let createUser = rs.stringForColumn("create_user")
                let createDate = rs.stringForColumn("create_date")
                let modifyUser = rs.stringForColumn("modify_user")
                let modifyDate = rs.stringForColumn("modify_date")
                let deletedFlag = Int(rs.intForColumn("deleted_flag"))
                let deleteUser = rs.stringForColumn("delete_user")
                let deleteDate = rs.stringForColumn("delete_date")
                
                let inspSecElm = InspSectionElement(elementId: elementId, inspectSetupId: inspectSetupId, elementNameEn: elementNameEn, elementNameCn: elementNameCn, prodTypeId: prodTypeId, inspectTypeId: inspectTypeId, elementType: elementType, inspectSectionId: inspectSectionId, inspectPositionId: inspectPositionId, displayOrder: displayOrder, resultSetId: resultSetId, requiredElementFlag: requiredElementFlag, detailDefaultValue: detailDefaultValue, detailRequiredResultList: detailRequiredResultList, detailSuggestFlag: detailSuggestFlag, recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                
                inspSecElms.append(inspSecElm)
            }
            }
            
            db.close()
            
            return inspSecElms
        }
        
        return nil
    }
    
    
    func getOptInspSecPositionByIds(prodTypeId:Int, inspTypeId:Int, sectionId:Int) ->[InspSectionPosition]? {
        //let sql = "SELECT DISTINCT ipm.* FROM inspect_element_mstr as iem INNER JOIN inspect_position_mstr as ipm ON iem.inspect_position_id=ipm.position_id WHERE iem.prod_type_id = ? AND iem.inspect_type_id = ? AND iem.inspect_section_id = ? AND iem.required_element_flag = 0 ORDER BY ipm.position_name_en ASC"
        let sql = "SELECT DISTINCT ipm.* FROM inspect_position_mstr ipm INNER JOIN inspect_position_element ipe ON ipm.position_id = ipe.inspect_position_id INNER JOIN inspect_section_element ise ON ipe.inspect_element_id = ise.inspect_element_id INNER JOIN inspect_element_mstr iem ON ise.inspect_element_id = iem.element_id WHERE ise.inspect_section_id = ? AND iem.required_element_flag = 0 AND (ipm.rec_status = 0 AND ipm.deleted_flag = 0) ORDER BY ipm.position_name_en ASC"
        var inspSecPostns = [InspSectionPosition]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [sectionId]) {
            
            while rs.next() {
                
                let positionId = Int(rs.intForColumn("position_id"))
                let inspectSetupId = 0//Int(rs.intForColumn("inspect_setup_id"))
                let positionCode = rs.stringForColumn("position_code")
                let positionNameEn = rs.stringForColumn("position_name_en")
                let positionNameCn = rs.stringForColumn("position_name_cn")
                let prodTypeId = Int(rs.intForColumn("prod_type_id"))
                let inspectTypeId = Int(rs.intForColumn("inspect_type_id"))
                let currentLevel = Int(rs.intForColumn("current_level"))
                let parentPositionId = Int(rs.intForColumn("parent_position_id"))
                let displayOrder = Int(rs.intForColumn("display_order"))
                let recStatus = Int(rs.intForColumn("rec_status"))
                let createUser = rs.stringForColumn("create_user")
                let createDate = rs.stringForColumn("create_date")
                let modifyUser = rs.stringForColumn("modify_user")
                let modifyDate = rs.stringForColumn("modify_date")
                let deletedFlag = Int(rs.intForColumn("deleted_flag"))
                let deleteUser = rs.stringForColumn("delete_user")
                let deleteDate = rs.stringForColumn("delete_date")
                
                let inspSecPostn = InspSectionPosition(positionId: positionId, inspectSetupId: inspectSetupId, positionCode: positionCode, positionNameEn: positionNameEn, positionNameCn: positionNameCn, prodTypeId: prodTypeId, inspectTypeId: inspectTypeId, currentLevel: currentLevel, parentPositionId: parentPositionId, displayOrder: displayOrder, recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                
                inspSecPostns.append(inspSecPostn)
            }
            }
            
            db.close()
            
            return inspSecPostns
        }
        
        return nil
    }
    
    func getTaskInspDataRecordByTaskId(taskId:Int, inspSecId:Int) ->[TaskInspDataRecord]? {
        let sql = "SELECT * FROM task_inspect_data_record WHERE task_id = ? AND inspect_section_id = ? ORDER BY record_id ASC"
        var taskInspDataRecs = [TaskInspDataRecord]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId,inspSecId]) {
            
            while rs.next() {
                
                let recordId = Int(rs.intForColumn("record_id"))
                let taskId = Int(rs.intForColumn("task_id"))
                let refRecordId = Int(rs.intForColumn("ref_record_id"))
                let inspectSectionId = Int(rs.intForColumn("inspect_section_id"))
                let inspectElementId = Int(rs.intForColumn("inspect_element_id"))
                let inspectPositionId = Int(rs.intForColumn("inspect_position_id"))
                let inspectPositionDesc = rs.stringForColumn("inspect_position_desc")
                let inspectDetail = rs.stringForColumn("inspect_detail")
                let inspectRemarks = rs.stringForColumn("inspect_remarks")
                let resultValueId = Int(rs.intForColumn("result_value_id"))
                let createUser = rs.stringForColumn("create_user")
                let createDate = rs.stringForColumn("create_date")
                let modifyUser = rs.stringForColumn("modify_user")
                let modifyDate = rs.stringForColumn("modify_date")
                let requestSectionId = Int(rs.intForColumn("request_section_id"))
                let requestElementDesc = rs.stringForColumn("request_element_desc")
                
                let taskInspDataRec = TaskInspDataRecord(recordId: recordId,taskId: taskId, refRecordId: refRecordId, inspectSectionId: inspectSectionId, inspectElementId: inspectElementId, inspectPositionId: inspectPositionId, inspectPositionDesc: inspectPositionDesc, inspectDetail: inspectDetail, inspectRemarks: inspectRemarks, resultValueId: resultValueId, requestSectionId: requestSectionId, requestElementDesc: requestElementDesc,  createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate)
                
                taskInspDataRecs.append(taskInspDataRec!)
            }
            }
            
            db.close()
            
            return taskInspDataRecs
        }
        
        return nil
    }
    
    
    func getInspSecPositionById(inspPostId:Int) ->InspSectionPosition? {
        let sql = "SELECT * FROM inspect_position_mstr WHERE position_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var inspSecPost:InspSectionPosition?
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [inspPostId]) {
            
            if rs.next() {
                
                let positionId = Int(rs.intForColumn("position_id"))
                let inspectSetupId = 0//Int(rs.intForColumn("inspect_setup_id"))
                let positionCode = rs.stringForColumn("position_code")
                let positionNameEn = rs.stringForColumn("position_name_en")
                let positionNameCn = rs.stringForColumn("position_name_cn")
                let prodTypeId = Int(rs.intForColumn("prod_type_id"))
                let inspectTypeId = Int(rs.intForColumn("inspect_type_id"))
                let currentLevel = Int(rs.intForColumn("current_level"))
                let parentPositionId = Int(rs.intForColumn("parent_position_id"))
                let displayOrder = Int(rs.intForColumn("display_order"))
                let recStatus = Int(rs.intForColumn("rec_status"))
                let createUser = rs.stringForColumn("create_user")
                let createDate = rs.stringForColumn("create_date")
                let modifyUser = rs.stringForColumn("modify_user")
                let modifyDate = rs.stringForColumn("modify_date")
                let deletedFlag = Int(rs.intForColumn("deleted_flag"))
                let deleteUser = rs.stringForColumn("delete_user")
                let deleteDate = rs.stringForColumn("delete_date")
                
                inspSecPost = InspSectionPosition(positionId: positionId, inspectSetupId: inspectSetupId, positionCode: positionCode, positionNameEn: positionNameEn, positionNameCn: positionNameCn, prodTypeId: prodTypeId, inspectTypeId: inspectTypeId, currentLevel: currentLevel, parentPositionId: parentPositionId, displayOrder: displayOrder, recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                
            }
            }
            
            db.close()
            
            return inspSecPost
        }
        
        return nil
    }
    
    func getInspSecElementById(inspElmId:Int) ->InspSectionElement? {
        let sql = "SELECT * FROM inspect_element_mstr WHERE element_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var inspSecElm:InspSectionElement?
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [inspElmId]) {
            
            if rs.next() {
                
                let elementId = Int(rs.intForColumn("element_id"))
                let inspectSetupId = 0//Int(rs.intForColumn("inspect_setup_id"))
                let elementNameEn = rs.stringForColumn("element_name_en")
                let elementNameCn = rs.stringForColumn("element_name_cn")
                let prodTypeId = Int(rs.intForColumn("prod_type_id"))
                let inspectTypeId = Int(rs.intForColumn("inspect_type_id"))
                let elementType = Int(rs.intForColumn("element_type"))
                let inspectSectionId = 0//Int(rs.intForColumn("inspect_section_id"))
                let inspectPositionId = 0//Int(rs.intForColumn("inspect_position_id"))
                let displayOrder = Int(rs.intForColumn("display_order"))
                let resultSetId = Int(rs.intForColumn("result_set_id"))
                let requiredElementFlag = Int(rs.intForColumn("required_element_flag"))
                let detailDefaultValue = rs.stringForColumn("detail_default_value")
                var detailRequiredResultList = rs.stringForColumn("detail_required_result_set_id")
                let detailSuggestFlag = Int(rs.intForColumn("detail_suggest_flag"))
                let recStatus = Int(rs.intForColumn("rec_status"))
                let createUser = rs.stringForColumn("create_user")
                let createDate = rs.stringForColumn("create_date")
                let modifyUser = rs.stringForColumn("modify_user")
                let modifyDate = rs.stringForColumn("modify_date")
                let deletedFlag = Int(rs.intForColumn("deleted_flag"))
                let deleteUser = rs.stringForColumn("delete_user")
                let deleteDate = rs.stringForColumn("delete_date")
                
                if (detailRequiredResultList == nil) {
                    detailRequiredResultList = ""
                }
                
                inspSecElm = InspSectionElement(elementId: elementId, inspectSetupId: inspectSetupId, elementNameEn: elementNameEn, elementNameCn: elementNameCn, prodTypeId: prodTypeId, inspectTypeId: inspectTypeId, elementType: elementType, inspectSectionId: inspectSectionId, inspectPositionId: inspectPositionId, displayOrder: displayOrder, resultSetId: resultSetId, requiredElementFlag: requiredElementFlag, detailDefaultValue: detailDefaultValue, detailRequiredResultList: detailRequiredResultList, detailSuggestFlag: detailSuggestFlag, recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
            }
            }
            
            db.close()
            
            return inspSecElm
        }
        
        return nil
    }
    
    func getResultValueIdByResultValue(resultValue:String, prodTypeId:Int, inspTypeId:Int) ->Int {
        //let sql = "SELECT value_id FROM result_value_mstr WHERE (value_name_en LIKE ? OR value_name_cn LIKE ?) AND prod_type_id = ? AND inspect_type_id = ?"
        let sql = "SELECT value_id FROM result_value_mstr WHERE value_name_en LIKE ? OR value_name_cn LIKE ? AND (rec_status = 0 AND deleted_flag = 0)"
        var resultValueId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [resultValue,resultValue]) {
            
                if rs.next() {
                    resultValueId = Int(rs.intForColumn("value_id"))
                }
            }
            
            db.close()
        }
        
        return resultValueId
    }
    
    func getResultValueByResultValueId(resultValueId:Int) ->String {
        let sql = "SELECT * FROM result_value_mstr WHERE value_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var resultValue = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [resultValueId]) {
            
                if rs.next() {
                    resultValue = _ENGLISH ? rs.stringForColumn("value_name_en") : rs.stringForColumn("value_name_cn")
                }
            }
            
            db.close()
        }
        
        return resultValue
    }
    
    func getResultValueById(resultValueId:Int) ->ResultValueObj? {
        let sql = "SELECT * FROM result_value_mstr WHERE value_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var resultValue:ResultValueObj?
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [resultValueId]) {
            
            if rs.next() {
                let resultValueId = Int(rs.intForColumn("value_id"))
                let resultValueNameEn = rs.stringForColumn("value_name_en")
                let resultValueNameCn = rs.stringForColumn("value_name_cn")
                
                resultValue = ResultValueObj(resultValueId:resultValueId, resultValueNameEn:resultValueNameEn, resultValueNameCn:resultValueNameCn)
            }
            }
            
            db.close()
            
            return resultValue
        }
        
        return nil
    }
    
    func getResultSetValuesByTaskId(taskId:Int) ->[SummaryResultValue] {
        let sql = "SELECT ism.section_id, ism.section_name_en,ism.section_name_cn,rvm.value_id, rvm.value_name_en,rvm.value_name_cn,IFNULL(dr.result_cnt, 0) AS result_cnt FROM inspect_task it INNER JOIN inspect_task_tmpl_section itts ON it.tmpl_id = itts.tmpl_id INNER JOIN inspect_section_mstr ism ON ism.section_id = itts.inspect_section_id AND ism.rec_status = 0 AND ism.deleted_flag = 0 INNER JOIN result_set_mstr rsm ON rsm.set_id = ism.result_set_id AND rsm.rec_status = 0 AND rsm.deleted_flag = 0 INNER JOIN result_set_value rsv ON rsv.set_id = rsm.set_id INNER JOIN result_value_mstr rvm ON rvm.value_id = rsv.value_id AND rvm.rec_status = 0 AND rvm.deleted_flag = 0 LEFT OUTER JOIN (SELECT task_id, inspect_section_id, result_value_id, COUNT(record_id) AS result_cnt FROM task_inspect_data_record GROUP BY task_id, inspect_section_id, result_value_id) dr ON dr.task_id = it.task_id AND dr.inspect_section_id = ism.section_id AND dr.result_value_id = rsv.value_id WHERE it.task_id=? AND (it.rec_status = 0 AND it.deleted_flag = 0) AND (ism.rec_status = 0 AND ism.deleted_flag = 0) AND (rsm.rec_status = 0 AND rsm.deleted_flag = 0) AND (rvm.rec_status = 0 AND rvm.deleted_flag = 0) ORDER BY ism.display_order ASC, rvm.display_order ASC"
        
        var resultSetValues = [SummaryResultValue]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId]) {
            
            while rs.next() {
                
                let sectionId = Int(rs.intForColumn("section_id"))
                let sectionName = _ENGLISH ? rs.stringForColumn("section_name_en") : rs.stringForColumn("section_name_cn")
                let valueId = Int(rs.intForColumn("value_id"))
                let valueName = _ENGLISH ? rs.stringForColumn("value_name_en") : rs.stringForColumn("value_name_cn")
                let resultCount = Int(rs.intForColumn("result_cnt"))
                
                let resultSetValue = SummaryResultValue(sectionId: sectionId,sectionName: sectionName,valueId: valueId,valueName: valueName,resultCount: resultCount)
                resultSetValues.append(resultSetValue)
            }
            }
            
            db.close()
        }
        
        return resultSetValues
    }
    
    func getResultSetValuesBySectionId(sectionId:Int) ->[String] {
        let sql = "SELECT value_name_en, value_name_cn FROM result_set_value AS rsv INNER JOIN result_value_mstr AS rvm ON rsv.value_id = rvm.value_id WHERE set_id = (SELECT rsm.set_id FROM inspect_section_mstr AS ism INNER JOIN result_set_mstr AS rsm ON ism.result_set_id = rsm.set_id WHERE ism.section_id = ?) ORDER BY rvm.display_order ASC"
        var resultSetValues = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [sectionId]) {
            
            while rs.next() {
                
                if _ENGLISH {
                    resultSetValues.append(rs.stringForColumn("value_name_en"))
                }else{
                    resultSetValues.append(rs.stringForColumn("value_name_cn"))
                }
            }
            }
            
            db.close()
        }
        
        return resultSetValues
    }
    
    func updateInspDefectDataRecord(taskInspDefectDataRecord:TaskInspDefectDataRecord) ->Int {
        if db.open() {
            db.beginTransaction()
            
            var lastInsertId = 0
            
            let sql = "INSERT OR REPLACE INTO task_defect_data_record  ('record_id','task_id','inspect_record_id','ref_record_id','inspect_element_id','defect_desc','defect_qty_critical','defect_qty_major','defect_qty_minor','defect_qty_total','create_user','create_date','modify_user','modify_date') VALUES ((SELECT record_id FROM task_defect_data_record WHERE record_id = ?),?,?,?,?,?,?,?,?,?,?,?,?,?)"
            
            if db.executeUpdate(sql, withArgumentsInArray:[notNilObject(taskInspDefectDataRecord.recordId)!,taskInspDefectDataRecord.taskId!,taskInspDefectDataRecord.inspectRecordId!,taskInspDefectDataRecord.refRecordId!,taskInspDefectDataRecord.inspectElementId!,taskInspDefectDataRecord.defectDesc!,taskInspDefectDataRecord.defectQtyCritical,taskInspDefectDataRecord.defectQtyMajor,taskInspDefectDataRecord.defectQtyMinor,taskInspDefectDataRecord.defectQtyTotal,taskInspDefectDataRecord.createUser!,taskInspDefectDataRecord.createDate!,taskInspDefectDataRecord.modifyUser!,taskInspDefectDataRecord.modifyDate!]){
            
                lastInsertId = Int(db.lastInsertRowId())
            }else{
                //UIView.init().alertView("Saving Defect Item Error!")
                db.rollback()
                db.close()
                return 0
            }
            
            db.commit()
            db.close()
            
            return lastInsertId
        }
        
        return 0
    }
    
    func getTypeNameByTypeId(typeId:Int) ->String {
        let sql = "SELECT type_name_en, type_name_cn FROM prod_type_mstr WHERE type_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var typeName = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [typeId]) {
            
                if rs.next() {
                    typeName = _ENGLISH ? rs.stringForColumn("type_name_en") : rs.stringForColumn("type_name_cn")
                }
            }
            
            db.close()
        }
        return typeName
    }
    
    func updateTask(task:Task) ->Bool {
        //let sql = "UPDATE inspect_task SET task_remarks=?,vdr_notes=?,inspect_result_value_id=?,inspector_sign_image_file=?,vdr_sign_name=?,vdr_sign_image_file=?,task_status=?,upload_inspector_id=?,upload_device_id=?, vdr_sign_date=datetime('now','localtime'),cancel_date=?,report_prefix=?,report_inspector_id=? WHERE task_id = ?"
        let sql = "UPDATE inspect_task SET task_remarks=?,vdr_notes=?,inspect_result_value_id=?,inspector_sign_image_file=?,vdr_sign_name=?,vdr_sign_image_file=?,task_status=?,upload_inspector_id=?,upload_device_id=?, vdr_sign_date=?,cancel_date=?,report_prefix=?,report_inspector_id=? WHERE task_id = ?"
        
        if db.open() {
            db.beginTransaction()
            
            let vdrSignDate = (task.vdrSignDate != nil) ? task.vdrSignDate:UIView.init().getCurrentDateTime()
            
            if !db.executeUpdate(sql, withArgumentsInArray: [task.taskRemarks!,task.vdrNotes!,task.inspectionResultValueId!,task.inspectionSignImageFile!,task.vdrSignName!,task.vdrSignImageFile!,task.taskStatus!,task.uploadInspectorId!,task.uploadDeviceId!,vdrSignDate!,task.cancelDate,task.reportPrefix!,task.reportInspectorId!,task.taskId!]) {
                
                db.rollback()
                db.close()
                return false
            }
            
            db.commit()
            db.close()
        }
        return true
    }
    
    func getResultValueIdByName(resultValueName:String) ->Int {
        let sql = "SELECT value_id FROM result_value_mstr WHERE value_name_en=? OR value_name_cn=? AND (rec_status = 0 AND deleted_flag = 0)"
        var resultValueId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [resultValueName,resultValueName]) {
            
                if rs.next() {
                    resultValueId = Int(rs.intForColumn("value_id"))
                }
            }
            
            db.close()
        }
        
        return resultValueId
    }
    
    func getResultValueNameById(resultValueId:Int) ->String {
        let sql = "SELECT value_name_en,value_name_cn FROM result_value_mstr WHERE value_id=? AND (rec_status = 0 AND deleted_flag = 0)"
        var resultValueName = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [resultValueId]) {
            
            if rs.next() {
                
                if _ENGLISH {
                    resultValueName = rs.stringForColumn("value_name_en")
                }else{
                    resultValueName = rs.stringForColumn("value_name_cn")
                }
            }
            }
            
            db.close()
        }
        
        return resultValueName
    }
    
    func getTaskInspDataRecords(taskId:Int, inspectSecId:Int) ->[TaskInspDataRecord]? {
        let sql = "SELECT * FROM task_inspect_data_record WHERE task_id = ? AND inspect_section_id= ?"
        var taskInspDataRecords = [TaskInspDataRecord]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId, inspectSecId]) {
            
            while rs.next() {
                
                let recordId = Int(rs.intForColumn("record_id"))
                let taskId = Int(rs.intForColumn("task_id"))
                let refRecordId = Int(rs.stringForColumn("ref_record_id"))
                let inspSecId = Int(rs.stringForColumn("inspect_section_id"))
                let inspElmtId = Int(rs.stringForColumn("inspect_element_id"))
                let inspPostnId = Int(rs.intForColumn("inspect_position_id"))
                let inspPostnDesc = rs.stringForColumn("inspect_position_desc")
                let inspDetail = rs.stringForColumn("inspect_detail")
                let inspRemarks = rs.stringForColumn("inspect_remarks")
                let resultValueId = Int(rs.intForColumn("result_value_id"))
                let createUser = rs.stringForColumn("create_user")
                let createDate = rs.stringForColumn("create_date")
                let modifyUser = rs.stringForColumn("modify_user")
                let modifyDate = rs.stringForColumn("modify_date")
                let reqSecId = Int(rs.intForColumn("request_section_id"))
                let reqElmtDesc = rs.stringForColumn("request_element_desc")
                
                let taskInspDataRecord = TaskInspDataRecord(recordId: recordId, taskId: taskId, refRecordId: refRecordId, inspectSectionId: inspSecId!, inspectElementId: inspElmtId!, inspectPositionId: inspPostnId, inspectPositionDesc: inspPostnDesc, inspectDetail: inspDetail, inspectRemarks: inspRemarks, resultValueId: resultValueId, requestSectionId: reqSecId, requestElementDesc: reqElmtDesc == nil ? "":reqElmtDesc, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate)
                
                taskInspDataRecords.append(taskInspDataRecord!)
            }
            }
            
            db.close()
            
            return taskInspDataRecords
        }
        
        return nil
    }
    
    func getInspSectionsById(sectionId:Int) ->InspSection? {
        //let sql = "SELECT * FROM inspect_section_mstr WHERE section_id=? AND rec_status = 0 AND deleted_flag = 0"
        let sql = "SELECT * FROM inspect_section_mstr WHERE section_id=? AND (rec_status = 0 AND deleted_flag = 0)"
        var inspSection:InspSection?
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [sectionId]) {
            
            if rs.next() {
                let sectionId = Int(rs.intForColumn("section_id"))
                let inspectSetupId = 0//Int(rs.intForColumn("inspect_setup_id"))
                let sectionNameEn = rs.stringForColumn("section_name_en")
                let sectionNameCn = rs.stringForColumn("section_name_cn")
                let prodTypeId = Int(rs.intForColumn("prod_type_id"))
                let inspectTypeId = Int(rs.intForColumn("inspect_type_id"))
                let displayOrder = Int(rs.intForColumn("display_order"))
                let resultSetId = Int(rs.intForColumn("result_set_id"))
                let inputModeCode = rs.stringForColumn("input_mode_code")
                let optionalEnableFlag = Int(rs.intForColumn("optional_enable_flag"))
                let adhoSelectFlag = Int(rs.intForColumn("adhoc_select_flag"))
                let recStatus = Int(rs.intForColumn("rec_status"))
                let createUser = rs.stringForColumn("create_user")
                let createDate = rs.stringForColumn("create_date")
                let modifyUser = rs.stringForColumn("modify_user")
                let modifyDate = rs.stringForColumn("modify_date")
                let deletedFlag = Int(rs.intForColumn("deleted_flag"))
                let deleteUser = rs.stringForColumn("delete_user")
                let deleteDate = rs.stringForColumn("delete_date")
                
                inspSection = InspSection(taskId: 0, sectionId: sectionId, inspectSetupId: inspectSetupId, sectionNameEn: sectionNameEn, sectionNameCn: sectionNameCn, prodTypeId: prodTypeId, inspectTypeId: inspectTypeId, displayOrder: displayOrder, resultSetId: resultSetId, inputModeCode: inputModeCode, optionalEnableFlag: optionalEnableFlag, adhocSelectFlag: adhoSelectFlag, recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
            }
            }
            
            db.close()
            
            return inspSection
        }
        
        return nil
    }
    
    func getReqSectionIdByName(sectionName:String) ->Int {
        let sql = "SELECT section_id FROM inspect_section_mstr WHERE section_name_en = ? OR section_name_cn = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var reqSecId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [sectionName,sectionName]) {
            
                if rs.next() {
                    reqSecId = Int(rs.intForColumn("section_id"))
                }
            }
            
            db.close()
        }
        return reqSecId
    }
    
    func getTaskDefectDataRecords(taskId:Int) ->[TaskInspDefectDataRecord]? {
        let sql = "SELECT * FROM task_defect_data_record WHERE task_id = ?"
        var taskDefectDataRecords = [TaskInspDefectDataRecord]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId]) {
            
            while rs.next() {
                
                let recordId = Int(rs.intForColumn("record_id"))
                let taskId = Int(rs.intForColumn("task_id"))
                let inspRecordId = Int(rs.stringForColumn("inspect_record_id"))
                let refRecordId = Int(rs.stringForColumn("ref_record_id"))
                let inspElmtId = Int(rs.stringForColumn("inspect_element_id"))
                let defectDesc = rs.stringForColumn("defect_desc")
                let defectQtyCritical = Int(rs.intForColumn("defect_qty_critical"))
                let defectQtyMajor = Int(rs.intForColumn("defect_qty_major"))
                let defectQtyMinor = Int(rs.intForColumn("defect_qty_minor"))
                let defectQtyTotal = Int(rs.intForColumn("defect_qty_total"))
                let createUser = rs.stringForColumn("create_user")
                let createDate = rs.stringForColumn("create_date")
                let modifyUser = rs.stringForColumn("modify_user")
                let modifyDate = rs.stringForColumn("modify_date")
                
                let taskDefectDataRecord = TaskInspDefectDataRecord(recordId: recordId, taskId: taskId, inspectRecordId: inspRecordId, refRecordId: refRecordId, inspectElementId: inspElmtId, defectDesc: defectDesc, defectQtyCritical: defectQtyCritical, defectQtyMajor: defectQtyMajor, defectQtyMinor: defectQtyMinor, defectQtyTotal: defectQtyTotal, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate)
                
                taskDefectDataRecords.append(taskDefectDataRecord!)
            }
            }
            
            db.close()
            
            return taskDefectDataRecords
        }
        
        return nil
    }
    
    func getSectionIdByElementId(elmId:Int) ->Int {
        //let sql = "SELECT section_id FROM inspect_section_mstr AS ism INNER JOIN inspect_element_mstr AS iem ON ism.section_id = iem.inspect_section_id WHERE iem.element_id = ?"
        let sql = "SELECT inspect_section_id FROM inspect_section_element WHERE inspect_element_id = ?"
        var sectionId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [elmId]) {
            
                if rs.next() {
                
                    sectionId = Int(rs.intForColumn("inspect_section_id"))
                }
            }
            
            db.close()
        }
        
        return sectionId
    }
    
    func getPositionIdByElementId(elmId:Int, inputMode:String = _INPUTMODE04) ->Int {
        var sql = "SELECT inspect_position_id FROM inspect_position_element WHERE inspect_element_id = ?"
        
        if inputMode == _INPUTMODE02 {
            sql = "SELECT ipe.inspect_position_id FROM inspect_position_element ipe INNER JOIN task_inspect_data_record tidr ON ipe.inspect_position_id = tidr.inspect_position_id INNER JOIN  task_defect_data_record tddr ON tddr.inspect_record_id = tidr.record_id WHERE tddr.inspect_record_id = ?"
        }

        var positionId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [elmId]) {
                
                if rs.next() {
                    
                    positionId = Int(rs.intForColumn("inspect_position_id"))
                }
            }
            
            db.close()
        }
        
        return positionId
    }
    
    func getInputModeCodeByTaskDefectDataId(recordId:Int) ->String? {
        var sql = "SELECT input_mode_code FROM inspect_section_mstr AS ism INNER JOIN task_inspect_data_record AS tidr ON ism.section_id = tidr.inspect_section_id INNER JOIN task_defect_data_record AS tddr ON tidr.record_id = tddr.inspect_record_id WHERE tddr.record_id = ?"//"SELECT input_mode_code FROM inspect_section_mstr AS ism INNER JOIN inspect_element_mstr AS iem ON ism.section_id = iem.inspect_section_id INNER JOIN task_inspect_data_record AS tidr ON iem.element_id = tidr.inspect_element_id INNER JOIN task_defect_data_record AS tddr ON tidr.record_id = tddr.inspect_record_id WHERE tddr.record_id = ?"
        var inputMode = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [recordId]) {
            
            if rs.next() {
                inputMode = rs.stringForColumn("input_mode_code")
                
            }else{
                
                sql = "SELECT request_section_id FROM task_inspect_data_record AS tidr INNER JOIN task_defect_data_record AS tddr ON tidr.record_id = tddr.inspect_record_id WHERE tddr.record_id = ?"
                
                let rs = db.executeQuery(sql, withArgumentsInArray: [recordId])
                
                if rs.next() {
                    let requestSecId = Int(rs.intForColumn("request_section_id"))
                    
                    if requestSecId>0 {
                        inputMode = _INPUTMODE03
                    }
                }
            }
            }
            
            db.close()
        }
        
        return inputMode
    }
    
    func getSectionByTaskInspDataId(dataRecordId:Int) ->InspSection? {
        let sql = "SELECT * FROM inspect_section_mstr AS ism INNER JOIN task_inspect_data_record AS tidr ON ism.section_id = tidr.inspect_section_id WHERE tidr.record_id = ?"
        var inspSection:InspSection?
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [dataRecordId]) {
            
            if rs.next() {
                let sectionId = Int(rs.intForColumn("section_id"))
                let inspectSetupId = 0//Int(rs.intForColumn("inspect_setup_id"))
                let sectionNameEn = rs.stringForColumn("section_name_en")
                let sectionNameCn = rs.stringForColumn("section_name_cn")
                let prodTypeId = Int(rs.intForColumn("prod_type_id"))
                let inspectTypeId = Int(rs.intForColumn("inspect_type_id"))
                let displayOrder = Int(rs.intForColumn("display_order"))
                let resultSetId = Int(rs.intForColumn("result_set_id"))
                let inputModeCode = rs.stringForColumn("input_mode_code")
                let optionalEnableFlag = Int(rs.intForColumn("optional_enable_flag"))
                let adhoSelectFlag = Int(rs.intForColumn("adhoc_select_flag"))
                let recStatus = Int(rs.intForColumn("rec_status"))
                let createUser = rs.stringForColumn("create_user")
                let createDate = rs.stringForColumn("create_date")
                let modifyUser = rs.stringForColumn("modify_user")
                let modifyDate = rs.stringForColumn("modify_date")
                let deletedFlag = Int(rs.intForColumn("deleted_flag"))
                let deleteUser = rs.stringForColumn("delete_user")
                let deleteDate = rs.stringForColumn("delete_date")
                
                inspSection = InspSection(taskId: 0, sectionId: sectionId, inspectSetupId: inspectSetupId, sectionNameEn: sectionNameEn, sectionNameCn: sectionNameCn, prodTypeId: prodTypeId, inspectTypeId: inspectTypeId, displayOrder: displayOrder, resultSetId: resultSetId, inputModeCode: inputModeCode, optionalEnableFlag: optionalEnableFlag, adhocSelectFlag: adhoSelectFlag, recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
            }
            }
            
            db.close()
            
            return inspSection
        }
        
        return nil
    }
    
    func updateTaskItem(taskItem:TaskItem) ->Bool {
        let sql = "INSERT OR REPLACE INTO inspect_task_item('rowid','task_id','po_item_id','target_inspect_qty','avail_inspect_qty','inspect_enable_flag','create_user','create_date','modify_user','modify_date','sampling_qty') VALUES((SELECT rowid FROM inspect_task_item WHERE task_id = ? AND po_item_id = ?),?,?,?,?,?,?,?,?,?,?)"
        
        if db.open(){
            
            let rs = db.executeUpdate(sql, withArgumentsInArray: [taskItem.taskId!,taskItem.poItemId!,taskItem.taskId!,taskItem.poItemId!,taskItem.targetInspectQty!,taskItem.availInspectQty!,taskItem.inspectEnableFlag!,taskItem.createUser!,taskItem.createDate!,taskItem.modifyUser!,taskItem.modifyDate!,taskItem.samplingQty!])
            
            db.close()
            return rs
        }
        
        return false
    }
    
    func deleteTaskInspDataRecordById(taskInspDataRocordId:Int) ->Bool {
        let sql = "DELETE FROM task_inspect_data_record WHERE record_id = ?"
        
        if db.open(){
            
            let rs = db.executeUpdate(sql, withArgumentsInArray: [taskInspDataRocordId])
            
            db.close()
            
            if !rs {
                return false
            }
        }
        
        return true
    }
    
    func deletePOItemByIds(poItemId:Int, taskId:Int) ->Bool {
        let sql = "DELETE FROM inspect_task_item WHERE po_item_id = ? AND task_id = ?"
        
        if db.open(){
            
            let rs = db.executeUpdate(sql, withArgumentsInArray: [poItemId, taskId])
            
            db.close()
            
            if !rs {
                return false
            }
        }
        
        return true
    }
    
    func deleteTaskInspDefectDataRecordById(id:Int) ->Bool {
        let sql = "DELETE FROM task_defect_data_record WHERE record_id = ?"
        
        if db.open(){
            
            let rs = db.executeUpdate(sql, withArgumentsInArray: [id])
            
            db.close()
            
            if !rs {
                return false
            }
        }
        
        return true
    }
    
    func insertTaskInspDataRecord(taskInspDataRecord:TaskInspDataRecord) ->Int {
        let sql = "INSERT OR REPLACE INTO task_inspect_data_record  ('record_id','task_id','ref_record_id','inspect_section_id','inspect_element_id','inspect_position_id','inspect_position_desc','inspect_detail','inspect_remarks','result_value_id','create_user','create_date','modify_user','modify_date','request_section_id','request_element_desc') VALUES ((SELECT record_id FROM task_inspect_data_record WHERE record_id = ?),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
        var taskInspDataRecordId = 0
        
        if db.open() {
            db.executeUpdate(sql, withArgumentsInArray: [taskInspDataRecord.recordId!,taskInspDataRecord.taskId!,taskInspDataRecord.refRecordId!,taskInspDataRecord.inspectSectionId!,taskInspDataRecord.inspectElementId!,taskInspDataRecord.inspectPositionId!,taskInspDataRecord.inspectPositionDesc!,taskInspDataRecord.inspectDetail!,taskInspDataRecord.inspectRemarks!,taskInspDataRecord.resultValueId,taskInspDataRecord.createUser!,taskInspDataRecord.createDate!,taskInspDataRecord.modifyUser!,taskInspDataRecord.modifyDate!,notNilObject(taskInspDataRecord.requestSectionId)!,notNilObject(taskInspDataRecord.requestElementDesc)!])
        
            taskInspDataRecordId = Int(db.lastInsertRowId())
            
            
            db.close()
        }
        
        return taskInspDataRecordId
    }
    
    func getInspTypeIdByName(inspTypeName:String) ->Int {
        let sql = "SELECT type_id FROM inspect_type_mstr WHERE type_name_en = ? OR type_name_cn =? AND (rec_status = 0 AND deleted_flag = 0)"
        var inspTypeId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [inspTypeName, inspTypeName]) {
                if rs.next() {
                    inspTypeId = Int(rs.intForColumn("type_id"))
                }
            }
            
            db.close()
        }
        
        return inspTypeId
    }
    
    func getProdTypeIdByName(prodTypeName:String) ->Int {
        let sql = "SELECT type_id FROM prod_type_mstr WHERE type_name_en = ? OR type_name_cn = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var prodTypeId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [prodTypeName, prodTypeName]) {
                if rs.next() {
                    prodTypeId = Int(rs.intForColumn("type_id"))
                }
            }
            
            db.close()
        }
        
        return prodTypeId
    }
    
    func getCatItemCountById(taskId:Int, sectionId:Int) ->Int {
        let sql = "SELECT COUNT(record_id) AS record_cnt FROM task_inspect_data_record WHERE task_id = ? AND inspect_section_id = ?"
        var itemCount = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId, sectionId]) {
                if rs.next() {
                    itemCount = Int(rs.intForColumn("record_cnt"))
                }
            }
            
            db.close()
        }
        
        return itemCount
    }
    
    func deleteTaskById(taskId:Int) ->Bool {
        
        if db.open() {
            db.beginTransaction()
            
            //1. Delete From Inspect Task
            var sql = "DELETE FROM inspect_task WHERE task_id = ?"
            if !db.executeUpdate(sql, withArgumentsInArray: [taskId]) {
                db.rollback()
                db.close()
                
                return false
            }
            
            //2. Delete From Inspect Task Inspector
            sql = "DELETE FROM inspect_task_inspector WHERE task_id = ?"
            if !db.executeUpdate(sql, withArgumentsInArray: [taskId]) {
                db.rollback()
                db.close()
                
                return false
            }
            
            //3. Delete From Inspect Task Item
            sql = "DELETE FROM inspect_task_item WHERE task_id = ?"
            if !db.executeUpdate(sql, withArgumentsInArray: [taskId]) {
                db.rollback()
                db.close()
                
                return false
            }
            
            //4. Delete From Inspect Task Item
            sql = "DELETE FROM inspect_task_item WHERE task_id = ?"
            if !db.executeUpdate(sql, withArgumentsInArray: [taskId]) {
                db.rollback()
                db.close()
                
                return false
            }
            
            //5. Delete From Task Defect Data Record
            sql = "DELETE FROM task_defect_data_record WHERE task_id = ?"
            if !db.executeUpdate(sql, withArgumentsInArray: [taskId]) {
                db.rollback()
                db.close()
                
                return false
            }
            
            //6. Delete From Task Inspect Position Point
            sql = "DELETE FROM task_inspect_position_point WHERE inspect_record_id IN (SELECT record_id FROM task_inspect_data_record WHERE task_id = ?)"
            if !db.executeUpdate(sql, withArgumentsInArray: [taskId]) {
                db.rollback()
                db.close()
                
                return false
            }
            
            //7. Delete From Task Inspect Data Record
            sql = "DELETE FROM task_inspect_data_record WHERE task_id = ?"
            if !db.executeUpdate(sql, withArgumentsInArray: [taskId]) {
                db.rollback()
                db.close()
                
                return false
            }
            
            //8. Delete From Task Inspect Field Value
            sql = "DELETE FROM task_inspect_field_value WHERE task_id = ?"
            if !db.executeUpdate(sql, withArgumentsInArray: [taskId]) {
                db.rollback()
                db.close()
                
                return false
            }
            
            //9. Delete From Task Inspect Photo File
            sql = "DELETE FROM task_inspect_photo_file WHERE task_id = ?"
            if !db.executeUpdate(sql, withArgumentsInArray: [taskId]) {
                db.rollback()
                db.close()
                
                return false
            }
            
            db.commit()
            db.close()
        }
        
        return true
    }
    
    func setConfirmedTaskUploaded() ->Bool {
        let sql = "UPDATE inspect_task SET task_status = ? WHERE task_status = ?"
        let taskStatus_Uploaded = GetTaskStatusId(caseId: "Uploaded").rawValue
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsInArray: [taskStatus_Uploaded, GetTaskStatusId(caseId: "Confirmed").rawValue]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func getResultSetIdByTmplId(tmplId:Int) ->Int {
        let sql = "SELECT result_set_id FROM inspect_task_tmpl_mstr WHERE tmpl_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var resultSetId = 1
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [tmplId]) {
                if rs.next() {
                    resultSetId = Int(rs.intForColumn("result_set_id"))
                }
            }
            
            db.close()
        }
        
        return resultSetId
    }
    
    func updateTaskInspectionDate(bookingNo:String, inspectionDate:String, taskId:Int) -> Bool {
        let sql = "UPDATE inspect_task SET inspection_no = ?, inspection_date = ?, report_inspector_id = ? WHERE task_id = ?"
        var result = false
        
        if db.open() {
            if db.executeUpdate(sql, withArgumentsInArray: [bookingNo, inspectionDate, (Cache_Inspector?.inspectorId)!, taskId]) {
                result = true
            }
            
            db.close()
            
        }
        
        return result
    }
    
    func updateTaskItemQty(availInspQty:Int, samplingQty:Int, taskId:Int, poItemId:Int) ->Bool {
        let sql = "UPDATE inspect_task_item SET avail_inspect_qty = ? AND sampling_qty = ? WHERE task_id = ? AND po_item_id = ?"
        var result = false
        
        if db.open() {
            if db.executeUpdate(sql, withArgumentsInArray: [availInspQty, samplingQty, taskId, poItemId]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func getAllTaskBrands() ->[Brand] {
        let sql = "SELECT * FROM brand_mstr bm INNER JOIN vdr_brand_map vbm ON bm.brand_id = vbm.brand_id INNER JOIN vdr_location_mstr vlm ON vbm.vdr_id = vlm.vdr_id INNER JOIN inspect_task it ON vlm.location_id = it.vdr_location_id WHERE (bm.rec_status = 0 AND bm.deleted_flag = 0)"
        
        var brands = [Brand]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray:nil) {
                
                while rs.next() {
                    
                    let dataEnv = Int(rs.intForColumn("data_env"))
                    let brandId = Int(rs.intForColumn("brand_id"))
                    let brandCode = rs.stringForColumn("brand_code")
                    let brandName = rs.stringForColumn("brand_name")
                    let recStatus = Int(rs.intForColumn("rec_status"))
                    let createUser = rs.stringForColumn("create_user")
                    let createDate = rs.stringForColumn("create_date")
                    let modifyUser = rs.stringForColumn("modify_user")
                    let modifyDate = rs.stringForColumn("modify_date")
                    let deletedFlag = Int(rs.intForColumn("deleted_flag"))
                    let deleteUser = rs.stringForColumn("delete_user")
                    let deleteDate = rs.stringForColumn("delete_date")
                    
                    let brand = Brand(dataEnv:dataEnv,brandId:brandId,brandCode:brandCode,brandName:brandName,recStatus:recStatus,createUser:createUser,createDate:createDate,modifyUser:modifyUser,modifyDate:modifyDate,deletedFlag:deletedFlag,deleteUser:deleteUser,deleteDate:deleteDate)
                    
                    brands.append(brand)
                }
            }
            
            db.close()
        }
        
        return brands
    }
    
    func getAllTaskBrandCodes() ->[String] {
        let sql = "SELECT DISTINCT(brand_code) FROM brand_mstr bm INNER JOIN vdr_brand_map vbm ON bm.brand_id = vbm.brand_id INNER JOIN vdr_location_mstr vlm ON vbm.vdr_id = vlm.vdr_id INNER JOIN inspect_task it ON vlm.location_id = it.vdr_location_id WHERE (bm.rec_status = 0 AND bm.deleted_flag = 0)"
        
        var brands = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray:nil) {
                
                while rs.next() {
                    
                    let brandCode = rs.stringForColumn("brand_code")
                    
                    brands.append(brandCode)
                }
            }
            
            db.close()
        }
        
        return brands
    }
    
    func getAllTaskBrandCodes(inputCode:String) ->[String] {
        let sql = "SELECT DISTINCT(brand_code) FROM brand_mstr bm INNER JOIN vdr_brand_map vbm ON bm.brand_id = vbm.brand_id INNER JOIN vdr_location_mstr vlm ON vbm.vdr_id = vlm.vdr_id INNER JOIN inspect_task it ON vlm.location_id = it.vdr_location_id WHERE brand_Code LIKE ? AND (bm.rec_status = 0 AND bm.deleted_flag = 0)"
        
        var brands = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray:["%"+inputCode+"%"]) {
                
                while rs.next() {
                    
                    let brandCode = rs.stringForColumn("brand_code")
                    
                    brands.append(brandCode)
                }
            }
            
            db.close()
        }
        
        return brands
    }
    
    func getAllTaskBookingNo(inputCode:String) ->[String] {
        let sql = "SELECT booking_no, inspection_no FROM inspect_task WHERE booking_no LIKE ? OR inspection_no LIKE ? AND (rec_status = 0 AND deleted_flag = 0)"
        
        var bookingNos = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray:["%"+inputCode+"%", "%"+inputCode+"%"]) {
                
                while rs.next() {
                    
                    let bookingNo = rs.stringForColumn("booking_no") == "" ? rs.stringForColumn("inspection_no") : rs.stringForColumn("booking_no")
                    
                    bookingNos.append(bookingNo)
                }
            }
            
            db.close()
        }
        
        return bookingNos
    }
    
    func getBookingNoByTaskId(taskId:Int) ->String {
        let sql = "SELECT booking_no, inspection_no FROM inspect_task WHERE task_id = ? AND (rec_status = 0 AND deleted_flag = 0)"
        var bookingNo = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray:[taskId]) {
                
                if rs.next() {
                    bookingNo = rs.stringForColumn("booking_no") != "" ? rs.stringForColumn("booking_no") : rs.stringForColumn("inspection_no")
                }
            }
            
            db.close()
        }
        
        return bookingNo
    }
    
    func didChangeInTaskPoItems(taskId:Int, poItemId:Int) ->Bool {
        let sql = "SELECT * FROM inspect_task_item WHERE task_id = ? AND po_item_id = ? AND ((avail_inspect_qty = '' AND sampling_qty = '') OR (avail_inspect_qty < 1 AND sampling_qty < 1)) AND inspect_enable_flag = 1"
        
        if db.open() {
        
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId, poItemId]) {
                if rs.next() {
                    return false
                }
            }
        
            db.close()
        }
        
        return true
    }
    
    func checkIfKeepPendingTaskStatus(taskId:Int) ->Bool {
        var sql = ""
        
        if db.open() {
            
            sql = "SELECT iem.required_element_flag FROM task_inspect_data_record tidr LEFT JOIN inspect_element_mstr iem ON tidr.inspect_element_id = iem.element_id WHERE tidr.task_id = ?"
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId]) {
                
                while rs.next() {
                    let requiredElementFlag = rs.intForColumn("required_element_flag")
                    
                    if Int(requiredElementFlag) < 1 {
                        
                        db.close()
                        return false
                    }
                }
            }
            
            sql = "SELECT 1 FROM task_defect_data_record WHERE task_id = ?"
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId]) {
                
                if rs.next() {
                    
                    db.close()
                    return false
                }
            }
            
            sql = "SELECT 1 FROM task_inspect_photo_file WHERE task_id = ?"
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId]) {
                
                if rs.next() {
                    
                    db.close()
                    return false
                }
            }
            
            db.close()
        }
        
        return true
    }
    
    func updateTaskStatusByTaskId(taskStatus:Int, taskId:Int) ->Bool {
        let sql = "UPDATE inspect_task SET task_status = ? WHERE task_id = ?"
        
        if db.open() {
        
            if !db.executeUpdate(sql, withArgumentsInArray: [taskStatus, taskId]) {
                
                db.close()
                return false
            }
         
            db.close()
        }
        
        return true
    }
    
    func getLastVdrConfirmerNameToday(vdrLocId:Int) ->String {
        //let sql = "SELECT vdr_sign_name FROM inspect_task WHERE task_status = ? AND vdr_location_id = ? AND vdr_sign_date >= date('now','-1 day')"
        let sql = "SELECT vdr_sign_name FROM inspect_task WHERE task_status >= ? AND vdr_location_id = ? ORDER BY vdr_sign_date DESC LIMIT 0,1"
        var vdrConfirmerName = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [GetTaskStatusId(caseId: "Confirmed").rawValue, vdrLocId]) {
                if rs.next() {
                    if rs.stringForColumn("vdr_sign_name") != nil && rs.stringForColumn("vdr_sign_name") != "" {
                        vdrConfirmerName = rs.stringForColumn("vdr_sign_name")
                    }
                }
            }
            
            db.close()
        }
        
        return vdrConfirmerName
    }
    
    func getVdrConfirmerNameByTaskId(taskId:Int) ->String {
        let sql = "SELECT vlm.vdr_sign_name FROM inspect_task it INNER JOIN vdr_location_mstr vlm ON it.vdr_location_id = vlm.location_id WHERE it.task_id = ?"
        var vdrConfirmerName = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId]) {
                if rs.next() {
                    if rs.stringForColumn("vdr_sign_name") != nil && rs.stringForColumn("vdr_sign_name") != "" {
                        vdrConfirmerName = rs.stringForColumn("vdr_sign_name")
                    }
                }
            }
            
            db.close()
        }
        
        return vdrConfirmerName
    }
    
    func ifPhotosAddedInTask(taskId:Int) ->Bool {
        let sql = "SELECT 1 FROM task_inspect_photo_file WHERE task_id = ?"
        var result = false
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId]) {
            
                if rs.next() {
                    result = true
                }
            }
            
            db.close()
        }
        
        return result
    }
    
    func getAllStyleNoByValue(inputValue:String) ->[String] {
        let sql = "SELECT DISTINCT(style_no) FROM fgpo_line_item fli INNER JOIN inspect_task_item iti ON fli.item_id = iti.po_item_id WHERE style_no LIKE ?"
        var styleNoList = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: ["%"+inputValue+"%"]) {
                while rs.next() {
                    styleNoList.append(rs.stringForColumn("style_no"))
                }
            }
            
            db.close()
        }
        
        return styleNoList
    }
    
    func getAllInvalidTaskId() ->[Int] {
        let sql = "SELECT task_id FROM inspect_task WHERE prod_type_id < 1 AND inspect_type_id < 1 AND tmpl_id < 1"
        var ids = [Int]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: nil) {
                while rs.next() {
                    ids.append(Int(rs.intForColumn("task_id")))
                }
            }
            
            db.close()
        }
        
        return ids
    }
    
    func getPositionIdByElementIdForINPUT02(recordId:Int) ->Int {
        let sql = "SELECT ipe.inspect_position_id FROM inspect_position_element ipe INNER JOIN task_inspect_data_record tidr ON ipe.inspect_position_id = tidr.inspect_position_id INNER JOIN  task_defect_data_record tddr ON tddr.inspect_record_id = tidr.record_id WHERE tddr.inspect_record_id = ?"
        var positionId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [recordId]) {
                
                if rs.next() {
                    
                    positionId = Int(rs.intForColumn("inspect_position_id"))
                }
            }
            
            db.close()
        }
        
        return positionId
    }
    
    func deleteTaskDefectDataPPTRecordsByInspItemId(id:Int) ->Bool {
        let sql = "DELETE FROM task_inspect_position_point WHERE inspect_record_id = ?"
        
        if db.open(){
            
            let rs = db.executeUpdate(sql, withArgumentsInArray: [id])
            
            db.close()
            
            if !rs {
                return false
            }
        }
        
        return true
    }

}