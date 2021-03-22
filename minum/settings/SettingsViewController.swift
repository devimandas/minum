//
//  SettingsViewController.swift
//  minum
//
//  Created by Devi Mandasari on 29/05/20.
//  Copyright © 2020 Ihwan ID. All rights reserved.
//

import Foundation
import UIKit
import HealthKit

// for declaration
let defaults = UserDefaults()
var statgender = defaults.string(forKey: "gender")
var statage = defaults.integer(forKey: "age")
var statweight = defaults.string(forKey: "weight")
var statheight = defaults.string(forKey: "height")

class SettingsViewController: UITableViewController, UIPickerViewDelegate {
   
    
    private let authorizeHealthKitSection = 2
    
    private enum ProfileDataError: Error {
      
      case missingBodyMassIndex
      
      var localizedDescription: String {
        switch self {
        case .missingBodyMassIndex:
          return "Unable to calculate body mass index with available profile data."
        }
      }
    }
    
    private let userHealthProfile = UserHealthProfile()
    
    private func updateHealthInfo() {
      loadAndDisplayAgeSex()
      loadAndDisplayMostRecentWeight()
      loadAndDisplayMostRecentHeight()
    }
    
    private func loadAndDisplayAgeSex() {
      
      do {
        let userAgeSex = try ProfileDataStore.getAgeSex()
        userHealthProfile.ageUH = userAgeSex.ageUH
        userHealthProfile.genderUH = userAgeSex.biologicalSexUH
        updateLabels()
        
      } catch let error {
        self.displayAlert(for: error)
      }
    }
    
    private func updateLabels() {
      
      if let ageUH = userHealthProfile.ageUH {
        
        
        statage = ageUH
        defaults.set(statage, forKey: "age")
        print(statage)
        age.text = "\(statage)"
        
        
      }

      if let biologicalSexUH = userHealthProfile.genderUH {
        gender.text = biologicalSexUH.stringRepresentation
        
        
        statgender = biologicalSexUH.stringRepresentation
        defaults.set(statgender ?? "", forKey: "gender")
        print(statgender)

      }
      
      if let weightUH = userHealthProfile.weightInKilograms {
        let weightFormatter = MassFormatter()
        weightFormatter.isForPersonMassUse = true
        weight.text = weightFormatter.string(fromKilograms: Double(weightUH))
        
        statweight = weightFormatter.string(fromKilograms: Double(weightUH))
        defaults.set(statweight, forKey: "weight")
        print(statweight)
      }

      if let heightUH = userHealthProfile.heightInMeters {
        let heightFormatter = LengthFormatter()
        heightFormatter.isForPersonHeightUse = true
        height.text = heightFormatter.string(fromMeters: Double(heightUH))
        
        statheight = heightFormatter.string(fromMeters: Double(heightUH))
        defaults.set(statheight, forKey: "height")
        print(statheight )
      }
     
    }
    
    private func loadAndDisplayMostRecentHeight() {

      //1. Use HealthKit to create the Height Sample Type
      guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else {
        print("Height Sample Type is no longer available in HealthKit")
        return
      }

      ProfileDataStore.getMostRecentSample(for: heightSampleType) { (sample, error) in

        guard let sample = sample else {

          if let error = error {
            self.displayAlert(for: error)
          }

          return
        }

        //2. Convert the height sample to meters, save to the profile model,
        //   and update the user interface.
        let heightInMeters = sample.quantity.doubleValue(for: HKUnit.meter())
        self.userHealthProfile.heightInMeters = heightInMeters
        self.updateLabels()
        
//        statage = "age"
//        defaults.set(statage, forKey: "age")
//
//        statgender = "gender"
//        defaults.set(statgender, forKey: "gender")
      }
    }
    
    private func loadAndDisplayMostRecentWeight() {

      guard let weightSampleType = HKSampleType.quantityType(forIdentifier: .bodyMass) else {
        print("Body Mass Sample Type is no longer available in HealthKit")
        return
      }

      ProfileDataStore.getMostRecentSample(for: weightSampleType) { (sample, error) in

        guard let sample = sample else {

          if let error = error {
            self.displayAlert(for: error)
          }
          return
        }

        let weightInKilograms = sample.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo))
        self.userHealthProfile.weightInKilograms = weightInKilograms
        self.updateLabels()
        
//        statweight = "weight"
//        defaults.set(statweight, forKey: "weight")
//
//        statheight = "height"
//        defaults.set(statheight, forKey: "height")
      }
    }
    
    
    private func displayAlert(for error: Error) {
      
      let alert = UIAlertController(title: nil,
                                    message: error.localizedDescription,
                                    preferredStyle: .alert)
      
      alert.addAction(UIAlertAction(title: "O.K.",
                                    style: .default,
                                    handler: nil))
      
      present(alert, animated: true, completion: nil)
    }
    
    private enum ProfileSection: Int {
      case ageSex
      case weightHeight
      case readHealthKitData
    }
    
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var gender: UILabel!
  //  Default.set(stat, forKey: "genderUH")
   // Default.set(string, forKey: "gender")
    
    // for update the stat value
    
    
    
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var authorizeHK: UISwitch!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
        //print(statage)
//        updateLabels()
        print(statage)
        age.text = "\(statage)"
        gender.text = statgender
        weight.text = statweight
        height.text = statheight
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        guard let section = ProfileSection(rawValue: indexPath.section) else {
          fatalError("A ProfileSection should map to the index path's section")
        }
        
      if indexPath.section == authorizeHealthKitSection {
        authorizeHealthKit()
      }
        
        switch section {
        case .readHealthKitData:
          updateHealthInfo()
        default: break
        }
    }
}
