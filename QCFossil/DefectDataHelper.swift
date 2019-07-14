//
//  DefectDataHelper.swift
//  QCFossil
//
//  Created by Yin Huang on 1/4/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation
import UIKit

class DefectDataHelper:DataHelperMaster {

    func getDefectTypeByTaskDefectDataRecordId(Id:Int) ->[String] {
        let sql = "SELECT distinct iem.element_name_en, iem.element_name_cn FROM inspect_element_mstr iem INNER JOIN inspect_position_element ipe ON iem.element_id = ipe.inspect_element_id INNER JOIN task_inspect_position_point tipp ON ipe.inspect_position_id = tipp.inspect_position_id INNER JOIN task_defect_data_record tddr ON tipp.inspect_record_id = tddr.inspect_record_id WHERE tddr.record_id = ?"
        var defectTypeElms = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [Id]) {
                while rs.next() {
                    
                    let elementNameEn = rs.stringForColumn("element_name_en")
                    let elementNameCn = rs.stringForColumn("element_name_cn")

                    defectTypeElms.append( _ENGLISH ? elementNameEn:elementNameCn)
                }
            }
            
            db.close()
        }
        
        return defectTypeElms
    }
    
    func getDefectTypeByTaskInspectDataRecordId(Id:Int) ->[PositPointObj] {
        let sql = "SELECT * FROM inspect_position_mstr ipm INNER JOIN task_inspect_position_point tipp ON ipm.position_id = tipp.inspect_position_id WHERE tipp.inspect_record_id = ?"
        var defectTypeElms = [PositPointObj]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [Id]) {
                while rs.next() {
                    let positionId = Int(rs.intForColumn("position_id"))
                    let parentId = Int(rs.intForColumn("parent_position_id"))
                    let elementNameEn = rs.stringForColumn("position_name_en")
                    let elementNameCn = rs.stringForColumn("position_name_cn")
                    
                    let positionObject = PositPointObj(positionId: positionId, parentId: parentId, positionNameEn: elementNameEn, positionNameCn: elementNameCn)
                    
                    defectTypeElms.append(positionObject)
                }
            }
            
            db.close()
        }
        
        return defectTypeElms
    }
    
    func getDefectTypeElms(positionIds:[String]) ->[String] {
        var sql = "SELECT distinct iem.element_name_en, iem.element_name_cn FROM inspect_element_mstr iem INNER JOIN inspect_position_element ipe ON iem.element_id = ipe.inspect_element_id WHERE iem.element_type = 2 AND ipe.inspect_position_id IN "
        var defectTypeElms = [String]()
        
        let positions = positionIds.joinWithSeparator(",")
        sql += "(\(positions))"
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: []) {
                while rs.next() {
                    //let elementId = Int(rs.intForColumn("element_id"))
                    let elementNameEn = rs.stringForColumn("element_name_en")
                    let elementNameCn = rs.stringForColumn("element_name_cn")
                    
                    //let elemtObj = ElmtObj(elementId:elementId, elementNameEn: elementNameEn,elementNameCn: elementNameCn,reqElmtFlag: 0)
                    defectTypeElms.append( _ENGLISH ? elementNameEn:elementNameCn)
                }
            }
            
            db.close()
        }
        
        return defectTypeElms
    }

    func deleteDefectItemById(recordId:Int) ->Bool {
        let sql = "DELETE FROM task_defect_data_record WHERE record_id = ?"
        
        if db.open() {
            
            if !db.executeUpdate(sql, withArgumentsInArray: [recordId]) {
                db.close()
                
                return false
            }
            
            db.close()
        }
        
        return true
    }
    
    func getInspElementIdByName(name:String, elementType:Int = 2) ->Int {
        let sql = "SELECT element_id FROM inspect_element_mstr WHERE (element_name_en = ? OR element_name_cn = ?) AND element_type = ?"
        var id = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [name, name, elementType]) {
                if rs.next() {
                    id = Int(rs.intForColumn("element_id"))
                }
            }
            
            db.close()
        }
        
        return id
    }
    
    func getInspElementNameById(id:Int) ->String {
        let sql = "SELECT element_name_en, element_name_cn FROM inspect_element_mstr WHERE element_id = ? AND element_type = 2"
        var name = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [id]) {
                if rs.next() {
                    name = _ENGLISH ? rs.stringForColumn("element_name_en") : rs.stringForColumn("element_name_cn")
                }
            }
            
            db.close()
        }
        
        return name
    }
    
    func getInspPositionNameById(id:Int) ->String {
        let sql = "SELECT * FROM inspect_position_mstr WHERE position_id = ? AND position_type = 1"
        var name = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [id]) {
                if rs.next() {
                    name = _ENGLISH ? rs.stringForColumn("position_name_en") : rs.stringForColumn("position_name_cn")
                }
            }
            
            db.close()
        }
        
        return name
    }
    
    
    func getDefectTypesByPositionId(positionId:Int) ->[String] {
        let sql = "SELECT * FROM inspect_element_mstr iem INNER JOIN inspect_position_element ipe ON ipe.inspect_element_id = iem.element_id WHERE ipe.inspect_position_id = ? AND iem.element_type = 2"
        var defectTypes = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [positionId]) {
                while rs.next() {
                    defectTypes.append((_ENGLISH ? rs.stringForColumn("element_name_en") : rs.stringForColumn("element_name_cn")))
                }
            }
            
            db.close()
        }
        
        return defectTypes
    }

    func getDefectObjectsByPositionId(positionId:Int) ->[DropdownValue] {
        let sql = "SELECT * FROM inspect_element_mstr iem INNER JOIN inspect_position_element ipe ON ipe.inspect_element_id = iem.element_id WHERE ipe.inspect_position_id = ? AND iem.element_type = 2"
        var defectTypes = [DropdownValue]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [positionId]) {
                while rs.next() {
                    let valueId = Int(rs.intForColumn("element_id"))
                    let valueNameEn = rs.stringForColumn("element_name_en")
                    let valueNameCn = rs.stringForColumn("element_name_cn")
                    let defectType = DropdownValue(valueId: valueId, valueNameEn: valueNameEn, valueNameCn: valueNameCn)
                    
                    defectTypes.append(defectType)
                }
            }
            
            db.close()
        }
        
        return defectTypes
    }
    
    func getTaskInspDataRcordNameById(recordId:Int) ->TaskInspDataRecord? {
        let sql = "SELECT * FROM task_inspect_data_record WHERE record_id = ?"
        var taskInspDataRecord:TaskInspDataRecord?
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [recordId]) {
                if rs.next() {
                    
                    let taskId = Int(rs.intForColumn("task_id"))
                    let refRecordId = Int(rs.intForColumn("ref_record_id"))
                    let inspectSectionId = Int(rs.intForColumn("inspect_section_id"))
                    let inspectElementId = Int(rs.intForColumn("inspect_element_id"))
                    let inspectPositionId = Int(rs.intForColumn("inspect_position_id"))
                    let inspectPositionDesc = rs.stringForColumn("inspect_position_desc")
                    let inspectDetail = rs.stringForColumn("inspect_detail")
                    let inspectRemarks = rs.stringForColumn("inspect_remarks")
                    let resultValueId = Int(rs.intForColumn("result_value_id"))
                    let requestSectionId = Int(rs.intForColumn("request_section_id"))
                    let requestElementDesc = rs.stringForColumn("request_element_desc")
                    
                    taskInspDataRecord = TaskInspDataRecord.init(taskId: taskId, refRecordId: refRecordId, inspectSectionId: inspectSectionId, inspectElementId: inspectElementId, inspectPositionId: inspectPositionId, inspectPositionDesc: inspectPositionDesc, inspectDetail: inspectDetail, inspectRemarks: inspectRemarks, resultValueId: resultValueId, requestSectionId: requestSectionId, requestElementDesc: requestElementDesc)
                }
            }
            
            db.close()
        }
        
        return taskInspDataRecord
    }
    
    func getPositionIdByElementId(elementId:Int) ->Int {
        let sql = "SELECT * FROM inspect_position_mstr ipm INNER JOIN inspect_position_element ipe ON ipm.position_id = ipe.inspect_position_id INNER JOIN inspect_element_mstr iem ON ipe.inspect_element_id = iem.element_id where iem.element_id = ? AND ipm.position_type = 3"
        var id = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [elementId]) {
                if rs.next() {
                    id = Int(rs.intForColumn("position_id"))
                }
            }
            
            db.close()
        }
        
        return id
    }
}
