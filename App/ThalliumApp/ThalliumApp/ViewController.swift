//
//  ViewController.swift
//  ThalliumApp
//
//  Created by Saul Rodriguez on 11/30/19.
//  Copyright © 2019 Saul Rodriguez. All rights reserved.
//

import Cocoa
import Metal
import MetalKit

class ViewController: NSViewController
{
    var mtkView: MTKView!
    var renderer: Renderer!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let mtkViewTemp = self.view as? MTKView
        else
        {
            print("View attached to ViewController is not an MTKView!")
            return
        }
        mtkView = mtkViewTemp
        
        guard let defaultDevice = MTLCreateSystemDefaultDevice()
        else
        {
            print("Metal is not supported on this device")
            return
        }
        print("My GPU is: \(defaultDevice)")
        mtkView.device = defaultDevice
        
        guard let tempRenderer = Renderer(mtkView: mtkView)
        else
        {
            print("Renderer failed to initialize")
            return
        }
        renderer = tempRenderer
        
        mtkView.delegate = renderer
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

