//
//  QCInfoViewController.swift
//  QCFossil
//
//  Created by pacmobile on 15/7/2019.
//  Copyright © 2019 kira. All rights reserved.
//

import UIKit

class QCInfoViewController: PopoverMaster, UIScrollViewDelegate {
    
    var ScrollView = UIScrollView()
    var ssPhotoPath = ""
    var cbPhotoPath = ""
    
    override func viewWillAppear(animated: Bool) {
        if let myParentTabVC = self.parentViewController?.parentViewController as? TabBarViewController {
            myParentTabVC.setLeftBarItem("< "+MylocalizedString.sharedLocalizeManager.getLocalizedString("Task Form"),actionName: "backToTaskDetailFromPADF")
            myParentTabVC.setRightBarItem("", actionName: "")
            
            myParentTabVC.navigationItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("QC Info")
        }
    }
    
    override func viewDidLoad() {
        self.tabBarItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("QC Info")
        self.view.frame = CGRect.init(x: 0, y: 80, width: 768, height: 1024)
        
        let taskQCInfoView = TaskQCInfoView.loadFromNibNamed("TaskQCInfoView")!
        
        self.ScrollView = UIScrollView.init(frame: self.view.frame)
        self.ScrollView.delegate = self
        
        self.view.addSubview(self.ScrollView)
        self.ScrollView.addSubview(taskQCInfoView)
        
        if let poItems = Cache_Task_On?.poItems {
            /*let stackView = UIStackView()
            stackView.axis = .Vertical
            stackView.alignment = .Fill
            stackView.distribution = .Fill
            stackView.spacing = 0
            */
            var index = 0
            for poItem in poItems {
                let poInfoView = POInfoView.loadFromNibNamed("POInfoView")!
                poInfoView.PONoDisplay.text = poItem.poNo
                poInfoView.SAPPONoDisplay.text = poItem.refOrderNo
                poInfoView.shipToDisplay.text = poItem.buyerLocationCode
                poInfoView.shipModeDisplay.text = poItem.shipModeName
                poInfoView.barcodeDisplay.text = poItem.itemBarCode
                
                if poItem.retailPrice != nil {
                    
                    if let currency = poItem.currency {
                        poInfoView.retailPriceDisplay.text = "\(currency)\(poItem.retailPrice!)"
                    } else {
                        poInfoView.retailPriceDisplay.text = "\(poItem.retailPrice!)"
                    }
                } else {
                    poInfoView.retailPriceDisplay.text = ""
                }
                
                if let styleNo = poItem.styleNo {
                    poInfoView.styleSizeLabelText = MylocalizedString.sharedLocalizeManager.getLocalizedString("Style")
                    poInfoView.styleSizeDisplay.text = "\(styleNo)"
                }
                
                if let dimen1 = poItem.dimen1, let styleNo = poItem.styleNo {
                    if dimen1 != "" {
                        poInfoView.styleSizeLabelText = MylocalizedString.sharedLocalizeManager.getLocalizedString("Style, Size")
                        poInfoView.styleSizeDisplay.text = "\(styleNo), \(dimen1)"
                    }
                }
                
                poInfoView.frame = CGRect(x: 0, y: CGFloat(105 * index), width: poInfoView.frame.size.width, height: 105)
                taskQCInfoView.poView.addSubview(poInfoView)
                
                index += 1
                
                /*
                stackView.addArrangedSubview(poInfoView)
                poInfoView.leadingAnchor.constraintEqualToAnchor(stackView.leadingAnchor).active = true
                poInfoView.trailingAnchor.constraintEqualToAnchor(stackView.trailingAnchor).active = true
                poInfoView.heightAnchor.constraintEqualToConstant(105).active = true
                 */
            }
            
            //taskQCInfoView.poView.addSubview(stackView)

        }
        
        let newHeight:CGFloat = CGFloat(105 * (Cache_Task_On?.poItems.count ?? 0))
        
        taskQCInfoView.poView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 9.0, *) {
            taskQCInfoView.poView.heightAnchor.constraintEqualToConstant(newHeight).active = true
        } else {
            taskQCInfoView.frame = CGRect(x: taskQCInfoView.frame.origin.x, y: taskQCInfoView.frame.origin.y, width: taskQCInfoView.frame.size.width, height: newHeight)
        }
        
        self.ScrollView.contentSize = CGSize.init(width: 768, height: 1900 + newHeight)
        taskQCInfoView.frame.size = CGSize.init(width: 768, height: 1900 + newHeight)
        
        let dpDataHelper = DPDataHelper()
        let taskQCInfo = dpDataHelper.getQCInfoByRefTaskId(Cache_Task_On?.refTaskId ?? 0)
        
        let poItem = Cache_Task_On?.poItems.first
        
        taskQCInfoView.vendorInput.text = Cache_Task_On?.vendor
        taskQCInfoView.qcInternalNoInput.text = taskQCInfo?.qcBookingRefNo
        taskQCInfoView.brandInput.text = Cache_Task_On?.brand
        taskQCInfoView.tsReportNoInput.text = taskQCInfo?.tsReportNo
        taskQCInfoView.materialCategoryInput.text = poItem?.materialCategory
        taskQCInfoView.assortmentInput.text = taskQCInfo?.assortment
        taskQCInfoView.inspectorInput.text = taskQCInfo?.inspectorNames
//        self.textDisplayRule(taskQCInfoView.inspectorInput)
        
        taskQCInfoView.assortmentStyleInput.text = taskQCInfo?.consignedStyles
        taskQCInfoView.seasonInput.text = poItem?.market
        taskQCInfoView.updateTimeInput.text = self.view.getCurrentDateTime()
        
        taskQCInfoView.orderQtyInput.text = String(poItem?.orderQty ?? 0)
        taskQCInfoView.qualityStardardInput.text = taskQCInfo?.qualityStandard
//        self.textDisplayRule(taskQCInfoView.qualityStardardInput)
        
        taskQCInfoView.bookedQtyInput.text = poItem?.targetInspectQty
        
        if Cache_Inspector?.typeCode == TypeCode.WATCH.rawValue {
            taskQCInfoView.markingInput.text = taskQCInfo?.casebackMarking
        } else {
            taskQCInfoView.markingInput.text = taskQCInfo?.jwlMarking
        }
        
        taskQCInfoView.aqlQtyInput.text = String(taskQCInfo?.aqlQty ?? 0)
        taskQCInfoView.lengthReqInput.text = taskQCInfo?.lengthRequirement
//        self.textDisplayRule(taskQCInfoView.lengthReqInput)
        
        taskQCInfoView.productGradeInput.text = taskQCInfo?.productClass
        taskQCInfoView.movtInput.text = taskQCInfo?.movtOrigin
//        self.textDisplayRule(taskQCInfoView.movtInput)
        
        taskQCInfoView.upcOrbidStatusInput.text = taskQCInfo?.upcOrbidStatus
        taskQCInfoView.combineQCRemarkInput.text = taskQCInfo?.combineQcRemarks
//        self.textDisplayRule(taskQCInfoView.combineQCRemarkInput)
        
        taskQCInfoView.adjustTimeInput.text = taskQCInfo?.adjustTime
        taskQCInfoView.weightInput.text = taskQCInfo?.netWeight
        
        taskQCInfoView.ssReadyInput.text = taskQCInfo?.ssReady
        taskQCInfoView.ssCommentReadyInput.text = taskQCInfo?.ssCommentReady
        taskQCInfoView.tsSubmitDateInput.text = taskQCInfo?.tsSubmitDate
        taskQCInfoView.tsResultInput.text = taskQCInfo?.tsResult
        taskQCInfoView.samePOWithRejectInput.text = taskQCInfo?.withSamePoRejectedBef
        taskQCInfoView.inspectSampleReadyInput.text = taskQCInfo?.inspectionSampleReady
        taskQCInfoView.linkTestQtyInput.text = taskQCInfo?.linksRemarks
        taskQCInfoView.dustTestQtyInput.text = taskQCInfo?.dusttestRemark
        taskQCInfoView.smartLinkTestQtyInput.text = taskQCInfo?.smartlinkRemark
        taskQCInfoView.otherTestQtyInput.text = String(taskQCInfo?.aqlQty ?? 0)
        
        taskQCInfoView.caFormInput.text = taskQCInfo?.caForm
//        self.textDisplayRule(taskQCInfoView.caFormInput)
        
        taskQCInfoView.precisionReportInput.text = taskQCInfo?.preciseReport
        taskQCInfoView.smartLinkReportInput.text = taskQCInfo?.smartlinkReport
        taskQCInfoView.reliabilityTestRemarkInput.text = taskQCInfo?.reliabilityRemark
        taskQCInfoView.ftyPackInfoInput.text = taskQCInfo?.ftyPackingInfo
        taskQCInfoView.ftyDroptestInfoInput.text = taskQCInfo?.ftyDroptestInfo
        
        taskQCInfoView.caFormInputText = taskQCInfo?.caForm ?? ""
        taskQCInfoView.combineQCRemarkInputText = taskQCInfo?.combineQcRemarks ?? ""
        taskQCInfoView.reliabilityTestRemarkInputText = taskQCInfo?.reliabilityRemark ?? ""
        taskQCInfoView.ssReadyInputText = taskQCInfo?.ssReady ?? ""
        taskQCInfoView.ssCommentReadyInputText = taskQCInfo?.ssCommentReady ?? ""
        taskQCInfoView.tsSubmitDateInputText = taskQCInfo?.tsSubmitDate ?? ""
        taskQCInfoView.tsResultInputText = taskQCInfo?.tsResult ?? ""
        taskQCInfoView.qualityStardardInputText = taskQCInfo?.qualityStandard ?? ""
        taskQCInfoView.inspectors = taskQCInfo?.inspectorNames ?? ""
        
        let photoDataHelper = PhotoDataHelper()
        let stylePhotos = photoDataHelper.getStylePhotoByStyleNo(Cache_Task_On?.taskId ?? 0)
        
        stylePhotos.ssPhotoName
        self.ssPhotoPath = (Cache_Inspector?.typeCode == TypeCode.WATCH.rawValue ? _WATCHSSPHOTOSPHYSICALPATH : _JEWELRYSSPHOTOSPHYSICALPATH) + stylePhotos.ssPhotoName
        
        if Cache_Inspector?.typeCode == TypeCode.WATCH.rawValue {
            self.ssPhotoPath = _WATCHSSPHOTOSPHYSICALPATH + stylePhotos.ssPhotoName
        } else {
            self.ssPhotoPath = _JEWELRYSSPHOTOSPHYSICALPATH + stylePhotos.ssPhotoName
        }
        
        self.cbPhotoPath = _CASEBACKPHOTOSPHYSICALPATH + stylePhotos.cbPhotoName
        
        let filemgr = NSFileManager.defaultManager()
        if stylePhotos.ssPhotoName != "" && filemgr.fileExistsAtPath(ssPhotoPath) {
            do {
                taskQCInfoView.salesmanPhoto.image = UIImage(contentsOfFile: ssPhotoPath)
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ssPhotoPreviewTapOnClick(_:)))
                taskQCInfoView.salesmanPhoto.userInteractionEnabled = true
                taskQCInfoView.salesmanPhoto.addGestureRecognizer(tapGestureRecognizer)
                
            }
        } else {
            taskQCInfoView.salesmanLabel.hidden = true
            taskQCInfoView.salesmanPhoto.hidden = true
        }
        
        if stylePhotos.cbPhotoName != "" && filemgr.fileExistsAtPath(cbPhotoPath) {
            do {
                taskQCInfoView.caseBackPhoto.image = UIImage(contentsOfFile: cbPhotoPath)
                let tapGestureRecognizer2 = UITapGestureRecognizer(target:self, action:#selector(cbPhotoPreviewTapOnClick(_:)))
                taskQCInfoView.caseBackPhoto.userInteractionEnabled = true
                taskQCInfoView.caseBackPhoto.addGestureRecognizer(tapGestureRecognizer2)
                
            } 
        } else {
            taskQCInfoView.caseBackLabel.hidden = true
            taskQCInfoView.caseBackPhoto.hidden = true
        }
    }
    
    func ssPhotoPreviewTapOnClick(sender: UITapGestureRecognizer) {
        let container: UIView = UIView()
        container.tag = _MASKVIEWTAG
        container.hidden = false
        container.frame = self.view.frame
        container.center = self.view.center
        container.backgroundColor = UIColor.clearColor()
        
        let layer = UIView()
        layer.frame = self.view.frame
        layer.center = self.view.center
        layer.backgroundColor = UIColor.blackColor()
        layer.alpha = 0.7
        container.addSubview(layer)
        
        let preview = ImagePreviewViewInput.loadFromNibNamed("ImagePreviewView")
        preview!.frame = CGRectMake(0,0,600,850)
        preview?.center = container.center
        preview?.parentView = container
        preview?.startEditBtn.hidden = true
        preview?.imageView.image = UIImage(contentsOfFile: self.ssPhotoPath)
        preview?.imageView.contentMode = .ScaleAspectFit
        preview?.imageView.frame = CGRect(x: 0,y: 0,width: 600,height: 800)
        preview?.BackgroundView.addSubview((preview?.imageView)!)
        
        container.addSubview(preview!)
        
        self.view.addSubview(container)
    }
    
    func cbPhotoPreviewTapOnClick(sender: UITapGestureRecognizer) {
        let container: UIView = UIView()
        container.tag = _MASKVIEWTAG
        container.hidden = false
        container.frame = self.view.frame
        container.center = self.view.center
        container.backgroundColor = UIColor.clearColor()
        
        let layer = UIView()
        layer.frame = self.view.frame
        layer.center = self.view.center
        layer.backgroundColor = UIColor.blackColor()
        layer.alpha = 0.7
        container.addSubview(layer)
        
        let preview = ImagePreviewViewInput.loadFromNibNamed("ImagePreviewView")
        preview!.frame = CGRectMake(0,0,600,850)
        preview?.center = container.center
        preview?.parentView = container
        preview?.startEditBtn.hidden = true
        preview?.imageView.image = UIImage(contentsOfFile: self.cbPhotoPath)
        preview?.imageView.contentMode = .ScaleAspectFit
        preview?.imageView.frame = CGRect(x: 0,y: 0,width: 600,height: 800)
        preview?.BackgroundView.addSubview((preview?.imageView)!)
        
        container.addSubview(preview!)
        
        self.view.addSubview(container)
    }
    
    func textDisplayRule(textField: UITextField) {
        
        if textField.text?.characters.count > 15 {
            textField.text = substringWithRange(textField.text!, start: 0, end: 15) + "..."
        }
        
    }
    
    func substringWithRange(text:String, start: Int, end: Int) -> String
    {
        if (start < 0 || start > text.characters.count)
        {
            print("start index \(start) out of bounds")
            return ""
        }
        else if end < 0 || end > text.characters.count
        {
            print("end index \(end) out of bounds")
            return ""
        }
        let range = Range(start: text.startIndex.advancedBy(start), end: text.startIndex.advancedBy(end))
        
        return text.substringWithRange(range)
    }
}