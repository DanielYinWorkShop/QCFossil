//
//  PhotoDataHelper.swift
//  QCFossil
//
//  Created by Yin Huang on 17/2/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation
import UIKit

class PhotoDataHelper:DataHelperMaster {
    
    func getPhotosByTaskId(taskId:Int, dataType:Int) ->[Photo]? {
        let sql = "SELECT * FROM task_inspect_photo_file WHERE task_id = ? AND data_type<?"
        var photos = [Photo]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId, dataType]) {
            
            while rs.next() {
                
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
                
                photos.append(photo!)
            }
            }
            
            db.close()
            
            for photo in photos {
                updateInspInfoToPhoto(photo)
            }
            
            return photos
        }
        
        return nil
    }
    
    func savePhoto(photo:Photo) ->Photo? {
        let sql = "INSERT OR REPLACE INTO task_inspect_photo_file  ('photo_id','task_id','ref_photo_id','org_filename','photo_file','thumb_file','photo_desc','data_record_id','create_user','create_date','modify_user','modify_date','data_type') VALUES ((SELECT photo_id FROM task_inspect_photo_file WHERE photo_id = ?),?,?,?,?,?,?,?,?,?,?,?,?)"
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsInArray: [photo.photoId ?? 0,photo.taskId,photo.refPhotoId ?? 0,photo.photoFile,photo.photoFile,photo.thumbFile ?? "",photo.photoDesc ?? "",photo.dataRecordId ?? 0,photo.createUser ?? "",photo.createDate ?? "",photo.modifyUser ?? "",photo.modifyDate ?? "",photo.dataType ?? 0]){
                photo.photoId = Int(db.lastInsertRowId())
                
                db.close()
                
                updateInspInfoToPhoto(photo)
                
                return photo
            }
            
            db.close()
        }
        
        return nil
    }
    
    /*
    func updateInspInfoToPhoto(photo:Photo) {
        /*
        DataType:
        0: Task
        1: Inspect
        2: Defect
        */
        if photo.dataType < 1{
            return
        }
        
        let sql = "SELECT iem.element_name_en,iem.element_name_cn,ipm.position_name_en,ipm.position_name_cn,ism.section_name_en,ism.section_name_cn  FROM inspect_element_mstr AS iem INNER JOIN inspect_position_mstr AS ipm ON iem.inspect_position_id = ipm.position_id INNER JOIN inspect_section_mstr AS ism INNER JOIN task_inspect_data_record AS tidr ON iem.element_id=tidr.inspect_element_id AND ipm.position_id=tidr.inspect_position_id AND ism.section_id=tidr.inspect_section_id INNER JOIN task_inspect_photo_file AS tipf ON tidr.record_id = tipf.data_record_id WHERE tipf.data_record_id = ?"
        
        if db.open() {
        
            if let rs = db.executeQuery(sql, withArgumentsInArray: [photo.dataRecordId!]) {
                if rs.next() {
                    photo.inspAreaName = _ENGLISH ? rs.stringForColumn("position_name_en") : rs.stringForColumn("position_name_cn")
                    photo.inspCatName = _ENGLISH ? rs.stringForColumn("section_name_en") : rs.stringForColumn("section_name_cn")
                    photo.inspItemName = _ENGLISH ? rs.stringForColumn("element_name_en") : rs.stringForColumn("element_name_cn")
                }
            }
            
            db.close()
        }
    }*/
    
    func updateInspInfoToPhoto(photo:Photo) {
        /*
        DataType:
        0: Task
        1: Inspect
        2: Defect
        */
        if photo.dataType < 1{
            return
        }
        
        var sql = "SELECT ism.input_mode_code FROM task_inspect_photo_file AS tipf INNER JOIN task_inspect_data_record AS tidr ON tidr.record_id = tipf.data_record_id INNER JOIN inspect_section_mstr AS ism ON tidr.inspect_section_id = ism.section_id WHERE tipf.photo_id = ?"
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [photo.photoId!]) {
                if rs.next() {
                    let inputMode = rs.stringForColumn("input_mode_code")
                    var inspAreaText = ""
                    var inspCatText = ""
                    var inspItemText = ""
                    
                    switch inputMode {
                        case _INPUTMODE01:
                            sql = "SELECT ism.section_name_en,ism.section_name_cn,iem.element_name_en,iem.element_name_cn FROM task_inspect_photo_file AS tipf INNER JOIN task_inspect_data_record AS tidr ON tidr.record_id = tipf.data_record_id INNER JOIN inspect_section_mstr AS ism ON tidr.inspect_section_id = ism.section_id INNER JOIN inspect_element_mstr AS iem ON tidr.inspect_element_id = iem.element_id WHERE tipf.photo_id = ?"
                        
                            if let rs = db.executeQuery(sql, withArgumentsInArray: [photo.photoId!]) {
                                if rs.next() {
                                    inspItemText = _ENGLISH ? rs.stringForColumn("element_name_en") : rs.stringForColumn("element_name_cn")
                                    inspCatText = _ENGLISH ? rs.stringForColumn("section_name_en") : rs.stringForColumn("section_name_cn")
                                }
                            }
                        
                        case _INPUTMODE02:
                            sql = "SELECT ipm.position_name_en,ipm.position_name_cn,ism.section_name_en,ism.section_name_cn FROM task_inspect_photo_file AS tipf INNER JOIN task_inspect_data_record AS tidr ON tidr.record_id = tipf.data_record_id INNER JOIN inspect_position_mstr AS ipm ON tidr.inspect_position_id = ipm.position_id INNER JOIN inspect_section_mstr AS ism ON tidr.inspect_section_id = ism.section_id WHERE tipf.photo_id = ?"
                            
                            if let rs = db.executeQuery(sql, withArgumentsInArray: [photo.photoId!]) {
                                if rs.next() {
                                    inspAreaText = _ENGLISH ? rs.stringForColumn("position_name_en") : rs.stringForColumn("position_name_cn")
                                    inspCatText = _ENGLISH ? rs.stringForColumn("section_name_en") : rs.stringForColumn("section_name_cn")
                                }
                            }
                        
                            sql = "SELECT tidr.record_id FROM task_inspect_photo_file AS tipf INNER JOIN task_inspect_data_record AS tidr ON tipf.data_record_id = tidr.record_id WHERE tipf.photo_id = ?"
                        
                            if let rs = db.executeQuery(sql, withArgumentsInArray: [photo.photoId!]) {
                                if rs.next() {
                                    let recordId = Int(rs.intForColumn("record_id"))
                                    let dpDataHelper = DPDataHelper()
                                    inspItemText = dpDataHelper.getDefectPositionPointsByRecordId(recordId)
                                }
                            }
                        
                        case _INPUTMODE03:
                            sql = "SELECT ism.section_name_en,ism.section_name_cn,tidr.request_element_desc FROM task_inspect_photo_file AS tipf INNER JOIN task_inspect_data_record AS tidr ON tidr.record_id = tipf.data_record_id INNER JOIN inspect_section_mstr AS ism ON tidr.request_section_id = ism.section_id WHERE tipf.photo_id = ?"
                        
                            if let rs = db.executeQuery(sql, withArgumentsInArray: [photo.photoId!]) {
                                if rs.next() {
                                    inspItemText = rs.stringForColumn("request_element_desc")
                                    inspCatText = _ENGLISH ? rs.stringForColumn("section_name_en") : rs.stringForColumn("section_name_cn")
                                }
                            }
                        
                        case _INPUTMODE04:
                            sql = "SELECT iem.element_name_en,iem.element_name_cn,ipm.position_name_en,ipm.position_name_cn,ism.section_name_en,ism.section_name_cn FROM task_inspect_photo_file tipf INNER JOIN task_inspect_data_record tidr ON tidr.record_id = tipf.data_record_id INNER JOIN inspect_element_mstr iem ON tidr.inspect_element_id = iem.element_id INNER JOIN inspect_position_mstr ipm ON tidr.inspect_position_id = ipm.position_id INNER JOIN inspect_section_mstr ism ON ism.section_id = tidr.inspect_section_id WHERE tipf.photo_id = ?"
                            
                            if let rs = db.executeQuery(sql, withArgumentsInArray: [photo.photoId!]) {
                                if rs.next() {
                                    inspAreaText = _ENGLISH ? rs.stringForColumn("position_name_en") : rs.stringForColumn("position_name_cn")
                                    inspCatText = _ENGLISH ? rs.stringForColumn("section_name_en") : rs.stringForColumn("section_name_cn")
                                    inspItemText = _ENGLISH ? rs.stringForColumn("element_name_en") : rs.stringForColumn("element_name_cn")
                                }
                            }
                        
                        default:break
                    }
                    
                    photo.inspAreaName = inspAreaText
                    photo.inspCatName = inspCatText
                    photo.inspItemName = inspItemText
                }
            }
            
            db.close()
        }
    }
    
    func existPhotoByInspItem(dataRecordId:Int, dataType:Int) ->Bool {
        let sql = "SELECT * FROM task_inspect_photo_file WHERE data_record_id = ? AND data_type = ?"
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [dataRecordId, dataType]) {
            
                if rs.next() {
                    db.close()
                    return true
                }
            }
            
            db.close()
        }
        
        return false
    }
    
    func updatePhotoDatasByPhotoName(photoName:String, dataType:Int, dataRecordId:Int) ->Photo? {
        let sql = "UPDATE task_inspect_photo_file SET data_record_id = ?, data_type = ? WHERE photo_file = ?"
        var photo:Photo?
        
        if db.open() {
            
            if !db.executeUpdate(sql, withArgumentsInArray: [dataRecordId,dataType,photoName]) {
                UIView.init().alertView("Update Photo Data Error")
                db.close()
                
                return photo
            }
            
            let sql = "SELECT * FROM task_inspect_photo_file WHERE photo_file = ?"
            if let rs = db.executeQuery(sql, withArgumentsInArray: [photoName]) {
                
                if rs.next() {
                    
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
                    
                    //Get Image
                    let pathForImage = Cache_Task_Path! + "/" + _THUMBSPHYSICALNAME + "/" + photoFile
                    let imageView = UIImageView.init(image: UIImage(contentsOfFile: pathForImage))
                    
                    photo = Photo(photo: imageView, photoFilename: photoFile, taskId: taskId, photoFile: photoFile)
                    
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
                    
                }
            }
            
            db.close()
        }
        
        return photo
    }

    
    func updatePhotoDatas(photoId:Int, dataType:Int, dataRecordId:Int) ->Photo? {
        let sql = "UPDATE task_inspect_photo_file SET data_record_id = ?, data_type = ? WHERE photo_id = ?"
        var photo:Photo?
        
        if db.open() {
            
            if !db.executeUpdate(sql, withArgumentsInArray: [dataRecordId,dataType,photoId]) {
                UIView.init().alertView("Update Photo Data Error")
                return photo
            }
            
            let sql = "SELECT * FROM task_inspect_photo_file WHERE photo_id = ?"
            if let rs = db.executeQuery(sql, withArgumentsInArray: [photoId]) {
            
            if rs.next() {
                
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
                
                photo = Photo(photo: nil, photoFilename: photoFile, taskId: taskId, photoFile: photoFile)
                
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
                
            }
            }
            
            db.close()
        }
        
        return photo
    }
    
    func getDefectPhotoNamesById(taskId:Int, dataRecordId:Int, taskPath:String) ->[String]? {
        let sql = "SELECT photo_file FROM task_inspect_photo_file WHERE task_id = ? AND data_record_id = ? AND data_type = 2"
        var photoNames = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId, dataRecordId]) {
                
                while rs.next() {
                
                    let photoFile = rs.stringForColumn("photo_file")
                
                    photoNames.append(photoFile!)
                }
            }
            
            db.close()
            
            return photoNames
        }
        
        return nil
    }
    
    func getDefectPhotosById(taskId:Int, dataRecordId:Int, taskPath:String) ->[Photo]? {
        let sql = "SELECT * FROM task_inspect_photo_file WHERE task_id = ? AND data_record_id = ? AND data_type = 2"
        var photos = [Photo]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId, dataRecordId]) {
            
            while rs.next() {
                
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
                
                //Get Image
                let path = taskPath+"/"+photoFile
                let image = UIImage(contentsOfFile: path)
                
                let photo = Photo(photo: UIImageView(image:image), photoFilename: photoFile, taskId: taskId, photoFile: photoFile)
                
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
                
                photos.append(photo!)
            }
            }
            
            db.close()
            
            return photos
        }
        
        return nil
    }
    
    func checkPhotoAddedByInspDataRecordId(dataRecordId:Int) ->Bool {
        let sql = "SELECT * FROM task_inspect_data_record AS tidr INNER JOIN task_defect_data_record AS tddr ON tidr.record_id = tddr.inspect_record_id INNER JOIN task_inspect_photo_file AS tipf ON tddr.record_id = tipf.data_record_id WHERE tidr.record_id = ? AND tipf.data_type = 2"
        
        if db.open(){
            
            //let rs = db.executeQuery(sql, withArgumentsInArray: [dataRecordId])
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [dataRecordId]) {
                
                if rs.next() {
                    db.close()
                    return true
                }
            }
        
            db.close()
        }
        
        return false
    }
    
    func deletePhotoByPhotoId(photoId:Int) ->Bool {
        let sql = "DELETE FROM task_inspect_photo_file WHERE photo_id = ?"
        
        if db.open(){
            
            if !db.executeUpdate(sql, withArgumentsInArray: [photoId]) {
                db.close()
                return false
            }
            
            db.close()
        }
        
        return true
    }
    
    func getPhotosByInspElmtId(inspElmtId:Int,dataType:Int=1) ->[Photo]? {
        let sql = "SELECT * FROM task_inspect_photo_file WHERE data_record_id = ? AND data_type = ?"
        var photos = [Photo]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [inspElmtId, dataType]) {
            
            while rs.next() {
                
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
                
                photos.append(photo!)
            }
            }
            
            db.close()
            
            return photos
        }
        
        return nil
    }
    
    func getPhotoIdByPhotoName(photoName:String) ->Int {
        let sql = "SELECT photo_id FROM task_inspect_photo_file WHERE photo_file = ?"
        var photoId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [photoName]) {
                if rs.next() {
                    photoId = Int(rs.intForColumn("photo_id"))
                }
            }
            
            db.close()
        }
        
        return photoId
    }
    
    func getStylePhotoByStyleNo(taskId:Int) ->StylePhoto {
        
        let sql = "SELECT sp.ss_photo_name, sp.cb_photo_name FROM style_photo sp INNER JOIN fgpo_line_item fli ON sp.style_no = fli.style_no INNER JOIN inspect_task_item iti ON fli.item_id = iti.po_item_id WHERE iti.task_id = ?"
        var stylePhotos = StylePhoto(ssPhotoName: "", cbPhotoName: "")
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [taskId]) {
                if rs.next() {
                    stylePhotos = StylePhoto(ssPhotoName: rs.stringForColumn("ss_photo_name"), cbPhotoName: rs.stringForColumn("cb_photo_name"))
                }
            }
            
            db.close()
        }
        
        return stylePhotos
    }
    
    func selectStylePhotosToRemove() ->[String] {
        
        let sql = "SELECT ss_photo_name, cb_photo_name FROM style_photo WHERE deleted_flag = 1"
        var paths = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: nil) {
                while rs.next() {
                    
                    let path = Cache_Inspector?.typeCode == TypeCode.WATCH.rawValue ? _WATCHSSPHOTOSPHYSICALPATH : _JEWELRYSSPHOTOSPHYSICALPATH
                    paths.append(path + rs.stringForColumn("ss_photo_name"))
                    paths.append(_CASEBACKPHOTOSPHYSICALPATH + rs.stringForColumn("cb_photo_name"))
                }
            }
            
            db.close()
        }
        
        return paths
    }
    
    func removeStylePhotosMarkDeleted() ->Bool {
        
        let sql = "DELETE FROM style_photo WHERE deleted_flag = 1"
        
        if db.open() {
            
            if !db.executeUpdate(sql, withArgumentsInArray: nil) {
                db.close()
                
                return false
            }
            
            db.close()
        }
        
        return true
    }
}