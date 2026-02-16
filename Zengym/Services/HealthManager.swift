import Foundation
import HealthKit
import SwiftUI

@MainActor
@Observable
class HealthManager {
    static let shared = HealthManager()
    
    var healthStore: HKHealthStore?
    var isAuthorized = false
    var errorMessage: String?
    
    // Data
    var stepCount: Double = 0
    var caloriesBurned: Double = 0
    var activeEnergy: Double = 0
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        } else {
            errorMessage = "HealthKit not available on this device"
        }
    }
    
    func requestAuthorization() async {
        guard let healthStore = healthStore else { return }
        
        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
            HKObjectType.categoryType(forIdentifier: .mindfulSession)!,
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
            HKObjectType.characteristicType(forIdentifier: .biologicalSex)!
        ]
        
        let shareTypes: Set<HKSampleType> = [
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.workoutType()
        ]
        
        do {
            try await healthStore.requestAuthorization(toShare: shareTypes, read: readTypes)
            DispatchQueue.main.async {
                self.isAuthorized = true
                self.fetchTodaysData()
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to request authorization: \(error.localizedDescription)"
            }
        }
    }
    
    func fetchTodaysData() {
        guard let healthStore = healthStore else { return }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        // Fetch Steps
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        
        let stepQuery = HKStatisticsQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else { return }
            DispatchQueue.main.async {
                self.stepCount = sum.doubleValue(for: HKUnit.count())
            }
        }
        
        // Fetch Active Energy
        guard let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
        
        let energyQuery = HKStatisticsQuery(
            quantityType: energyType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else { return }
            DispatchQueue.main.async {
                self.activeEnergy = sum.doubleValue(for: HKUnit.kilocalorie())
            }
        }
        
        healthStore.execute(stepQuery)
        healthStore.execute(energyQuery)
    }
}
