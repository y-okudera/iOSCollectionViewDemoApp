//
//  ViewController.swift
//  iOSCollectionViewDemoApp
//
//  Created by YukiOkudera on 2019/02/27.
//  Copyright © 2019 Yuki Okudera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var photoSearchRequest: PhotoSearchRequest?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoSearchRequest = PhotoSearchRequest(page: 1, tags: "dog")
        photoSearchRequest?.delegate = self
        photoSearchRequest?.load()
    }

}

extension ViewController: PhotoSearchProtocol {
    func succeeded(response: PhotoSearchResponse) {
        print("response", response)
    }
    
    func failed(text: String) {
        print("error text", text)
    }
}
