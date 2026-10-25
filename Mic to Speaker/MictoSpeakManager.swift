//

import Foundation

import AVFoundation
import UIKit

final class LiveMicManager {

    private let engine = AVAudioEngine()
    private let session = AVAudioSession.sharedInstance()

    func start(completion: @escaping (Error?) -> Void) {
        session.requestRecordPermission { [weak self] granted in
            DispatchQueue.main.async {
                guard let self = self else { return }

                guard granted else {
                    let error = NSError(
                        domain: "LiveMicManager",
                        code: 1,
                        userInfo: [
                            NSLocalizedDescriptionKey:
                                "Microphone permission was denied."
                        ]
                    )
                    completion(error)
                    return
                }

                do {
                    try self.startAudio()
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
        }
    }

    private func startAudio() throws {
        guard !engine.isRunning else { return }

        try session.setCategory(
            .playAndRecord,
            mode: .default,
            options: [.allowBluetoothA2DP]
        )

        try session.setActive(true)

        let input = engine.inputNode
        let format = input.outputFormat(forBus: 0)

        engine.connect(
            input,
            to: engine.mainMixerNode,
            format: format
        )

        engine.mainMixerNode.outputVolume = 1.0

        engine.prepare()
        try engine.start()
    }

    func stop() {
        if engine.isRunning {
            engine.stop()
        }

        engine.reset()

        do {
            try session.setActive(
                false,
                options: .notifyOthersOnDeactivation
            )
        } catch {
            print("Audio session deactivation failed: \(error)")
        }
    }
}
