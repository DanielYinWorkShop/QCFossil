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
    @IBOutlet weak var displayStyleSizeFullTextBtn: UIButton!
    
    var styleSizeLabelText = MylocalizedString.sharedLocalizeManager.getLocalizedString("Style")
    var styleSizeText = ""
    
    override func awakeFromNib() {
        self.backgroundColor = _TABLECELL_BG_COLOR1
    }
    
    override func didMoveToSuperview() {
        self.PONoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("PO No")
        self.SAPPONoLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("SAP PO No")
        self.styleSizeLabel.text = styleSizeLabelText
        self.shipToLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Ship To")
        self.shipModeLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Ship Mode")
        self.retailPriceLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Retail Price")
        self.barcodeLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Barcode")
        
        self.displayStyleSizeFullTextBtn.hidden = true
    }
    
    @IBAction func displayFullTextDidPress(sender: UIButton) {
        
        let popoverContent = PopoverViewController()
        popoverContent.preferredContentSize = CGSizeMake(320,150 + _NAVIBARHEIGHT)
        
        popoverContent.dataType = _POPOVERNOTITLE
        
        switch sender.tag {
        case 1:
            popoverContent.selectedValue = styleSizeText ?? ""
            break
        default:
            popoverContent.selectedValue = styleSizeText ?? ""
            break
        }
        
        
        let nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        nav.navigationBar.barTintColor = UIColor.whiteColor()
        nav.navigationBar.tintColor = UIColor.blackColor()
        
        let popover = nav.popoverPresentationController
        popover!.delegate = sender.parentVC as! PopoverMaster
        popover!.sourceView = sender
        
        
        switch sender.tag {
        default:
            popover!.sourceRect = CGRectMake(0,sender.frame.minY,sender.frame.size.width,sender.frame.size.height)
            break
        }
        
        sender.parentVC!.presentViewController(nav, animated: true, completion: nil)
    }

}