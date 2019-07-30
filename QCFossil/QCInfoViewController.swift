//
//  QCInfoViewController.swift
//  QCFossil
//
//  Created by pacmobile on 15/7/2019.
//  Copyright © 2019 kira. All rights reserved.
//

import UIKit

class QCInfoViewController: UIViewController, UIScrollViewDelegate {
    
    var ScrollView = UIScrollView()

    override func viewWillAppear(animated: Bool) {
        if let myParentTabVC = self.parentViewController?.parentViewController as? TabBarViewController {
            myParentTabVC.setRightBarItem("", actionName: "")
        }
    }
    
    override func viewDidLoad() {
        self.tabBarItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("QC Info")
        
        let taskQCInfoView = TaskQCInfoView.loadFromNibNamed("TaskQCInfoView")!
        
        self.ScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 50, width: 768, height: 1024))
        
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
                poInfoView.styleSizeDisplay.text = "\(poItem.styleNo!), \(poItem.dimen1!)"
                poInfoView.shipToDisplay.text = poItem.buyerLocationCode
                poInfoView.shipModeDisplay.text = poItem.shipModeName
                poInfoView.barcodeDisplay.text = ""
                
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
        
        self.ScrollView.contentSize = CGSize.init(width: 768, height: 1500 + newHeight)

        let dpDataHelper = DPDataHelper()
        let taskQCInfo = dpDataHelper.getQCInfoByRefTaskId(Cache_Task_On?.refTaskId ?? 0)
        
        let poItem = Cache_Task_On?.poItems.first
        
        taskQCInfoView.vendorInput.text = Cache_Task_On?.vendor
        taskQCInfoView.qcInternalNoInput.text = taskQCInfo?.qcBookingRefNo
        taskQCInfoView.brandInput.text = Cache_Task_On?.brand
        taskQCInfoView.tsReportNoInput.text = taskQCInfo?.tsReportNo
        taskQCInfoView.materialCategoryInput.text = poItem?.materialCategory
        taskQCInfoView.assortmentInput.text = taskQCInfo?.assortment
        taskQCInfoView.inspectorInput.text = Cache_Inspector?.inspectorName
        taskQCInfoView.assortmentStyleInput.text = taskQCInfo?.consignedStyles
        taskQCInfoView.seasonInput.text = poItem?.market
        taskQCInfoView.updateTimeInput.text = self.view.getCurrentDateTime()
        
        taskQCInfoView.orderQtyInput.text = String(poItem?.orderQty)
        taskQCInfoView.qualityStardardInput.text = taskQCInfo?.qualityStandard
        taskQCInfoView.bookedQtyInput.text = ""
        taskQCInfoView.markingInput.text = Cache_Inspector?.typeCode == "WATCH" ? taskQCInfo?.casebackMarking : taskQCInfo?.jwlMarking
        taskQCInfoView.aqlQtyInput.text = String(taskQCInfo?.aqlQty)
        taskQCInfoView.lengthReqInput.text = taskQCInfo?.netWeight
        taskQCInfoView.productGradeInput.text = taskQCInfo?.productClass
        taskQCInfoView.movtInput.text = taskQCInfo?.movtOrigin
        taskQCInfoView.upcOrbidStatusInput.text = taskQCInfo?.upcOrbidStatus
        taskQCInfoView.combineQCRemarkInput.text = taskQCInfo?.combineQcRemarks
        
        taskQCInfoView.ssReadyInput.text = taskQCInfo?.ssReady
        taskQCInfoView.ssCommentReadyInput.text = taskQCInfo?.ssCommentReady
        taskQCInfoView.tsSubmitDateInput.text = taskQCInfo?.tsSubmitDate
        taskQCInfoView.tsResultInput.text = taskQCInfo?.tsResult
        taskQCInfoView.samePOWithRejectInput.text = taskQCInfo?.withSamePoRejectedBef
        taskQCInfoView.inspectSampleReadyInput.text = taskQCInfo?.inspectionSampleReady
        taskQCInfoView.linkTestQtyInput.text = taskQCInfo?.linksRemarks
        taskQCInfoView.dustTestQtyInput.text = taskQCInfo?.dusttestRemark
        taskQCInfoView.smartLinkTestQtyInput.text = taskQCInfo?.smartlinkRemark
        taskQCInfoView.otherTestQtyInput.text = String(taskQCInfo?.aqlQty)
        
        taskQCInfoView.caFormInput.text = taskQCInfo?.caForm
        taskQCInfoView.precisionReportInput.text = taskQCInfo?.preciseReport
        taskQCInfoView.smartLinkReportInput.text = taskQCInfo?.smartlinkReport
        taskQCInfoView.reliabilityTestRemarkInput.text = taskQCInfo?.reliabilityRemark
        taskQCInfoView.ftyPackInfoInput.text = taskQCInfo?.ftyPackingInfo
        taskQCInfoView.ftyDroptestInfoInput.text = taskQCInfo?.ftyDroptestInfo
        
    }
    
    
}