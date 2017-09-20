//
//  ViewController.swift
//  preHealthKit
//
//  Created by msano on 2017/09/20.
//  Copyright © 2017年 msano. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: action
    @IBAction func AddTemperatureButtonTapped(_ sender: UIButton) {
        didTapAddData()
    }

}

extension ViewController {
    
    func didTapAddData() {
        saveHealthData()
    }
    
    // MARK: private
    private func saveHealthData() {
        guard let temperature = Double("36.0"),
            let type = HKObjectType.quantityType(forIdentifier: .bodyTemperature) else {
            return
        }
        
        // 単位
        let unit = HKUnit.degreeCelsius()
        
        // データ保存領域の生成
        let healthStore = HKHealthStore()
        
        let healthData = HKQuantity(
            unit: unit,
            doubleValue: temperature
        )
        
        let sample = HKQuantitySample(
            type: type,
            quantity: healthData,
            start: Date(),
            end: Date()
        )
        
        let authorizedStatus = healthStore.authorizationStatus(for: type)
        
        if authorizedStatus == .sharingAuthorized {
            healthStore.save(sample, withCompletion: { (success, error) in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                
                if success {
                    healthStore.save(sample, withCompletion:{ (success, error) in
                        print("保存成功")
                    })
                }
            })
        } else {
            
            healthStore.requestAuthorization(
                toShare: [type],
                read: [type],
                completion: { (success, error) in
            
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                
                // アクセス権限を得たらデータを保存
                if success {
                    healthStore.save(sample, withCompletion:{ (success, error) in
                        print("保存成功")
                    })
                }
            })
        }
    }
}

