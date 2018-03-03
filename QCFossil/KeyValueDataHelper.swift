//
//  KeyValueDataHelper.swift
//  QCFossil
//
//  Created by pacmobile on 26/10/2016.
//  Copyright © 2016 kira. All rights reserved.
//


import Foundation
import UIKit

class KeyValueDataHelper:DataHelperMaster {
    
    func updateLastLoginDatetime(userId:String, datetime:String) ->Bool {
        let sql = "INSERT OR REPLACE INTO option_key_value(key,value,date_added) VALUES(?,?,datetime('now','localtime'))"
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsInArray: ["LastLoginDatetime-"+userId, datetime]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func getLastLoginDatetimeByUserId(userId:String) ->String {
        let sql = "SELECT value FROM option_key_value WHERE key = ?"
        var datetime = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: ["LastLoginDatetime-"+userId]) {
                if rs.next() {
                    datetime = rs.stringForColumn("value")
                }
            }
            
            db.close()
        }
        
        return datetime
    }
    
    func updateLastDownloadDatetime(userId:String, datetime:String) ->Bool {
        let sql = "INSERT OR REPLACE INTO option_key_value(key,value,date_added) VALUES(?, ? ,datetime('now','localtime'))"
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsInArray: ["LastDownloadDatetime-"+userId, datetime]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func getLastDownloadDatetimeByUserId(userId:String) ->String {
        let sql = "SELECT value FROM option_key_value WHERE key = ?"
        var datetime = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: ["LastDownloadDatetime-"+userId]) {
                if rs.next() {
                    datetime = rs.stringForColumn("value")
                }
            }
            
            db.close()
        }
        
        return datetime
    }
    
    func updateLastUploadDatetime(userId:String, datetime:String) ->Bool {
        let sql = "INSERT OR REPLACE INTO option_key_value(key,value,date_added) VALUES(?, ? ,datetime('now','localtime'))"
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsInArray: ["LastUploadDatetime-"+userId, datetime]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func getLastUploadDatetimeByUserId(userId:String) ->String {
        let sql = "SELECT value FROM option_key_value WHERE key = ?"
        var datetime = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: ["LastUploadDatetime-"+userId]) {
                if rs.next() {
                    datetime = rs.stringForColumn("value")
                }
            }
            
            db.close()
        }
        
        return datetime
    }
    
    func updateLastBackupDatetime(userId:String, datetime:String) ->Bool {
        let sql = "INSERT OR REPLACE INTO option_key_value(key,value,date_added) VALUES(?, ? ,datetime('now','localtime'))"
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsInArray: ["LastBackupDatetime-"+userId, datetime]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func getLastBackupDatetimeByUserId(userId:String) ->String {
        let sql = "SELECT value FROM option_key_value WHERE key = ?"
        var datetime = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: ["LastBackupDatetime-"+userId]) {
                if rs.next() {
                    datetime = rs.stringForColumn("value")
                }
            }
            
            db.close()
        }
        
        return datetime
    }
    
    func updateLastRestoreDatetime(userId:String, datetime:String) ->Bool {
        let sql = "INSERT OR REPLACE INTO option_key_value(key,value,date_added) VALUES(?, ? ,datetime('now','localtime'))"
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsInArray: ["LastRestoreDatetime-"+userId, datetime]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func getLastRestoreDatetimeByUserId(userId:String) ->String {
        let sql = "SELECT value FROM option_key_value WHERE key = ?"
        var datetime = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: ["LastRestoreDatetime-"+userId]) {
                if rs.next() {
                    datetime = rs.stringForColumn("value")
                }
            }
            
            db.close()
        }
        
        return datetime
    }
    
    func updateLastUploadTasksCount(userId:String, tasksCount:Int) ->Bool {
        let sql = "INSERT OR REPLACE INTO option_key_value(key,value,date_added) VALUES(?, ? ,datetime('now','localtime'))"
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsInArray: ["LastUploadTasksCount-"+userId, tasksCount]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func getLastUploadTasksCountByUserId(userId:String) ->String {
        let sql = "SELECT value FROM option_key_value WHERE key = ?"
        var datetime = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: ["LastUploadTasksCount-"+userId]) {
                if rs.next() {
                    datetime = rs.stringForColumn("value")
                }
            }
            
            db.close()
        }
        
        return datetime
    }
    
    func saveInspectorSignImage(userId:String, imageToBase64:String) ->Bool {
        let sql = "INSERT OR REPLACE INTO option_key_value(key,value,date_added) VALUES(?, ?, datetime('now','localtime'))"
        
        if db.open() {
            
            if !db.executeUpdate(sql, withArgumentsInArray: ["InspectorSignImage-"+userId, imageToBase64]) {
                db.close()
                return false
            }
            
            db.close()
        }
        
        return true
    }
    
    func getInspectorSignImage(userId:String) ->String {
        let sql = "SELECT value FROM option_key_value WHERE key = ?"
        var inspectorSignImage = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: ["InspectorSignImage-"+userId]) {
                if rs.next() {
                    inspectorSignImage = rs.stringForColumn("value")
                }
            }
            
            db.close()
        }
        
        return inspectorSignImage
    }
    
    func getTaskRunningNoByDate(userId:String) ->String {
        var sql = "SELECT * FROM option_key_value WHERE key = ? AND date_added >= date('now','0 day')"
        var runningNo = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: ["TaskRunningNo-"+userId]) {
                if rs.next() {
                    runningNo = Int(rs.stringForColumn("value"))! + 1
                    
                    //sql = "UPDATE option_key_value SET value = ?, date_added = datetime('now','localtime') WHERE key = ?"
                    sql = "INSERT OR REPLACE INTO option_key_value(key,value,date_added) VALUES(?, ?, datetime('now','localtime'))"
                    
                    if db.executeUpdate(sql, withArgumentsInArray: ["TaskRunningNo-"+userId, runningNo]) {
                        
                    }
                    
                }else{
                    
                    //sql = "UPDATE option_key_value SET value = 0, date_added = datetime('now','localtime') WHERE key = ?"
                    sql = "INSERT OR REPLACE INTO option_key_value(key,value,date_added) VALUES(?, ?, datetime('now','localtime'))"
                    
                    if db.executeUpdate(sql, withArgumentsInArray: ["TaskRunningNo-"+userId, runningNo]) {
                       runningNo = 0
                    }
                    
                }
            }
            
            db.close()
        }
        
        return String(runningNo)
    }

    func updateDBVersionNum(versionNum:String) ->Bool {
        let sql = "INSERT OR REPLACE INTO option_key_value(key,value,date_added) VALUES(?, ? ,datetime('now','localtime'))"
        var result = false
        
        if db.open() {
            
            if db.executeUpdate(sql, withArgumentsInArray: ["version", versionNum]) {
                result = true
            }
            
            db.close()
        }
        
        return result
    }
    
    func getDBVersionNum() ->String {
        let sql = "SELECT value FROM option_key_value WHERE key = ?"
        var version = ""
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: ["version"]) {
                if rs.next() {
                    version = rs.stringForColumn("value")
                }
            }
            
            db.close()
        }
        
        return version
    }
}

