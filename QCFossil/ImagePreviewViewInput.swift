//
//  ImagePreviewViewInput.swift
//  QCFossil
//
//  Created by Yin Huang on 21/2/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit

class ImagePreviewViewInput: UIView, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var BackgroundView: UIView!
    weak var parentView:UIView?
    weak var parentImageView:UIImageView?
    weak var parentDefectItem:InputModeDFMaster2?
    var imageName:String?
    var photoIndex:Int?
    var inactiveAlpha:CGFloat = 0.2
    
    @IBOutlet weak var imageView: SignoffView!
    @IBOutlet weak var closeBtn: CustomButton!
    
    //Edit Tools
    @IBOutlet weak var brushColorRed: CustomButton!
    @IBOutlet weak var brushColorBlue: CustomButton!
    @IBOutlet weak var brushColorGreen: CustomButton!
    @IBOutlet weak var brushColorYellow: CustomButton!
    @IBOutlet weak var brushClearBtn: CustomButton!
    @IBOutlet weak var saveImageBtn: CustomButton!
    @IBOutlet weak var startEditBtn: CustomButton!
    @IBOutlet weak var brushSize_s: CustomButton!
    @IBOutlet weak var brushSize_m: CustomButton!
    @IBOutlet weak var brushSize_l: CustomButton!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        imageView.setBrushStyle(CGFloat(_BRUSHSTYLE["red"]!), green: CGFloat(_BRUSHSTYLE["green"]!), blue: CGFloat(_BRUSHSTYLE["blue"]!), brush: CGFloat(_BRUSHSTYLE["brush"]!))
        updateLocalizeString()
        
        self.clipsToBounds = true
    }
    
    func updateLocalizeString() {
        self.startEditBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Edit"), forState: UIControlState.Normal)
        self.closeBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Close")+" X", forState: UIControlState.Normal)
        self.saveImageBtn.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Save"), forState: UIControlState.Normal)
        
        updateBrushColor()
        updateBrushSize()
    }
    
    func updateBrushSize() {
        if _BRUSHSTYLE["brush"] > 5 {
            self.brushSize_l.alpha = 1.0
            self.brushSize_s.alpha = inactiveAlpha
            self.brushSize_m.alpha = inactiveAlpha
        }else if _BRUSHSTYLE["brush"] > 3 {
            self.brushSize_m.alpha = 1.0
            self.brushSize_s.alpha = inactiveAlpha
            self.brushSize_l.alpha = inactiveAlpha
        }else{
            self.brushSize_s.alpha = 1.0
            self.brushSize_m.alpha = inactiveAlpha
            self.brushSize_l.alpha = inactiveAlpha
        }
    }
    
    func updateBrushColor() {
        if _BRUSHSTYLE["red"] > 250 {
            self.brushColorRed.alpha = 1.0
            self.brushColorBlue.alpha = inactiveAlpha
            self.brushColorGreen.alpha = inactiveAlpha
            self.brushColorYellow.alpha = inactiveAlpha
        }else if _BRUSHSTYLE["blue"] > 250 {
            self.brushColorBlue.alpha = 1.0
            self.brushColorRed.alpha = inactiveAlpha
            self.brushColorGreen.alpha = inactiveAlpha
            self.brushColorYellow.alpha = inactiveAlpha
        }else if _BRUSHSTYLE["green"] > 250 {
            self.brushColorGreen.alpha = 1.0
            self.brushColorBlue.alpha = inactiveAlpha
            self.brushColorRed.alpha = inactiveAlpha
            self.brushColorYellow.alpha = inactiveAlpha
        }else{
            self.brushColorYellow.alpha = 1.0
            self.brushColorBlue.alpha = inactiveAlpha
            self.brushColorGreen.alpha = inactiveAlpha
            self.brushColorRed.alpha = inactiveAlpha
        }
    }
    
    func setEnableEditing(enable:Bool) {
        self.brushClearBtn.hidden = enable
        self.brushColorBlue.hidden = enable
        self.brushColorGreen.hidden = enable
        self.brushColorRed.hidden = enable
        self.brushColorYellow.hidden = enable
        self.brushSize_s.hidden = enable
        self.brushSize_m.hidden = enable
        self.brushSize_l.hidden = enable
        self.saveImageBtn.hidden = enable
        self.imageView.userInteractionEnabled = !enable
    }

    override func didMoveToSuperview() {
        setEnableEditing(true)
    }
    
    @IBAction func startEditOnClick(sender: UIButton) {
        /*if self.disableFuns(self) {
            self.alertView(MylocalizedString.sharedLocalizeManager.getLocalizedString("Cannot update Confirmed or Cancelled Task!"))
            return
        }*/
        
        if sender.tag < 1 {
            sender.setTitle("+", forState: UIControlState.Normal)
            sender.tag = 1
            sender.titleLabel?.font = UIFont.systemFontOfSize(30)
            setEnableEditing(false)
            
        }else{
            
            let popoverContent = PopoverViewController()
            popoverContent.preferredContentSize = CGSizeMake(320,240 + _NAVIBARHEIGHT/*350 + _NAVIBARHEIGHT*/)
            
            popoverContent.parentTextFieldView = nil
            popoverContent.sourceType = _SHAPEPREVIEWTYPE
            popoverContent.dataType = _SHAPEDATATYPE
            popoverContent.parentView = self
            
            let nav = UINavigationController(rootViewController: popoverContent)
            nav.modalPresentationStyle = UIModalPresentationStyle.Popover
            nav.navigationBar.barTintColor = UIColor.whiteColor()
            
            let popover = nav.popoverPresentationController
            popover!.delegate = self
            popover!.sourceView = sender //sender.parentVC?.view
            popover!.sourceRect = CGRectMake(sender.frame.minX,sender.frame.minY,sender.frame.size.width,sender.frame.size.height)
            
            sender.parentVC!.presentViewController(nav, animated: true, completion: nil)
            
        }
    }

    @IBAction func closeBtnOnClick(sender: CustomButton) {
        if (self.parentView != nil) {
            self.parentView!.removeFromSuperview()
        }
    }
    
    @IBAction func saveBtnOnClick(sender: CustomButton) {
        self.imageView.image = UIImage.init(view: self.imageView)
        let endEditImage = imageView.saveEndEditImage(imageView.image!)
        //let endEditImageView = UIImageView.init(image: UIImage.init(view: self.imageView))
        let endEditImageView = UIImageView.init(image: endEditImage)
        
        //Update photo to local
        if self.photoIndex >= 0 {
            let photoName = self.parentDefectItem?.photoNameAtIndex[self.photoIndex!]
            var photo = Photo.init(photo: endEditImageView, photoFilename: photoName!, taskId: Cache_Task_On!.taskId!, photoFile: photoName!)
            let photoDataHelper = PhotoDataHelper()
            photo?.photoId = photoDataHelper.getPhotoIdByPhotoName(photoName!)
            
            photo = self.parentDefectItem!.savePhotoToLocal(photo!) //self.parentDefectItem?.savePhotoToLocal(photo!)
            
            //Update photo
            let pathForImage = Cache_Task_Path! + "/" + _THUMBSPHYSICALNAME + "/" + photoName!
            self.parentImageView?.image = UIImage(contentsOfFile: pathForImage)
        }
        
        self.imageView.subviews.forEach({if $0.tag == _SHAPEVIEWTAG {$0.removeFromSuperview()} })
    }

    @IBAction func clearBtnOnClick(sender: CustomButton) {
        //imageDrawView.image = nil
        //Use the Regular Size Image
        let path = Cache_Task_Path!+"/"+imageName!
        imageView.image = UIImage(contentsOfFile: path)
        
        self.imageView.subviews.forEach({if $0.tag == _SHAPEVIEWTAG {$0.removeFromSuperview()} })
    }
    
    @IBAction func setBrushStyle(sender: CustomButton) {
    
        switch sender.tag {
            case 1://red brush
                _BRUSHSTYLE["red"] = 255.0
                _BRUSHSTYLE["green"] = 0.0
                _BRUSHSTYLE["blue"] = 0.0
            
            case 2://blue brush
                _BRUSHSTYLE["red"] = 0.0
                _BRUSHSTYLE["green"] = 0.0
                _BRUSHSTYLE["blue"] = 255.0
            
            case 3://green brush
                _BRUSHSTYLE["red"] = 0.0
                _BRUSHSTYLE["green"] = 255.0
                _BRUSHSTYLE["blue"] = 0.0
            
            case 4://yellow brush
                _BRUSHSTYLE["red"] = 125.0
                _BRUSHSTYLE["green"] = 125.0
                _BRUSHSTYLE["blue"] = 0.0
            
            case 5://bigger brush
                _BRUSHSTYLE["brush"] = 6
            case 6://smaller brush
                _BRUSHSTYLE["brush"] = 4
            case 7://smaller brush
                _BRUSHSTYLE["brush"] = 2
            default://red brush
                _BRUSHSTYLE["red"] = 255.0
                _BRUSHSTYLE["green"] = 0.0
                _BRUSHSTYLE["blue"] = 0.0
        }
        
        updateBrushSize()
        updateBrushColor()
        imageView.setBrushStyle(CGFloat(_BRUSHSTYLE["red"]!), green: CGFloat(_BRUSHSTYLE["green"]!), blue: CGFloat(_BRUSHSTYLE["blue"]!), brush: CGFloat(_BRUSHSTYLE["brush"]!))
    }
    
}
