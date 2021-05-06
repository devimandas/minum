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
var notifications = [Notification]()

var isAuthorize = defaults.bool(forKey: "Authorize")

//let localnotificationmanager = LocalNotificationManager()

var newInt = 0

class SettingsViewController: UITableViewController, UIPickerViewDelegate, ObservableObject {
    
    
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
    
    @IBOutlet weak var notifDaySwitch: UISwitch!
    @IBAction func notifDaySwitch(_ sender: Any) {
        //  notifSwitch.isOn = !notifSwitch.isOn
        // print("tes on off")
        let defaults = UserDefaults.standard
        
        if notifDaySwitch.isOn {
            defaults.set(true, forKey: "notifDaySwitch")
            print("on")
            alarmDayFasting((Any).self)
        } else {
            defaults.set(false, forKey: "notifDaySwitch")
            print("off")
            SettingsViewController.removeLocalNotification()
        }
    }
    
    @IBOutlet weak var notifFastingSwitch: UISwitch!
    @IBAction func notifFastingSwitch(_ sender: Any) {
        // let defaults = UserDefaults.standard
        
        if notifFastingSwitch.isOn {
            defaults.set(true, forKey: "notifFastingSwitch")
            print("on")
            alarmDayFasting((Any).self)
        } else {
            defaults.set(false, forKey: "notifFastingSwitch")
            print("off")
            SettingsViewController.removeLocalNotification()
        }
    }
    
    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .notDetermined:
                break
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break
            }
        }
    }
    func scheduleNotifications() {
        print("scheduled")
        for notification in notifications {
            
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            content.sound = .default
            
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.datetime, repeats: true)
            
            let request = UNNotificationRequest(identifier: notification.title, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                guard error == nil else { return }
                print(error)
            }
        }
    }
    
    public static func removeLocalNotification(){
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    func alarmDayFasting(_ sender: Any) {
        if notifDaySwitch.isOn {
            notifications.append(Notification(title: "Kepala1", body: "alarm pertama", datetime: DateComponents(calendar: Calendar.current, hour: 08, minute: 00)))
            notifications.append(Notification(title: "Kepala2", body: "alarm kedua", datetime: DateComponents(calendar: Calendar.current, hour: 12, minute: 00)))
            notifications.append(Notification(title: "Kepala3", body: "alarm ketiga", datetime: DateComponents(calendar: Calendar.current, hour: 16, minute: 00)))
            
            schedule()
            scheduleNotifications()
            
        }
        
        if notifFastingSwitch.isOn {
            notifications.append(Notification(title: "Kepala1", body: "alarm pertama", datetime: DateComponents(calendar: Calendar.current, hour: 04, minute: 00)))
            notifications.append(Notification(title: "Kepala2", body: "alarm kedua", datetime: DateComponents(calendar: Calendar.current, hour: 18, minute: 30)))
            notifications.append(Notification(title: "Kepala3", body: "alarm ketiga", datetime: DateComponents(calendar: Calendar.current, hour: 21, minute: 00)))
            
            schedule()
            scheduleNotifications()
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
            
            isAuthorize = true
            defaults.set(isAuthorize, forKey: "Authorize")
            print("HealthKit Successfully Authorized.")
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //User default Profile
        if isAuthorize == true {
            age.text = "\(statage)"
            gender.text = statgender
            weight.text = statweight
            height.text = statheight
        }
        
        //User default Notif Day Switch
        if (defaults.object(forKey: "notifDaySwitch") == nil) {
            defaults.bool(forKey: "notifDaySwitch")
        } else {
            (defaults.object(forKey: "notifDaySwitch") != nil)
            notifDaySwitch.isOn = defaults.bool(forKey: "notifDaySwitch")
          //  notifFastingSwitch.isEnabled = false
        }
        
        //User default Notif Fasting Switch
        if (defaults.object(forKey: "notifFastingSwitch") == nil) {
            defaults.bool(forKey: "notifFastingSwitch")
        } else {
            (defaults.object(forKey: "notifFastingSwitch") != nil)
            notifFastingSwitch.isOn = defaults.bool(forKey: "notifFastingSwitch")
            // fasting((Any).self)
        }
        
        //Disable Switch Button
        if notifDaySwitch.isOn {
            notifFastingSwitch!.isOn = false
            notifFastingSwitch.isEnabled = false
        } else if notifFastingSwitch.isOn {
            notifDaySwitch!.isOn = false
            notifDaySwitch.isEnabled = false
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

struct Notification {
    var title: String
    var body:String
    var datetime:DateComponents
}
