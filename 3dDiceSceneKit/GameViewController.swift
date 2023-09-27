//
//  GameViewController.swift
//  3dDiceSceneKit
//
//  Created by shelby gold on 9/27/23.
//

import UIKit

import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    
    var gameView: SCNView!
    var gameScene: SCNScene!
    var cameraNode:SCNNode!
    var targetCreationTime: TimeInterval = 0
    var physicsField:SCNPhysicsField!
   
    let sideOne = UIImage(imageLiteralResourceName: "DiceOne")
    let sideTwo = UIImage(imageLiteralResourceName: "DiceTwo")
    let sideThree = UIImage(imageLiteralResourceName: "DiceThree")
    let sideFour = UIImage(imageLiteralResourceName: "DiceFour")
    let sideFive = UIImage(imageLiteralResourceName: "DiceFive")
    let sideSix = UIImage(imageLiteralResourceName: "DiceSix")

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initScene()
        initCamera()
        initField()
       
    }
    
    func initView(){
        gameView = self.view as? SCNView
        gameView.allowsCameraControl = false
        gameView.autoenablesDefaultLighting = true
        gameView.delegate = self
    }
    
    func initScene() {
        gameScene = SCNScene()
        gameView.scene = gameScene
        gameView.isPlaying = true
        createBox()
        createDice()
        createDice()
    }
    func initField() {
        physicsField = SCNPhysicsField()
        physicsField.isActive = true
    }
    
    func initCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 11, z: 0)
        //cameraNode.camera?.automaticallyAdjustsZRange = true
        gameScene.rootNode.addChildNode(cameraNode)
        cameraNode.eulerAngles = SCNVector3Make(-1.575, 0, 0)    }
    
    func assignDiceFace(faceImage: UIImage) -> SCNMaterial{
        let material = SCNMaterial()
        material.locksAmbientWithDiffuse = true
        material.isDoubleSided = false
        material.diffuse.contents = faceImage
        material.ambient.contents = UIColor.white
        return material
    }
    func createDice() {
        
        let dice: SCNGeometry = SCNBox(width: 1.5, height: 1.5, length: 1.5, chamferRadius: 0.15)
        dice.materials.first?.diffuse.contents = UIColor.white
        dice.firstMaterial?.lightingModel = .blinn
        dice.firstMaterial?.diffuse.intensity = 1
        dice.firstMaterial?.shininess = 2
        dice.firstMaterial?.lightingModel = .blinn
        
        let geometruNode = SCNNode(geometry: dice)
        geometruNode.geometry?.materials = [assignDiceFace(faceImage: sideOne),assignDiceFace(faceImage: sideTwo), assignDiceFace(faceImage: sideThree), assignDiceFace(faceImage: sideFour), assignDiceFace(faceImage: sideFive), assignDiceFace(faceImage: sideSix)]
//        let radialGravityField = SCNPhysicsField.linearGravity()
//        geometruNode.physicsField = radialGravityField
        geometruNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        //radialGravityField.strength = 0.5
        
        geometruNode.physicsBody?.friction = 0.5
        geometruNode.physicsBody?.damping = 0
        geometruNode.name = "Dice"
        gameScene.rootNode.addChildNode(geometruNode)
        
        
        let randomXDirection: Float = arc4random_uniform(2) == 0 ? -4 : 4
        let randomYDirection: Float = arc4random_uniform(2) == 0 ? -4 : 4
        let force = SCNVector3(x: randomXDirection, y: 2, z: randomYDirection)
        geometruNode.physicsBody?.applyForce(force, at: SCNVector3(-0.1, 0.2, 0.07), asImpulse: true)
       
    }
    func createWall(wallPosition: SCNVector3, wallDemensions: SCNGeometry, wallColor: UIColor) -> SCNNode {
        let wall: SCNGeometry = wallDemensions
        wall.firstMaterial?.lightingModel = .constant
        wall.materials.first?.diffuse.contents = wallColor
        let wallNode = SCNNode(geometry: wall)
        wallNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        
        wallNode.physicsBody?.friction = 0.5
        wallNode.physicsBody?.damping = 0.5
        wallNode.position = wallPosition
        return wallNode
    }
    
    
    
    func createBox() {
        let floor: SCNGeometry = SCNFloor()
         
        let floorImage = UIImage(imageLiteralResourceName: "GreenBackground")
       
        floor.firstMaterial?.lightingModel = .constant
        let geometruNode = SCNNode(geometry: floor)
        geometruNode.geometry?.firstMaterial?.shininess = 1
        geometruNode.geometry?.firstMaterial?.clearCoat.intensity = 1
        geometruNode.geometry?.firstMaterial?.clearCoat.contents = UIColor.green
        geometruNode.geometry?.firstMaterial?.specular.contents = .none
        geometruNode.geometry?.firstMaterial?.diffuse.contents = UIColor(named: "Blue5")
        geometruNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        geometruNode.position = SCNVector3(x: 0, y: -2, z: 0)
        gameScene.rootNode.addChildNode(geometruNode)
        
        let rightWall = createWall(wallPosition: SCNVector3(x: 3, y: 0, z: 0), wallDemensions: SCNBox(width: 0.25, height: 15, length: 13.25, chamferRadius: 0.01), wallColor: UIColor(named: "Blue4")!)
        gameScene.rootNode.addChildNode(rightWall)
        let leftWall = createWall(wallPosition: SCNVector3(x: -3, y: 0, z: 0), wallDemensions: SCNBox(width: 0.25, height: 15, length: 13.25, chamferRadius: 0.01), wallColor: UIColor(named: "Blue1")!)
        gameScene.rootNode.addChildNode(leftWall)
        let backWall = createWall(wallPosition: SCNVector3(x: 0, y: 0, z: 6.5), wallDemensions: SCNBox(width: 6.25, height: 15, length: 0.25, chamferRadius: 0.01), wallColor: UIColor(named: "Blue2")!)
        gameScene.rootNode.addChildNode(backWall)
        let frontWall = createWall(wallPosition: SCNVector3(x: 0, y: 0, z: -6.5), wallDemensions: SCNBox(width: 6.25, height: 15, length: 0.25, chamferRadius: 0.01), wallColor: UIColor(named: "Blue3")!)
        gameScene.rootNode.addChildNode(frontWall)
    
    }
    override func becomeFirstResponder() -> Bool {
        return true
    
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let buzzer = UINotificationFeedbackGenerator()
            let nodes = gameScene.rootNode.childNodes
          
            for block in nodes {
                let randomXDirection: Float = arc4random_uniform(2) == 0 ? -4 : 4
                let randomYDirection: Float = arc4random_uniform(2) == 0 ? -4 : 4
                let force = SCNVector3(x: randomXDirection, y: 8, z: randomYDirection)
                block.physicsBody?.applyForce(force, at: SCNVector3(-0.2, 0.2, 0.2), asImpulse: true)
                buzzer.notificationOccurred(.success)
            }
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //cleanUp()
//        let generator = UIImpactFeedbackGenerator(style: .heavy)
        let buzzer = UINotificationFeedbackGenerator()
        let touched = touches.first!
        let location = touched.location(in: gameView)
        let hitList = gameView.hitTest(location, options: nil)
        let nodes = gameScene.rootNode.childNodes
        for block in nodes {
            let randomXDirection: Float = arc4random_uniform(2) == 0 ? -4 : 4
            let randomYDirection: Float = arc4random_uniform(2) == 0 ? -4 : 4
            let force = SCNVector3(x: randomXDirection, y: 8, z: randomYDirection)
            block.physicsBody?.applyForce(force, at: SCNVector3(-0.2, 0.2, 0.2), asImpulse: true)
            
            buzzer.notificationOccurred(.success)
        }
//        if let hitObject = hitList.first {
//            let tappedDiceNode = hitObject.node
//            var floorNode = gameScene.rootNode.childNodes.first
//            if tappedDiceNode.hasActions {
//                tappedDiceNode.isPaused = false
//            } else {
//                tappedDiceNode.isPaused = true
//            }
//            if tappedDiceNode == floorNode {
//                for node in gameScene.rootNode.childNodes {
//                    print(node.name)
//                    if node.name != "Dice" {
//                        
//                    }
//                }
//            }
            
            
            
            
//            }
    }
    func cleanUp() {
        var nodes = gameScene.rootNode.childNodes
        nodes.removeFirst()
        
        let blocks = nodes
        print(blocks)
        for node in nodes {
            
                node.removeFromParentNode()
            
        }
    }
    
    
   
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    @objc func handlePan(panGesture: UIPanGestureRecognizer) {
     
      
        let location = panGesture.location(in: gameView)
        var hitList = gameView.hitTest(location, options: nil)
      switch panGesture.state {
      case .began:
        // existing logic from previous approach. Keep this.
          let hitList = gameView.hitTest(location, options: nil)
        
       // lastPanLocation = hitList.worldCoordinates
      case .changed:
        // This entire case has been replaced
          let worldTouchPosition = gameView.unprojectPoint(hitList.removeFirst().worldCoordinates)
        let movementVector = SCNVector3(
            worldTouchPosition.x - (hitList.first?.node.position.x)!,
          worldTouchPosition.y - (hitList.first?.node.position.y)!,
          worldTouchPosition.z - (hitList.first?.node.position.z)!)
          hitList.first?.node.localTranslate(by: movementVector)
          hitList.first?.node.position = worldTouchPosition
      default:
        break
      }
    }

}
