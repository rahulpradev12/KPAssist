//
//  KPVoiceCommandAssitant.swift
//  KPAssist
//
//  Created by R, Rahul Pradev on 04/11/22.
//

import Foundation

public class KPVoiceCommandAssitant {
    
    
    let tagger = KPWordTagger()
    let commands = [
        "need bill",
        "need prescription",
        "Hey please call Doc",
        "bill amount",
    ]
    
    // MARK: Initializer
    public init(){}
    
    // MARK: Display prection
    public func displayPrediction() {
        commands.forEach { review in
            guard let prediction = tagger.prediction(for: review) else { return }
            debugPrint("\(review): \(prediction)")
        }
    }
}
