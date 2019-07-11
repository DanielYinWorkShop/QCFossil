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
                    self.db.beginTransaction()
                    
                    //---------------------------- Vdr Location Mstr ----------------------------
                    var sql = "ALTER TABLE vdr_location_mstr ADD COLUMN vdr_sign_name varchar(100) DEFAULT ''"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(vdr_location_mstr)", withArgumentsInArray: nil) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "vdr_sign_name" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    //---------------------------- Inspect Mstr ----------------------------
                    sql = "ALTER TABLE inspector_mstr ADD COLUMN chg_pwd_req_date varchar(30) DEFAULT ''"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspector_mstr)", withArgumentsInArray: nil) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "chg_pwd_req_date" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    //---------------------------- Fgpo Line Item ----------------------------
                    sql = "ALTER TABLE fgpo_line_item ADD COLUMN prod_desc text DEFAULT ''"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(fgpo_line_item)", withArgumentsInArray: nil) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "prod_desc" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    //-------------------------------- Task Inspect Photo File ----------------------------
                    sql = "ALTER TABLE task_inspect_photo_file ADD COLUMN upload_date datetime"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(task_inspect_photo_file)", withArgumentsInArray: nil) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "upload_date" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
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
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "confirm_upload_date" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    //---------------------------- Add Trigger ----------------------------
                    sql = "DROP TRIGGER IF EXISTS t_task_inspect_photo_file_after_update;CREATE TRIGGER IF NOT EXISTS t_task_inspect_photo_file_after_update AFTER UPDATE ON task_inspect_photo_file FOR EACH ROW BEGIN UPDATE inspect_task SET task_status = 5 WHERE task_status = 4 AND (confirm_upload_date IS NOT NULL OR confirm_upload_date <> '') AND task_id IN ( SELECT DISTINCT it.task_id FROM inspect_task it WHERE it.task_id = NEW.task_id AND NOT EXISTS ( SELECT 1 FROM task_inspect_photo_file tipf WHERE tipf.task_id = it.task_id AND (tipf.upload_date IS NULL OR tipf.upload_date = '')));END;"
                    
                    if !self.db.executeStatements(sql) {
                        result = false
                    }
                    
                    //---------------------------- Inspect Position Mstr for 1.09 ----------------------------
                    sql = "ALTER TABLE inspect_position_mstr ADD COLUMN position_zone_set_id VARCHAR(10)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_position_mstr)", withArgumentsInArray: nil) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "position_zone_set_id" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    sql = "ALTER TABLE inspect_element_mstr ADD COLUMN inspect_defect_set_id VARCHAR(10)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_element_mstr)", withArgumentsInArray: nil) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "inspect_defect_set_id" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    sql = "ALTER TABLE inspect_element_mstr ADD COLUMN inspect_case_set_id VARCHAR(10)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_element_mstr)", withArgumentsInArray: nil) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "inspect_case_set_id" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    sql = "ALTER TABLE inspect_element_mstr ADD COLUMN inspect_case_set_id VARCHAR(10)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_element_mstr)", withArgumentsInArray: nil) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "inspect_case_set_id" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    // Add table zone_value_mstr
                    sql = "CREATE TABLE IF NOT EXISTS `zone_value_mstr` ( `value_id` VARCHAR ( 10 ), `value_code` VARCHAR ( 30 ) NOT NULL, `value_name_en` VARCHAR ( 60 ) NOT NULL, `value_name_cn` VARCHAR ( 60 ) NOT NULL, `display_order` VARCHAR ( 10 ) NOT NULL, `rec_status` VARCHAR ( 2 ) NOT NULL, `create_date` DATETIME NOT NULL, `create_user` VARCHAR ( 30 ) NOT NULL, `modify_date` DATETIME NOT NULL, `modify_user` VARCHAR ( 30 ) NOT NULL, `deleted_flag` VARCHAR ( 1 ) NOT NULL, `delete_date` DATETIME, `delete_user` VARCHAR ( 30 ), PRIMARY KEY(`value_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                        result = false
                    }
                    
                    // Add table zone_set_mstr
                    sql = "CREATE TABLE IF NOT EXISTS `zone_set_mstr` ( `set_id` VARCHAR ( 10 ), `set_name` VARCHAR ( 60 ) NOT NULL, `rec_status` VARCHAR ( 2 ) NOT NULL, `create_date` DATETIME NOT NULL, `create_user` VARCHAR ( 30 ) NOT NULL, `modify_date` DATETIME NOT NULL, `modify_user` VARCHAR ( 30 ) NOT NULL, `deleted_flag` VARCHAR ( 1 ) NOT NULL, `delete_date` DATETIME, `delete_user` VARCHAR ( 30 ), PRIMARY KEY(`set_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                        result = false
                    }
                    
                    // Add table zone_set_mstr
                    sql = "CREATE TABLE IF NOT EXISTS `zone_set_value` ( `set_id` VARCHAR ( 10 ), `value_id` VARCHAR ( 10 ), `create_date` DATETIME NOT NULL, `create_user` VARCHAR ( 30 ) NOT NULL, `modify_date` DATETIME NOT NULL, `modify_user` VARCHAR ( 30 ) NOT NULL, PRIMARY KEY(`set_id`,`value_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                        result = false
                    }
                    
                    // Add table case_value_mstr
                    sql = "CREATE TABLE IF NOT EXISTS `case_value_mstr` ( `value_id` VARCHAR ( 10 ), `value_code` VARCHAR ( 10 ) NOT NULL, `value_name_en` VARCHAR ( 60 ) NOT NULL, `value_name_cn` VARCHAR ( 60 ) NOT NULL, `display_order` VARCHAR ( 10 ) NOT NULL, `rec_status` VARCHAR ( 2 ) NOT NULL, `create_date` DATETIME NOT NULL, `create_user` VARCHAR ( 30 ) NOT NULL, `modify_date` DATETIME NOT NULL, `modify_user` VARCHAR ( 30 ) NOT NULL, `deleted_flag` VARCHAR ( 1 ) NOT NULL, `delete_date` DATETIME, `delete_user` VARCHAR ( 30 ), PRIMARY KEY(`value_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                        result = false
                    }
                    
                    // Add table case_set_mstr
                    sql = "CREATE TABLE IF NOT EXISTS `case_set_mstr` ( `set_id` VARCHAR ( 10 ), `set_name` VARCHAR ( 60 ) NOT NULL, `rec_status` VARCHAR ( 2 ) NOT NULL, `create_date` DATETIME NOT NULL, `create_user` VARCHAR ( 30 ) NOT NULL, `modify_date` DATETIME NOT NULL, `modify_user` VARCHAR ( 30 ) NOT NULL, `deleted_flag` VARCHAR ( 1 ) NOT NULL, `delete_date` DATETIME, `delete_user` VARCHAR ( 30 ), PRIMARY KEY(`set_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                        result = false
                    }
                    
                    // Add table case_set_value
                    sql = "CREATE TABLE IF NOT EXISTS `case_set_value` ( `set_id` VARCHAR(10), `value_id` VARCHAR(10), `create_date` DATETIME NOT NULL, `create_user` VARCHAR(30) NOT NULL, `modify_date` DATETIME NOT NULL, `modify_user` VARCHAR(30) NOT NULL )"
                    if !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                        result = false
                    }
                    
                    // Add table defect_value_mstr
                    sql = "CREATE TABLE IF NOT EXISTS `defect_value_mstr` ( `value_id` VARCHAR(10), `value_code` VARCHAR(10) NOT NULL, `value_name_en` VARCHAR(60) NOT NULL, `value_name_cn` VARCHAR(60) NOT NULL, `display_order` VARCHAR(10) NOT NULL, `rec_status` VARCHAR(2) NOT NULL, `create_date` DATETIME NOT NULL, `create_user` VARCHAR(30) NOT NULL, `modify_date` DATETIME NOT NULL, `modify_user` VARCHAR(30) NOT NULL, `deleted_flag` VARCHAR(1) NOT NULL, `delete_date` DATETIME, `delete_user` VARCHAR(30), PRIMARY KEY(`value_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                        result = false
                    }
                    
                    // Add table defect_set_mstr
                    sql = "CREATE TABLE IF NOT EXISTS `defect_set_mstr` ( `set_id` VARCHAR(30), `set_name` VARCHAR(60) NOT NULL, `rec_status` VARCHAR(2) NOT NULL, `create_date` DATETIME NOT NULL, `create_user` VARCHAR(30) NOT NULL, `modify_date` DATETIME NOT NULL, `modify_user` VARCHAR(30) NOT NULL, `deleted_flag` VARCHAR(1) NOT NULL, `delete_date` DATETIME, `delete_user` VARCHAR(30), PRIMARY KEY(`set_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                        result = false
                    }
                    
                    // Add table defect_set_value
                    sql = "CREATE TABLE IF NOT EXISTS `defect_set_value` ( `set_id` VARCHAR(10), `value_id` VARCHAR(10), `create_date` DATETIME NOT NULL, `create_user` VARCHAR(30) NOT NULL, `modify_date` DATETIME NOT NULL, `modify_user` VARCHAR(30) NOT NULL, PRIMARY KEY(`value_id`,`set_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                        result = false
                    }
                
                    // Add table task_selection_option_mstr
                    sql = "CREATE TABLE IF NOT EXISTS `task_selection_option_mstr` ( `option_id` NUMERIC(10,0) NOT NULL, `data_env` VARCHAR(30) NOT NULL, `selection_type` NUMERIC(2,0) NOT NULL, `result_code_match_list` VARCHAR(1000), `option_val` VARCHAR(100) NOT NULL, `option_text_en` VARCHAR(1000) NOT NULL, `option_text_zh` VARCHAR(1000) NOT NULL, `display_order` NUMERIC(10,0) NOT NULL, `rec_status` NUMERIC(2,0) NOT NULL, `create_user` VARCHAR(30) NOT NULL, `create_date` DATETIME NOT NULL, `modify_user` VARCHAR(30) NOT NULL, `modify_date` DATETIME NOT NULL, `deleted_flag` NUMERIC(1,0) NOT NULL, `delete_user` VARCHAR(30), `delete_date` DATETIME, PRIMARY KEY(`option_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                        result = false
                    }
                    
                    // Add table inspect_task_qc_info
                    sql = "CREATE TABLE IF NOT EXISTS `inspect_task_qc_info` ( `task_id` numeric(10,0) NOT NULL, `aql_qty` numeric(10,0), `product_class` varchar(50), `quality_standard` varchar(50), `adjust_time` varchar(50), `preinspect_detail` TEXT, `ca_form` varchar(50), `caseback_marking` varchar(50), `upc_orbid_status` varchar(50), `ts_report_no` varchar(50), `ts_submit_date` DATETIME, `ts_result` nvarchar(50), `qc_booking_ref_no` varchar(50), `ss_comment_ready`varchar(50), `ss_ready` varchar(50), `ss_photo_name` varchar(50), `battery_production_code` varchar(50), `with_quesiton_pending` varchar(50), `wth_same_po_rejected_bef` varchar(50), `assortment` varchar(50), `consigned_styles` varchar(50), `qc_inspect_type` varchar(50), `net_weight` varchar(50), `inspect_method` varchar(50), `length_requirement` varchar(50), `inspection_sample_ready` varchar(50), `fty_packing_info` varchar(50), `fty_droptest_info` varchar(50), `movt_origin` varchar(100), `battery_type` varchar(50), `pre_inspect_result` nvarchar(50), `pre_inspect_remark` TEXT, `reliability_remark` TEXT, `jwl_marking` varchar(50), `combine_qc_remarks` varchar(150), `links_remarks` nvarchar(50), `dusttest_remark` nvarchar(50), `smartlink_remark` nvarchar(50), `precise_report` nvarchar(50), `smartlink_report` nvarchar(50), `create_user` varchar(30) NOT NULL, `create_date` DATETIME NOT NULL, `modify_user` varchar(30) NOT NULL, `modify_date` DATETIME NOT NULL, PRIMARY KEY(`task_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                        result = false
                    }
                    
                    // Add table style_photo
                    sql = "CREATE TABLE IF NOT EXISTS `style_photo` ( `photo_id` numeric(10,0) NOT NULL, `data_env` varchar(30) NOT NULL, `style_no` varchar(30) NOT NULL, `ss_photo_name` varchar(50) NOT NULL, `create_date` datetime NOT NULL, `modify_date` datetime NOT NULL, `deleted_flag` numeric(1,0) NOT NULL, `delete_date` datetime, PRIMARY KEY(`photo_id`) )"
                    if !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                        result = false
                    }
                    
                    // Add new field to task_inspect_data_record
                    sql = "ALTER TABLE task_inspect_data_record ADD COLUMN inspect_position_zone_value_id VARCHAR(10)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(task_inspect_data_record)", withArgumentsInArray: nil) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "inspect_position_zone_value_id" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    // Add new field to task_defect_data_record
                    sql = "ALTER TABLE task_defect_data_record ADD COLUMN inspect_element_defect_value_id VARCHAR(10)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(task_defect_data_record)", withArgumentsInArray: nil) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "inspect_element_defect_value_id" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    // Add new field to task_defect_data_record
                    sql = "ALTER TABLE task_defect_data_record ADD COLUMN inspect_element_case_value_id VARCHAR(10)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(task_defect_data_record)", withArgumentsInArray: nil) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "inspect_element_case_value_id" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    // Add new field to qc_remarks_option_list
                    sql = "ALTER TABLE inspect_task ADD COLUMN qc_remarks_option_list TEXT"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task)", withArgumentsInArray: nil) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "qc_remarks_option_list" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    // Add new field to additional_admin_item_option_list
                    sql = "ALTER TABLE inspect_task ADD COLUMN additional_admin_item_option_list TEXT"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(inspect_task)", withArgumentsInArray: nil) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "additional_admin_item_option_list" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    // Add new field to defect_remarks_option_list
                    sql = "ALTER TABLE task_defect_data_record ADD COLUMN defect_remarks_option_list TEXT"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(task_defect_data_record)", withArgumentsInArray: nil) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "defect_remarks_option_list" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    // Add new field to defect_remarks_option_list
                    sql = "ALTER TABLE task_defect_data_record ADD COLUMN other_remarks TEXT"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(task_defect_data_record)", withArgumentsInArray: nil) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "other_remarks" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    // Add new field to fgpo_line_item
                    sql = "ALTER TABLE fgpo_line_item ADD COLUMN market varchar(20)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(fgpo_line_item)", withArgumentsInArray: nil) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "market" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    // Add new field to fgpo_line_item
                    sql = "ALTER TABLE fgpo_line_item ADD COLUMN material_category varchar(20)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(fgpo_line_item)", withArgumentsInArray: nil) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "material_category" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }
                    
                    // Add new field to fgpo_line_item
                    sql = "ALTER TABLE fgpo_line_item ADD COLUMN ship_mode_name varchar(20)"
                    if let tableInfo = self.db.executeQuery("PRAGMA table_info(fgpo_line_item)", withArgumentsInArray: nil) {
                        var noNeedUpdate = false
                        while tableInfo.next() {
                            if tableInfo.stringForColumn("name") == "ship_mode_name" {
                                noNeedUpdate = true
                            }
                        }
                        
                        if !noNeedUpdate && !self.db.executeUpdate(sql, withArgumentsInArray: nil) {
                            result = false
                        }
                    }

                    //----------------------------------------------------------------------------------
                    
                    if result {
                        self.db.commit()
                    } else {
                        self.db.rollback()
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
    