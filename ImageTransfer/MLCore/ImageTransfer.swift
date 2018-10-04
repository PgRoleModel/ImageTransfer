//
//  ImageTransfer.swift
//  ImageTransfer
//
//  Created by ding qi on 2018/09/17.
//  Copyright © 2018 ding qi. All rights reserved.
//

import UIKit
import CoreML

class ImageTransfer: NSObject {
    
    // image 呼びこみ
    // CIImageに変換
    
    // model定義
    func transferImage(image: CIImage){
        guard let model = try? VNCoreMLModel(for: XX.model) else {
            fatalError("can't load Places ML model")
        }}
    
    // Create a Vision request with completion handler
    let request = VNCoreMLRequest(model: model) { [weak self] request, error in
        }
    
    //
}


