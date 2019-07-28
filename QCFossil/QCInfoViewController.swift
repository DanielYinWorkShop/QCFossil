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

    override func viewDidLoad() {
        self.tabBarItem.title = MylocalizedString.sharedLocalizeManager.getLocalizedString("QC Info")
        
        let taskQCInfoView = TaskQCInfoView.loadFromNibNamed("TaskQCInfoView")!
        
        self.ScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 50, width: 768, height: 1024))
        
        self.ScrollView.contentSize = CGSize.init(width: 768, height: 1700)
        self.ScrollView.delegate = self
        
        self.view.addSubview(self.ScrollView)
        
        self.ScrollView.addSubview(taskQCInfoView)
        
        
        let poInfoView = POInfoView.loadFromNibNamed("POInfoView")!
        let poInfoView2 = POInfoView.loadFromNibNamed("POInfoView")!
        let poInfoView3 = POInfoView.loadFromNibNamed("POInfoView")!
        let poInfoView4 = POInfoView.loadFromNibNamed("POInfoView")!
        poInfoView.frame = CGRect(x: 0, y: 0, width: 768, height: 105)
        poInfoView2.frame = CGRect(x: 0, y: 105, width: 768, height: 105)
        poInfoView3.frame = CGRect(x: 0, y: 210, width: 768, height: 105)

        taskQCInfoView.poView.addSubview(poInfoView)
        taskQCInfoView.poView.addSubview(poInfoView2)
        taskQCInfoView.poView.addSubview(poInfoView3)
   
        taskQCInfoView.poView.frame.size = CGSize(width: 768, height: 420)
        /*
        taskQCInfoView.poView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 9.0, *) {
            taskQCInfoView.poView.heightAnchor.constraintEqualToConstant(420).active = true
        } else {
            // Fallback on earlier versions
        }*/
        
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