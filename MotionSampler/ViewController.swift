//
//  ViewController.swift
//  MotionSampler
//
//  Created by Tyler Angert on 4/11/19.
//  Copyright © 2019 Tyler Angert. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import  CoreMotion

class ViewController: UIViewController, ARSCNViewDelegate,  ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var recording = false
    var currentMotionData = CMDeviceMotion()
    var currentTransform = simd_float4x4()
    let motionManager = CMMotionManager()
    
    // MARK: Visuals
    let materialPrefixes : [String] = ["bamboo-wood-semigloss",
                                       "oakfloor2",
                                       "scuffed-plastic",
                                       "rustediron-streaks"];

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Basic motion data
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startMagnetometerUpdates()
        motionManager.startDeviceMotionUpdates()
        
        
        // AR Delegates
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.showsStatistics = true
        sceneView.scene = sceneView.scene
        
        // Setup background - This will be the beautiful blurred background
        // that assist the user understand the 3D envirnoment
//        let bg = UIImage(named: "sphericalBlurred.png")
//        sceneView.scene.background.contents = bg;
//
//        // Setup Image Based Lighting (IBL) map
//        let env = UIImage(named: "spherical.jpg")
//        sceneView.scene.lightingEnvironment.contents = env
        sceneView.scene.lightingEnvironment.intensity = 2.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - Basic touch actions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        recording = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        recording = false
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard let motionData = motionManager.deviceMotion else { return }
        
        currentTransform = frame.camera.transform
        currentMotionData = motionData
        
        let size: Float = 0.025
        let baseSize: Float = 0.01
        let acc =  motionData.userAcceleration.length()
        let adjustedSize: CGFloat = CGFloat(baseSize + size * acc)
        
        if recording {
            let pyramid =  SCNNode(geometry: SCNPyramid(width: adjustedSize, height: adjustedSize, length: adjustedSize))
            
            // 5 is a  pretty high acceleration value
            pyramid.geometry?.firstMaterial?.diffuse.contents = UIColor.lerp(start: UIColor.white, end: UIColor.red, fraction:CGFloat(acc/5))
            pyramid.simdTransform = currentTransform
            
            sceneView.scene.rootNode.addChildNode(pyramid)
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
