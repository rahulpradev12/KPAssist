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
    
    // Word Tagging
    private lazy var tagger: NLTagger? = {
        do {
            let url = Bundle.main.url(forResource: "ActionClassifier1", withExtension: "mlmodelc")!
            let model = try NLModel(contentsOf: url)  // MLModel -> NLModel
            let tagger = NLTagger(tagSchemes: [scheme])
            tagger.setModels([model], forTagScheme: scheme) // Associating custom model with custom scheme
            return tagger
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
}
