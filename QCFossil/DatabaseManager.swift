//
//  DatabaseManager.swift
//  QCFossil
//
//  Created by pacmobile on 25/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

private let sharedDbMgr = DatabaseManager()

class DatabaseManager {
    var db = FMDatabase()
    
    func initDbObj(inspectorName:String = "")  {
        var database = _DBNAME_USING
        
        if inspectorName != "" {
            database = _DBNAME_USING + "_" + inspectorName
            _TASKSPHYSICALPATH = "\(_TASKSPHYSICALPATHPREFIX + inspectorName + "/\(_TASKSPHYSICALFOLDERNAME)")/"
            
        }
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        print("path: \(dirPaths)")
        let dbDir = dirPaths[0] as String
        
        let foderPath = _TASKSPHYSICALPATHPREFIX + inspectorName
        let databasePath = dbDir.stringByAppendingString("/\(inspectorName)\(database)")
        
        if !filemgr.fileExistsAtPath(databasePath) {
            print("Database File No Exist! Copy From Code")
            
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(foderPath, withIntermediateDirectories: true, attributes: nil)
                
                let srcPath = NSBundle.mainBundle().pathForResource(_DBNAME_USING, ofType: "sqlite")
                
                try filemgr.copyItemAtPath(srcPath!, toPath: databasePath)
            } catch let error as NSError {
                print("initDbObj: "+error.localizedDescription)
            }
        }
        
        db = FMDatabase(path: databasePath)
        
        _INSPECTORWORKINGPATH = foderPath
    }
    
    func openLocalDB(inspectorName:String = "") ->Bool {
        var database = _DBNAME_USING
        
        if inspectorName != "" {
            database = _DBNAME_USING + "_" + inspectorName
            _TASKSPHYSICALPATH = "\(_TASKSPHYSICALPATHPREFIX + inspectorName + "/\(_TASKSPHYSICALFOLDERNAME)")/"
            
        }
        
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        print("path: \(dirPaths)")
        let dbDir = dirPaths[0] as String
        
        let foderPath = _TASKSPHYSICALPATHPREFIX + inspectorName
        let databasePath = dbDir.stringByAppendingString("/\(inspectorName)\(database)")
        
        if !filemgr.fileExistsAtPath(databasePath) {
            print("No this Username")
            
            return false
        }
        
        db = FMDatabase(path: databasePath)
        _INSPECTORWORKINGPATH = foderPath
        
        return true
    }
    
    class var sharedDatabaseManager : DatabaseManager {
        return sharedDbMgr
    }
}
