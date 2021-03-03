//
//  ProfileDataStore.swift
//  minum
//
//  Created by Devi Mandasari on 03/03/21.
//  Copyright © 2021 Ihwan ID. All rights reserved.
//

import Foundation
import HealthKit

class ProfileDataStore {

  class func getAgeSex() throws -> (ageUH: Int,
                                                biologicalSexUH: HKBiologicalSex) {
    
    let healthKitStore = HKHealthStore()
    
    do {
      
      //1. This method throws an error if these data are not available.
      let birthdayComponents =  try healthKitStore.dateOfBirthComponents()
      let biologicalSex =       try healthKitStore.biologicalSex()
      
      //2. Use Calendar to calculate age.
      let today = Date()
      let calendar = Calendar.current
      let todayDateComponents = calendar.dateComponents([.year],
                                                        from: today)
      let thisYear = todayDateComponents.year!
      let age = thisYear - birthdayComponents.year!
      
      //3. Unwrap the wrappers to get the underlying enum values.
      let unwrappedBiologicalSex = biologicalSex.biologicalSex
      
      return (age, unwrappedBiologicalSex)
    }
  }
  
  class func getMostRecentSample(for sampleType: HKSampleType,
                                 completion: @escaping (HKQuantitySample?, Error?) -> Swift.Void) {
    
    //1. Use HKQuery to load the most recent samples.
    let mostRecentPredicate = HKQuery.predicateForSamples(withStart: Date.distantPast,
                                                          end: Date(),
                                                          options: .strictEndDate)
    
    let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate,
                                          ascending: false)
    
    let limit = 1
    
    let sampleQuery = HKSampleQuery(sampleType: sampleType,
                                    predicate: mostRecentPredicate,
                                    limit: limit,
                                    sortDescriptors: [sortDescriptor]) { (query, samples, error) in
    
      //2. Always dispatch to the main thread when complete.
      DispatchQueue.main.async {
        
        guard let samples = samples,
              let mostRecentSample = samples.first as? HKQuantitySample else {
                
              completion(nil, error)
              return
        }
        
        completion(mostRecentSample, nil)
      }
    }
    
    HKHealthStore().execute(sampleQuery)
  }
}
