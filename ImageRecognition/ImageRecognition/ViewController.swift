//
//  ViewController.swift
//  ImageRecognition
//
//  Created by chen Ivan on 2020/12/5.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

  @IBOutlet weak var imageView: UIImageView!
  
  let imagePicker = UIImagePickerController()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    imagePicker.delegate = self
    imagePicker.sourceType = .camera
    imagePicker.allowsEditing = false
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let userPickeredImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      imageView.image = userPickeredImage
      
      guard let ciimage = CIImage(image: userPickeredImage) else {
        fatalError("Could not convert UIImage into CIMIMage")
      }
      
      detect(image: ciimage)
    }
    
    imagePicker.dismiss(animated: true, completion: nil)
  }
  
  func detect(image: CIImage) {
    guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
      fatalError("Loading CoreML Model Failed.")
    }
    
    let request = VNCoreMLRequest(model: model) { (request, error) in
      guard let results = request.results as? [VNClassificationObservation] else {
        fatalError("Model failed to process image.")
      }
      
      if let firstResult = results.first {
        if firstResult.identifier.contains("hotdog") {
          self.navigationItem.title = "Hotdog"
        } else {
          self.navigationItem.title = "Not Hotdog"
        }
      }
    }
    
    let handler = VNImageRequestHandler(ciImage: image)
    
    do {
      try handler.perform([request])
    } catch {
      print(error)
    }
  }
  
  @IBAction func tappedCamera(_ sender: UIBarButtonItem) {
    present(imagePicker, animated: true, completion: nil)
  }
}

