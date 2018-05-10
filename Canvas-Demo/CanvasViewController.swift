//
//  CanvasViewController.swift
//  Canvas-Demo
//
//  Created by Ibukun on 3/26/18.
//  Copyright © 2018 Ibukun. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var trayView: UIView!
    
    let trayDownOffset: CGFloat! = 170
    var trayOriginalCenter: CGPoint!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x, y: trayView.center.y + trayDownOffset)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        
        if sender.state == .began {
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            if trayView.center.y > trayUp.y {
                trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + (translation.y / 10))
            } else  {
                trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            }
        } else if sender.state == .ended {
            if velocity.y > 0 {
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [] ,animations: {
                    self.trayView.center = self.trayDown
                    self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: CGFloat(Double.pi))
                })
            } else {
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [] ,animations: {
                    self.trayView.center = self.trayUp
                     self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: CGFloat(Double.pi))
                })
            }
        }
        
    }
    
    var newFace: UIImageView!
    var newFaceOriginalCenter: CGPoint!
    var imageView: UIImageView!
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            //print("Began: didPan")
            imageView = sender.view as! UIImageView
            newFace = UIImageView(image: imageView.image)
            view.addSubview(newFace)
            newFace.center = imageView.center
            newFace.center.y += trayView.frame.origin.y
            newFaceOriginalCenter = newFace.center
            //Extras
            newFace.transform = CGAffineTransform(scaleX: 2, y: 2)
        } else if sender.state == .changed {
            //print("Changed: didPan")
            
            newFace.center = CGPoint(x: newFaceOriginalCenter.x + translation.x, y: newFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            //print("Ended: didPan")
            //add pan
            let pan_gesture = UIPanGestureRecognizer(target: self, action: #selector(didPanFaceAfterSelection(sender:)))
            pan_gesture.delegate = self
            newFace.addGestureRecognizer(pan_gesture)
            //add pinch
            let pin_gesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinchFace(sender:)))
            pin_gesture.delegate = self
            newFace.addGestureRecognizer(pin_gesture)
            //add rotation
            let rotation_gesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotateFace(sender:)))
            rotation_gesture.delegate = self
            newFace.addGestureRecognizer(rotation_gesture)
            //add double tap
            let double_gesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(sender:)))
            double_gesture.delegate = self
            double_gesture.numberOfTapsRequired = 2
            newFace.addGestureRecognizer(double_gesture)
            newFace.isUserInteractionEnabled = true
            //Scaling
            UIView.animate(withDuration: 0.4, animations: {
                self.newFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
//            print("centerx: \(imageView.center.x+trayView.frame.origin.x) centery: \(imageView.center.y + trayView.frame.origin.y)")
//            print("newFacex: \(newFace.center.x) newFacey: \(newFace.center.y)")
//            if newFace.center.y > trayView.frame.origin.y {
//                //print("delete face")
//                UIView.animate(withDuration: 2, animations: {
//                    self.newFace.transform = self.newFace.transform.translatedBy(x: self.imageView.center.x + self.trayView.frame.origin.x, y: self.imageView.center.y + self.trayView.frame.origin.y)
//                }, completion: { (success) in
//                    self.newFace.removeFromSuperview()
//                    self.newFace = nil
//                    self.trayView.setNeedsDisplay()
//                })
//            }
        }
    }
    
    @objc func didPanFaceAfterSelection(sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            //print("Began: newDidPan")
            newFace = sender.view as! UIImageView
            newFaceOriginalCenter = newFace.center
            newFace.transform = CGAffineTransform(scaleX: 2, y: 2)
        } else if sender.state == .changed {
            //print("Changed: newDidPan")
            newFace.center = CGPoint(x: newFaceOriginalCenter.x + translation.x, y: newFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            //print("Ended: newDidPan")
            UIView.animate(withDuration: 0.4, animations: {
                self.newFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
//            //print("center: \(newFace.center.y) trayView: \(trayView.frame.origin.y)")
//            if newFace.center.y > trayView.frame.origin.y {
//                //print("delete face")
//                UIView.animate(withDuration: 2, animations: {
//                    self.newFace.transform = self.newFace.transform.translatedBy(x: self.imageView.center.x + self.trayView.frame.origin.x, y: self.imageView.center.y + self.trayView.frame.origin.y)
//                }, completion: { (success) in
//                    self.newFace.removeFromSuperview()
//                    self.newFace = nil
//                    self.trayView.setNeedsDisplay()
//                })
//            }
        }
    }
    
    @objc func didPinchFace(sender: UIPinchGestureRecognizer){
        let imageView = sender.view as! UIImageView
        
        if sender.state == .began {
            //let oldTransform = imageView.transform
        } else if sender.state == .changed {
            imageView.transform = imageView.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        } else if sender.state == .ended {
        }
        
    }
    
    @objc func didRotateFace(sender: UIRotationGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        
        if sender.state == .began {
            
        } else if sender.state == .changed {

            imageView.transform = imageView.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        } else if sender.state == .ended {
            
        }
    }
    
    @objc func didDoubleTap(sender: UITapGestureRecognizer){
        let imageView = sender.view as! UIImageView
        imageView.removeFromSuperview()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    

}
