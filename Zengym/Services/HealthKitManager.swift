import Foundation
import HealthKit

@MainActor
class HealthKitManager {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()

    private init() {}

    var isAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    func requestAuthorization() {
        guard isAvailable else { return }

        let typesToWrite: Set<HKSampleType> = [
            .workoutType(),
            HKQuantityType(.activeEnergyBurned)
        ]

        let typesToRead: Set<HKObjectType> = [
            .workoutType(),
            HKQuantityType(.activeEnergyBurned)
        ]

        healthStore.requestAuthorization(toShare: typesToWrite, read: typesToRead) { success, error in
            if let error = error {
                print("⚠️ HealthKit authorization error: \(error.localizedDescription)")
            }
            if success {
                print("✅ HealthKit authorized")
            }
        }
    }

    func saveWorkout(durationMinutes: Int, calories: Int) {
        guard isAvailable else { return }

        let startDate = Date().addingTimeInterval(-Double(durationMinutes * 60))
        let endDate = Date()

        let workout = HKWorkout(
            activityType: .traditionalStrengthTraining,
            start: startDate,
            end: endDate,
            duration: Double(durationMinutes * 60),
            totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: Double(calories)),
            totalDistance: nil,
            metadata: [
                HKMetadataKeyWorkoutBrandName: "Zengym"
            ]
        )

        healthStore.save(workout) { success, error in
            if let error = error {
                print("⚠️ Failed to save workout: \(error.localizedDescription)")
            }
            if success {
                print("✅ Workout saved to HealthKit")

                // Save calories as separate sample
                let calorieType = HKQuantityType(.activeEnergyBurned)
                let calorieSample = HKQuantitySample(
                    type: calorieType,
                    quantity: HKQuantity(unit: .kilocalorie(), doubleValue: Double(calories)),
                    start: startDate,
                    end: endDate
                )

                self.healthStore.save(calorieSample) { _, _ in }
            }
        }
    }
}
