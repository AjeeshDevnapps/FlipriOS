//
//  FunCamViewController.swift
//  Musilac-MB
//
//  Created by Benjamin McMurrich on 09/10/2018.
//  Copyright © 2018 I See U. All rights reserved.
//

import UIKit
import AVFoundation

class FunCamViewController: UIViewController {
    
    var temperature = ""
    @IBOutlet weak var closeBtn: UIButton!

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var capturedImageView: UIImageView!
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var snapshotView: UIView!
    
    
    var cameraActionsViewVisible = true
    @IBOutlet weak var cameraActionsView: UIView!
    @IBOutlet weak var previewActionsView: UIView!
    
    let session = AVCaptureSession()
    let photoOutput = AVCapturePhotoOutput()
    let sessionQueue = DispatchQueue(label: "session queue",
                                     attributes: [],
                                     target: nil)
    
    var previewLayer : AVCaptureVideoPreviewLayer!
    var backgroundPreviewLayer : AVCaptureVideoPreviewLayer!
    var videoDeviceInput: AVCaptureDeviceInput!
    var setupResult: SessionSetupResult = .success
    
    enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }
    
    var items = [String]()
    var selectedItemIndex = 0
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let strokeTextAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.strokeColor : UIColor.white,
            NSAttributedString.Key.foregroundColor : UIColor(red: 248/255, green: 58/255, blue: 89/255, alpha: 1),
            NSAttributedString.Key.strokeWidth : -4.0,
        ]
        
        temperatureLabel.attributedText = NSAttributedString(string: temperature, attributes: strokeTextAttributes)
        
        closeBtn.setTitle("Annuler".localized, for: .normal)
        loadFilters()
        
        checkAuthorization()
        
        /*
         Setup the capture session.
         In general it is not safe to mutate an AVCaptureSession or any of its
         inputs, outputs, or connections from multiple threads at the same time.
         
         Why not do all of this on the main queue?
         Because AVCaptureSession.startRunning() is a blocking call which can
         take a long time. We dispatch session setup to the sessionQueue so
         that the main queue isn't blocked, which keeps the UI responsive.
         */
        sessionQueue.async { [unowned self] in
            self.configureSession()
        }
        
        shareButton.layer.cornerRadius = shareButton.bounds.size.width/2
        
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.blurView.alpha = 0
        })
        
        sessionQueue.async {
            switch self.setupResult {
            case .success:
                // Only start the session running if setup succeeded.
                DispatchQueue.main.async { [unowned self] in
                    self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                    self.previewLayer.frame = self.previewView.bounds
                    self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    self.previewView.layer.addSublayer(self.previewLayer)
                    self.session.startRunning()
                }
                
            case .notAuthorized:
                DispatchQueue.main.async { [unowned self] in
                    let changePrivacySetting = "AVCam doesn't have permission to use the camera, please change privacy settings"
                    let message = NSLocalizedString(changePrivacySetting, comment: "Alert message when the user has denied access to the camera")
                    let alertController = UIAlertController(title: "Flipr", message: message, preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                            style: .cancel,
                                                            handler: nil))
                    
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"),
                                                            style: .`default`,
                                                            handler: { _ in
                                                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    }))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
            case .configurationFailed:
                DispatchQueue.main.async { [unowned self] in
                    let alertMsg = "Alert message when something goes wrong during capture session configuration"
                    let message = NSLocalizedString("Unable to capture media", comment: alertMsg)
                    let alertController = UIAlertController(title: "Flipr", message: message, preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                            style: .cancel,
                                                            handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if setupResult == .notAuthorized {
            
            UIView.animate(withDuration: 1, animations: {
                
            }) { (success) in
                let alertController = UIAlertController(title:"Réglage nécessaire !", message: "Vous devez autoriser l'app à accéder à l'appareil pour prendre une photo.", preferredStyle: UIAlertController.Style.alert)
                
                let doneAction =  UIAlertAction(title: "Réglages", style: .cancel)
                {
                    (result : UIAlertAction) -> Void in
                    
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                    
                }
                
                let cancelAction =  UIAlertAction(title: "Fermer", style: .default)
                alertController.addAction(doneAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
        
        self.view.bringSubviewToFront(temperatureLabel)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sessionQueue.async { [unowned self] in
            if self.setupResult == .success {
                self.session.stopRunning()
            }
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.blurView.alpha = 1
        })
        
        super.viewWillDisappear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        
        if capturedImageView.image != nil {
            
            if let image = snapshotView.snapshot() {
                var items:[Any] = [image, "#flipr"]
                if let jpgImage = image.jpegData(compressionQuality: 0.8) {
                    items = [jpgImage]
                }
                let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
                self.present(vc, animated: true)
            }
            
        }
        
    }
    
    
    
    // MARK: Filter Management
    
    func loadFilters() {
        
        items = ["funcam1"]
        self.filterImageView.image = UIImage(named: items[selectedItemIndex])
        self.view.bringSubviewToFront(temperatureLabel)
        /*
        let query = PFQuery(className:className).includeKey("media")
        query.cachePolicy = .cacheThenNetwork
        query.whereKey("status", equalTo: "published")
        query.order(byAscending: "order")
        query.findObjectsInBackground { (objects, error) in
            print("Filter objects: \(objects)")
            if let objects = objects {
                self.items = objects
                if self.selectedItemIndex < self.items.count {
                    let item = self.items[self.selectedItemIndex]
                    if let media = item["media"] as? PFObject {
                        if let file = media["file"] as? PFFileObject {
                            if let url = file.url {
                                self.filterImageView.kf.setImage(with: URL(string: url)!)
                            }
                        }
                    }
                }
                self.collectionView.reloadData()
            } else {
                print("Filter item Error :\(error)")
            }
        }*/
    }
    
    // MARK: Session Management

    func checkAuthorization() {
        /*
         Check video authorization status. Video access is required and audio
         access is optional. If audio access is denied, audio is not recorded
         during movie recording.
         */
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            // The user has previously granted access to the camera.
            break
            
        case .notDetermined:
            /*
             The user has not yet been presented with the option to grant
             video access. We suspend the session queue to delay session
             setup until the access request has completed.
             
             Note that audio access will be implicitly requested when we
             create an AVCaptureDeviceInput for audio during session setup.
             */
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [unowned self] granted in
                if !granted {
                    self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            })
            
        default:
            // The user has previously denied access.
            setupResult = .notAuthorized
            
        }
    }
    
    private func configureSession() {
        if setupResult != .success {
            return
        }
        
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.photo
        
        // Add video input.
        do {
            var defaultVideoDevice: AVCaptureDevice?
            
            // PAR défuat on ouvre sur les selfies, sinon on suit le code d'origni
            if let frontCameraDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
                defaultVideoDevice = frontCameraDevice
            } else {
                // Choose the back dual camera if available, otherwise default to a wide angle camera.
                let dualCameraDeviceType: AVCaptureDevice.DeviceType
                if #available(iOS 11, *) {
                    dualCameraDeviceType = .builtInDualCamera
                } else {
                    dualCameraDeviceType = .builtInDuoCamera
                }
                
                if let dualCameraDevice = AVCaptureDevice.default(dualCameraDeviceType, for: AVMediaType.video, position: .back) {
                    defaultVideoDevice = dualCameraDevice
                } else if let backCameraDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
                    // If the back dual camera is not available, default to the back wide angle camera.
                    defaultVideoDevice = backCameraDevice
                } else if let frontCameraDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: .front) {
                    /*
                     In some cases where users break their phones, the back wide angle camera is not available.
                     In this case, we should default to the front wide angle camera.
                     */
                    defaultVideoDevice = frontCameraDevice
                }
        
            }
            
            let videoDeviceInput = try AVCaptureDeviceInput(device: defaultVideoDevice!)
            
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
                
            } else {
                print("Could not add video device input to the session")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
        } catch {
            print("Could not create video device input: \(error)")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        
        // Add photo output.
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
            
            photoOutput.isHighResolutionCaptureEnabled = true
            photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported
        } else {
            print("Could not add photo output to the session")
            setupResult = .configurationFailed
            session.commitConfiguration()
            return
        }
        
        session.commitConfiguration()
    }
    
    @IBAction func switchActionsView(sender: Any) {
        
        if cameraActionsViewVisible {
            UIView.animate(withDuration: 0.25, animations: {
                self.cameraActionsView.alpha = 0
            }) { (success) in
                UIView.animate(withDuration: 0.25, animations: {
                    self.previewActionsView.alpha = 1
                }) { (success) in
                    self.cameraActionsViewVisible = false
                }
            }
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.previewActionsView.alpha = 0
                self.blurView.alpha = 1
            }) { (success) in
                self.capturedImageView.image = nil
                UIView.animate(withDuration: 0.25, animations: {
                    self.cameraActionsView.alpha = 1
                    self.blurView.alpha = 0
                }) { (success) in
                    self.cameraActionsViewVisible = true
                }
            }
        }
        
        
    }
    
    @IBAction func switchCameraTapped(sender: Any) {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.blurView.alpha = 1
        }) { (success) in
            
            self.session.beginConfiguration()
            
            //Remove existing input
            guard let currentCameraInput: AVCaptureInput = self.session.inputs.first else {
                return
            }
            
            self.session.removeInput(currentCameraInput)
            
            //Get new input
            var newCamera: AVCaptureDevice! = nil
            if let input = currentCameraInput as? AVCaptureDeviceInput {
                if (input.device.position == .back) {
                    newCamera = self.cameraWithPosition(position: .front)
                } else {
                    newCamera = self.cameraWithPosition(position: .back)
                }
            }
            
            //Add input to session
            var err: NSError?
            var newVideoInput: AVCaptureDeviceInput!
            do {
                newVideoInput = try AVCaptureDeviceInput(device: newCamera)
            } catch let err1 as NSError {
                err = err1
                newVideoInput = nil
            }
            
            if newVideoInput == nil || err != nil {
                print("Error creating capture device input: \(err?.localizedDescription)")
            } else {
                self.session.addInput(newVideoInput)
            }
            
            //Commit all the configuration changes at once
            self.session.commitConfiguration()
            
            
            UIView.animate(withDuration: 0.25, animations: {
                self.blurView.alpha = 0
            }) { (success) in
            }
        }
        
    }
    
    // Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }
        
        return nil
    }
    
    @IBAction private func capturePhoto(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.10, animations: {
            self.blurView.alpha = 1
        }) { (success) in
            UIView.animate(withDuration: 0.10, animations: {
                self.blurView.alpha = 0
            })
        }
        
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isHighResolutionPhotoEnabled = true
        if self.videoDeviceInput.device.isFlashAvailable {
            photoSettings.flashMode = .auto
        }
        
        let settings = AVCapturePhotoSettings()
        guard let previewPixelType = settings.__availablePreviewPhotoPixelFormatTypes.first else { return }
        let previewFormat = [
            kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
            kCVPixelBufferWidthKey as String: 160,
            kCVPixelBufferHeightKey as String: 160
        ]
        settings.previewPhotoFormat = previewFormat
        
        /*
        if let firstAvailablePreviewPhotoPixelFormatTypes = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: firstAvailablePreviewPhotoPixelFormatTypes]
        }
        */
        
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

}

// MARK: - AVCapturePhotoCaptureDelegate Methods
extension FunCamViewController: AVCapturePhotoCaptureDelegate {
    
    /*
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let error = error {
            print("Error capturing photo: \(error)")
        } else {
            if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
                
                if let image = UIImage(data: dataImage) {
                    
                    guard let currentCameraInput: AVCaptureInput = session.inputs.first else {
                        self.capturedImageView.image = image
                        return
                    }
                    if let input = currentCameraInput as? AVCaptureDeviceInput {
                        if (input.device.position == .front) {
                            let reversedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .leftMirrored)
                            self.capturedImageView.image = reversedImage
                        } else {
                            self.capturedImageView.image = image
                        }
                    }
                }
                
            }
        }
        
    }
    */
    
    @available(iOS 11.0, *)
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let data = photo.fileDataRepresentation(),
            let image =  UIImage(data: data)  else {
                return
        }
        
        guard let currentCameraInput: AVCaptureInput = session.inputs.first else {
            self.capturedImageView.image = image
            return
        }
        if let input = currentCameraInput as? AVCaptureDeviceInput {
            if (input.device.position == .front) {
                let reversedImage = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .leftMirrored)
                self.capturedImageView.image = reversedImage
            } else {
                self.capturedImageView.image = image
            }
            collectionView.reloadData()
            switchActionsView(sender: self)
        }
    }
}


// MARK: - UICollectionView  Methods
extension FunCamViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath)
        
        let item = self.items[indexPath.row]
        
        if let view = cell.viewWithTag(3) {
            if indexPath.row == selectedItemIndex {
                view.isHidden = false
                view.backgroundColor = .clear
                view.clipsToBounds = true
                view.layer.borderColor = UIColor.white.cgColor
                view.layer.borderWidth = 2
                view.layer.cornerRadius = 10
            } else {
                view.isHidden = true
            }

        }
        
        if let imageView = cell.viewWithTag(1) as? UIImageView {
            imageView.layer.cornerRadius = 7
            if let capturedImage = capturedImageView.image {
                imageView.image = capturedImage
            }
        }
        
        if let imageView = cell.viewWithTag(2) as? UIImageView {
            imageView.layer.cornerRadius = 7
            imageView.image = UIImage(named: item)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedItemIndex = indexPath.row
        
        let item = self.items[indexPath.row]
        
        filterImageView.image = UIImage(named: item)
        
        collectionView.reloadData()
    }

}

extension UIView {
    func snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
