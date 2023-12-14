//
//  TextToSpeech.swift
//  MedWise
//
//  Created by Pawan Dharel on 12/10/23.
//

import Foundation
import AVFoundation


class TextToSpeechManager {
    private let synthesizer = AVSpeechSynthesizer()
    
    func speak(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechUtterance.rate = 0.5
        synthesizer.speak(speechUtterance)
    }
    
    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
