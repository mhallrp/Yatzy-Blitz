import AVFoundation
import SwiftUI

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    @AppStorage("isSoundOn") private var isSoundOn = true
    
    enum SoundEffect: String {
        case diceRoll1 = "diceRoll1"
        case diceRoll2 = "diceRoll2"
        case diceRoll3 = "diceRoll3"
    }
    
    func playSound(_ soundEffect: String) {
        playSoundEffect(soundEffect)
    }
    
    func playSoundEffect(_ soundFileName: String) {
        if  isSoundOn{
            if let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "mp3") {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.play()
                } catch {
                    print("Error playing the audio file: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func playRandomRollSound() {
        let diceRolls: [SoundEffect] = [.diceRoll1, .diceRoll2, .diceRoll3]
        if let randomRoll = diceRolls.randomElement() {
            playSoundEffect(randomRoll.rawValue)
        }
    }
}
