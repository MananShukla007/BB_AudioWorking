import SwiftUI

struct PracticeSessionScreen: View {
    @Environment(\.presentationMode) var presentationMode
    let childName: String
    
    @Binding var programChoices: [String]

    var body: some View {
        ZStack {
            // Background Color
            Color(red: 0.27, green: 0.48, blue: 0.61) // Blue #457B9D
                .ignoresSafeArea()

            VStack(spacing: 0) { // No unnecessary spacing
                // Back Button at Top Left
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding([.leading, .top], 20)

                // Centered Top Image
                Image("BB_LOGO")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200) // Adjust size as needed
                    .padding(.top, 20)

                // Child's Name and "Practice" Text
                VStack(spacing: 0) { // No gap between lines
                    Text(childName)
                        .font(.custom("MarkerFelt-Wide", size: 75)) // Childish Font
                        .foregroundColor(.white)

                    Text("Practice")
                        .font(.custom("MarkerFelt-Wide", size: 35)) // Reduced size
                        .foregroundColor(.white)
                }

                Spacer().frame(height: 30) // Space between name/practice and next section

                // "Choose Program" Text
                Text("Choose Program")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.bottom, 15) // Space below "Choose Program"

                // Program Choice Buttons
                VStack(spacing: 15) {
                    ForEach(programChoices, id: \.self) { choice in
                        NavigationLink(destination: SessionDetailScreen(childName: childName, selectedSession: choice)) {
                            Text(choice)
                                .frame(width: 300, height: 50)
                                .background(Color(red: 0.92, green: 0.55, blue: 0.55)) // Light Red #EA8C8C
                                .cornerRadius(8)
                                .shadow(radius: 5)
                                .multilineTextAlignment(.center)
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                }

                Spacer() // Small spacer at the bottom
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct PracticeSessionScreen_Previews: PreviewProvider {
    static var previews: some View {
        PracticeSessionScreen(
            childName: "Sample Child",
            programChoices: .constant(["Ball", "Cookie", "Down"])
        )
    }
}
