import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    private var swapPlayer: AVAudioPlayer?
    private var successPlayer: AVAudioPlayer?

    private init() {
        setupPlayers()
    }

    private func setupPlayers() {
        if let swapURL = Bundle.main.url(forResource: "tap", withExtension: "mp3") {
            swapPlayer = try? AVAudioPlayer(contentsOf: swapURL)
            swapPlayer?.prepareToPlay()
        }

        if let successURL = Bundle.main.url(forResource: "success", withExtension: "wav") {
            successPlayer = try? AVAudioPlayer(contentsOf: successURL)
            successPlayer?.prepareToPlay()
        }
    }

    func playSwap() {
        swapPlayer?.stop()
        swapPlayer?.currentTime = 0
        swapPlayer?.play()
    }

    func playSuccess() {
        successPlayer?.stop()
        successPlayer?.currentTime = 0
        successPlayer?.play()
    }
}
