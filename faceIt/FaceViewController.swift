//
//  ViewController.swift
//  FaceIt
//
//  Created by 张经纬 on 2018/6/27.
//  Copyright © 2018 Jingwei Zhang. All rights reserved.
//


import UIKit

@objcMembers
class FaceViewController: VCLLoggingViewController {

    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.changeScale(byReactingTo:)))
            faceView.addGestureRecognizer(pinchRecognizer)
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byReactingTo:)))
            tapRecognizer.numberOfTapsRequired  = 1
            faceView.addGestureRecognizer(tapRecognizer)
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            swipeUpRecognizer.direction = .up
            faceView.addGestureRecognizer(swipeUpRecognizer)
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            swipeDownRecognizer.direction = .down
            faceView.addGestureRecognizer(swipeDownRecognizer)
            
            let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeColor))
            doubleTapRecognizer.numberOfTouchesRequired = 2;
            doubleTapRecognizer.numberOfTapsRequired = 1;
            faceView.addGestureRecognizer(doubleTapRecognizer);
            
            
            
            updateUI()      // called only ones, when iOS hooks up this faceView
        }
    }
    
    var colorChange = 0;
    func changeColor()  {
        colorChange += 1;
        switch colorChange%4 {
        case 0:
            faceView.color = UIColor.blue;
        case 1:
            faceView.color = UIColor.black;
        case 2:
            faceView.color = UIColor.yellow;
        case 3:
            faceView.color = UIColor.red;
        default:
            faceView.color = UIColor.blue;
        }
    }
    
    func increaseHappiness()
    {
        expression = expression.happier
    }
    
    func decreaseHappiness()
    {
        expression = expression.sadder
    }
    
    @IBAction private func toggleEyes(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let eyes: FacialExpression.Eyes = expression.eyes == .closed ? .open : .closed
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }

    var expression = FacialExpression(eyes: .closed, mouth: .frown) {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        switch expression.eyes {
        case .open:
            faceView?.eyesOpen = true   // optional chaining, in case faceView is not yet set.
        case .closed:
            faceView?.eyesOpen = false
        case .squinting:
            faceView?.eyesOpen = false
        }
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
    }

    private let mouthCurvatures: [FacialExpression.Mouth: Double] = [
        .frown: -1.0, .smirk: -0.5, .neutral: 0.0, .grin: 0.5, .smile: 1.0
    ]
    
}

