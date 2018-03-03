//
//  Vendor.swift
//  QCFossil
//
//  Created by pc01 on 24/2/2016.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

class Vendor {
    
    var dataEnv:Int?
    var vdrId:Int?
    var vdrCode:Int?
    var vdrName:Int?
    var displayName:String?
    var contactAddr:String?
    var contactPerson:String?
    var contactPhone:String?
    var contactEmail:String?
    var recStatus:String?
    var createUser:String?
    var createDate:String?
    var modifyUser:String?
    var modifyDate:String?
    var deletedFlag:Int?
    var deleteUser:String?
    var deleteDate:String?
    
    init(dataEnv:Int?,vdrId:Int?,vdrCode:Int?,vdrName:Int?,displayName:String?,contactAddr:String?,contactPerson:String?,contactPhone:String?,contactEmail:String?,recStatus:String?,createUser:String?,createDate:String?,modifyUser:String?,modifyDate:String?,deletedFlag:Int?,deleteUser:String?,deleteDate:String?) {
        
        self.dataEnv = dataEnv
        self.vdrId = vdrId
        self.vdrCode = vdrCode
        self.vdrName = vdrName
        self.displayName = displayName
        self.contactAddr = contactAddr
        self.contactPerson = contactPerson
        self.contactEmail = contactEmail
        self.recStatus = recStatus
        self.createUser = createUser
        self.createDate = createDate
        self.modifyUser = modifyUser
        self.modifyDate = modifyDate
        self.deletedFlag = deletedFlag
        self.deleteUser = deleteUser
        self.deleteDate = deleteDate
        
    }
    
}