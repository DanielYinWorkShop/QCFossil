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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prevLayer?.frame.size = myView.frame.size
    }
    
    func createSession() {
        session = AVCaptureSession()
        device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            try input = AVCaptureDeviceInput(device: device)
            session?.addInput(input)
        } catch let error as NSError {
            print("camera input error: \(error)")
        }
        
        prevLayer = AVCaptureVideoPreviewLayer(session: session)
        prevLayer?.frame.size = myView.frame.size
        prevLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        prevLayer?.connection.videoOrientation = transformOrientation(UIInterfaceOrientation(rawValue: UIApplication.shared.statusBarOrientation.rawValue)!)
        
        myView.layer.addSublayer(prevLayer!)
        
        session?.startRunning()
    }
    
    func cameraWithPosition(_ position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        for device in devices! {
            if (device as AnyObject).position == position {
                return device as? AVCaptureDevice
            }
        }
        return nil
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) -> Void in
            self.prevLayer?.connection.videoOrientation = self.transformOrientation(UIInterfaceOrientation(rawValue: UIApplication.shared.statusBarOrientation.rawValue)!)
            self.prevLayer?.frame.size = self.myView.frame.size
            }, completion: { (context) -> Void in
                
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func transformOrientation(_ orientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation {
        switch orientation {
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
    
    @IBAction func switchCameraSide(_ sender: AnyObject) {
        if let sess = session {
            let currentCameraInput: AVCaptureInput = sess.inputs[0] as! AVCaptureInput
            sess.removeInput(currentCameraInput)
            var newCamera: AVCaptureDevice
            if (currentCameraInput as! AVCaptureDeviceInput).device.position == .back {
                newCamera = self.cameraWithPosition(.front)!
            } else {
                newCamera = self.cameraWithPosition(.back)!
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
