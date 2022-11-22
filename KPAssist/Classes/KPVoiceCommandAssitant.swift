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
    public weak var delegate: KPAssistDelegate?
    
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
        "hello",
        "appointment",
        "cancel appointment",
        "Hey, can you book an appointment",
        "Thank you dude for the appointment",
        "hey! good morning. Need appointment", //fails for appointment
        "hello doctor"
    ]
    
    
    // MARK: Initialization
    
    public init() {
      speechRecognizer = SFSpeechRecognizer(locale: locale)
    }
    
    // TODO: Add Convenience init to pass locale

    
    // MARK: Initializer
    //private init(){}
    
    // MARK: Public Methods
    
    public func startListening() throws -> Void {
        var textBuffer = ""
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: Constants.bufferSize, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            throw KPAssistError.audioEngineNotRecognized
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            // throw an error via delegate
            return
        }
        if !myRecognizer.isAvailable {
            
            // throw an error via delegate
            // Recognizer is not available right now
            throw KPAssistError.speechRecognizerNotAvailable
        
        }
        var timer = Timer()
        
        //"Hello hello hey hi can I just bring me I think it\'s working"
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                let instructionText = result.bestTranscription.formattedString as? String ?? ""
                if textBuffer != instructionText && !result.isFinal {
                    timer.invalidate()
                    textBuffer = instructionText
                    timer = Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false, block: { _ in
                        self.predictText(with: textBuffer)
                    })
                }
            }
            //debugPrint(result.bestTranscription.formattedString as? String ?? "")
//            if let result = result {
//                if result.isFinal {
//                    let transcriptString = result.bestTranscription.formattedString
////                    guard let prediction = self.tagger.predictAction(for: transcriptString) else { return }
////                    self.delegate?.kpVoiceAssistant(self, didRecievePrediction: prediction)
//                    //print("INSTRUCTION =\(transcriptString) PREDICTION = \(prediction)")
//                }
                
            else if let error = error {
                // throw an error via delegate
                print(error)
            }
                                                            
        })
    }
    
    @objc func predictText(with clause: String) {
        debugPrint("do call the prediction for \(clause)")
        self.stopListening()
        guard let prediction = self.tagger.predictAction(for: clause.lowercased()) else { return }
        self.delegate?.kpVoiceAssistant(self, didRecievePrediction: prediction, inputTranscript: clause)
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
        /*commands.forEach { review in
            guard let prediction = tagger.prediction(for: review) else { return }
            debugPrint("\(review): \(prediction)")
        }
         */
        commands.forEach { instruction in
            guard let prediction = tagger.predictAction(for: instruction) else { return }
            debugPrint("\(instruction): \(prediction)")
        }
    }
}
