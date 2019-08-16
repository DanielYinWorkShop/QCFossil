//
//  DPDataHelper.swift
//  QCFossil
//
//  Created by Yin Huang on 21/3/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation
import UIKit

class DPDataHelper:DataHelperMaster {

    func getDefectPositions(/*prodTypeId:Int=1, inspTypeId:Int=3, currLevel:Int=1, parentPosId:Int=0*/sectionId:Int) ->[PositObj] {
        //let sql = "SELECT * FROM inspect_position_mstr WHERE prod_type_id = ? AND inspect_type_id = ? AND current_level = ? AND parent_position_id = ?"
        //let sql = "SELECT * FROM inspect_position_mstr ipm INNER JOIN inspect_task_tmpl_position ittp ON ipm.position_id = ittp.inspect_position_id INNER JOIN inspect_task_tmpl_mstr ittm ON ittp.tmpl_id = ittm.tmpl_id WHERE ittm.prod_type_id = ? AND ittm.inspect_type_id = ? AND ipm.current_level = ? AND ipm.parent_position_id = ?"
        let sql = "SELECT * FROM inspect_position_mstr ipm INNER JOIN inspect_position_element ipe ON ipm.position_id = ipe.inspect_position_id INNER JOIN inspect_section_element ise ON ipe.inspect_element_id = ise.inspect_element_id INNER JOIN inspect_element_mstr iem ON ise.inspect_element_id = iem.element_id WHERE ise.inspect_section_id = ? AND iem.element_type = 1"
        var defectPosits = [PositObj]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [/*prodTypeId, inspTypeId, currLevel, parentPosId*/sectionId]) {
                while rs.next() {
                    let positionId = Int(rs.intForColumn("position_id"))
                    let positionNameEn = rs.stringForColumn("position_name_en")
                    let positionNameCn = rs.stringForColumn("position_name_cn")
                    
                    let positObj = PositObj(positionId:positionId, positionNameEn:positionNameEn,positionNameCn:positionNameCn)
                    defectPosits.append(positObj)
                }
            }
            
            db.close()
        }
        
        return defectPosits
    }
    
    func getAllDefectPositPoints() ->[PositPointObj] {
        let sql = "SELECT * FROM inspect_position_mstr WHERE current_level = 2"
        var defectPositPoints = [PositPointObj]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: nil) {
                
                while rs.next() {
                    let positionId = Int(rs.intForColumn("position_id"))
                    let parentId = Int(rs.intForColumn("parent_position_id"))
                    let positionNameEn = rs.stringForColumn("position_name_en")
                    let positionNameCn = rs.stringForColumn("position_name_cn")
                    
                    let positPointObj = PositPointObj(positionId:positionId, parentId: parentId, positionNameEn:positionNameEn,positionNameCn:positionNameCn)
                    defectPositPoints.append(positPointObj)
                }
            }
            
            db.close()
        }
        
        return defectPositPoints
    }
    
    func getDefectPositPoints(parentPositId:Int=0) ->[PositObj] {
        let sql = "SELECT * FROM inspect_position_mstr WHERE parent_position_id = ?"
        var defectPositPoints = [PositObj]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [parentPositId]) {
            
                while rs.next() {
                    let positionId = Int(rs.intForColumn("position_id"))
                    let positionNameEn = rs.stringForColumn("position_name_en")
                    let positionNameCn = rs.stringForColumn("position_name_cn")
                    
                    let positObj = PositObj(positionId:positionId, positionNameEn:positionNameEn,positionNameCn:positionNameCn)
                    defectPositPoints.append(positObj)
                }
            }
            
            db.close()
        }
        
        return defectPositPoints
    }
    
    func updateDefectPositionPoints(recordId:Int, defectPositionPoints:[TaskInspPosinPoint]) ->[TaskInspPosinPoint] {
        let sql = "INSERT OR REPLACE INTO task_inspect_position_point  ('rowid','inspect_record_id','inspect_position_id','create_user','create_date','modify_user','modify_date') VALUES ((SELECT rowid FROM task_inspect_position_point WHERE inspect_record_id = ? AND inspect_position_id = ?),?,?,?,?,?,?)"
        var oldDfPositPoints = getDefectPositionPointsObjByRecordId(recordId)
        
        if db.open() {
            db.beginTransaction()
            
            //Update...
            for defectPositionPoint in defectPositionPoints {
                oldDfPositPoints = oldDfPositPoints.filter({$0.inspPosinId != defectPositionPoint.inspPosinId})
                
                if defectPositionPoint.inspRecordId>0 && defectPositionPoint.inspPosinId>0 {
                    
                    if db.executeUpdate(sql, withArgumentsInArray: [defectPositionPoint.inspRecordId,defectPositionPoint.inspPosinId,defectPositionPoint.inspRecordId,defectPositionPoint.inspPosinId,defectPositionPoint.createUser,defectPositionPoint.createDate,defectPositionPoint.modifyUser,defectPositionPoint.modifyDate]) {
                
                        
                    }else{
                        print("Rollback When Updating PP")
                        db.rollback()
                        db.close()
                
                        return defectPositionPoints
                    }
                }
            }
            
            //Remove...
            for oldDfPositPoint in oldDfPositPoints {
                if !deleteDefectPositionPointById(oldDfPositPoint.inspRecordId,inspPositId: oldDfPositPoint.inspPosinId) {
                    print("Rollback When Removing Old PP")
                    db.rollback()
                    db.close()
                    return defectPositionPoints
                }
            }
            
            db.commit()
            db.close()
        }
        
        return defectPositionPoints
    }
    
    func getDefectPositionPointsObjByRecordId(recordId:Int) ->[TaskInspPosinPoint] {
        let sql = "SELECT * FROM task_inspect_position_point WHERE inspect_record_id=?"
        var defectPositPoints = [TaskInspPosinPoint]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [recordId]) {
                while rs.next() {
                    let inspRecordId = Int(rs.intForColumn("inspect_record_id"))
                    let inspPosinId = Int(rs.intForColumn("inspect_position_id"))
                    let createUser = rs.stringForColumn("create_user")
                    let createDate = rs.stringForColumn("create_date")
                    let modifyUser = rs.stringForColumn("modify_user")
                    let modifyDate = rs.stringForColumn("modify_date")
                    
                    let defectPositPoint = TaskInspPosinPoint.init(inspRecordId: inspRecordId, inspPosinId: inspPosinId, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate)
                    
                    defectPositPoints.append(defectPositPoint!)
                }
            }
            
            db.close()
        }
        
        return defectPositPoints
    }
    
    func getDefectPositionPointsByRecordId(recordId:Int) ->String {
        let sql = "SELECT ipm.position_name_en,ipm.position_name_cn FROM task_inspect_position_point AS tipp INNER JOIN inspect_position_mstr AS ipm ON tipp.inspect_position_id = ipm.position_id WHERE tipp.inspect_record_id=?"
        var defectPositPoints = ""
        
        if db.open() {
        
            if let rs = db.executeQuery(sql, withArgumentsInArray: [recordId]) {
                while rs.next() {
                    defectPositPoints += (_ENGLISH ? rs.stringForColumn("position_name_en") : rs.stringForColumn("position_name_cn")) + ", "
                }
                
                if defectPositPoints != "" {
                    defectPositPoints += "!@#"
                    defectPositPoints = defectPositPoints.stringByReplacingOccurrencesOfString(", !@#", withString: "")
                }
            }
            
            db.close()
        }
        
        return defectPositPoints
    }
    
    func getDefectPositionPointsByDFRecordId(recordId:Int) ->String {
        let sql = "SELECT ipm.position_name_en,ipm.position_name_cn FROM task_inspect_position_point AS tipp INNER JOIN inspect_position_mstr AS ipm ON tipp.inspect_position_id = ipm.position_id WHERE tipp.inspect_record_id=?"
        var defectPositPoints = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [recordId]) {
                while rs.next() {
                    defectPositPoints += (_ENGLISH ? rs.stringForColumn("position_name_en") : rs.stringForColumn("position_name_cn")) + ", "
                }
                
                if defectPositPoints != "" {
                    defectPositPoints += "!@#"
                    defectPositPoints = defectPositPoints.stringByReplacingOccurrencesOfString(", !@#", withString: "")
                }
            }
            
            db.close()
        }
        
        return defectPositPoints
    }
    
    
    func deleteDefectPositionPointById(inspRecordId:Int, inspPositId:Int) ->Bool {
        let sql = "DELETE FROM task_inspect_position_point WHERE inspect_record_id=? AND inspect_position_id=?"
    
        if !db.executeUpdate(sql, withArgumentsInArray: [inspRecordId, inspPositId]) {
            return false
        }
        
        return true
    }
    
    func getElementIdBySectionIdForINPUT02(sectionId:Int) ->Int {
        let sql = "SELECT iem.element_id FROM inspect_element_mstr iem INNER JOIN inspect_section_element ise ON iem.element_id = ise.inspect_element_id WHERE ise.inspect_section_id = ? AND iem.element_type = 1"
        var result = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [sectionId]) {
                if rs.next() {
                    result = Int(rs.intForColumn("element_id"))
                }
            }
            
            db.close()
        }
        
        return result
    }
    
    func getInspElementIdByInspRecordIdForINPUT02(recordId:Int) ->Int {
        let sql = "SELECT tidr.inspect_element_id FROM task_inspect_data_record tidr INNER JOIN task_defect_data_record tddr ON tidr.record_id = tddr.inspect_record_id WHERE tddr.record_id = ?"
        var result = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [recordId]) {
                if rs.next() {
                    result = Int(rs.intForColumn("inspect_element_id"))
                }
            }
            
            db.close()
        }
        
        return result
    }
    
    func getPositionItemByElementId(elementId:Int) ->String {
        let sql = "SELECT * FROM inspect_position_mstr ipm INNER JOIN inspect_position_element ipe ON ipm.position_id = ipe.inspect_position_id INNER JOIN inspect_element_mstr iem ON ipe.inspect_element_id = iem.element_id WHERE iem.element_id = ? AND ipm.position_type = 3"
        var positionString = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [elementId]) {
                if rs.next() {
                    positionString = (_ENGLISH ? rs.stringForColumn("position_name_en") : rs.stringForColumn("position_name_cn"))
                }
            }
            
            db.close()
        }
        
        return positionString
    }
    
    func getPositionIdByElementId(elementId:Int) ->Int {
        let sql = "SELECT * FROM inspect_position_mstr ipm INNER JOIN inspect_position_element ipe ON ipm.position_id = ipe.inspect_position_id INNER JOIN inspect_element_mstr iem ON ipe.inspect_element_id = iem.element_id WHERE iem.element_id = ? AND ipm.position_type = 3"
        var positionId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [elementId]) {
                if rs.next() {
                    positionId = Int(rs.intForColumn("position_id"))
                }
            }
            
            db.close()
        }
        
        return positionId
    }
 
    func getQCInfoByRefTaskId(id:Int) ->InspectTaskQCInfo? {
        
        let sql = "SELECT * FROM inspect_task_qc_info WHERE ref_task_id = ?"
        var qcInfo:InspectTaskQCInfo? = nil
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [id]) {
                if rs.next() {
                    
                    let refTaskId = Int(rs.stringForColumn("ref_task_id"))
                    let aqlQty = Int(rs.stringForColumn("aql_qty"))
                    let productClass = rs.stringForColumn("product_class")
                    let qualityStandard = rs.stringForColumn("quality_standard")
                    let adjustTime = rs.stringForColumn("adjust_time")
                    let preinspectDetail = rs.stringForColumn("preinspect_detail")
                    let caForm = rs.stringForColumn("ca_form")
                    let casebackMarking = rs.stringForColumn("caseback_marking")
                    let upcOrbidStatus = rs.stringForColumn("upc_orbid_status")
                    let tsReportNo = rs.stringForColumn("ts_report_no")
                    let tsSubmitDate = rs.stringForColumn("ts_submit_date")
                    let tsResult = rs.stringForColumn("ts_result")
                    let qcBookingRefNo = rs.stringForColumn("qc_booking_ref_no")
                    let ssCommentReady = rs.stringForColumn("pre_inspect_remark") == "" ? rs.stringForColumn("ss_comment_ready") : rs.stringForColumn("pre_inspect_remark")
                    let ssReady = rs.stringForColumn("ss_ready")
                    let ssPhotoName = rs.stringForColumn("ss_photo_name")
                    let batteryProductionCode = rs.stringForColumn("battery_production_code")
                    let withQuesitonPending = rs.stringForColumn("with_quesiton_pending")
                    let withSamePoRejectedBef = rs.stringForColumn("wth_same_po_rejected_bef")
                    let assortment = rs.stringForColumn("assortment")
                    let consignedStyles = rs.stringForColumn("consigned_styles")
                    let qcInspectType = rs.stringForColumn("qc_inspect_type")
                    let netWeight = rs.stringForColumn("net_weight")
                    let inspectMethod = rs.stringForColumn("inspect_method")
                    let lengthRequirement = rs.stringForColumn("length_requirement")
                    let inspectionSampleReady = rs.stringForColumn("inspection_sample_ready")
                    let ftyPackingInfo = rs.stringForColumn("fty_packing_info")
                    let ftyDroptestInfo = rs.stringForColumn("fty_droptest_info")
                    let movtOrigin = rs.stringForColumn("movt_origin")
                    let batteryType = rs.stringForColumn("battery_type")
                    let preInspectResult = rs.stringForColumn("pre_inspect_result")
                    let preInspectRemark = rs.stringForColumn("pre_inspect_remark")
                    let reliabilityRemark = rs.stringForColumn("reliability_remark")
                    let jwlMarking = rs.stringForColumn("jwl_marking")
                    let combineQcRemarks = rs.stringForColumn("combine_qc_remarks")
                    let linksRemarks = rs.stringForColumn("links_remarks")
                    let dusttestRemark = rs.stringForColumn("dusttest_remark")
                    let smartlinkRemark = rs.stringForColumn("smartlink_remark")
                    let preciseReport = rs.stringForColumn("precise_report")
                    let smartlinkReport = rs.stringForColumn("smartlink_report")
                    let createUser = rs.stringForColumn("create_user")
                    let createDate = rs.stringForColumn("create_date")
                    let modifyUser = rs.stringForColumn("modify_user")
                    let modifyDate = rs.stringForColumn("modify_date")
                    let inspectorNames = rs.stringForColumn("inspector_names")
                    
                    qcInfo = InspectTaskQCInfo(refTaskId: refTaskId, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate)
                    qcInfo?.aqlQty = aqlQty
                    qcInfo?.productClass = productClass
                    qcInfo?.qualityStandard = qualityStandard
                    qcInfo?.adjustTime = adjustTime
                    qcInfo?.preinspectDetail = preinspectDetail
                    qcInfo?.caForm = caForm
                    qcInfo?.casebackMarking = casebackMarking
                    qcInfo?.upcOrbidStatus = upcOrbidStatus
                    qcInfo?.tsReportNo = tsReportNo
                    qcInfo?.tsSubmitDate = tsSubmitDate
                    qcInfo?.tsResult = tsResult
                    qcInfo?.qcBookingRefNo = qcBookingRefNo
                    qcInfo?.ssCommentReady = ssCommentReady
                    qcInfo?.ssReady = ssReady
                    qcInfo?.ssPhotoName = ssPhotoName
                    qcInfo?.batteryProductionCode = batteryProductionCode
                    qcInfo?.withQuesitonPending = withQuesitonPending
                    qcInfo?.withSamePoRejectedBef = withSamePoRejectedBef
                    qcInfo?.assortment = assortment
                    qcInfo?.consignedStyles = consignedStyles
                    qcInfo?.qcInspectType = qcInspectType
                    qcInfo?.netWeight = netWeight
                    qcInfo?.inspectMethod = inspectMethod
                    qcInfo?.lengthRequirement = lengthRequirement
                    qcInfo?.inspectionSampleReady = inspectionSampleReady
                    qcInfo?.ftyPackingInfo = ftyPackingInfo
                    qcInfo?.ftyDroptestInfo = ftyDroptestInfo
                    qcInfo?.movtOrigin = movtOrigin
                    qcInfo?.batteryType = batteryType
                    qcInfo?.preInspectResult = preInspectResult
                    qcInfo?.preInspectRemark = preInspectRemark
                    qcInfo?.reliabilityRemark = reliabilityRemark
                    qcInfo?.jwlMarking = jwlMarking
                    qcInfo?.combineQcRemarks = combineQcRemarks
                    qcInfo?.linksRemarks = linksRemarks
                    qcInfo?.dusttestRemark = dusttestRemark
                    qcInfo?.smartlinkRemark = smartlinkRemark
                    qcInfo?.preciseReport = preciseReport
                    qcInfo?.smartlinkReport = smartlinkReport
                    qcInfo?.inspectorNames = inspectorNames
                    
                    /*
                     qcInfo = InspectTaskQCInfo(refTaskId: refTaskId, aqlQty: aqlQty, productClass: productClass, qualityStandard: qualityStandard, adjustTime: adjustTime, preinspectDetail: preinspectDetail, caForm: caForm, casebackMarking: casebackMarking, upcOrbidStatus: upcOrbidStatus, tsReportNo: tsReportNo, tsSubmitDate: tsSubmitDate, tsResult: tsResult, qcBookingRefNo: qcBookingRefNo, ssCommentReady: ssCommentReady, ssReady: ssReady, ssPhotoName: ssPhotoName, batteryProductionCode: batteryProductionCode, withQuesitonPending: withQuesitonPending, withSamePoRejectedBef: withSamePoRejectedBef, assortment: assortment, consignedStyles: consignedStyles, qcInspectType: qcInspectType, netWeight: netWeight, inspectMethod: inspectMethod, lengthRequirement: lengthRequirement, inspectionSampleReady: inspectionSampleReady, ftyPackingInfo: ftyPackingInfo, ftyDroptestInfo: ftyDroptestInfo, movtOrigin: movtOrigin, batteryType: batteryType, preInspectResult: preInspectResult, preInspectRemark: preInspectRemark, reliabilityRemark: reliabilityRemark, jwlMarking: jwlMarking, combineQcRemarks: combineQcRemarks, linksRemarks: linksRemarks, dusttestRemark: dusttestRemark, smartlinkRemark: smartlinkRemark, preciseReport: preciseReport, smartlinkReport: smartlinkReport, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate)
                     */
                    
                }
            }
            
            db.close()
        }
        
        return qcInfo
    }
}