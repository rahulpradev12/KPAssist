//
//  KPWordTagger.swift
//  KPAssist
//
//  Created by R, Rahul Pradev on 04/11/22.
//

import CoreML
import NaturalLanguage

public class KPWordTagger {
    
    // Custom scheme
    private let scheme = NLTagScheme("KPVoiceActionReview")
    private let options: NLTagger.Options = [.omitPunctuation]
    
    //Text classifier
    private lazy var speechSentimentClassifier: NLModel? = {
            do {
                let mainBundle = Bundle(for: Self.self)
                if let url = mainBundle.url(forResource: "KPAssist", withExtension: "bundle"){
                    
                    let kpAssistBundle = Bundle(url: url)
                    
                    let mlModelURL = kpAssistBundle?.url(forResource: "VoiceToActionSentiment", withExtension: "mlmodelc")
                    let model = try NLModel(contentsOf: mlModelURL!)
                    return model
                }
                return nil
                
            } catch {
                return nil
            }
                                    
        }()

    
    // Word Tagging
    private lazy var tagger: NLTagger? = {
        do {
            let mainBundle = Bundle(for: Self.self)
            if let url = mainBundle.url(forResource: "KPAssist", withExtension: "bundle"){
                
                let kpAssistBundle = Bundle(url: url)
        
                let mlModelURL = kpAssistBundle?.url(forResource: "ActionClassifier1", withExtension: "mlmodelc")
                                
                let model = try NLModel(contentsOf: mlModelURL!)  // MLModel -> NLModel
                let tagger = NLTagger(tagSchemes: [scheme])
                tagger.setModels([model], forTagScheme: scheme) // Associating custom model with custom scheme
                return tagger
            }
            return nil
            
        } catch {
            return nil
        }
    }()
    
    // MARK: Prediction method
    public func prediction(for text: String) -> String? {
        tagger?.string = text
        let range = text.startIndex ..< text.endIndex
        tagger?.setLanguage(.english, range: range)
        return tagger?.tags(in: range,
                            unit: .document,
                            scheme: scheme,
                            options: options)
        .compactMap { tag, _ -> String? in
            return tag?.rawValue
        }
        .first
    }
    
    // predict text/action by text classifier
    public func predictAction(for text: String) -> String? {
        return speechSentimentClassifier?.predictedLabel(for: text)
    }

}
