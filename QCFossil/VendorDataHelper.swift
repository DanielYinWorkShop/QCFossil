//
//  VendorDataHelper.swift
//  QCFossil
//
//  Created by pacmobile on 26/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation

class VendorDataHelper:DataHelperMaster{
    
    func getVdrNameByLocationId(locationId:Int) ->String {
        let sql = "SELECT display_name FROM vdr_mstr WHERE vdr_id = ?"
        var vdrName:String = "null"
        let vdrId = getVdrIdByLocationId(locationId)
        
        if db.open() {
        
            if let rs = db.executeQuery(sql, withArgumentsInArray: [vdrId]) {
            
                if rs.next() {
                    vdrName = rs.stringForColumnIndex(0)
                }
            }
            
            db.close()
        }
        
        return vdrName
    }
    
    func getVdrLocationById(locationId:Int) ->String {
        let sql = "SELECT location_name FROM vdr_location_mstr WHERE location_id = ?"
        var vdrLocation:String = "null"
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [locationId]) {
            
                if rs.next() {
                    vdrLocation = rs.stringForColumnIndex(0)
                }
            }
            
            db.close()
        }
        
        return vdrLocation
    }
    
    func getVdrLocationIdByName(vdrLocName:String) ->Int {
        let sql = "SELECT location_id FROM vdr_location_mstr WHERE location_name = ?"
        var vdrLocId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [vdrLocName]) {
                
                if rs.next() {
                    vdrLocId = Int(rs.intForColumnIndex(0))
                }
            }
            
            db.close()
        }
        
        return vdrLocId
    }
    
    func getVdrLocationIdByCode(vdrLocCode:String) ->Int {
        let sql = "SELECT location_id FROM vdr_location_mstr WHERE location_code = ?"
        var vdrLocId = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [vdrLocCode]) {
                
                if rs.next() {
                    vdrLocId = Int(rs.intForColumnIndex(0))
                }
            }
            
            db.close()
        }
        
        return vdrLocId
    }
    
    func getVdrIdByLocationId(locationId:Int) ->Int {
        let sql = "SELECT vdr_id FROM vdr_location_mstr WHERE location_id = ?"
        var vdrId:Int = 0
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [locationId]) {
            
                if rs.next() {
                    vdrId = Int(rs.intForColumnIndex(0))
                }
            }
            
            db.close()
        }
        
        return vdrId
    }
    
    func getBrandIdByLocationId(locationId:Int) ->Int {
        let sql = "SELECT brand_id FROM vdr_brand_map WHERE vdr_id = ?"
        var brandId:Int = 0
        let vdrId = getVdrIdByLocationId(locationId)
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [vdrId]) {
            
                if rs.next() {
                    brandId = Int(rs.intForColumnIndex(0))
                }
            }
            
            db.close()
        }
        
        return brandId
    }
    
    func getBrandNameByLocationId(locationId:Int) ->String {
        let sql = "SELECT brand_name FROM brand_mstr WHERE brand_id = ?"
        var brandName:String = ""
        let brandId = getBrandIdByLocationId(locationId)
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray: [brandId]) {
            
                if rs.next() {
                    brandName = rs.stringForColumnIndex(0)
                }
            }
            
            db.close()
        }
        
        return brandName
    }
    
    func getVendorNameByvdrCode(vdrCode:Int) ->String {
        let sql = "SELECT display_name FROM vdr_mstr WHERE vdr_code = ?"
        var vendorName = ""

        if db.open() {

            if let rs = db.executeQuery(sql, withArgumentsInArray: [vdrCode]) {

                if rs.next() {
                    vendorName = rs.stringForColumn("vdr_code")
                }
            }
            
            db.close()
        }
        return vendorName
    }
    
    func getVendorLocationByvdrId(vdrId:Int) ->String {
        let sql = "SELECT location_name FROM vdr_location_mstr WHERE vdr_id = ?"

        var vendorLocation = ""
        
        if db.open() {
        
            if let rs = db.executeQuery(sql, withArgumentsInArray: [vdrId]) {
            
                if rs.next() {
                    vendorLocation = rs.stringForColumn("vdr_id")
                }
            }
            
            db.close()
        }
        return vendorLocation
    }
    
    func getAllVendors() ->[Vendor]?{
        
        //let sql = "SELECT * FROM vdr_mstr WHERE data_env = 'LEATHER' ORDER BY display_name ASC"
        let sql = "SELECT DISTINCT vm.* FROM vdr_mstr vm INNER JOIN vdr_location_mstr vlm ON vm.vdr_id = vlm.vdr_id INNER JOIN inspect_task it ON vlm.location_id = it.vdr_location_id ORDER BY location_code ASC"
        
        var vendors = [Vendor]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray:nil) {
            
            while rs.next() {
                
                let dataEnv = Int(rs.intForColumn("data_env"))
                let vdrId = Int(rs.intForColumn("vdr_id"))
                let vdrCode = Int(rs.intForColumn("vdr_code"))
                let vdrName = Int(rs.intForColumn("vdr_name"))
                let displayName = rs.stringForColumn("display_name")
                let contactAddr = rs.stringForColumn("contact_addr")
                let contactPerson = rs.stringForColumn("contact_person")
                let contactPhone = rs.stringForColumn("contact_phone")
                let contactEmail = rs.stringForColumn("contact_email")
                let recStatus = rs.stringForColumn("rec_status")
                let createUser = rs.stringForColumn("create_user")
                let createDate = rs.stringForColumn("create_date")
                let modifyUser = rs.stringForColumn("modify_user")
                let modifyDate = rs.stringForColumn("modify_date")
                let deletedFlag = Int(rs.intForColumn("deleted_flag"))
                let deleteUser = rs.stringForColumn("delete_user")
                let deleteDate = rs.stringForColumn("delete_date")
                
                let vendor = Vendor(dataEnv: dataEnv, vdrId: vdrId, vdrCode: vdrCode, vdrName: vdrName, displayName: displayName, contactAddr: contactAddr, contactPerson: contactPerson, contactPhone: contactPhone, contactEmail: contactEmail, recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                
                vendors.append(vendor)
            }
            }
            
            db.close()
        }
        return vendors
    }
    
    func getAllVdrLocs() ->[VdrLoc]? {
        
        //let sql = "SELECT * FROM vdr_location_mstr WHERE data_env = 'LEATHER' ORDER BY location_code ASC"
        let sql = "SELECT DISTINCT vlm.* FROM vdr_location_mstr vlm INNER JOIN inspect_task it ON vlm.location_id = it.vdr_location_id ORDER BY location_code ASC"
        
        var vdrLocs = [VdrLoc]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray:nil) {
            
            while rs.next() {
                
                let dataEnv = Int(rs.intForColumn("data_env"))
                let locationId = Int(rs.intForColumn("location_id"))
                let vdrId = Int(rs.intForColumn("vdr_id"))
                let locationCode = rs.stringForColumn("location_code")
                let locationName = rs.stringForColumn("location_name")
                let recStatus = rs.stringForColumn("rec_status")
                let createUser = rs.stringForColumn("create_user")
                let createDate = rs.stringForColumn("create_date")
                let modifyUser = rs.stringForColumn("modify_user")
                let modifyDate = rs.stringForColumn("modify_date")
                let deletedFlag = Int(rs.intForColumn("deleted_flag"))
                
                let deleteUser = rs.stringForColumn("delete_user")
                let deleteDate = rs.stringForColumn("delete_date")
                
                let vdrLoc = VdrLoc(dataEnv: dataEnv, locationId: locationId, vdrId: vdrId, locationCode: locationCode, locationName: locationName,recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                
                vdrLocs.append(vdrLoc)
                
            }
            }
            
            db.close()
        }
        return vdrLocs
    }
    
    func getAllVendorsFromPOSearch() ->[Vendor]?{
        
        let sql = "SELECT * FROM vdr_mstr vm WHERE EXISTS (SELECT 1 FROM fgpo_line_item fli WHERE fli.ref_vdr_id = vm.vdr_id AND fli.outstand_qty > 0 AND fli.line_status <> 5) ORDER BY display_name ASC"
        
        var vendors = [Vendor]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray:nil) {
                
                while rs.next() {
                    
                    let dataEnv = Int(rs.intForColumn("data_env"))
                    let vdrId = Int(rs.intForColumn("vdr_id"))
                    let vdrCode = Int(rs.intForColumn("vdr_code"))
                    let vdrName = Int(rs.intForColumn("vdr_name"))
                    let displayName = rs.stringForColumn("display_name")
                    let contactAddr = rs.stringForColumn("contact_addr")
                    let contactPerson = rs.stringForColumn("contact_person")
                    let contactPhone = rs.stringForColumn("contact_phone")
                    let contactEmail = rs.stringForColumn("contact_email")
                    let recStatus = rs.stringForColumn("rec_status")
                    let createUser = rs.stringForColumn("create_user")
                    let createDate = rs.stringForColumn("create_date")
                    let modifyUser = rs.stringForColumn("modify_user")
                    let modifyDate = rs.stringForColumn("modify_date")
                    let deletedFlag = Int(rs.intForColumn("deleted_flag"))
                    let deleteUser = rs.stringForColumn("delete_user")
                    let deleteDate = rs.stringForColumn("delete_date")
                    
                    let vendor = Vendor(dataEnv: dataEnv, vdrId: vdrId, vdrCode: vdrCode, vdrName: vdrName, displayName: displayName, contactAddr: contactAddr, contactPerson: contactPerson, contactPhone: contactPhone, contactEmail: contactEmail, recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                    
                    vendors.append(vendor)
                }
            }
            
            db.close()
        }
        return vendors
    }
    
    func getAllVdrLocsFromPOSearch() ->[VdrLoc]? {
        
        let sql = "SELECT * FROM vdr_location_mstr vlm WHERE EXISTS (SELECT 1 FROM fgpo_line_item fli WHERE fli.ref_vdr_location_id = vlm.location_id AND fli.outstand_qty > 0 AND fli.line_status <> 5) ORDER BY location_code ASC"
        
        var vdrLocs = [VdrLoc]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray:nil) {
                
                while rs.next() {
                    
                    let dataEnv = Int(rs.intForColumn("data_env"))
                    let locationId = Int(rs.intForColumn("location_id"))
                    let vdrId = Int(rs.intForColumn("vdr_id"))
                    let locationCode = rs.stringForColumn("location_code")
                    let locationName = rs.stringForColumn("location_name")
                    let recStatus = rs.stringForColumn("rec_status")
                    let createUser = rs.stringForColumn("create_user")
                    let createDate = rs.stringForColumn("create_date")
                    let modifyUser = rs.stringForColumn("modify_user")
                    let modifyDate = rs.stringForColumn("modify_date")
                    let deletedFlag = Int(rs.intForColumn("deleted_flag"))
                    
                    let deleteUser = rs.stringForColumn("delete_user")
                    let deleteDate = rs.stringForColumn("delete_date")
                    
                    let vdrLoc = VdrLoc(dataEnv: dataEnv, locationId: locationId, vdrId: vdrId, locationCode: locationCode, locationName: locationName,recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                    
                    vdrLocs.append(vdrLoc)
                    
                }
            }
            
            db.close()
        }
        return vdrLocs
    }
    
    func getAllVendorsFromTaskSearch() ->[Vendor]?{
        
        //let sql = "SELECT * FROM vdr_mstr vm WHERE EXISTS (SELECT 1 FROM fgpo_line_item fli WHERE fli.ref_vdr_id = vm.vdr_id) ORDER BY display_name ASC"
        let sql = "SELECT DISTINCT vm.* FROM inspect_task it INNER JOIN vdr_location_mstr vlm ON it.vdr_location_id = vlm.location_id INNER JOIN vdr_mstr vm ON vlm.vdr_id=vm.vdr_id WHERE it.vdr_location_id = vlm.location_id ORDER BY display_name ASC"
        
        var vendors = [Vendor]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray:nil) {
                
                while rs.next() {
                    
                    let dataEnv = Int(rs.intForColumn("data_env"))
                    let vdrId = Int(rs.intForColumn("vdr_id"))
                    let vdrCode = Int(rs.intForColumn("vdr_code"))
                    let vdrName = Int(rs.intForColumn("vdr_name"))
                    let displayName = rs.stringForColumn("display_name")
                    let contactAddr = rs.stringForColumn("contact_addr")
                    let contactPerson = rs.stringForColumn("contact_person")
                    let contactPhone = rs.stringForColumn("contact_phone")
                    let contactEmail = rs.stringForColumn("contact_email")
                    let recStatus = rs.stringForColumn("rec_status")
                    let createUser = rs.stringForColumn("create_user")
                    let createDate = rs.stringForColumn("create_date")
                    let modifyUser = rs.stringForColumn("modify_user")
                    let modifyDate = rs.stringForColumn("modify_date")
                    let deletedFlag = Int(rs.intForColumn("deleted_flag"))
                    let deleteUser = rs.stringForColumn("delete_user")
                    let deleteDate = rs.stringForColumn("delete_date")
                    
                    let vendor = Vendor(dataEnv: dataEnv, vdrId: vdrId, vdrCode: vdrCode, vdrName: vdrName, displayName: displayName, contactAddr: contactAddr, contactPerson: contactPerson, contactPhone: contactPhone, contactEmail: contactEmail, recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                    
                    vendors.append(vendor)
                }
            }
            
            db.close()
        }
        return vendors
    }
    
    func getAllVdrLocsFromTaskSearch() ->[VdrLoc]? {
        
        //let sql = "SELECT * FROM vdr_location_mstr vlm WHERE EXISTS (SELECT 1 FROM fgpo_line_item fli WHERE fli.ref_vdr_location_id = vlm.location_id) ORDER BY location_code ASC"
        let sql = "SELECT DISTINCT vlm.* FROM inspect_task it INNER JOIN vdr_location_mstr vlm ON it.vdr_location_id = vlm.location_id ORDER BY location_code ASC"
        
        var vdrLocs = [VdrLoc]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray:nil) {
                
                while rs.next() {
                    
                    let dataEnv = Int(rs.intForColumn("data_env"))
                    let locationId = Int(rs.intForColumn("location_id"))
                    let vdrId = Int(rs.intForColumn("vdr_id"))
                    let locationCode = rs.stringForColumn("location_code")
                    let locationName = rs.stringForColumn("location_name")
                    let recStatus = rs.stringForColumn("rec_status")
                    let createUser = rs.stringForColumn("create_user")
                    let createDate = rs.stringForColumn("create_date")
                    let modifyUser = rs.stringForColumn("modify_user")
                    let modifyDate = rs.stringForColumn("modify_date")
                    let deletedFlag = Int(rs.intForColumn("deleted_flag"))
                    
                    let deleteUser = rs.stringForColumn("delete_user")
                    let deleteDate = rs.stringForColumn("delete_date")
                    
                    let vdrLoc = VdrLoc(dataEnv: dataEnv, locationId: locationId, vdrId: vdrId, locationCode: locationCode, locationName: locationName,recStatus: recStatus, createUser: createUser, createDate: createDate, modifyUser: modifyUser, modifyDate: modifyDate, deletedFlag: deletedFlag, deleteUser: deleteUser, deleteDate: deleteDate)
                    
                    vdrLocs.append(vdrLoc)
                    
                }
            }
            
            db.close()
        }
        return vdrLocs
    }
    
    func getAllVendors(inputValue:String) ->[String] {
        //let sql = "SELECT DISTINCT(display_name) FROM vdr_mstr WHERE display_name LIKE ?"
        //let sql = "SELECT DISTINCT vm.* FROM vdr_mstr vm INNER JOIN vdr_location_mstr vlm ON vm.vdr_id = vlm.vdr_id INNER JOIN inspect_task it ON vlm.location_id = it.vdr_location_id WHERE display_name LIKE ? ORDER BY location_code ASC"
        let sql = "SELECT DISTINCT vm.* FROM vdr_mstr vm WHERE EXISTS (SELECT 1 FROM fgpo_line_item fli WHERE fli.ref_vdr_id = vm.vdr_id) AND vm.display_name LIKE ? ORDER BY display_name ASC"
        
        var vdrs = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray:["%"+inputValue+"%"]) {
                
                while rs.next() {
                    
                    let vdr = rs.stringForColumn("display_name")
                    
                    vdrs.append(vdr)
                    
                }
            }
            
            db.close()
        }
        return vdrs
    }
    
    func getAllVendorLocs(inputValue:String) ->[String] {
        //let sql = "SELECT DISTINCT(location_code) FROM vdr_location_mstr WHERE location_code LIKE ?"
        //let sql = "SELECT DISTINCT vlm.* FROM vdr_location_mstr vlm INNER JOIN inspect_task it ON vlm.location_id = it.vdr_location_id WHERE location_code LIKE ? ORDER BY location_code ASC"
        let sql = "SELECT DISTINCT vlm.* FROM vdr_location_mstr vlm WHERE EXISTS (SELECT 1 FROM fgpo_line_item fli WHERE fli.ref_vdr_location_id = vlm.location_id) AND location_code LIKE ? ORDER BY location_code ASC"

        var vdrLocs = [String]()
        
        if db.open() {
            
            if let rs = db.executeQuery(sql, withArgumentsInArray:["%"+inputValue+"%"]) {
                
                while rs.next() {
                    
                    let vdrLoc = rs.stringForColumn("location_code")
                    
                    vdrLocs.append(vdrLoc)
                    
                }
            }
            
            db.close()
        }
        return vdrLocs
    }
}