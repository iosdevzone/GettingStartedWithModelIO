//
//  ViewController.swift
//  ModelIOApp
//
//  Created by idz on 5/9/16.
//  Copyright © 2016 iOS Developer Zone.
//  License: MIT
//  See: https://raw.githubusercontent.com/iosdevzone/GettingStartedWithModelIO/master/LICENSE
//

import UIKit
import ModelIO
import SceneKit
import SceneKit.ModelIO

extension MDLMaterial {
    func setTextureProperties(textures: [MDLMaterialSemantic:String]) -> Void {
        for (key,value) in textures {
            guard let url = NSBundle.mainBundle().URLForResource(value, withExtension: "") else {
                fatalError("Failed to find URL for resource \(value).")
            }
            let property = MDLMaterialProperty(name:value, semantic: key, URL: url)
            self.setProperty(property)
        }
    }
}


class ViewController: UIViewController {
    
    var sceneView: SCNView {
        return self.view as! SCNView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the .OBJ file
        guard let url = NSBundle.mainBundle().URLForResource("Fighter", withExtension: "obj") else {
            fatalError("Failed to find model file.")
        }
        
        let asset = MDLAsset(URL:url)
        guard let object = asset.objectAtIndex(0) as? MDLMesh else {
            fatalError("Failed to get mesh from asset.")
        }
        
        // Create a material from the various textures
        let scatteringFunction = MDLScatteringFunction()
        let material = MDLMaterial(name: "baseMaterial", scatteringFunction: scatteringFunction)
        
        material.setTextureProperties([
            .BaseColor:"Fighter_Diffuse_25.jpg",
            .Specular:"Fighter_Specular_25.jpg",
            .Emission:"Fighter_Illumination_25.jpg"])
        
        // Apply the texture to every submesh of the asset
        for  submesh in object.submeshes  {
            if let submesh = submesh as? MDLSubmesh {
                submesh.material = material
            }
        }
        
        // Wrap the ModelIO object in a SceneKit object
        let node = SCNNode(MDLObject: object)
        let scene = SCNScene()
        scene.rootNode.addChildNode(node)
        
        // Set up the SceneView
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        sceneView.scene = scene
        sceneView.backgroundColor = UIColor.blackColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

