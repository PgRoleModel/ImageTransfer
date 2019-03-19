//
//  ViewController.swift
//  ImageTransfer
//
//  Created by ding qi on 2018/09/17.
//  Copyright © 2018 ding qi. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var referenceImageView: UIImageView!
    @IBOutlet weak var resultImageView: UIImageView!
    
    var uiImageViewToSet = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if(uiImageViewToSet != nil){
                self.uiImageViewToSet.contentMode = .scaleAspectFit
                self.uiImageViewToSet.image = pickedImage
            }
        }
        picker.dismiss(animated: true, completion: {
            guard let uiImage = info[UIImagePickerControllerOriginalImage] as? UIImage
                else { fatalError("no image from image picker") }
        })
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func ImageTransfer (orgImage: UIImage?) -> UIImage? {
        let model = TeiStyle1()
        
        
        let styleArray = try? MLMultiArray(shape: [1] as [NSNumber], dataType: .double)
        styleArray?[0] = 1.0
        if orgImage == nil{
            return orgImage
        }
        var retImage = orgImage
        if let image = pixelBuffer(from: orgImage!) {
            do {
                let predictionOutput = try model.prediction(image: image, index: styleArray!)
                
                let ciImage = CIImage(cvPixelBuffer: predictionOutput.stylizedImage)
                let tempContext = CIContext(options: nil)
                let tempImage = tempContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(predictionOutput.stylizedImage), height: CVPixelBufferGetHeight(predictionOutput.stylizedImage)))
                retImage = UIImage(cgImage: tempImage!)
            } catch let error as NSError {
                print("CoreML Model Error: \(error)")
            }
        }
        return retImage
    }
    
    func pixelBuffer(from image:UIImage) -> CVPixelBuffer? {
        // 1
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 256, height: 256), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 256, height: 256))
        _ = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // 2
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, 256, 256, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        // 3
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        // 4
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: 256, height: 256, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        // 5
        context?.translateBy(x: 0, y: 256)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        // 6
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: 256, height: 256))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }

    @IBAction func chooseOriginalImage(_ sender: Any) {
        let c = UIImagePickerController()
        c.delegate = self
        uiImageViewToSet = originalImageView
        present(c, animated: true)
    }
    @IBAction func chooseReferenceImage(_ sender: Any) {
        let c = UIImagePickerController()
        c.delegate = self
        uiImageViewToSet = referenceImageView
        present(c, animated: true)
    }
    @IBAction func transferImage(_ sender: Any) {
        let originalImage = originalImageView.image
        let transferedImage = ImageTransfer(orgImage: originalImage)
        self.resultImageView.image = transferedImage
    }
    
}

