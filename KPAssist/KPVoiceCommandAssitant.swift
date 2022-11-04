//
//  KPVoiceCommandAssitant.swift
//  KPAssist
//
//  Created by R, Rahul Pradev on 04/11/22.
//

import Foundation

class KPVoiceCommandAssitant {
    let tagger = KPWordTagger()
    let reviews = [
        "need bill",
        "need prescription",
        "Hey please call Doc",
        "bill amount",
        //Dummy Strings
        "The view from where I was sit was just amazing",
        "The waiter was very friendly and kind",
        "The fish was rotten :/",
        "Jon Snow is the King in the North!"
    ]
    
    func displayPrediction() {
        reviews.forEach { review in
            guard let prediction = tagger.prediction(for: review) else { return }
            print("\(review): \(prediction)")
        }
    }
}
