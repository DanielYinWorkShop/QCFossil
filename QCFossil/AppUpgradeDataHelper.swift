//
//  AppUpgradeDataHelper.swift
//  QCFossil
//
//  Created by pacmobile on 13/12/2016.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation
import UIKit

class AppUpgradeDataHelper:DataHelperMaster {

    func appUpgradeCode(parentView:UIView, completion:(result: Bool) -> ()) {
        
        dispatch_async(dispatch_get_main_queue(), {
            parentView.showActivityIndicator(MylocalizedString.sharedLocalizeManager.getLocalizedString("DB Updating"))
            
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue()) {
                var result = true
                var database = "\(_DBNAME_USING)_\((Cache_Inspector?.appUserName?.lowercaseString)!)"
                let filemgr = NSFileManager.defaultManager()
                let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                let dbDir = dirPaths[0] as String
                let databasePath = dbDir.stringByAppendingString("/\((Cache_Inspector?.appUserName?.lowercaseString)!)\(database)")
                let databasePathBakup = dbDir.stringByAppendingString("/\((Cache_Inspector?.appUserName?.lowercaseString)!)\(database)_bakup")
                
                //If Backup File Exist, Restore First...
                if filemgr.fileExistsAtPath(databasePathBakup) {
                    print("DB Backup File Found, Restore Now...")
                    
                    do {
                        try filemgr.removeItemAtPath(databasePath)
                        try filemgr.moveItemAtPath(databasePathBakup, toPath: databasePath)
                        try filemgr.removeItemAtPath(databasePathBakup)
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        completion(result: result)
                    }
                }
                
                
                //Backup DB Here...
                parentView.showActivityIndicator(MylocalizedString.sharedLocalizeManager.getLocalizedString("DB Backup"))
                
                if Cache_Inspector?.appUserName != "" {
                    database = _DBNAME_USING + "_" + (Cache_Inspector?.appUserName?.lowercaseString)!
                    _TASKSPHYSICALPATH = "\(_TASKSPHYSICALPATHPREFIX + (Cache_Inspector?.appUserName?.lowercaseString)! + "/\(_TASKSPHYSICALFOLDERNAME)")/"
                    
                }
                
                if filemgr.fileExistsAtPath(databasePath) {
                    
                    do {
                        try filemgr.copyItemAtPath(databasePath, toPath: databasePathBakup)
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
                //End Backup DB...
                
                parentView.showActivityIndicator(MylocalizedString.sharedLocalizeManager.getLocalizedString("Updating"))
                if self.db.open() {
                    
                    //---------------------------- Vdr Location Mstr ----------------------------
                    var sql = "ALTER TABLE vdr_location_mstr ADD COLUMN vdr_sign_name varchar(100) DEFAULT ''"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(vdr_location_mstr)", withArgumentsInArray: nil) {
                        var needUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "vdr_sign_name" {
                                needUpdate = true
                            }
                        }
                        
                        if !needUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    //---------------------------- Inspect Mstr ----------------------------
                    sql = "ALTER TABLE inspector_mstr ADD COLUMN chg_pwd_req_date varchar(30) DEFAULT ''"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspector_mstr)", withArgumentsInArray: nil) {
                        var needUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "chg_pwd_req_date" {
                                needUpdate = true
                            }
                        }
                        
                        if !needUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    //---------------------------- Fgpo Line Item ----------------------------
                    sql = "ALTER TABLE fgpo_line_item ADD COLUMN prod_desc text DEFAULT ''"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(fgpo_line_item)", withArgumentsInArray: nil) {
                        var needUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "prod_desc" {
                                needUpdate = true
                            }
                        }
                        
                        if !needUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    //-------------------------------- Task Inspect Photo File ----------------------------
                    sql = "ALTER TABLE task_inspect_photo_file ADD COLUMN upload_date datetime"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(task_inspect_photo_file)", withArgumentsInArray: nil) {
                        var needUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "upload_date" {
                                needUpdate = true
                            }
                        }
                        
                        if !needUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    sql = "UPDATE task_inspect_photo_file SET upload_date = datetime('now','localtime') WHERE task_id IN (SELECT task_id FROM inspect_task WHERE task_status = ? OR task_status = ?)"
                    
                    if !self.db.executeUpdate(sql, withArgumentsInArray: [GetTaskStatusId(caseId: "Confirmed").rawValue, GetTaskStatusId(caseId: "Uploaded").rawValue]) {
                        result = false
                    }
                    
                    //---------------------------- Inspect Task ----------------------------
                    sql = "ALTER TABLE inspect_task ADD COLUMN confirm_upload_date datetime"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task)", withArgumentsInArray: nil) {
                        var needUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "confirm_upload_date" {
                                needUpdate = true
                            }
                        }
                        
                        if !needUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    //---------------------------- Add Trigger ----------------------------
                    //sql = "DROP TRIGGER IF EXISTS t_task_inspect_photo_file_after_update;CREATE TRIGGER IF NOT EXISTS t_task_inspect_photo_file_after_update AFTER UPDATE ON task_inspect_photo_file FOR EACH ROW BEGIN UPDATE inspect_task SET task_status = 5 WHERE task_status = 4 AND confirm_upload_date IS NOT NULL AND task_id IN ( SELECT DISTINCT it.task_id FROM inspect_task it WHERE it.task_id = NEW.task_id AND NOT EXISTS ( SELECT 1 FROM task_inspect_photo_file tipf WHERE tipf.task_id = it.task_id AND tipf.upload_date IS NULL OR tipf.upload_date = '') ); END;"
                    
                    sql = "DROP TRIGGER IF EXISTS t_task_inspect_photo_file_after_update;CREATE TRIGGER IF NOT EXISTS t_task_inspect_photo_file_after_update AFTER UPDATE ON task_inspect_photo_file FOR EACH ROW BEGIN UPDATE inspect_task SET task_status = 5 WHERE task_status = 4 AND (confirm_upload_date IS NOT NULL OR confirm_upload_date <> '') AND task_id IN ( SELECT DISTINCT it.task_id FROM inspect_task it WHERE it.task_id = NEW.task_id AND NOT EXISTS ( SELECT 1 FROM task_inspect_photo_file tipf WHERE tipf.task_id = it.task_id AND (tipf.upload_date IS NULL OR tipf.upload_date = '')));END;"
                    
                    if !self.db.executeStatements(sql) {
                        result = false
                    }
                    
                    self.db.close()
                }
                
                //If upgrade success, remove the backup DB file, else rollback from the backup DB file
                if result && filemgr.fileExistsAtPath(databasePathBakup) {
                    print("DB Upgrade Success, Remove Backup FIle Now...")
                    
                    do {
                        try filemgr.removeItemAtPath(databasePathBakup)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            parentView.removeActivityIndicator()
                            parentView.showActivityIndicator(MylocalizedString.sharedLocalizeManager.getLocalizedString("Success"))
                            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
                            dispatch_after(time, dispatch_get_main_queue()) {
                                parentView.removeActivityIndicator()
                                completion(result: result)
                            }
                        })
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        completion(result: result)
                    }
                }else if filemgr.fileExistsAtPath(databasePathBakup) {
                    print("DB Upgrade Fail, Rollback Now...")
                    
                    do {
                        try filemgr.removeItemAtPath(databasePath)
                        try filemgr.moveItemAtPath(databasePathBakup, toPath: databasePath)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            parentView.removeActivityIndicator()
                            parentView.showActivityIndicator(MylocalizedString.sharedLocalizeManager.getLocalizedString("Fail"))
                            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
                            dispatch_after(time, dispatch_get_main_queue()) {
                                parentView.removeActivityIndicator()
                                completion(result: result)
                            }
                        })
                        
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        completion(result: result)
                    }
                }else{
                    completion(result: false)
                }
                
                
            }
        })
    }
}
    