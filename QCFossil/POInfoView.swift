//
//  POInfoView.swift
//  QCFossil
//
//  Created by pacmobile on 29/7/2019.
//  Copyright © 2019 kira. All rights reserved.
//

import UIKit

class POInfoView: UIView {

    @IBOutlet weak var PONoLabel: UILabel!
    @IBOutlet weak var PONoDisplay: UILabel!
    @IBOutlet weak var SAPPONoLabel: UILabel!
    @IBOutlet weak var SAPPONoDisplay: UILabel!
    @IBOutlet weak var styleSizeLabel: UILabel!
    @IBOutlet weak var styleSizeDisplay: UILabel!
    @IBOutlet weak var shipToLabel: UILabel!
    @IBOutlet weak var shipToDisplay: UILabel!
    @IBOutlet weak var shipModeLabel: UILabel!
    @IBOutlet weak var shipModeDisplay: UILabel!
    @IBOutlet weak var retailPriceLabel: UILabel!
    @IBOutlet weak var retailPriceDisplay: UILabel!
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var barcodeDisplay: UILabel!
    @IBOutlet weak var topBarLine: UILabel!
    
    override func awakeFromNib() {
        
        
    }
    
    override func didMoveToSuperview() {
        self.PONoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("PO No")
        self.SAPPONoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("SAP PO No")
        self.styleSizeLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Style, Size")
        self.shipToLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Ship To")
        self.shipModeLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Ship Mode")
        self.retailPriceLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Retail Price")
        self.barcodeLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Barcode")
    }
    
}