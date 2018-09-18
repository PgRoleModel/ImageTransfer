//
//  ImageTransfer.swift
//  ImageTransfer
//
//  Created by ding qi on 2018/09/17.
//  Copyright © 2018 ding qi. All rights reserved.
//

import UIKit

class ImageTransfer: NSObject {
    
    func transferImage(image: CIImage){
        guard let model = try? VNCoreMLModel(for: XX.model) else {
            fatalError("can't load Places ML model")
        }}
    
    // Create a Vision request with completion handler
    let request = VNCoreMLRequest(model: model) { [weak self] request, error in
        }
}


