//
//  FirstViewController.swift
//  minum
//
//  Created by Ihwan ID on 12/05/20.
//  Copyright © 2020 Ihwan ID. All rights reserved.
//

import UIKit
import WaveAnimationView

var statActivities = defaults.string(forKey: "activities")

class WaterViewController: UIViewController {
    
    @IBOutlet weak var waterVolumeTextField: UITextField!
    @IBOutlet weak var progressDrinks: UILabel!
    @IBOutlet weak var animasiProgres: UILabel!
    @IBOutlet weak var dateWater: UILabel!
    @IBOutlet weak var activitiesButton: UIButton!
    
    
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
    
    // var dateWater: Date
    var selectVolume: String?
    var text:UILabel!
    var name:String!
    var targetDrinks = 2000
    var activities:String?
    
    @IBOutlet weak var lapView: UIView!
    
    var wave: WaveAnimationView!
    
    func createVolumePicker() {
        
        let volumePicker = UIPickerView()
        volumePicker.delegate = self
        
        waterVolumeTextField.inputView = volumePicker
        
        //Customizations
        volumePicker.backgroundColor = .lightGray
    }
    
    func countRumus1() {
        if isAuthorize == true {
            //RUMUS 1 : Usia
            if statage < 17 {
                
                let weightForm = statweight!.replacingOccurrences(of: " kg", with: "")
                var intWeight = Int(weightForm)
                //if intWeight != nil {
                if intWeight! <= 10 {
                    let newWeight = intWeight! * 100
                    intWeight = newWeight
                    newInt = Int(intWeight!)
                } else if intWeight! >= 11 || intWeight! <= 20 {
                    let newWeight = 1000+50*(20 - intWeight!)
                    intWeight = newWeight
                    newInt = Int(intWeight!)
                } else if intWeight! >= 21 || intWeight! <= 70 {
                    let newWeight = 1500+20*(70 - intWeight!)
                    intWeight = newWeight
                    newInt = Int(intWeight!)
                }
                
                // }
            } else if statage > 17 {
                
                let weightForm = statweight!.replacingOccurrences(of: " kg", with: "")
                var intWeight = Int(weightForm)
                let newWeight = 50 * intWeight!
                intWeight = newWeight
                newInt = Int(intWeight!)
            }
            
            //RUMUS 2 : Jenis Kelamin
            print("check : ",newInt)
            if statgender == "Male" {
                let devide = Float(57) / Float(100)
                let test = devide * Float(newInt)
                print("rumus jenis kelamin laki", test)
            } else {
                let devide = Float(55) / Float(100)
                let test = devide * Float(newInt)
                print("rumus jenis kelamin perempuan", test)
            }
            
            //RUMUS 3 : Faktor Aktivitas
            
        
        }
        
    }
    
    
    @objc func createToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        //Customizations
        toolBar.barTintColor = .white
        toolBar.tintColor = .systemBlue
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(finishDrink))
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
    
    @objc func finishDrink(_ sender: Any) {
        
        //self.hapticImpact.impactOccurred()
        
        notification.notificationOccurred(.success)
        //notificationType The type of notification feedback (success,warning,error).
        
        guard let newData = CoreDataManager.shared.createDrink(amount: selectVolume!) else { return }
        dismissKeyboard()
        //print(newData)
        
    }
    
    @objc private func activitiesTapButton(_ sender: Any){
        let imagePickerController = UIImagePickerController()
        
        //Alert Notification
        let actionSheet = UIAlertController(title: "Add Activities", message: "You must enter an activity type : ", preferredStyle: .alert)
        
        //Photo From Camera
        actionSheet.addAction(UIAlertAction(title: "Strenuous", style: .default, handler: {(action: UIAlertAction) in
            self.activitiesButton.setTitle("Strenuous", for: .normal)
            self.activities = "Strenuous"
            print("tes print activities", self.activities!)
            
            
            //statweight = weightFormatter.string(fromKilograms: Double(weightUH))
            defaults.set(self.activities, forKey: "activities")
        }))
        
        //Photo from Photo Library
        actionSheet.addAction(UIAlertAction(title: "Medium", style: .default, handler: { (action: UIAlertAction) in
            self.activitiesButton.setTitle("Medium", for: .normal)
            self.activities = "Medium"
            print("tes print activities", self.activities!)
            
            defaults.set(self.activities, forKey: "activities")
        }))
        
        //Photo from Photo Library
        actionSheet.addAction(UIAlertAction(title: "Light", style: .default, handler: { (action: UIAlertAction) in
            self.activitiesButton.setTitle("Light", for: .normal)
            self.activities = "Light"
            print("tes print activities", self.activities!)
            
            defaults.set(self.activities, forKey: "activities")
        }))
        
        //Cancel Button
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(actionSheet, animated: true, completion: nil)
        
        
        
        //Popover Position
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func setActivities(){
        if (defaults.object(forKey: "activities") == nil) {
            print("tes activities")
        } else {
            
            activitiesButton.setTitle(statActivities, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setActivities()
        
        print(activities)
        
        
        
        countRumus1()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // formatter.unitsStyle = .full
        dateWater.text = formatter.string(for: self)
        
        
        if isAuthorize == true {
            targetDrinks = 3000
        }
        
        lapView.layer.cornerRadius = lapView.frame.size.width/2
        lapView.clipsToBounds = true
        
        lapView.layer.borderColor = UIColor(rgb: 0x4D80E4).cgColor
        lapView.layer.backgroundColor = UIColor(rgb: 0x253961).cgColor
        lapView.layer.borderWidth = 5.0
        
        //       drinkBtnlbl.layer.cornerRadius = 5
        let drinks = CoreDataManager.shared.fetchDrinks()
        var histories = [History]()
        if drinks!.count != 0 {
            
            histories.append(contentsOf: drinks?.last?.history!.allObjects as! [History])
            let amount = histories.map({$0.amount}).reduce(0, +)
            
            progressDrinks.text = "\(amount)" + " / \(targetDrinks) ml"
            
            
            wave = WaveAnimationView(frame: CGRect(origin: .zero, size: lapView.bounds.size), color: UIColor(rgb: 0x5CC2F4))
            let resultAnimasi = Double((amount))/Double(targetDrinks)
            animasiProgres.text = "\(Int(resultAnimasi * 100))%"
            wave.progress = Float(resultAnimasi)
            lapView.addSubview(wave)
            wave.startAnimation()
        }  else if drinks!.count == 0 {
            
            let amount = 0
            progressDrinks.text = "\(amount)" + " / \(targetDrinks) ml"
            
            
            wave = WaveAnimationView(frame: CGRect(origin: .zero, size: lapView.bounds.size), color: UIColor(rgb: 0x5CC2F4))
            let resultAnimasi = Double((amount))/Double(targetDrinks)
            animasiProgres.text = "\(Int(resultAnimasi * 100))%"
            wave.progress = Float(resultAnimasi)
            lapView.addSubview(wave)
            wave.startAnimation()
            print(amount)
        }
        
        createVolumePicker()
        createToolbar()
        // drinkBtnLbl.layer.cornerRadius = 5
        
        self.activitiesButton.addTarget(self, action: #selector(activitiesTapButton), for: .touchUpInside)
        print(targetDrinks)
    }
    
//    @objc func methodOfReceivedProgress(notification: Notification) {
//        print("Value of notification : ", notification.object ?? "")
//    }
    
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

extension WaterViewController{
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
    
}
