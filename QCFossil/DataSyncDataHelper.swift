//
//  DataSyncDataHelper.swift
//  QCFossil
//
//  Created by Yin Huang on 3/6/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation
import UIKit

class DataSyncDataHelper:DataHelperMaster {
    
    func cleanDBTableByName(tableName:String) ->Bool {
        let sql = "DELETE FROM " + tableName
        var result = false
        
        let noDeleteTables = ["inspect_task_item","inspect_task"]
        
        if noDeleteTables.contains(tableName) || db.executeUpdate(sql, withArgumentsInArray: nil) {
                result = true
        }
        
        return result
    }
    /*
    func clearDBTables() ->Bool {
        if db.open() {
            db.beginTransaction()
            
            //1. clean table
            for _DS_DL_API_NAME in _DS_DL_API {
                for (key, value) in _DS_DL_API_NAME["ACTIONTABLES"] as! Dictionary<String, String> {
                    if key != "" {
                        
                        if !cleanDBTableByName(value) {
                            db.rollback()
                            db.close()
                            return false
                        }
                    }
                }
            }
        
            db.commit()
            db.close()
        }
        
        return true
    }*/
    
    
    func clearDBTables(_DS_TABLES:Dictionary<String, String>) ->Bool {
        if db.open() {
            db.beginTransaction()
            
            //1. clean table
            for (key, value) in _DS_TABLES {
                if key != "" {
                    
                    if !cleanDBTableByName(value) {
                        db.rollback()
                        db.close()
                        return false
                    }
                }
                
            }
            
            db.commit()
            db.close()
        }
        
        return true
    }
    
    func updateTableRecordsByScript(vc:DataSyncViewController, apiName:String, sqlScript:[String], handler:(Bool)-> Void) ->Bool {
        
        if db.open() {
            db.beginTransaction()
            
            if apiName == "_DS_FGPODATA" {
                self.cleanDBTableByName("fgpo_line_item WHERE item_id NOT IN (SELECT po_item_id FROM inspect_task_item)")
                vc.updateProgressBar(0.7)
            }
            
            for sql in sqlScript {
                //1. skip no data record
                if sql == "" {
                    continue
                }
                    
                //2. update table records
                if !db.executeUpdate(sql, withArgumentsInArray: nil) {
                    print("Error, DB Rollback!")
                    db.rollback()
                    db.close()
                        
//                    if apiName == "_DS_DL_TASK_STATUS" {
                    handler(false)
//                    }
                    
                    return false
                }
            }
            
            db.commit()
            db.close()
        }
            
        handler(true)
        return true
    }
    
    func shouldSkipTaskData(objId:Int) ->Bool {
        
        if db.open() {
            let sql = "SELECT 1 FROM inspect_task WHERE ref_task_id = ?"
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [objId]) {
                
                if rs.next() {
                    
                    db.close()
                    return false
                }
            }
            
            db.close()
        }
        
        return true
    }
    
    func selectTaskIdsCanDelete() ->[Int] {
        var taskIds = [Int]()
        
        if db.open() {
            
            let sql = "SELECT task_id FROM inspect_task WHERE task_status <> ? AND app_ready_purge_date <> ? AND app_ready_purge_date IS NOT NULL"
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [GetTaskStatusId(caseId: "Confirmed").rawValue, ""]) {
                
                while rs.next() {
                    let taskId = Int(rs.intForColumn("task_id"))
                    taskIds.append(taskId)
                }
            }
            
            db.close()
        }
        
        return taskIds
    }
    
    func getAllInspectTasks(var tasklist:Dictionary<String,String>) -> [Dictionary<String,String>] {
        let sql = "SELECT * FROM inspect_task WHERE ((task_status = ? AND confirm_upload_date IS NULL) OR task_status = ?) AND report_inspector_id = ?"
        var tasks = [Dictionary<String,String>]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [GetTaskStatusId(caseId: "Confirmed").rawValue, GetTaskStatusId(caseId: "Cancelled").rawValue, (Cache_Inspector?.inspectorId)!]) {
                
                while rs.next() {
                    
                    for (key,_) in tasklist {
                        
                        tasklist[key] = rs.stringForColumn(key)
                        
                    }
                    
                    tasks.append(tasklist)
                }
            }
            
            db.close()
        }
        
        return tasks
    }
    
    func getAllInspectTaskInspectors(var taskInspectorlist:Dictionary<String,String>) -> [Dictionary<String,String>] {
        let sql = "SELECT * FROM inspect_task_inspector iti INNER JOIN inspect_task it ON iti.task_id = it.task_id WHERE inspector_id = ? AND ((it.task_status = ? AND it.confirm_upload_date IS NULL) OR it.task_status = ?)"
        var taskInspectors = [Dictionary<String,String>]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [(Cache_Inspector?.inspectorId)!, GetTaskStatusId(caseId: "Confirmed").rawValue, GetTaskStatusId(caseId: "Cancelled").rawValue]) {
                
                while rs.next() {
                    
                    for (key,_) in taskInspectorlist {
                        
                        taskInspectorlist[key] = rs.stringForColumn(key)
                        
                    }
                    
                    taskInspectors.append(taskInspectorlist)
                }
            }
            
            db.close()
        }
        
        return taskInspectors
    }
 
    func getAllInspectTaskItems(var taskItemlist:Dictionary<String,String>) -> [Dictionary<String,String>] {
        //let sql = "SELECT * FROM inspect_task_item"
        let sql = "SELECT iti.* FROM inspect_task_item iti INNER JOIN inspect_task it ON iti.task_id = it.task_id WHERE it.report_inspector_id = ? AND ((it.task_status = ? AND it.confirm_upload_date IS NULL) OR it.task_status = ?)"
        var taskItems = [Dictionary<String,String>]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [(Cache_Inspector?.inspectorId)!, GetTaskStatusId(caseId: "Confirmed").rawValue, GetTaskStatusId(caseId: "Cancelled").rawValue]) {
                
                while rs.next() {
                    
                    for (key,_) in taskItemlist {
                        
                        if let value = rs.stringForColumn(key) {
                            taskItemlist[key] = value
                        } else {
                            taskItemlist[key] = ""
                        }
                    }
                    
                    taskItems.append(taskItemlist)
                }
            }
            
            db.close()
        }
        
        return taskItems
    }
    
    func getAllInspectTaskIFVs(var taskIFVlist:Dictionary<String,String>) -> [Dictionary<String,String>] {
        let sql = "SELECT * FROM task_inspect_field_value tifv INNER JOIN inspect_task it ON tifv.task_id = it.task_id WHERE it.report_inspector_id = ? AND ((it.task_status = ? AND it.confirm_upload_date IS NULL) OR it.task_status = ?)"
        var taskIFVs = [Dictionary<String,String>]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [(Cache_Inspector?.inspectorId)!, GetTaskStatusId(caseId: "Confirmed").rawValue, GetTaskStatusId(caseId: "Cancelled").rawValue]) {
                
                while rs.next() {
                    
                    for (key,_) in taskIFVlist {
                        
                        taskIFVlist[key] = rs.stringForColumn(key)
                        
                    }
                    
                    taskIFVs.append(taskIFVlist)
                }
            }
            
            db.close()
        }
        
        return taskIFVs
    }
    
    func getAllInspectTaskIDRs(var taskIDRlist:Dictionary<String,String>) -> [Dictionary<String,String>] {
        //let sql = "SELECT * FROM task_inspect_data_record"
        let sql = "SELECT tidr.* FROM task_inspect_data_record tidr INNER JOIN inspect_task it ON tidr.task_id = it.task_id WHERE it.report_inspector_id = ? AND ((it.task_status = ? AND it.confirm_upload_date IS NULL) OR it.task_status = ?)"
        var taskIDRs = [Dictionary<String,String>]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [(Cache_Inspector?.inspectorId)!, GetTaskStatusId(caseId: "Confirmed").rawValue, GetTaskStatusId(caseId: "Cancelled").rawValue]) {
                
                while rs.next() {
                    
                    for (key,_) in taskIDRlist {
                        
                        if let value = rs.stringForColumn(key) {
                            taskIDRlist[key] = value
                        } else {
                            taskIDRlist[key] = ""
                        }
                    }
                    
                    taskIDRs.append(taskIDRlist)
                }
            }
            
            db.close()
        }
        
        return taskIDRs
    }
    
    func getAllInspectTaskIPPs(var taskIPPlist:Dictionary<String,String>) -> [Dictionary<String,String>] {
        let sql = "SELECT tipp.* FROM task_inspect_position_point tipp INNER JOIN task_inspect_data_record tidr ON tipp.inspect_record_id = tidr.record_id INNER JOIN inspect_task it ON tidr.task_id = it.task_id WHERE it.report_inspector_id = ? AND ((it.task_status = ? AND it.confirm_upload_date IS NULL) OR it.task_status = ?)"
        var taskIPPs = [Dictionary<String,String>]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [(Cache_Inspector?.inspectorId)!, GetTaskStatusId(caseId: "Confirmed").rawValue, GetTaskStatusId(caseId: "Cancelled").rawValue]) {
                
                while rs.next() {
                    
                    for (key,_) in taskIPPlist {
                        
                        taskIPPlist[key] = rs.stringForColumn(key)
                        
                    }
                    
                    taskIPPs.append(taskIPPlist)
                }
            }
            
            db.close()
        }
        
        return taskIPPs
    }
    
    func getAllInspectTaskDDRs(var taskDDRlist:Dictionary<String,String>) -> [Dictionary<String,String>] {
        //let sql = "SELECT * FROM task_defect_data_record"
        let sql = "SELECT tddr.* FROM task_defect_data_record tddr INNER JOIN inspect_task it ON tddr.task_id = it.task_id WHERE it.report_inspector_id = ? AND ((it.task_status = ? AND it.confirm_upload_date IS NULL) OR it.task_status = ?)"
        var taskDDRs = [Dictionary<String,String>]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [(Cache_Inspector?.inspectorId)!, GetTaskStatusId(caseId: "Confirmed").rawValue, GetTaskStatusId(caseId: "Cancelled").rawValue]) {
                
                while rs.next() {
                    
                    for (key,_) in taskDDRlist {
                        
                        taskDDRlist[key] = rs.stringForColumn(key)
                        
                    }
                    
                    taskDDRs.append(taskDDRlist)
                }
            }
            
            db.close()
        }
        
        return taskDDRs
    }
    
    func getAllInspectTaskIPFs(var taskIPFlist:Dictionary<String,String>) -> [Dictionary<String,String>] {
        //let sql = "SELECT * FROM task_inspect_photo_file"
        let sql = "SELECT tipf.* FROM task_inspect_photo_file tipf INNER JOIN inspect_task it ON tipf.task_id = it.task_id WHERE it.report_inspector_id = ? AND ((it.task_status = ? AND it.confirm_upload_date IS NULL) OR it.task_status = ?)";
        var taskIPFs = [Dictionary<String,String>]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [(Cache_Inspector?.inspectorId)!, GetTaskStatusId(caseId: "Confirmed").rawValue, GetTaskStatusId(caseId: "Cancelled").rawValue]) {
                
                while rs.next() {
                    
                    for (key,_) in taskIPFlist {
                        
                        taskIPFlist[key] = rs.stringForColumn(key)
                        
                    }
                    
                    taskIPFs.append(taskIPFlist)
                }
            }
            
            db.close()
        }
        
        return taskIPFs
    }
    
    func getAllConfirmedTaskIds() ->[Int] {

        //let sql = "SELECT task_id FROM inspect_task WHERE task_status = ? OR task_status = ?"
        let sql = "SELECT task_id FROM inspect_task WHERE task_status = ?"
        
        var taskIds = [Int]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [GetTaskStatusId(caseId: "Confirmed").rawValue/*, GetTaskStatusId(caseId: "Uploaded").rawValue*/]) {
                
                while rs.next() {
                    let taskId = Int(rs.intForColumn("task_id"))
                    taskIds.append(taskId)
                }
            }
            
            db.close()
        }
        
        return taskIds
    }
    
    func getAllPhotos(includeTaskIds:String, excludeTaskIds:String) ->[Photo]? {
        //Task Status is 2, mean Confirmed Task
        //let sql = "SELECT * FROM inspect_task it INNER JOIN task_inspect_photo_file tipf ON it.task_id = tipf.task_id WHERE it.report_inspector_id = ? AND it.task_id NOT IN \(excludeTaskIds) AND it.task_id IN \(includeTaskIds) AND (tipf.upload_date = '' OR tipf.upload_date IS NULL) ORDER BY it.confirm_upload_date ASC, tipf.photo_id ASC"
        let sql = "SELECT * FROM inspect_task it INNER JOIN task_inspect_photo_file tipf ON it.task_id = tipf.task_id WHERE it.report_inspector_id = ? AND it.task_id NOT IN \(excludeTaskIds) AND it.task_id IN \(includeTaskIds) AND (tipf.upload_date = '' OR tipf.upload_date IS NULL) ORDER BY it.vdr_sign_date ASC, tipf.create_date ASC"
        var photos = [Photo]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [/*GetTaskStatusId(caseId: "Confirmed").rawValue, GetTaskStatusId(caseId: "Cancelled").rawValue,*/ (Cache_Inspector?.inspectorId)!]) {
                
                while rs.next() {
                    
                    //Photo Table Data
                    let photoId = Int(rs.intForColumn("photo_id"))
                    let taskId = Int(rs.intForColumn("task_id"))
                    let refPhotoId = Int(rs.intForColumn("ref_photo_id"))
                    let orgFileName = rs.stringForColumn("org_filename")
                    let photoFile = rs.stringForColumn("photo_file")
                    let thumbFile = rs.stringForColumn("thumb_file")
                    let photoDesc = rs.stringForColumn("photo_desc")
                    let dataRecordId = Int(rs.intForColumn("data_record_id"))
                    let createUser = rs.stringForColumn("create_user")
                    let createDate = rs.stringForColumn("create_date")
                    let modifyUser = rs.stringForColumn("modify_user")
                    let modifyDate = rs.stringForColumn("modify_date")
                    let dataType = Int(rs.intForColumn("data_type"))
                    
                    //Task Data
                    let taskBookingNo = rs.stringForColumn("booking_no") != "" ? rs.stringForColumn("booking_no") : rs.stringForColumn("inspection_no")
                    
                    let photo = Photo(photo: nil, photoFilename: photoFile, taskId: taskId, photoFile: photoFile)
                    
                    photo?.photoId = photoId
                    photo?.refPhotoId = refPhotoId
                    photo?.orgFileName = orgFileName
                    photo?.thumbFile = thumbFile
                    photo?.photoDesc = photoDesc
                    photo?.dataRecordId = dataRecordId
                    photo?.createUser = createUser
                    photo?.createDate = createDate
                    photo?.modifyUser = modifyUser
                    photo?.modifyDate = modifyDate
                    photo?.dataType = dataType
                    photo?.taskBookingNo = taskBookingNo
                    
                    photos.append(photo!)
                }
            }
            
            db.close()
            
            return photos
        }
        
        return nil
    }
    
    func updateTaskStatus(taskId:Int, status:Int, refuseDesc:String, ref_task_id:Int) ->Bool {
        
        let sql = "UPDATE inspect_task SET task_status = ?, data_refuse_desc = ? WHERE task_id = ? AND task_status <> ?"
        let sqlUpdateRefTaskId = "UPDATE inspect_task SET ref_task_id = ? WHERE task_id = ? AND (ref_task_id is NULL OR ref_task_id < 1)"
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsInArray: [status, refuseDesc, taskId, status]) {
                if db.executeUpdate(sqlUpdateRefTaskId, withArgumentsInArray: [ref_task_id, taskId]) {
                    result = true
                }
            }
            
            db.close()
        }
        
        return result
    }
    
    func shouldPhysicalDeleteTask(taskId:Int) ->Bool {
        let sql = "SELECT task_status FROM inspect_task WHERE task_id = ? AND (task_status = ? OR task_status = ?)"
        var result = false
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId, GetTaskStatusId(caseId: "Pending").rawValue, GetTaskStatusId(caseId: "Draft").rawValue]) {
                
                if rs.next() {
                    result = true
                }
            }
            
            db.close()
        }
        
        return result
    }
    
    func existInTaskItemTable(poItemId:Int) ->Bool {
        let sql = "SELECT 1 FROM inspect_task_item WHERE po_item_id = ?"
        var result = false
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [poItemId]) {
                
                if rs.next() {
                    result = true
                }
            }
            
            db.close()
        }
        
        return result
    }
    
    func updatePhotoUploadDateByPhotoId(photoId:Int) ->Bool {
        let sql = "UPDATE task_inspect_photo_file SET upload_date = datetime('now', 'localtime') WHERE photo_id = ?"
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsInArray: [photoId]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func updateInspectTaskConfirmUploadDate(taskId:Int) ->Bool {
        let sql = "UPDATE inspect_task SET confirm_upload_date = datetime('now', 'localtime') WHERE task_id = ? AND task_status = ?"
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsInArray: [taskId, GetTaskStatusId(caseId: "Confirmed").rawValue]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
}