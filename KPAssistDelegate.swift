//
//  KPAssistDelegate.swift
//  KPAssist
//
//  Created by R, Rahul Pradev on 16/11/22.
//

import Foundation

public protocol KPAssistDelegate: AnyObject {
    
    // Successfull Prediction from ML
    func kpVoiceAssistant(_ assistant: KPVoiceCommandAssitant, didRecievePrediction prediction: String, inputTranscript: String)
    
    // Error
    func kpVoiceAssistant(_ assistant: KPVoiceCommandAssitant, didRecieveError error: KPAssistError)
    
}
