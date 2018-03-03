//
//  CameraViewController.swift
//  QCFossil
//
//  Created by Yin Huang on 1/4/16.
//  Copyright © 2016 kira. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var myView: UIView!
    
    var session: AVCaptureSession?
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureMetadataOutput?
    var prevLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSession()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        prevLayer?.frame.size = myView.frame.size
    }
    
    func createSession() {
        session = AVCaptureSession()
        device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            try input = AVCaptureDeviceInput(device: device)
            session?.addInput(input)
        } catch let error as NSError {
            print("camera input error: \(error)")
        }
        
        prevLayer = AVCaptureVideoPreviewLayer(session: session)
        prevLayer?.frame.size = myView.frame.size
        prevLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        prevLayer?.connection.videoOrientation = transformOrientation(UIInterfaceOrientation(rawValue: UIApplication.sharedApplication().statusBarOrientation.rawValue)!)
        
        myView.layer.addSublayer(prevLayer!)
        
        session?.startRunning()
    }
    
    func cameraWithPosition(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for device in devices {
            if device.position == position {
                return device as? AVCaptureDevice
            }
        }
        return nil
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) -> Void in
            self.prevLayer?.connection.videoOrientation = self.transformOrientation(UIInterfaceOrientation(rawValue: UIApplication.sharedApplication().statusBarOrientation.rawValue)!)
            self.prevLayer?.frame.size = self.myView.frame.size
            }, completion: { (context) -> Void in
                
        })
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    func transformOrientation(orientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation {
        switch orientation {
        case .LandscapeLeft:
            return .LandscapeLeft
        case .LandscapeRight:
            return .LandscapeRight
        case .PortraitUpsideDown:
            return .PortraitUpsideDown
        default:
            return .Portrait
        }
    }
    
    @IBAction func switchCameraSide(sender: AnyObject) {
        if let sess = session {
            let currentCameraInput: AVCaptureInput = sess.inputs[0] as! AVCaptureInput
            sess.removeInput(currentCameraInput)
            var newCamera: AVCaptureDevice
            if (currentCameraInput as! AVCaptureDeviceInput).device.position == .Back {
                newCamera = self.cameraWithPosition(.Front)!
            } else {
                newCamera = self.cameraWithPosition(.Back)!
            }
            
            do {
                let newVideoInput:AVCaptureInput
                try newVideoInput = AVCaptureDeviceInput(device: newCamera)
                session?.addInput(newVideoInput)
            } catch let error as NSError {
                print(error)
            }
            
        }
    }
    
}