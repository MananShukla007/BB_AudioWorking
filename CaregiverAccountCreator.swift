//
//  CaregiverAccountCreator.swift
//  Behavior Buddy
//
//  Created by Micah Pressler on 10/1/24.
//

import SwiftUI

struct CaregiverAccountCreator: View {
    @Environment(\.presentationMode) var presentationMode
    @State var newEmail = ""
    @State var newPassword = ""
    @State var firstName = ""
    @State var lastName = ""
    @State var newUsername = ""
    @State private var isRegistered = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.lightSkyBlue
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Back Button
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "arrow.left")
                            Text("Back")
                        }
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 0) {
                        Text("Behavior")
                            .font(.custom("Chalkduster", size: 36))
                            .bold()
                            .foregroundColor(.darkSkyBlue)
                            .multilineTextAlignment(.center)

                        Text("Buddy")
                            .font(.custom("Chalkduster", size: 36))
                            .bold()
                            .foregroundColor(.darkSkyBlue)
                            .multilineTextAlignment(.center)
                    }

                    Text("Caregiver Account Creation")
                        .font(.custom("Chalkduster", size: 28))
                        .foregroundColor(Color.orange.opacity(0.7))
                        .padding(.top, 10)

                    ScrollView {
                        VStack {
                            Form {
                                Section(header: Text("Your Info")) {
                                    TextField("First Name", text: $firstName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())

                                    TextField("Last Name", text: $lastName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())

                                    TextField("Email", text: $newEmail)
                                        .autocapitalization(.none)
                                        .keyboardType(.emailAddress)
                                        .textContentType(.emailAddress)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())

                                    TextField("Username", text: $newUsername)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())

                                    SecureField("Password", text: $newPassword)
                                        .textContentType(.password)
                                }
                            }
                            .scrollContentBackground(.hidden)
                        }
                    }

                    Spacer()

                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.green)
                            .frame(width: 150, height: 50)
                        Text("Create Account")
                            .foregroundStyle(.white)
                    }
                    .onTapGesture {
                        print(firstName, lastName, newEmail, newUsername, newPassword)
                        isRegistered = true
                    }

                    Spacer()

                    NavigationLink(
                        destination: BCBAClientSelection(),
                        isActive: $isRegistered
                    ) {
                        EmptyView()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

struct CaregiverAccountCreator_Previews: PreviewProvider {
    static var previews: some View {
        CaregiverAccountCreator()
    }
}
