//
//  UserHealthProfile.swift
//  minum
//
//  Created by Devi Mandasari on 03/03/21.
//  Copyright © 2021 Ihwan ID. All rights reserved.
//

import Foundation
import HealthKit

class UserHealthProfile {
  
  var ageUH: Int?
  var genderUH: HKBiologicalSex?
  var heightInMeters: Double?
  var weightInKilograms: Double?
  
    var bodyMassIndex: Double? {
      
      guard let weightInKilograms = weightInKilograms,
        let heightInMeters = heightInMeters,
        heightInMeters > 0 else {
          return nil
      }
      
      return (weightInKilograms/(heightInMeters*heightInMeters))
   }
    
}
