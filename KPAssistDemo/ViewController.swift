//
//  ViewController.swift
//  KPAssistDemo
//
//  Created by R, Rahul Pradev on 10/11/22.
//

import UIKit
import KPAssist

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let kpAssistObj = KPVoiceCommandAssitant()
        
        // Add more commands to test the prediction in KPVoiceCommandAssitant
        // check the debug console for o/p for prediction
        kpAssistObj.displayPrediction()
    }


}

