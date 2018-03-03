//
//  TaskInspector.swift
//  QCFossil
//
//  Created by pacmobile on 2/11/2016.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

class TaskInspector {
    var inspectorId:Int?
    var createUser:String?
    var createDate:String?
    var modifyUser:String?
    var modifyDate:String?
    var inspectEnableFlag:Int?
    var taskId:Int?
    
    init(inspectorId:Int, createUser:String?, createDate:String?, modifyUser:String?, modifyDate:String?, inspectEnableFlag:Int, taskId:Int?) {
        
        self.inspectorId = inspectorId
        self.createUser = createUser
        self.createDate = createDate
        self.modifyUser = modifyUser
        self.modifyDate = modifyDate
        self.inspectEnableFlag = inspectEnableFlag
        self.taskId = taskId
    }
}