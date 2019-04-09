//
//  ScanVC.swift
//  ScannerAutofocus
//
//  Created by Thomas Haider on 16.12.18.
//  Copyright © 2018 Totta Gmbh. All rights reserved.
//

import UIKit
import AVKit
import  AVFoundation

class ScanVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var lbl : UILabel!
    @IBOutlet weak var preView : UIView!
    @IBOutlet weak var btn : UIButton!
    
    var captureSession = AVCaptureSession()
    var previewLayer = AVCaptureVideoPreviewLayer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn.isEnabled = false
        let device : AVCaptureDevice!
        device = AVCaptureDevice.default(for: AVMediaType.video)
        if device == nil {exit(EXIT_FAILURE)}
        do {
            try device.lockForConfiguration()
            device.focusPointOfInterest = CGPoint(x: 0.5, y: 0.5)
            device.autoFocusRangeRestriction = .near
            device.focusMode = .continuousAutoFocus
            device.unlockForConfiguration()
        } catch {
            print("Kann Fokus nicht einstellen")
        }
        
        let videoInput = try? AVCaptureDeviceInput(device: device)
        if (captureSession.canAddInput(videoInput!)) {
            captureSession.addInput(videoInput!)
        } else {
            print("Kann AVCaptureSession nicht einrichten")
            exit(EXIT_FAILURE)
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.code39, AVMetadataObject.ObjectType.code39Mod43, AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.ean13]
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        } else {
            print("Barcode Scanner kann nicht eingerichtet werden")
            exit(EXIT_FAILURE)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        preView.layer.addSublayer(previewLayer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer.frame = preView.bounds
        captureSession.startRunning()
        
    }
    
    @IBAction func btnPressed() {
        captureSession.startRunning()
        btn.isEnabled = false
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        for metaObj in metadataObjects {
            if let readableObject = metaObj as? AVMetadataMachineReadableCodeObject, let bcode = readableObject.stringValue {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                lbl.text = bcode
                captureSession.stopRunning()
                btn.isEnabled = true
                break
            }
        }
    }
    
}
