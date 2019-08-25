//
//  TaskStatus.swift
//  QCFossil
//
//  Created by pacmobile on 26/1/16.
//  Copyright © 2016 kira. All rights reserved.
//

import Foundation
import UIKit
/*
enum TaskStatus:String {
    case Cancelled = "Cancelled"
    case Draft = "Draft"
    case Pending = "Pending"
    case Confirmed = "Confirmed"
    case Uploaded = "Uploaded"
    case Refused = "Refuserd"
    
    init(caseId:Int) {
        switch caseId {
            case -1: self = .Cancelled
            case 0: self = .Draft
            case 1: self = .Pending
            case 2: self = .Confirmed
            case 3: self = .Uploaded
            case 4: self = .Refused
            default:self = .Draft
        }
    }
}

enum GetTaskStatusId:Int {
    case Cancelled = -1
    case Draft = 0
    case Pending = 1
    case Confirmed = 2
    case Uploaded = 3
    case Refused = 4
    
    init(caseId:String) {
        switch caseId {
        case "Cancelled": self = .Cancelled
        case "Draft": self = .Draft
        case "Pending": self = .Pending
        case "Confirmed": self = .Confirmed
        case "Uploaded": self = .Uploaded
        case "Refuserd": self = .Refused
        default:self = .Draft
        }
    }
}
*/
enum TaskStatus:String {
    case Cancelled = "Cancelled"
    case Booking = "Booking"
    case Pending = "Pending"
    case Draft = "Draft"
    case Confirmed = "Confirmed"
    case Uploaded = "Uploaded"
    case Refused = "Refused"
    case PendingForReview = "PendingForReview"
    case Reviewed = "Reviewed"
    case Skipped = "Skipped"
    
    init(caseId:Int) {
        switch caseId {
        case 0: self = .Cancelled
        case 1: self = .Booking
        case 2: self = .Pending
        case 3: self = .Draft
        case 4: self = .Confirmed
        case 5: self = .Uploaded
        case 6: self = .Refused
        case 7: self = .PendingForReview
        case 8: self = .Reviewed
        case 9: self = .Skipped
        default:self = .Draft
        }
    }
}

enum GetTaskStatusId:Int {
    case Cancelled = 0
    case Booking = 1
    case Pending = 2
    case Draft = 3
    case Confirmed = 4
    case Uploaded = 5
    case Refused = 6
    case PendingForReview = 7
    case Reviewed = 8
    case Skipped = 9
    
    init(caseId:String) {
        switch caseId {
        case "Cancelled": self = .Cancelled
        case "Booking": self = .Booking
        case "Pending": self = .Pending
        case "Draft": self = .Draft
        case "Confirmed": self = .Confirmed
        case "Uploaded": self = .Uploaded
        case "Refused": self = .Refused
        case "PendingForReview": self = .PendingForReview
        case "Reviewed": self = .Reviewed
        case "Skipped": self = .Skipped
        default:self = .Draft
        }
    }
}

enum PhotoAddedStatus:String {
    case Yes = "Yes"
    case No = "No"
    
    init(caseId:String) {
        switch caseId {
        case "yes": self = .Yes
        case "no": self = .No
        default: self = .No
        }
        
    }
}

enum InspTypeValue:String {
    case MATERIAL = "MATERIAL"
    case INLINE = "IN-LINE"
    case FINAL = "FINAL"
    
    init(caseId:Int) {
        switch caseId {
        case 1: self = .MATERIAL
        case 2: self = .INLINE
        case 3: self = .FINAL
        default: self = .FINAL
        }
        
    }
}

enum PhotoDataType:Int {
    case TASK = 0
    case INSPECT = 1
    case DEFECT = 2
    
    init(caseId:String) {
        switch caseId {
        case "TASK": self = .TASK
        case "INSPECT": self = .INSPECT
        case "DEFECT": self = .DEFECT
        default: self = .TASK
        }
        
    }
}

enum TypeCode:String {
    case WATCH = "WATCH"
    case JEWELRY = "JEWELRY"
    case LEATHER = "LEATHER"
}

struct ElmtObj{
    var elementId:Int
    var elementNameEn:String
    var elementNameCn:String
    var reqElmtFlag:Int
}

struct PositObj{
    var positionId:Int
    var positionNameEn:String
    var positionNameCn:String
}

struct PositPointObj{
    var positionId:Int
    var parentId:Int
    var positionNameEn:String
    var positionNameCn:String
}


struct SectObj{
    var sectionId:Int
    var sectionNameEn:String
    var sectionNameCn:String
    var inputMode:String
}

struct ResultValueObj{
    var resultValueId:Int
    var resultValueNameEn:String
    var resultValueNameCn:String
}

struct DefectPhoto {
    var image:UIImage
    var photoFileName:String
}


struct StylePhoto {
    var ssPhotoName:String
    var cbPhotoName:String
}

/*
enum CommonText {
    case iPad
    case iPhone
    case AppleTV
    case AppleWatch
    
    func getLocalize() -> String {
        switch self {
        case AppleTV: return MylocalizedString.sharedLocalizeManager.getLocalizedString("Username")
        case iPhone: return MylocalizedString.sharedLocalizeManager.getLocalizedString("Username")
        case iPad: return MylocalizedString.sharedLocalizeManager.getLocalizedString("Username")
        case AppleWatch: return MylocalizedString.sharedLocalizeManager.getLocalizedString("Username")
        }
    }
}
let value = CommonText.iPad.getLocalize()
print("localize String: \(value)")
*/


