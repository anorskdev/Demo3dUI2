//
//  ContentView.swift
//  Demo3dUI2
//
//  Created by Allen Norskog on 10/29/23.
//

import SwiftUI
import SceneKit

struct ContentView: View {
    let sceneView =  SCNView()
    let cameraNode = SCNNode()
    var baseNode = SCNNode()
    var scene = SCNScene(named: "art.scnassets/ship.scn") // SCNScene()
    // var scene = SCNScene(named: "art2.scnassets/empty.scn") // SCNScene()

    var body: some View {
        print("Hello")
        return ZStack {
            SceneView(
                scene: sceneSetup(),
                pointOfView: cameraNode,
                options: [
                    // .allowsCameraControl,
                    .autoenablesDefaultLighting
                ]
            ).ignoresSafeArea()
            VStack  {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        cameraNode.position.z += 1
                        // print("Button tapped")
                    }, label: {
                        Image(systemName: "move.3d")
                            .resizable()
                            .frame(width: 80, height: 80)
                    })
                }
            }

        }

    }

    func sceneSetup() -> SCNScene {
        // add to an SCNView
        print("sceneSetup")
        sceneView.scene = scene

        // add the container node containing all model elements
        sceneView.scene!.rootNode.addChildNode(baseNode)

        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 2)
        scene?.rootNode.addChildNode(cameraNode)


        // view the scene through your camera
        sceneView.pointOfView = cameraNode

        // add gesture recognizers here

        let geoNode = setupGeometry()
        scene?.rootNode.addChildNode(geoNode)

        return scene!
    }

    func setupGeometry() -> SCNNode {
        var vertices: [SCNVector3] = []

        let sf = 1 // Scale factor
        let sf2: Float = 0.1
        for i in 0...9 {
            for j in 0...9 {
                vertices.append(SCNVector3(x: Float(i * sf) * sf2, y: Float(-j * sf) * sf2, z: -2))
            }
        }

        let vertexSource = SCNGeometrySource(vertices: vertices)

        // Faces
        //let indices: [Int32] = [4,4,4,4, 0,1,4,3, 1,2,5,4, 3,4,7,6, 4,5,8,7  ]

        var indices:   [Int32] = []

        // Number of vertices for each polygon first (4 for quad mesh)
        for _ in 0..<(9 * 9) {
            indices.append(4)
        }
        // Followed by index to polygon vertices.
        for i in 0...8 {
            for j in 0...8 {
                indices.append(Int32((i * 10) + j))
                indices.append(Int32((i * 10) + j + 1))
                indices.append(Int32(((i + 1) * 10) + j + 1))
                indices.append(Int32(((i + 1) * 10) + j))
            }
        }

        let indexData = Data(bytes: indices, count: indices.count * MemoryLayout<Int32>.size)
        let indexElement = SCNGeometryElement(data: indexData,
                                              primitiveType: SCNGeometryPrimitiveType.polygon,
                                              primitiveCount: indices.count / 5,
                                              bytesPerIndex: MemoryLayout<Int32>.size)

        // Normals

        var normals: [SCNVector3] = []
        for i in 0...9 {
            for j in 0...9 {
                normals.append(SCNVector3(x: 0, y: 0, z: 1))
                if i == 9 && j == 9 { print()}
            }
        }

        let normalSource = SCNGeometrySource(normals: normals)

        // Materials
        let imageMaterial = SCNMaterial()
        imageMaterial.diffuse.contents = UIImage(named: "waves")

        let whiteMaterial = SCNMaterial()
        whiteMaterial.diffuse.contents = UIColor.white

        // Geometry
        let shapeGeometry: SCNGeometry

        shapeGeometry = SCNGeometry(sources: [vertexSource, normalSource], elements: [indexElement])
        // shapeGeometry = SCNGeometry(sources: [vertexSource], elements: [indexElement])
        shapeGeometry.materials = [whiteMaterial]

        let shapeNode = SCNNode(geometry: shapeGeometry)
        shapeNode.position = SCNVector3(0, 0, 0)
        shapeNode.name = "geoMesh"

        return shapeNode

//        if let root = scene?.rootNode {
//            // NOTE: first node used by camera from setupCamera().
//            if root.childNodes.count < 4 {
//                root.addChildNode(shapeNode)
//            } else {
//                root.replaceChildNode(root.childNodes[3], with: shapeNode)
//            }
//        }

    }
}

//    struct ContentView_Previews: PreviewProvider {
//        static var previews: some View {
//            ContentView()
//        }
//    }
