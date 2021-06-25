//
//  PhotoAlbumCellTableViewCell.swift
//  QCFossil
//
//  Created by pacmobile on 23/12/15.
//  Copyright © 2015 kira. All rights reserved.
//

import UIKit

class PhotoAlbumCellTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var photo: SignoffView!
    @IBOutlet weak var photoFilename: UILabel!
    @IBOutlet weak var photoDescription: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var inspCatLabel: UILabel!
    @IBOutlet weak var inspAreaLabel: UILabel!
    @IBOutlet weak var inspItemLabel: UILabel!
    @IBOutlet weak var photoFilenameLabel: UILabel!
    @IBOutlet weak var inspCatInput: UILabel!
    @IBOutlet weak var inspAreaInput: UILabel!
    @IBOutlet weak var inspItemInput: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.photoDescription.delegate = self
        
        
        updateLocalizeString()
    }

    func updateLocalizeString() {
        
        self.photoFilename.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Photo Filename")
        self.descriptionLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Description")
        self.inspCatLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspect Category")
        self.inspAreaLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspect Area")
        self.inspItemLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Inspect Item")
        self.photoFilenameLabel.text = MylocalizedString.sharedLocalizeManager.getLocalizedString("Photo Filename")
    }

    @IBAction func previewPhoto(_ sender: UIButton) {
        print("preview photo album photos")
        
        if photo.image != nil && photoFilename.text != "" {
            
            let container:UIView = UIView()
            container.tag = _MASKVIEWTAG
            container.isHidden = false
            container.frame = (self.parentVC?.parent!.view.frame)!
            container.center = (self.parentVC?.parent!.view.center)!
            container.backgroundColor = UIColor.clear
            
            let layer = UIView()
            layer.frame = (self.parentVC?.parent!.view.frame)!
            layer.center = (self.parentVC?.parent!.view.center)!
            layer.backgroundColor = UIColor.black
            layer.alpha = 0.7
            container.addSubview(layer)
            
            let image = UIImage(contentsOfFile: Cache_Task_Path!+"/"+photoFilename.text!)
            let imageView = UIImageView(image:image)
            
            //imageView.frame = CGRect(x: 0,y: 0,width: imageView.image!.size.width,height: imageView.image!.size.height)
            imageView.frame = CGRect(x: 0,y: 0,width: 600,height: 800)
            imageView.center = (self.parentVC?.parent!.view.center)!
            
            container.addSubview(imageView)
            
            let button = UIButton(type: UIButtonType.system) as UIButton
            button.frame = (self.parentVC?.parent!.view.frame)!
            button.backgroundColor = UIColor.clear
            button.titleLabel!.font = UIFont(name: "", size: 20)
            button.setTitleColor(UIColor.white, for: UIControlState())
            button.setTitle(MylocalizedString.sharedLocalizeManager.getLocalizedString("Tap Anywhere To Close"), for: UIControlState())
            button.contentEdgeInsets = UIEdgeInsetsMake(400 + (self.parentVC?.parent!.view.center.y)!-30, 0, 0, 0);
            button.addTarget(self, action: #selector(PhotoAlbumCellTableViewCell.closePreviewLayer), for: UIControlEvents.touchUpInside)
            
            container.addSubview(button)
            
            self.parentVC?.parent!.view.addSubview(container)
        }
    }
    
    func closePreviewLayer() {
        let maskView = self.parentVC?.parent!.view.viewWithTag(_MASKVIEWTAG)
        maskView?.removeFromSuperview()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if self.frame.origin.y - (self.parentVC as! PhotoAlbumViewController).photoTableView.contentOffset.y > 350 {
            (self.parentVC as! PhotoAlbumViewController).adjustTableViewPosition()
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("textview changed")
        
        //let photos = Cache_Task_On!.myPhotos//(self.parentVC as! PhotoAlbumViewController).photos
        let photoSetFilter = Cache_Task_On!.myPhotos.filter({$0.photoFile == self.photoFilename.text })
        
        if photoSetFilter.count > 0 {
            let photo = photoSetFilter[0]
            photo.photoDesc = textView.text
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    
}
