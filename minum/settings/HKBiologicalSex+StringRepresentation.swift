//
//  HKBiologicalSex+StringRepresentation.swift
//  minum
//
//  Created by Devi Mandasari on 03/03/21.
//  Copyright © 2021 Ihwan ID. All rights reserved.
//

import Foundation
import HealthKit

extension HKBiologicalSex {
  
  var stringRepresentation: String {
    switch self {
    case .notSet: return "Unknown"
    case .female: return "Female"
    case .male: return "Male"
    case .other: return "Other"
    }
  }
}
