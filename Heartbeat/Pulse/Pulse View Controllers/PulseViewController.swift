//
//  PulseViewController.swift
//  Pulse
//
//  Edited by Lexi Diep on 4/3/21.
//

// Original credits go to Athanasios Papazoglou.
// Papazoglou created the original code.
// Copyright © 2020 Athanasios Papazoglou. All rights reserved.

//  All files within Pulse group are used under the MIT copyright guidelines for proper use
//  under the Heartbeat application development.

import UIKit
import AVFoundation

class PulseViewController: UIViewController {
    
    
    @IBOutlet weak var previewLayerShadowView: UIView!
    @IBOutlet weak var previewLayer: UIView!
    @IBOutlet weak var pulseLabel: UILabel!
    @IBOutlet weak var thresholdLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    private var validFrameCounter = 0
    private var heartRateManager: HeartRateManager!
    private var hueFilter = Filter()
    private var pulseDetector = PulseDetector()
    private var inputs: [CGFloat] = []
    private var measurementStartedFlag = false
    private var timer = Timer()
    private var BPMarray: [Int] = []
    private var finalArray: [Int] = []
    private var MAX_COUNT: Float = 25.0
    private var currentCount: Float = 0.0
    var onDoneBlock : ((Bool) -> Void)?
    
    init() {
        super.init(nibName: "PulseViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initVideoCapture()

        thresholdLabel.numberOfLines = 0
        thresholdLabel.text = "Cover the back camera until\nthe image turns red"
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupPreviewView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deinitCaptureSession()
    }
    
    // MARK: - Setup Views
    private func setupPreviewView() {
        previewLayer.layer.cornerRadius = 12.0
        previewLayer.layer.masksToBounds = true
        
        previewLayerShadowView.backgroundColor = .clear
        previewLayerShadowView.layer.shadowColor = UIColor.black.cgColor
        previewLayerShadowView.layer.shadowOpacity = 0.25
        previewLayerShadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        previewLayerShadowView.layer.shadowRadius = 3
        previewLayerShadowView.clipsToBounds = false
    }
    
    // MARK: - Frames Capture Methods
    private func initVideoCapture() {
        let specs = VideoSpec(fps: 30, size: CGSize(width: 300, height: 300))
        heartRateManager = HeartRateManager(cameraType: .back, preferredSpec: specs, previewContainer: previewLayer.layer)
        heartRateManager.imageBufferHandler = { [unowned self] (imageBuffer) in
            self.handle(buffer: imageBuffer)
        }
    }
    
    // MARK: - AVCaptureSession Helpers
    private func initCaptureSession() {
        heartRateManager.startCapture()
    }
    
    private func deinitCaptureSession() {
        heartRateManager.stopCapture()
        toggleTorch(status: false)
    }
    
    private func toggleTorch(status: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        device.toggleTorch(on: status)
    }
    
    // MARK: - Measurement
    private func startMeasurement() {
        if (BPMarray.count < 25) {
            if (self.BPMarray.count == 25) {
                self.toggleTorch(status: false)
                self.dismiss(animated: true, completion: {
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                })
                return
            }

            DispatchQueue.main.async {
                self.toggleTorch(status: true)
            
                self.progressBar.setProgress(self.currentCount, animated: true)
                
            
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (timer) in
                    guard let self = self else { return }
                    let average = self.pulseDetector.getAverage()
                    let pulse = 60.0/average
                    if pulse == -60 {
                        UIView.animate(withDuration: 0.2, animations: {
                            self.pulseLabel.alpha = 0
                        }) { (finished) in
                            self.pulseLabel.isHidden = finished
                        }
                    } else {
                        UIView.animate(withDuration: 0.2, animations: {
                            self.pulseLabel.alpha = 1.0
                        }) { (_) in
                            self.pulseLabel.isHidden = false
                            self.pulseLabel.text = "\(lroundf(pulse)) BPM"
                            if (self.BPMarray.count < 25) {
                                self.BPMarray.append(lroundf(pulse))
                            }
                            
                            self.currentCount += 1
                            if (self.currentCount < 25) {
                                self.perform(#selector(self.updateProgress), with:nil, afterDelay: 1.0)
                            }
                    
                            if (self.BPMarray.count == 25) {
                                self.toggleTorch(status: false)

                                self.onDoneBlock!(true)
                                self.dismiss(animated: true, completion: {
                                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                                })
                                self.toggleTorch(status: false)
                                return
                            }
                        }
                    }
                })
            }
        } // end if BPMarray count is less than 25
        else {
            self.toggleTorch(status: false)
            self.dismiss(animated: true, completion: {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
            return
        }
    }
}


//MARK: - Handle Image Buffer
extension PulseViewController {
    fileprivate func handle(buffer: CMSampleBuffer) {
        var redmean:CGFloat = 0.0;
        var greenmean:CGFloat = 0.0;
        var bluemean:CGFloat = 0.0;
        
        let pixelBuffer = CMSampleBufferGetImageBuffer(buffer)
        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer!)

        let extent = cameraImage.extent
        let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
        let averageFilter = CIFilter(name: "CIAreaAverage",
                              parameters: [kCIInputImageKey: cameraImage, kCIInputExtentKey: inputExtent])!
        let outputImage = averageFilter.outputImage!

        let ctx = CIContext(options:nil)
        let cgImage = ctx.createCGImage(outputImage, from:outputImage.extent)!
        
        let rawData:NSData = cgImage.dataProvider!.data!
        let pixels = rawData.bytes.assumingMemoryBound(to: UInt8.self)
        let bytes = UnsafeBufferPointer<UInt8>(start:pixels, count:rawData.length)
        var BGRA_index = 0
        for pixel in UnsafeBufferPointer(start: bytes.baseAddress, count: bytes.count) {
            switch BGRA_index {
            case 0:
                bluemean = CGFloat (pixel)
            case 1:
                greenmean = CGFloat (pixel)
            case 2:
                redmean = CGFloat (pixel)
            case 3:
                break
            default:
                break
            }
            BGRA_index += 1
        }
        
        let hsv = rgb2hsv((red: redmean, green: greenmean, blue: bluemean, alpha: 1.0))
        // Do a sanity check to see if a finger is placed over the camera
        if (hsv.1 > 0.5 && hsv.2 > 0.5) {
            DispatchQueue.main.async {
                self.thresholdLabel.text = "Try to hold your index finger still\nwhile we calculate your heart rate."
                self.toggleTorch(status: true)
                if !self.measurementStartedFlag {
                    if (self.BPMarray.count <= 25) {
                        self.startMeasurement()
                    }
                    self.toggleTorch(status: false)
                    self.measurementStartedFlag = true
                }
            }
            validFrameCounter += 1
            inputs.append(hsv.0)
            // Filter the hue value - the filter is a simple BAND PASS FILTER that removes any DC component and any high frequency noise
            let filtered = hueFilter.processValue(value: Double(hsv.0))
            if validFrameCounter > 60 {
                self.pulseDetector.addNewValue(newVal: filtered, atTime: CACurrentMediaTime())
            }
        } else {
            validFrameCounter = 0
            measurementStartedFlag = false
            pulseDetector.reset()
            DispatchQueue.main.async {
                self.thresholdLabel.text = "Cover the back camera until the image turns red."
            }
        }
    }
    
    @objc func updateProgress() {

        if BPMarray.count == 25 {
            self.toggleTorch(status: false)
            finalArray = BPMarray
            ((UIApplication.shared.delegate as! AppDelegate).collectedBPM) = finalArray
            currentCount = 0.0
            //return
        }
        else {
            progressBar.progress = currentCount/MAX_COUNT
        }
    }
    
}
