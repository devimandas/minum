//
//  SettingsViewController.swift
//  minum
//
//  Created by Devi Mandasari on 29/05/20.
//  Copyright © 2020 Ihwan ID. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    var arrayGender = ["Female", "Male"]
    var picker = UIPickerView()
    var toolBar : UIToolbar = UIToolbar()
    private let authorizeHealthKitSection = 2
    
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var authorizeHK: UISwitch!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayGender.count
    }
    
    @objc func tap(gestureReconizer: UITapGestureRecognizer) {
        print("*")
        picker.isHidden = false
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gender.text = arrayGender[row]
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayGender[row]
    }
    
    private func authorizeHealthKit() {
      
      HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
        
        guard authorized else {
          
          let baseMessage = "HealthKit Authorization Failed"
          
          if let error = error {
            print("\(baseMessage). Reason: \(error.localizedDescription)")
          } else {
            print(baseMessage)
          }
          
          return
        }
        
        print("HealthKit Successfully Authorized.")
      }
      
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        var pickerRect = picker.frame
        pickerRect.origin.x = 0
        pickerRect.origin.y = 204
        picker.frame = pickerRect
        picker.delegate = self
        picker.dataSource = self
        picker.isHidden = true
        view.addSubview(picker)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(gestureReconizer:)))
        gender.addGestureRecognizer(tap)
        gender.isUserInteractionEnabled = true
        
        
        
        age.text = "14"
        gender.text = "Female"
        weight.text = "50"
        height.text = "50"
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      if indexPath.section == authorizeHealthKitSection {
        authorizeHealthKit()
      }
    }
}
