import SwiftUI
import Speech
import AVFoundation
import Amplify
import AWSPluginsCore

struct SpeechRecognitionView: View {
    @State private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    @State private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    @State private var recognitionTask: SFSpeechRecognitionTask?
    @State private var audioEngine = AVAudioEngine()
    @State private var audioRecorder: AVAudioRecorder?
    @State private var transcribedText: String = ""
    @State private var isRecording: Bool = false
    @State private var audioFileURL: URL?
    @State private var showLiveTranscription: Bool = false

    @State private var sessionCount: Int = 0
    @State private var timeRemaining = 180
    @State private var isTimerRunning = false
    @State private var showMessage: String? = nil
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    let clientName: String
    let selectedProgram: String

    var body: some View {
        VStack(spacing: 20) {
            // Child Name and Session Text
            VStack(spacing: 0) {
                Text(clientName)
                    .font(.custom("MarkerFelt-Wide", size: 75)) // Childish Font
                    .foregroundColor(.white)

                Text("SESSION")
                    .font(.custom("MarkerFelt-Wide", size: 35)) // Childish Font
                    .foregroundColor(.white)
            }

            // Program Box
            HStack {
                Text("Program:")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.3)) // Grey background
                    .cornerRadius(8)

                Text(selectedProgram)
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(red: 0.92, green: 0.55, blue: 0.55)) // Red #E63946
                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
            .padding(.horizontal, 20)

            // Session Count Box
            HStack {
                Text("Session:")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.3)) // Grey background
                    .cornerRadius(8)

                Text("\(sessionCount)")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(red: 0.92, green: 0.55, blue: 0.55)) // Updated button color
                    .cornerRadius(8)
                    .shadow(radius: 5)
            }
            .padding(.horizontal, 20)

            Spacer().frame(height: 30)

            // Timer Box
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.3)) // Grey background
                    .frame(width: 300, height: 100)
                Text(timeString(from: timeRemaining))
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
            }
            .onReceive(timer) { _ in
                if isTimerRunning && timeRemaining > 0 {
                    timeRemaining -= 1
                } else if timeRemaining == 0 {
                    showMessage = "Session Ended!"
                    isTimerRunning = false
                }
            }

            // Show Live Transcription Button
            Button(action: {
                showLiveTranscription.toggle()
            }) {
                Text("Show Live Transcription")
                    .foregroundColor(.white)
            }

            if showLiveTranscription {
                TextEditor(text: $transcribedText)
                    .font(.body)
                    .padding()
                    .frame(height: 200)
                    .border(Color.gray, width: 1)
                    .cornerRadius(8)
            }

            // Start and End Buttons
            HStack {
                Button(action: startRecording) {
                    Text("Start")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.92, green: 0.55, blue: 0.55)) // Updated button color
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(isRecording)
                }

                Button(action: stopRecording) {
                    Text("End")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.92, green: 0.55, blue: 0.55)) // Updated button color
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(!isRecording)
                }
            }
            .padding()

            // Save Button
            Button(action: saveAudio) {
                Text("Save")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.92, green: 0.55, blue: 0.55)) // Updated button color
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            if let message = showMessage {
                Text(message)
                    .font(.title)
                    .bold()
                    .foregroundColor(Color(red: 0.92, green: 0.55, blue: 0.55))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.3)) // Grey box
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }

            Spacer()

            // Upload File Button
            Button("Upload File") {
                Task {
                    print("file upload pressed")
                    let identityString = await getIdentityID()
                    print("Identity ID is " + identityString)
                    let dateS = dateString()
                    let s3FileName = dateS + ".m4a"
                    print(s3FileName)
                    let uploadTask = Amplify.Storage.uploadFile(
                        path: .fromString("recordings/\(identityString)/\(s3FileName)"),
                        local: audioFileURL!
                    )
                }
            }
            .foregroundColor(.white)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.27, green: 0.48, blue: 0.61))
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            requestSpeechAuthorization()
        }
    }

    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }

    private func dateString() -> String {
        let date = Date()
        let format = Date.VerbatimFormatStyle(
            format: """
            \(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)_\(hour: .twoDigits(
            clock: Date.FormatStyle.Symbol.VerbatimHour.Clock.twentyFourHour,
            hourCycle: Date.FormatStyle.Symbol.VerbatimHour.HourCycle.zeroBased
            ))-\(minute: .twoDigits)-\(second: .twoDigits)
            """,
            locale: .autoupdatingCurrent,
            timeZone: .autoupdatingCurrent,
            calendar: .init(identifier:.gregorian))
        let s = date.formatted(format)
        return s
    }

    private func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                print("Speech recognition authorized")
            case .denied, .restricted, .notDetermined:
                print("Speech recognition not authorized")
            @unknown default:
                print("Unknown authorization status")
            }
        }
    }

    private func startRecording() {
        do {
            transcribedText = ""
            createRecordingsFolder()
            let recordingsFolder = getRecordingsFolder()
            let audioFileName = UUID().uuidString + ".m4a"
            audioFileURL = recordingsFolder.appendingPathComponent(audioFileName)
            let audioRecorderSettings: [String: Any] = [
                AVFormatIDKey: kAudioFormatMPEG4AAC,
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

            let inputNode = audioEngine.inputNode
            audioRecorder = try AVAudioRecorder(url: audioFileURL!, settings: audioRecorderSettings)
            audioRecorder?.prepareToRecord()

            if audioRecorder == nil {
                print("Audio recorder is not initialized.")
                return
            }

            if audioRecorder?.prepareToRecord() == false {
                print("Failed to prepare audio recorder.")
                return
            }

            audioRecorder?.record()

            // Prepare recognition request
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let recognitionRequest = recognitionRequest else {
                fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
            }
            recognitionRequest.shouldReportPartialResults = true
            recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
                if let result = result {
                    transcribedText = result.bestTranscription.formattedString
                }

                if error != nil || result?.isFinal == true {
                    self.audioEngine.stop()
                    print("Audio Engine Stopped")
                    inputNode.removeTap(onBus: 0)
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                }
            }
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            print("Input node format: \(recordingFormat)")
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
                self.recognitionRequest?.append(buffer)
            }

            audioEngine.prepare()
            do {
                try audioEngine.start()
                print("Audio Engine started.")
            } catch {
                print("Failed to start Audio Engine: \(error.localizedDescription)")
            }

            isTimerRunning = true
            isRecording = true
        } catch {
            print("Failed to start recording: \(error.localizedDescription)")
        }
    }

    private func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        audioRecorder?.stop()
        isRecording = false
        isTimerRunning = false
    }

    private func saveAudio() {
        guard let audioFileURL = audioFileURL else {
            print("No audio file to save")
            return
        }

        print("Saved audio file: \(audioFileURL.path)")
    }

    private func getRecordingsFolder() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("SPEECH RECORDINGS")
    }

    private func createRecordingsFolder() {
        let recordingsFolder = getRecordingsFolder()
        do {
            try FileManager.default.createDirectory(at: recordingsFolder, withIntermediateDirectories: true, attributes: nil)
            print("Recordings folder created at: \(recordingsFolder.path)")
        } catch {
            print("Failed to create recordings folder: \(error.localizedDescription)")
        }
    }
    
    func getIdentityID() async -> String {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            if let identityProvider = session as? AuthCognitoIdentityProvider {
                let identityId = try identityProvider.getIdentityId().get()
                return identityId
            }
        } catch let error as AuthError {
            print("Fetch auth session failed with error - \(error)")
        } catch {
        }
        return "Error Retrieving Identity ID"
    }
}

struct SpeechRecognitionView_Previews: PreviewProvider {
    static var previews: some View {
        SpeechRecognitionView(clientName: "Micah", selectedProgram: "Sample Program")
    }
}
