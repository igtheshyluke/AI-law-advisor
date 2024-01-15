//
//  SpeechSynthesizer.swift
//  LegalAdvice
//
//  Created by Rakan on 2024/1/10.
//

import Foundation
import AVFoundation
import SwiftUI
import AVKit

class SpeechSynthesizer: NSObject,ObservableObject, AVSpeechSynthesizerDelegate {
    let synthesizer = AVSpeechSynthesizer()
    @Published var player: AVPlayer?
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func startSpeaking(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.volume = 1.0
        synthesizer.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        // Change the source of your video player when speech starts
        if let url = URL(string: "https://your-start-video-url.com") {
            player = AVPlayer(url: url)
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // Change the source of your video player when speech ends
        if let url = URL(string: "https://your-end-video-url.com") {
            player = AVPlayer(url: url)
        }
    }
}
