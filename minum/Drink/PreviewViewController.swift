//  PreviewViewController.swift
//  minum
//
//  Created by Edo Lorenza on 29/05/20.
//  Copyright © 2020 Ihwan ID. All rights reserved.
//
import UIKit

class PreviewViewController: UIViewController {
   
   @IBOutlet weak var drinkBtnLbl: UIButton!
   @IBOutlet weak var waterVolumeTextField: UITextField!
    
   let volumes = ["100",
               "200",
               "300",
               "500",
               "600",
               "700",
               "800",
               "900",
               "1000"]
   

//var hapticImpact = UIImpactFeedbackGenerator(style: .heavy)
 let notification = UINotificationFeedbackGenerator()
//A concrete UIFeedbackGenerator subclass that creates haptics to communicate successes, failures, and warnings.
      
   var selectVolume: String?
   var image:UIImage!
   var text:UILabel!
   var name:String!
   
   override func viewDidLoad() {
       super.viewDidLoad()
       createVolumePicker()
       createToolbar()
       drinkBtnLbl.layer.cornerRadius = 5
             
   }
    
      func createVolumePicker() {
            
            let volumePicker = UIPickerView()
            volumePicker.delegate = self
            
            waterVolumeTextField.inputView = volumePicker
            
            //Customizations
            volumePicker.backgroundColor = .lightGray
        }
        
        
        func createToolbar() {
            
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            
            //Customizations
            toolBar.barTintColor = .white
            toolBar.tintColor = .systemBlue
            
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(PreviewViewController.dismissKeyboard))
        
          
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/2, height: 40))
            label.font = UIFont.boldSystemFont(ofSize: 15)
            label.textAlignment = NSTextAlignment.center
            label.text = "Water Volume (ml)"
            label.textColor = .lightGray
            
            let labelButton = UIBarButtonItem(customView: label)
            
            toolBar.setItems([doneButton, labelButton], animated: false)

            toolBar.isUserInteractionEnabled = true
            
            waterVolumeTextField.inputAccessoryView = toolBar
        }
        
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
     

   //save image and picker to core data
   @IBAction func saveButton(_ sender: Any) {
    
    //self.hapticImpact.impactOccurred()
    
    notification.notificationOccurred(.success)
    //notificationType The type of notification feedback (success,warning,error).
    
//    guard let imageToSave = image else {
//               return
//           }
    
    guard let newData = CoreDataManager.shared.createDrink(amount: selectVolume!) else { return }
    
    print(newData)
    
       }

    
}


//UIPickerview
extension PreviewViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return volumes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return volumes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectVolume = volumes[row]
        waterVolumeTextField.text = selectVolume
    }
    
}
