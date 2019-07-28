//
//  InspectorDataHelper.swift
//  QCFossil
//
//  Created by Yin Huang on 4/2/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

class InspectorDataHelper:DataHelperMaster {
    
    func getInspector(userName:String, password:String) ->Inspector? {
        let sql = "SELECT * FROM inspector_mstr im INNER JOIN prod_type_mstr ptm ON im.prod_type_id = ptm.type_id WHERE (lower(app_username) = ? OR app_username = ?) AND app_password = ?"
        var inspector:Inspector?
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [userName.lowercaseString, userName, password]) {
            
            if rs.next() {
                
                let inspectorId = Int(rs.intForColumn("inspector_id"))
                let inspectorName = rs.stringForColumn("inspector_name")
                let prodTypeId = Int(rs.intForColumn("prod_type_id"))
                let appUserName = rs.stringForColumn("app_username")
                let appPassword = rs.stringForColumn("app_password")
                let serviceToken = rs.stringForColumn("service_token")
                let reportPrefix = rs.stringForColumn("report_prefix")
                let reportRunningNo = rs.stringForColumn("report_running_no")
                let phoneNo = rs.stringForColumn("phone_no")
                let emailAddr = rs.stringForColumn("email_addr")
                let createUser = rs.stringForColumn("create_user")
                let createDate = rs.stringForColumn("create_date")
                let modifyUser = rs.stringForColumn("modify_user")
                let modifyDate = rs.stringForColumn("modify_date")
                let recStatus = Int(rs.intForColumn("rec_status"))
                let deleteFlag = Int(rs.intForColumn("deleted_flag"))
                let deleteUser = rs.stringForColumn("delete_user")
                let deleteDate = rs.stringForColumn("delete_date")
                let chgPwdReqDate = rs.stringForColumn("chg_pwd_req_date")
                let typeCode = rs.stringForColumn("type_code")
                
                inspector = Inspector(inspectorId: inspectorId, inspectorName: inspectorName, prodTypeId: prodTypeId, appUserName: appUserName, appPassword: appPassword, serviceToken: serviceToken, reportPrefix: reportPrefix, reportRunningNo: reportRunningNo, phoneNo: phoneNo, emailAddr: emailAddr, typeCode: typeCode)
                
                inspector?.createUser = createUser
                inspector?.createDate = createDate
                inspector?.modifyUser = modifyUser
                inspector?.modifyDate = modifyDate
                inspector?.recStatus = recStatus
                inspector?.deleteFlag = deleteFlag
                inspector?.deleteUser = deleteUser
                inspector?.deleteDate = deleteDate
                inspector?.chgPwdReqDate = chgPwdReqDate
                
            }
            }
            
            db.close()
        
            return inspector
        }
        
        return nil
    }
    
    func getTaskCountByInspectorId(inspectorId:Int) ->Int {
        let sql = "SELECT COUNT(task_id) AS task_cnt FROM inspect_task WHERE inspection_no = ?"
        var taskCount = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [inspectorId]) {
                
                if rs.next() {
                    taskCount = Int(rs.intForColumn("task_cnt"))
                }
            }
            
            db.close()
        }
        
        return taskCount
    }
    
    func updateRunningNo(rpRunningNo:Int,inspectorId:Int) ->Bool {
        let sql = "UPDATE inspector_mstr SET report_running_no = ? WHERE inspector_id = ?"
        var result = true
        
        if db.open() {
         
            if !db.executeUpdate(sql, withArgumentsInArray: [rpRunningNo, inspectorId]) {
                result = false
            }
            
            db.close()
        }
        
        return result
    }
    
    func getAllInspectors() ->[Inspector] {
        let sql = "SELECT * FROM inspector_mstr"
        var inspectors = [Inspector]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: nil) {
                
                while rs.next() {
                    
                    let inspectorId = Int(rs.intForColumn("inspector_id"))
                    let inspectorName = rs.stringForColumn("inspector_name")
                    let prodTypeId = Int(rs.intForColumn("prod_type_id"))
                    let appUserName = rs.stringForColumn("app_username")
                    let appPassword = rs.stringForColumn("app_password")
                    let serviceToken = rs.stringForColumn("service_token")
                    let reportPrefix = rs.stringForColumn("report_prefix")
                    let reportRunningNo = rs.stringForColumn("report_running_no")
                    let phoneNo = rs.stringForColumn("phone_no")
                    let emailAddr = rs.stringForColumn("email_addr")
                    
                    inspectors.append(Inspector(inspectorId: inspectorId, inspectorName: inspectorName, prodTypeId: prodTypeId, appUserName: appUserName, appPassword: appPassword, serviceToken: serviceToken, reportPrefix: reportPrefix, reportRunningNo: reportRunningNo, phoneNo: phoneNo, emailAddr: emailAddr, typeCode: ""))
                }
            }
            
            db.close()
        }
        
        return inspectors
    }
    
    func updateInspector(inspector:Inspector) ->Int {
        
        if db.open() {
            var sql = "SELECT report_running_no FROM inspector_mstr WHERE inspector_id = ?"
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [inspector.inspectorId!]) {
                
                if rs.next() {
                    let rptRunningNo = Int(rs.intForColumn("report_running_no"))
                    inspector.reportRunningNo = rptRunningNo > Int(inspector.reportRunningNo!) ? String(rptRunningNo) : inspector.reportRunningNo
                }
            }
            
            sql = "INSERT OR REPLACE INTO inspector_mstr  ('inspector_id','inspector_name','prod_type_id','app_username','app_password','service_token','report_prefix','report_running_no','phone_no','email_addr','rec_status','create_user','create_date','modify_user','modify_date','deleted_flag','delete_user','delete_date') VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
            
            if db.executeUpdate(sql, withArgumentsInArray:[notNilObject(inspector.inspectorId)!,inspector.inspectorName!,inspector.prodTypeId!,inspector.appUserName!,inspector.appPassword!,inspector.serviceToken!,inspector.reportPrefix!,inspector.reportRunningNo!,inspector.phoneNo!,inspector.emailAddr!,1,inspector.createUser!,inspector.createDate!,inspector.modifyUser!,inspector.modifyDate!,0,"",""]){
                
            }
            
            db.close()
            
            return 1
        }
        
        return 0
    }
    
}