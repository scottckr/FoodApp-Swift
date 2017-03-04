//
//  ViewController.swift
//  FoodApp
//
//  Created by Scott Crocker on 2017-02-16.
//  Copyright © 2017 Scott Crocker. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var addFavoriteButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var healthyLabel: UILabel!

    var itemInfo: [String:Any] = [:]
    var favoriteItems : [[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nutrientValues = itemInfo["nutrientValues"] as! [String : Any]
        
        let kcalValue = nutrientValues["energyKcal"] as! Float
        let carbValue = nutrientValues["carbohydrates"] as! Float
        if carbValue > 0 {
            healthyLabel.text = "\((kcalValue/carbValue/2))"
        } else {
            healthyLabel.text = "\((kcalValue/2))"
        }
        
        if let image = UIImage(contentsOfFile: imagePath) {
            imageView.image = image
            print("Image found.")
        } else {
            print("No image found.")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        if UserDefaults.standard.object(forKey: "favoriteItems") != nil {
            favoriteItems = UserDefaults.standard.object(forKey: "favoriteItems") as! [[String : Any]]
        }
        self.title = itemInfo["name"] as! String?
        checkFavorites()
    }
    
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            picker.sourceType = .savedPhotosAlbum
        }
        present(picker, animated: true, completion: nil)
    }
    
    var imagePath : String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory.appending("/\(itemInfo["name"]).png")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        if let data = UIImagePNGRepresentation(image) {
            do {
                let url = URL(fileURLWithPath: imagePath)
                try data.write(to: url)
                print("Saved image to: \(imagePath)")
            } catch let error {
                print("Could not save image: \(error)")
            }
        }
        picker.dismiss(animated: true, completion: nil)
        imageView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func checkFavorites() {
        if favoriteItems.flatMap({$0["name"] as? String}).contains((itemInfo["name"] as? String)!) {
            addFavoriteButton.setTitle("Tillagd i favoriter", for: .disabled)
            addFavoriteButton.isEnabled = false
        } else {
            addFavoriteButton.setTitle("Lägg till i favoriter", for: .normal)
            addFavoriteButton.isEnabled = true
        }
    }

    @IBAction func addToFavorites(_ sender: UIButton) {
        favoriteItems.append(itemInfo)
        UserDefaults.standard.set(favoriteItems, forKey: "favoriteItems")
        UserDefaults.standard.synchronize()
        checkFavorites()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CompareTable" {
            let compareTable = segue.destination as! CompareTableViewController
            compareTable.item1 = itemInfo
        } else {
            let detailVC = segue.destination as! InfoTableViewController
            detailVC.itemInfo = itemInfo
            let nutrientValues = itemInfo["nutrientValues"] as? [String:Float]
            if let kcalValue = nutrientValues?["energyKcal"], let carbValue = nutrientValues?["carbohydrates"] {
                detailVC.healthValue = (kcalValue * carbValue)/2
            }
        }
    }
}

