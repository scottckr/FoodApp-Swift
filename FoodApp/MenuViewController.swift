//
//  MenuViewController.swift
//  FoodApp
//
//  Created by Scott Crocker on 2017-02-18.
//  Copyright © 2017 Scott Crocker. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var foodstuffLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    
    var dynamicAnimator : UIDynamicAnimator!
    var gravity : UIGravityBehavior!
    var collision : UICollisionBehavior!
    var snapLabel : UISnapBehavior!
    var snapImageView : UISnapBehavior!
    var snapSearchButton : UISnapBehavior!
    var snapFavoritesButton : UISnapBehavior!
    var animationStopped : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dynamicAnimator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [foodstuffLabel, imageView, searchButton, favoritesButton])
        collision = UICollisionBehavior(items: [foodstuffLabel, imageView, searchButton, favoritesButton])
        dynamicAnimator.addBehavior(gravity)
        dynamicAnimator.addBehavior(collision)
        addDynamics()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        animationStopped = false
        
        addDynamics()
        
        shakeLabelAndImage()
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        animationStopped = true
        dynamicAnimator.removeBehavior(gravity)
        dynamicAnimator.removeBehavior(collision)
        dynamicAnimator.removeBehavior(snapFavoritesButton)
        dynamicAnimator.removeBehavior(snapSearchButton)
        dynamicAnimator.removeBehavior(snapLabel)
        dynamicAnimator.removeBehavior(snapImageView)
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func addDynamics() {
        snapImageView = UISnapBehavior(item: imageView, snapTo: CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-400))
        snapLabel = UISnapBehavior(item: foodstuffLabel, snapTo: CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-320))
        snapSearchButton = UISnapBehavior(item: searchButton, snapTo: CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-200))
        snapFavoritesButton = UISnapBehavior(item: favoritesButton, snapTo: CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-150))
        dynamicAnimator.addBehavior(snapLabel)
        dynamicAnimator.addBehavior(snapImageView)
        dynamicAnimator.addBehavior(snapSearchButton)
        dynamicAnimator.addBehavior(snapFavoritesButton)
    }
    
    func shakeLabelAndImage() {
        if !animationStopped {
            let animation = {
                self.foodstuffLabel.transform = self.foodstuffLabel.transform.scaledBy(x: 1.25, y: 1.25)
                self.imageView.transform = self.imageView.transform.scaledBy(x: 1.25, y: 1.25)
            }
            let animation2 = {
                self.foodstuffLabel.transform = self.foodstuffLabel.transform.scaledBy(x: 0.8, y: 0.8)
                self.imageView.transform = self.imageView.transform.scaledBy(x: 0.8, y: 0.8)
            }
            let animation3 = {
                self.foodstuffLabel.transform = self.foodstuffLabel.transform.rotated(by: 0.1)
                self.imageView.transform = self.imageView.transform.rotated(by: 0.1)
            }
            let animation4 = {
                self.foodstuffLabel.transform = self.foodstuffLabel.transform.rotated(by: -0.1)
                self.imageView.transform = self.imageView.transform.rotated(by: -0.1)
            }
            UIView.animate(withDuration: 0.1, delay: 3.0, options: UIViewAnimationOptions.beginFromCurrentState, animations: animation, completion: {
                finished in
                UIView.animate(withDuration: 0.1, animations: animation2, completion: {
                    finished in
                    UIView.animate(withDuration: 0.025, animations: animation3, completion: {
                        finished in
                        UIView.animate(withDuration: 0.025, animations: animation4, completion: {
                            finished in
                            UIView.animate(withDuration: 0.025, animations: animation3, completion: {
                                finished in
                                UIView.animate(withDuration: 0.025, animations: animation4)
                            })
                        })
                    })
                })
                self.shakeLabelAndImage()
            })
        }
    }
}
