//
//  TaskQCInfoView.swift
//  QCFossil
//
//  Created by pacmobile on 19/7/2019.
//  Copyright © 2019 kira. All rights reserved.
//

import UIKit

class TaskQCInfoView: UIView {
    
    @IBOutlet weak var sectionHeaderLabel1: UILabel!
    @IBOutlet weak var sectionHeaderLabel2: UILabel!
    @IBOutlet weak var sectionHeaderLabel3: UILabel!
    @IBOutlet weak var sectionHeaderLabel4: UILabel!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var vendorInput: UITextField!
    @IBOutlet weak var qcInternalNoLabel: UILabel!
    @IBOutlet weak var qcInternalNoInput: UITextField!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var brandInput: UITextField!
    @IBOutlet weak var tsReportNoLabel: UILabel!
    @IBOutlet weak var tsReportNoInput: UITextField!
    @IBOutlet weak var materialCategoryLabel: UILabel!
    @IBOutlet weak var materialCategoryInput: UITextField!
    @IBOutlet weak var assortmentLabel: UILabel!
    @IBOutlet weak var assortmentInput: UITextField!
    @IBOutlet weak var inspectorLabel: UILabel!
    @IBOutlet weak var inspectorInput: UITextField!
    @IBOutlet weak var assortmentStyleLabel: UILabel!
    @IBOutlet weak var assortmentStyleInput: UITextField!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var seasonInput: UITextField!
    @IBOutlet weak var updateTimeLabel: UILabel!
    @IBOutlet weak var updateTimeInput: UITextField!
    @IBOutlet weak var poView: UIView!
    @IBOutlet weak var orderQtyLabel: UILabel!
    @IBOutlet weak var orderQtyInput: UITextField!
    @IBOutlet weak var qualityStardardLabel: UILabel!
    @IBOutlet weak var qualityStardardInput: UITextField!
    @IBOutlet weak var bookedQtyLabel: UILabel!
    @IBOutlet weak var bookedQtyInput: UITextField!
    @IBOutlet weak var markingLabel: UILabel!
    @IBOutlet weak var markingInput: UITextField!
    @IBOutlet weak var aqlQtyLabel: UILabel!
    @IBOutlet weak var aqlQtyInput: UITextField!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var weightInput: UITextField!
    @IBOutlet weak var adjustTimeLabel: UILabel!
    @IBOutlet weak var adjustTimeInput: UITextField!
    @IBOutlet weak var lengthReqLabel: UILabel!
    @IBOutlet weak var lengthReqInput: UITextField!
    @IBOutlet weak var productGradeLabel: UILabel!
    @IBOutlet weak var productGradeInput: UITextField!
    @IBOutlet weak var movtLabel: UILabel!
    @IBOutlet weak var movtInput: UITextField!
    @IBOutlet weak var upcOrbidStatusLabel: UILabel!
    @IBOutlet weak var upcOrbidStatusInput: UITextField!
    @IBOutlet weak var combineQCRemarkLabel: UILabel!
    @IBOutlet weak var combineQCRemarkInput: UITextField!
    @IBOutlet weak var ssReadyLabel: UILabel!
    @IBOutlet weak var ssReadyInput: UITextField!
    @IBOutlet weak var ssCommentReadyLabel: UILabel!
    @IBOutlet weak var ssCommentReadyInput: UITextField!
    @IBOutlet weak var tsSubmitDateLabel: UILabel!
    @IBOutlet weak var tsSubmitDateInput: UITextField!
    @IBOutlet weak var tsResultLabel: UILabel!
    @IBOutlet weak var tsResultInput: UITextField!
    @IBOutlet weak var samePOWithRejectLabel: UILabel!
    @IBOutlet weak var samePOWithRejectInput: UITextField!
    @IBOutlet weak var inspectSampleReadyLabel: UILabel!
    @IBOutlet weak var inspectSampleReadyInput: UITextField!
    @IBOutlet weak var linkTestQtyLabel: UILabel!
    @IBOutlet weak var linkTestQtyInput: UITextField!
    @IBOutlet weak var dustTestQtyLabel: UILabel!
    @IBOutlet weak var dustTestQtyInput: UITextField!
    @IBOutlet weak var smartLinkTestQtyLabel: UILabel!
    @IBOutlet weak var smartLinkTestQtyInput: UITextField!
    @IBOutlet weak var otherTestQtyLabel: UILabel!
    @IBOutlet weak var otherTestQtyInput: UITextField!
    @IBOutlet weak var caFormLabel: UILabel!
    @IBOutlet weak var caFormInput: UITextField!
    @IBOutlet weak var precisionReportLabel: UILabel!
    @IBOutlet weak var precisionReportInput: UITextField!
    @IBOutlet weak var smartLinkReportLabel: UILabel!
    @IBOutlet weak var smartLinkReportInput: UITextField!
    @IBOutlet weak var reliabilityTestRemarkLabel: UILabel!
    @IBOutlet weak var reliabilityTestRemarkInput: UITextField!
    @IBOutlet weak var ftyPackInfoLabel: UILabel!
    @IBOutlet weak var ftyPackInfoInput: UITextField!
    @IBOutlet weak var ftyDroptestInfoLabel: UILabel!
    @IBOutlet weak var ftyDroptestInfoInput: UITextField!

    @IBOutlet weak var caseBackPhoto: UIImageView!
    @IBOutlet weak var salesmanPhoto: UIImageView!

    override func awakeFromNib() {
        self.qcInternalNoInput.userInteractionEnabled = false
    }

}
