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
import UserNotifications
//import LocalNotificationManager

// for declaration
let defaults = UserDefaults()
var statgender = defaults.string(forKey: "gender")
var statage = defaults.integer(forKey: "age")
var statweight = defaults.string(forKey: "weight")
var statheight = defaults.string(forKey: "height")

//let localnotificationmanager = LocalNotificationManager()

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
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var authorizeHK: UISwitch!
    @IBAction func notification(_ sender: Any) {
        let alertController = UIAlertController(title: "Local Notification", message: nil, preferredStyle: .actionSheet)
        let setLocalNotificationAction = UIAlertAction(title: "Set", style: .default) { (action) in LocalNotificationManager.setNotification(5, of: .seconds, repeats: false, title: "It's time to drink water!", body: "After drinking, touch the cup to confirm", userInfo: ["aps" : ["hello" : "world"]])
        }
//        let removeLocalNotificationAction = UIAlertAction(title: "Remove", style: .default) { (action) in LocalNotificationManager.cancel()
//        }
        
        if ((sender as AnyObject).isOn == true) {
        //Yes
        print("Yes")
           alertController.addAction(setLocalNotificationAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
        //No
        print("No")
           // let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
            //alertController.addAction(removeLocalNotificationAction)
            //alertController.addAction(cancelAction)
        }
    }
    
    @IBAction func fasting(_ sender: Any) {
//        let content = UNMutableNotificationContent()
//        content.title = "Weekly Staff Meeting"
//        content.body = "Every Tuesday at 2pm"
//
//        var dateComponents = DateComponents()
//        dateComponents.calendar = Calendar.current
//
//        dateComponents.weekday = 2  // Tuesday
//        dateComponents.hour = 14    // 14:00 hours
//        dateComponents.minute = 46
//
//        // Create the trigger as a repeating event.
//        let trigger = UNCalendarNotificationTrigger(
//                 dateMatching: dateComponents, repeats: true)
//
//
//        let uuidString = UUID().uuidString
//        let request = UNNotificationRequest(identifier: uuidString,
//                    content: content, trigger: trigger)
//
//        // Schedule the request with the system.
//        let notificationCenter = UNUserNotificationCenter.current()
//        notificationCenter.add(request) { (error) in
//           if error != nil {
//              // Handle any errors.
//           }
//        }
        
        
        if ((sender as AnyObject).isOn == true) {
        print("Yes")
            
            let notification = UILocalNotification()
            
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current

              /* Time and timezone settings */
            notification.fireDate = NSDate(timeIntervalSinceNow: 8.0) as Date
            notification.repeatInterval = NSCalendar.Unit.day
            notification.timeZone = NSCalendar.current.timeZone
              notification.alertBody = "A new item is downloaded."

              /* Action settings */
              notification.hasAction = true
              notification.alertAction = "View"

              /* Badge settings */
              notification.applicationIconBadgeNumber =
                UIApplication.shared.applicationIconBadgeNumber + 1
              /* Additional information, user info */
              notification.userInfo = [
                "Key 1" : "Value 1",
                "Key 2" : "Value 2"
              ]

              /* Schedule the notification */
            UIApplication.shared.scheduleLocalNotification(notification)
            } else {
        print("No")
        }
    }
    
    
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
        print(statage)
        
        if (authorizeHealthKitSection == 0) {
            true
        } else {
         age.text = "\(statage)"
         gender.text = statgender
         weight.text = statweight
         height.text = statheight
        }
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
