//
//  KPVoiceCommandAssitant.swift
//  KPAssist
//
//  Created by R, Rahul Pradev on 04/11/22.
//

import Foundation
import Speech
import AVKit

public class KPVoiceCommandAssitant {
    
    // MARK: Constants
    private enum Constants {
        static let bufferSize: AVAudioFrameCount = 1024
    }
    
    // MARK: Public variables
    
    // Assign App Specific Locale
    public var locale: Locale = Locale(identifier: "en_US")
    
    // MARK: IVars
    
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer?
    private let request = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask: SFSpeechRecognitionTask?
    private let tagger = KPWordTagger()
    
    // Add more commands to check the accuracy, if required.
    // This can be passed from the Demo app
    let commands = [
        "need bill",
        "need prescription",
        "Hey please call Doc",
        "bill amount",
    ]
    
    
    // MARK: Initialization
    
    public init() {
      speechRecognizer = SFSpeechRecognizer(locale: locale)
    }
    
    // TODO: Add Convenience init to pass locale

    
    // MARK: Initializer
    //private init(){}
    
    // MARK: Public Methods
    
    public func startListening() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: Constants.bufferSize, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            // throw an error via delegate
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            // throw an error via delegate
            return
        }
        if !myRecognizer.isAvailable {
            // throw an error via delegate
            // Recognizer is not available right now
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                let transcriptString = result.bestTranscription.formattedString
                guard let prediction = self.tagger.prediction(for: transcriptString) else { return }
                
                
                
            } else if let error = error {
                // throw an error via delegate
                print(error)
            }
        })
    }
    
    public func stopListening() {
        recognitionTask?.finish()
        recognitionTask = nil
        
        // stop audio
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
        
    // MARK: Display prediction
    public func displayPrediction() {
        commands.forEach { review in
            guard let prediction = tagger.prediction(for: review) else { return }
            debugPrint("\(review): \(prediction)")
        }
    }
}
