//
//  KPAssistError.swift
//  KPAssist
//
//  Created by R, Rahul Pradev on 16/11/22.
//

import Foundation

public enum KPAssistError: Error {
case noSpeechPermissionEnabled// if no speech Permission
case noMicrophonePermissionEnabled // if no Microphone Permission
case audioEngineNotRecognized // if no Audio Engine
case speechRecognizerNotAvailable // If Speech is not Recognized
case recognitionTaskNotValid // If Recognition Task in Invalid
case noPredictionAvailable // If ML does'nt have any prediction
}
