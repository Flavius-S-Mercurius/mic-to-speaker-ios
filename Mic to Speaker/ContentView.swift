
import SwiftUI

struct ContentView: View {

    private let mic = LiveMicManager()

    @State private var isRunning = false
    @State private var status = "Ready"

    var body: some View {
        VStack(spacing: 25) {

            Image(systemName: isRunning
                  ? "speaker.wave.3.fill"
                  : "mic.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("Live Microphone")
                .font(.largeTitle)
                .bold()

            Text(status)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button {
                if isRunning {
                    mic.stop()
                    isRunning = false
                    status = "Stopped"
                } else {
                    status = "Requesting microphone permission..."

                    mic.start { error in
                        if let error = error {
                            status = error.localizedDescription
                            isRunning = false
                        } else {
                            status = "Microphone is live"
                            isRunning = true
                        }
                    }
                }
            } label: {
                Text(isRunning ? "Stop" : "Start")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isRunning ? Color.red : Color.blue)
                    .cornerRadius(12)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(30)
    }
}
