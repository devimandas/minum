//
//  FirstViewController.swift
//  minum
//
//  Created by Ihwan ID on 12/05/20.
//  Copyright © 2020 Ihwan ID. All rights reserved.
//

import UIKit
import WaveAnimationView

class WaterViewController: UIViewController {

//    @IBOutlet weak var waterVolumeTextField: UITextField!
    @IBOutlet weak var drinkBtnLbl: UIButton!
    @IBOutlet weak var waterVolumeTextField: UITextField!
    @IBOutlet weak var progressDrinks: UILabel!
    @IBOutlet weak var animasiProgres: UILabel!
    
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
    var text:UILabel!
    var name:String!
    var targetDrinks = 2000
    
    @IBOutlet weak var lapView: UIView!
    
    var wave: WaveAnimationView!
    
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
          
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(WaterViewController.dismissKeyboard))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(WaterViewController.dismissKeyboard))

          let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/2, height: 40))
          label.font = UIFont.boldSystemFont(ofSize: 15)
          label.textAlignment = NSTextAlignment.center
          label.text = "Water Volume (ml)"
          label.textColor = .lightGray

          let labelButton = UIBarButtonItem(customView: label)

        toolBar.setItems([cancelButton, labelButton, doneButton], animated: true)
        
          toolBar.isUserInteractionEnabled = true
          
          waterVolumeTextField.inputAccessoryView = toolBar
      }
      
      
      @objc func dismissKeyboard() {
          view.endEditing(true)
      }
    
    //save data and picker to core data
    @IBAction func saveButton(_ sender: Any) {
     
     //self.hapticImpact.impactOccurred()
     
     notification.notificationOccurred(.success)
     //notificationType The type of notification feedback (success,warning,error).
     
     guard let newData = CoreDataManager.shared.createDrink(amount: selectVolume!) else { return }
     
     print(newData)
     
        }
    
     func doneButton(_ sender: Any) {
     
     //self.hapticImpact.impactOccurred()
     
     notification.notificationOccurred(.success)
     //notificationType The type of notification feedback (success,warning,error).
     
     guard let newData = CoreDataManager.shared.createDrink(amount: selectVolume!) else { return }
     
     print(newData)
     
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let objToBeSent = "Save Drinks"
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: objToBeSent)
        
        lapView.layer.cornerRadius = lapView.frame.size.width/2
        lapView.clipsToBounds = true

        lapView.layer.borderColor = UIColor(rgb: 0x4D80E4).cgColor
        lapView.layer.backgroundColor = UIColor(rgb: 0x253961).cgColor
        lapView.layer.borderWidth = 5.0
    
 //       drinkBtnlbl.layer.cornerRadius = 5

        let drinks = CoreDataManager.shared.fetchDrinks()
                var histories = [History]()
                
                for drink in drinks! {
                    histories.append(contentsOf: drink.history!.allObjects as! [History])
                }
                let amount = histories.map({$0.amount}).reduce(0, +)
        //print (drinks?.last?.date ?? amount)
        print(amount)
        
        progressDrinks.text = "\(amount)" + " / \(targetDrinks) ml"
        let resultAnimasi = Double((amount))/Double(targetDrinks)
        animasiProgres.text = "\(Int(resultAnimasi * 100))%"
        
        wave = WaveAnimationView(frame: CGRect(origin: .zero, size: lapView.bounds.size), color: UIColor(rgb: 0x5CC2F4))
        wave.progress = Float(resultAnimasi)
        lapView.addSubview(wave)
               wave.startAnimation()
        
        createVolumePicker()
        createToolbar()
        drinkBtnLbl.layer.cornerRadius = 5
        
        print(amount)
        print(targetDrinks)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        wave.stopAnimation()
    }

}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
    
   
}


//UIPickerview
extension WaterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
