import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Updated Background Color
                Color(red: 0.27, green: 0.48, blue: 0.61) // Blue #457B9D
                    .ignoresSafeArea()
                VStack {
                    // Replacing Text with Image
                    Image("BB_LOGO")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200) // Adjust size as needed
                        .padding()

                    Spacer()
                    caregiverButton
                    Spacer()
                    bcbaButton
                    Spacer()

                    // Small Admin Button at the Bottom
                    adminButton
                }
            }
        }
    }
}

var caregiverButton: some View {
    ZStack {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color(red: 0.92, green: 0.55, blue: 0.55)) // Light Red #EA8C8C
            .frame(width: 250, height: 100)
        NavigationLink("Caregiver", destination: CaregiverScreen())
            .font(.largeTitle)
            .bold()
            .foregroundColor(.white)
    }
}

var bcbaButton: some View {
    ZStack {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color(red: 0.92, green: 0.55, blue: 0.55)) // Light Red #EA8C8C
            .frame(width: 250, height: 100)
        NavigationLink("BCBA", destination: BCBAScreen())
            .font(.largeTitle)
            .bold()
            .foregroundColor(.white)
    }
}

var adminButton: some View {
    ZStack {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(red: 0.92, green: 0.55, blue: 0.55)) // Light Red #EA8C8C
            .frame(width: 150, height: 40)
        NavigationLink("Admin", destination: AdminScreen())
            .font(.title3)
            .bold()
            .foregroundColor(.white)
    }
}

struct AdminScreen: View {
    var body: some View {
        ZStack {
            Color(red: 0.27, green: 0.48, blue: 0.61) // Blue #457B9D
                .ignoresSafeArea()
            Text("Welcome to the Admin Panel")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    ContentView()
}
