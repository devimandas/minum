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
    
    func rumusSatu(str: Int)->Int {
        if isAuthorize == true {
            //RUMUS 1 : Usia
            if statage < 17 {
                
                guard let weightForm = statweight?.replacingOccurrences(of: " kg", with: "") else { return 0 }
                var intWeight = Int(weightForm)
                //if intWeight != nil {
                if intWeight! <= 10 {
                    let newWeight = intWeight! * 100
                    intWeight = newWeight
                    newInt = Int(intWeight!)
                    return newInt
                } else if intWeight! >= 11 || intWeight! <= 20 {
                    let newWeight = 1000+50*(20 - intWeight!)
                    intWeight = newWeight
                    newInt = Int(intWeight!)
                    return newInt
                } else if intWeight! >= 21 || intWeight! <= 70 {
                    let newWeight = 1500+20*(70 - intWeight!)
                    intWeight = newWeight
                    newInt = Int(intWeight!)
                    return newInt
                }
                
            } else if statage > 17 {
                
                let weightForm = statweight!.replacingOccurrences(of: " kg", with: "")
                var intWeight = Int(weightForm)
                let newWeight = 50 * intWeight!
                intWeight = newWeight
                newInt = Int(intWeight!)
                return newInt
            }
        }
        return 0
    }
    
    func rumusDua(str: String)->Float {
        if isAuthorize == true {
            //RUMUS 2 : Jenis Kelamin
            let weightForm = statweight!.replacingOccurrences(of: " kg", with: "")
            
            if statgender == "Male" {
                let devide = Float(57) / Float(100)
                let test = devide * Float(weightForm)!
                return test
            } else if statgender == "Female"{
                let devide = Float(55) / Float(100)
                let test = devide * Float(weightForm)!
                return test
            }
        }
        return 0
    }
    
    func rumusTiga(str: String)->Float {
        //RUMUS 3 : Faktor Aktivitas : Menentukan Faktor Aktifitas : Menentukan AMB
        var AMB : Double
        var faktorAktivitas : Double
        var totalKalori : Double
        let weightForm = statweight?.replacingOccurrences(of: " kg", with: "")
        let heightForm = statheight?.replacingOccurrences(of: " cm", with: "")
        
        if statgender == "Male" {
            AMB = Double(66.5 + (13.7 * Float(weightForm ?? "Not Set")!)) + (5.0 * Double(Float(heightForm ?? "Not Set")!)) - (6.8 * Double(statage))
            print("hasil male AMB", AMB)
            if (defaults.object(forKey: "activities") == nil) {
                print("tes aktivitas masih kosong")
            } else if (defaults.object(forKey: "activities") as! String == "Strenuous" ) {
                //Faktor Aktivitas Berat
                faktorAktivitas = 2.10
                totalKalori = faktorAktivitas * AMB
                return Float(totalKalori)
            } else if (defaults.object(forKey: "activities") as! String == "Medium" ) {
                //Faktor Aktivitas Sedang
                faktorAktivitas = 1.76
                totalKalori = faktorAktivitas * AMB
                return Float(totalKalori)
            } else if (defaults.object(forKey: "activities") as! String == "Light" ) {
                //Faktor Aktivitas Ringan
                faktorAktivitas = 1.56
                totalKalori = faktorAktivitas * AMB
                return Float(totalKalori)
            }
        } else if statgender == "Female" {
            AMB = Double(66.5 + (9.6 * Float(weightForm ?? "Not Set")!)) + (1.8 * Double(Float(heightForm ?? "Not Set")!)) - (4.7 * Double(statage))
            print("hasil female AMB", AMB)
            if (defaults.object(forKey: "activities") == nil) {
                print("tes aktivitas masih kosong")
            } else if (defaults.object(forKey: "activities") as! String == "Strenuous" ) {
                //Faktor Aktivitas Berat
                faktorAktivitas = 2.00
                totalKalori = faktorAktivitas * AMB
                return Float(totalKalori)
            } else if (defaults.object(forKey: "activities") as! String == "Medium" ) {
                //Faktor Aktivitas Sedang
                faktorAktivitas = 1.70
                totalKalori = faktorAktivitas * AMB
                return Float(totalKalori)
            } else if (defaults.object(forKey: "activities") as! String == "Light" ) {
                //Faktor Aktivitas Ringan
                faktorAktivitas = 1.55
                totalKalori = faktorAktivitas * AMB
                return Float(totalKalori)
            }
        }
        return 0
    }
    
    func rumusEmpat(str: Int)->Int{
        if str < 17 {
            guard let weightForm = statweight?.replacingOccurrences(of: " kg", with: "") else { return 0 }
            var intWeight = Int(weightForm)
            //if intWeight != nil {
            if intWeight! <= 10 {
                let newWeight = intWeight! * 100
                intWeight = newWeight
                newInt = Int(intWeight!)
                return newInt
                
            } else if intWeight! <= 20 {
                let diffWeight = intWeight! - 10
                intWeight = diffWeight
                newInt = Int(intWeight!)
                let aa = (10 * 100) + (newInt * 50)
                return aa
            } else {
                let diffWeight = intWeight! - 20
                intWeight = diffWeight
                newInt = Int(intWeight!)
                let aa = (10 * 100) + (10 * 50) + (newInt * 25)
                return aa
            }
        } else if str > 17 {
            let weightForm = statweight!.replacingOccurrences(of: " kg", with: "")
            var intWeight = Int(weightForm)
            let newWeight = 50 * intWeight!
            intWeight = newWeight
            newInt = Int(intWeight!)
            return newInt
        }
        return statage
    }
    
    func totalKebutuhanMinum() -> Double {
        //Kebutuhan cairan ideal = (Rumus 1 + Rumus 2 + Rumus 3 + Rumus 4) / 4
        //print("rumus1 : ", rumusSatu(str: statage))
      //  print("rumus2 :", rumusDua(str: statgender!))
      //  print("rumus3 :", rumusTiga(str: statgender!))
      //  print("rumus4 :", rumusEmpat(str: statage))
        
        var totalMinum : Double
        totalMinum = (Double(rumusSatu(str: statage)) + Double(rumusDua(str: statgender ?? "Not Set")) + Double(rumusTiga(str: statgender ?? "Not Set")) + Double(rumusEmpat(str: statage))) / 4
        return totalMinum
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
        
        let drinks = CoreDataManager.shared.fetchDrinks()
        var histories = [History]()
            histories.append(contentsOf: drinks?.last?.history!.allObjects as! [History])
            let amount = histories.map({$0.amount}).reduce(0, +)
            
        self.progressDrinks.text = "\(amount)" + " / \(self.targetDrinks) ml"

        //print(newData)
        
    }
    
    @objc private func activitiesTapButton(_ sender: Any){
        if isAuthorize == true {
            let imagePickerController = UIImagePickerController()
            
            //Alert Notification
            let actionSheet = UIAlertController(title: "Add Activities", message: "You must enter an activity type : ", preferredStyle: .alert)
            
            //Photo From Camera
            actionSheet.addAction(UIAlertAction(title: "Strenuous", style: .default, handler: {(action: UIAlertAction) in
                self.activitiesButton.setTitle("Strenuous", for: .normal)
                self.activities = "Strenuous"
               // print("tes print activities", self.activities!)
                
                
                //statweight = weightFormatter.string(fromKilograms: Double(weightUH))
                defaults.set(self.activities, forKey: "activities")
                self.targetDrinks = Int(self.totalKebutuhanMinum())
                let drinks = CoreDataManager.shared.fetchDrinks()
                var histories = [History]()
                    histories.append(contentsOf: drinks?.last?.history!.allObjects as! [History])
                    let amount = histories.map({$0.amount}).reduce(0, +)
                    
                self.progressDrinks.text = "\(amount)" + " / \(self.targetDrinks) ml"
                    
            }))
            
            //Photo from Photo Library
            actionSheet.addAction(UIAlertAction(title: "Medium", style: .default, handler: { (action: UIAlertAction) in
                self.activitiesButton.setTitle("Medium", for: .normal)
                self.activities = "Medium"
               // print("tes print activities", self.activities!)
                
                defaults.set(self.activities, forKey: "activities")
                self.targetDrinks = Int(self.totalKebutuhanMinum())
                let drinks = CoreDataManager.shared.fetchDrinks()
                var histories = [History]()
                    histories.append(contentsOf: drinks?.last?.history!.allObjects as! [History])
                    let amount = histories.map({$0.amount}).reduce(0, +)
                    
                self.progressDrinks.text = "\(amount)" + " / \(self.targetDrinks) ml"
            }))
            
            //Photo from Photo Library
            actionSheet.addAction(UIAlertAction(title: "Light", style: .default, handler: { (action: UIAlertAction) in
                self.activitiesButton.setTitle("Light", for: .normal)
                self.activities = "Light"
               // print("tes print activities", self.activities!)
                
                defaults.set(self.activities, forKey: "activities")
                self.targetDrinks = Int(self.totalKebutuhanMinum())
                let drinks = CoreDataManager.shared.fetchDrinks()
                var histories = [History]()
                    histories.append(contentsOf: drinks?.last?.history!.allObjects as! [History])
                    let amount = histories.map({$0.amount}).reduce(0, +)
                    
                self.progressDrinks.text = "\(amount)" + " / \(self.targetDrinks) ml"
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
        else {
            let imagePickerController = UIImagePickerController()
            
            //Alert Notification
            let actionSheet = UIAlertController(title: "Before You Add Activities", message: "You must authorize HealthKit : ", preferredStyle: .alert)
            
            //Cancel Button
            actionSheet.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    //        self.present(actionSheet, animated: true, completion: nil)
            
            
            
            //Popover Position
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            self.present(actionSheet, animated: true, completion: nil)
        }
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
        print("total akhir :", totalKebutuhanMinum())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // formatter.unitsStyle = .full
//        dateWater.text = formatter.string(for: self)
        
        
        if isAuthorize == true {
            targetDrinks = Int(totalKebutuhanMinum())
            activitiesButton.isEnabled = true
        }
        
        lapView.layer.cornerRadius = lapView.frame.size.width/2
        lapView.clipsToBounds = true
        
        lapView.layer.borderColor = UIColor(rgb: 0x4D80E4).cgColor
        lapView.layer.backgroundColor = UIColor(rgb: 0x253961).cgColor
        lapView.layer.borderWidth = 5.0
        
        //       drinkBtnlbl.layer.cornerRadius = 5
        let drinks = CoreDataManager.shared.fetchDrinks()
        var histories = [History]()
        if drinks?.count != 0 {
            
            histories.append(contentsOf: drinks?.last?.history!.allObjects as! [History])
            let amount = histories.map({$0.amount}).reduce(0, +)
            
            progressDrinks.text = "\(amount)" + " / \(targetDrinks) ml"
            
            
            wave = WaveAnimationView(frame: CGRect(origin: .zero, size: lapView.bounds.size), color: UIColor(rgb: 0x5CC2F4))
            let resultAnimasi = Double((amount))/Double(targetDrinks)
            animasiProgres.text = "\(Int(resultAnimasi * 100))%"
            wave.progress = Float(resultAnimasi)
            lapView.addSubview(wave)
            wave.startAnimation()
        }  else if drinks?.count == 0 {
            
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
        waterVolumeTextField.text = ""
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
