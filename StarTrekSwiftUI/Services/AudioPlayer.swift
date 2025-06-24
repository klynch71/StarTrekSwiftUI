//
//  AudioPlayer.swift
//  StarTrekSwiftUI
//
//  Created by Kevin Lynch on 5/22/25.
//
//  Copyright (c) 2025 Kevin Lynch
//  This file is licensed under the MIT license
//

import AVFoundation

/// A simple wrapper for `AVAudioPlayer` to handle sound playback.
///
/// Supports looping and integrates with the `AVAudioPlayerDelegate` to manage playback completion.
class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    
    private var audioPlayer: AVAudioPlayer? = nil
    
    /// Plays an audio file with the given name.
    ///
    /// - Parameters:
    ///   - name: The name of the audio file (must be included in the app bundle).
    ///   - loops: The number of times the audio should loop. Use `-1` for infinite looping.
    func play(_ name: String, loops: Int = 1) {
        guard let path = Bundle.main.path(forResource: name, ofType: nil) else {
            print("Error: Sound file \(name) not found in bundle.")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.numberOfLoops = loops
            audioPlayer?.play()
        } catch {
            print("Error: Failed to load or play sound file '\(name)': \(error.localizedDescription)")
        }
    }
    
    /// Stops playback if active.
    func stop() {
        audioPlayer?.stop()
    }
    
    /// Called when the audio player finishes playback.
    ///
    /// - Parameters:
    ///   - player: The audio player instance.
    ///   - flag: A boolean indicating whether playback finished successfully.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            // Clean up the audio player instance after successful playback
            self.audioPlayer?.stop()
            self.audioPlayer = nil
        }
    }
}

