import SwiftUI

struct ChildDetailScreen: View {
    @Environment(\.presentationMode) var presentationMode

    let childName: String
    @State private var programChoices: [String] = ["Ball", "Cookie", "Down"] // Default program choices

    var body: some View {
        ZStack {
            // Updated Background Color
            Color(red: 0.27, green: 0.48, blue: 0.61) // Blue #457B9D
                .ignoresSafeArea()

            VStack {
                // Back Arrow Button
                HStack {
                    Button(action: {
                        // Back action
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding([.leading, .top], 20)

                // Centered Logo with Spacing from Top
                Image("BB_LOGO")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200) // Adjust size as needed
                    .padding(.top, 40) // Increased top padding

                Spacer()

                // Child's Name in Center
                Text(childName)
                    .font(.system(size: 56, weight: .bold)) // Larger Text
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 60) // Space below name

                // Two Buttons Below
                VStack(spacing: 20) {
                    NavigationLink(destination: PracticeSessionScreen(childName: childName, programChoices: $programChoices)) {
                        Text("Practice")
                            .font(.title2)
                            .bold()
                            .frame(width: 300, height: 60)
                            .background(Color(red: 0.92, green: 0.55, blue: 0.55)) // Light Red #EA8C8C
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        print("Progress tapped for \(childName)")
                    }) {
                        Text("Progress")
                            .font(.title2)
                            .bold()
                            .frame(width: 300, height: 60)
                            .background(Color(red: 0.92, green: 0.55, blue: 0.55)) // Light Red #EA8C8C
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct ChildDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChildDetailScreen(childName: "Sample Child")
    }
}
