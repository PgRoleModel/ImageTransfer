//
//  ViewController.swift
//  ImageTransfer
//
//  Created by ding qi on 2018/09/17.
//  Copyright © 2018 ding qi. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController, UIPageViewControllerDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPageViewControllerDelegate {

    let idList:[String] = ["original", "style1", "style2", "style3"]
    
    var pageViewController: UIPageViewController!
    var viewControllers: [UIViewController] = []
    
    @IBOutlet weak var selectTab: UISegmentedControl!
    
    
    
    var uiImageViewToSet = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for id in idList{
            viewControllers.append((storyboard?.instantiateViewController(withIdentifier: id))!)
        }
        pageViewController = childViewControllers[0] as! UIPageViewController
        pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: true, completion: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let originalImageVIew = viewControllers[0].view.viewWithTag(10) as! UIImageView
            if(originalImageVIew != nil){
//                uiImageViewToSet.contentMode = .scaleAspectFit
                originalImageVIew.image = pickedImage
            }else{
                viewControllers[0].view.backgroundColor = UIColor.red
            }
            let style1ImageView = viewControllers[1].view.viewWithTag(20) as! UIImageView
            let style2ImageView = viewControllers[2].view.viewWithTag(30) as! UIImageView
            let style3ImageView = viewControllers[3].view.viewWithTag(40) as! UIImageView
            if(style1ImageView != nil && style2ImageView != nil && style3ImageView != nil){
                style1ImageView.image = ImageTransfer1(orgImage: pickedImage)
                style2ImageView.image = ImageTransfer2(orgImage: pickedImage)
                style3ImageView.image = ImageTransfer3(orgImage: pickedImage)
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
    
    func ImageTransfer1 (orgImage: UIImage?) -> UIImage? {
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
    
    func ImageTransfer2 (orgImage: UIImage?) -> UIImage? {
        let model = TeiStyle2()
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
    
    func ImageTransfer3 (orgImage: UIImage?) -> UIImage? {
        let model = TeiStyle3()
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
//        uiImageViewToSet = originalImageView
        present(c, animated: true)
    }
    @IBAction func transferImage(_ sender: Any) {
//        let originalImage = originalImageView.image
//        let transferedImage = ImageTransfer(orgImage: originalImage)
//        style1ImageView.image = transferedImage
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = idList.index(of: viewController.restorationIdentifier!)!
        if(index < idList.count - 1){
            return storyboard!.instantiateViewController(withIdentifier: idList[index+1])
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = idList.index(of: viewController.restorationIdentifier!)!
        if(index > 0){
            return storyboard!.instantiateViewController(withIdentifier: idList[index-1])
        }
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let index = idList.index(of:(pageViewController.viewControllers?.first!.restorationIdentifier)!)
        self.selectTab.selectedSegmentIndex = index!
    }
    
    @IBAction func selectedTab(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex{
        case 0:
            pageViewController.setViewControllers([viewControllers[0]], direction: .reverse, animated: true, completion: nil)
            break
        case 1:
            pageViewController.setViewControllers([viewControllers[1]], direction: .forward, animated: true, completion: nil)
            break
        case 2:
            pageViewController.setViewControllers([viewControllers[2]], direction: .forward, animated: true, completion: nil)
            break
        case 3:
            pageViewController.setViewControllers([viewControllers[3]], direction: .forward, animated: true, completion: nil)
            break
        default:
            return
        }
    }
}

