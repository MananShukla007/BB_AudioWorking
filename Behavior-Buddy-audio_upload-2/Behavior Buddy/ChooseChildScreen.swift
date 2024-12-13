import SwiftUI

struct ChooseChildScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var childNames = ["Maggie", "Ben", "Lisa"]

    var body: some View {
        ZStack {
            // Old Background Color
            Color(red: 0.27, green: 0.48, blue: 0.61) // Blue #457B9D
                .ignoresSafeArea()

            VStack {
                HStack {
                    // Back Arrow Button
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

                Spacer()

                // Centered Image
                Image("BB_LOGO")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200) // Adjust as needed
                    .padding(.bottom, 20)

                // "Choose Your Child:" Title
                Text("Choose Your Child:")
                    .font(.custom("MarkerFelt-Wide", size: 28)) // Childish Font
                    .bold()
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                // Child Name Buttons
                VStack(spacing: 15) {
                    ForEach(childNames, id: \.self) { name in
                        NavigationLink(destination: ChildDetailScreen(childName: name)) {
                            Text(name)
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

                Spacer()
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct ChooseChildScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChooseChildScreen()
    }
}
