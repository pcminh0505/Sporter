//
//  ProfileView.swift
//  Sporter
//
//  Created by Minh Pham on 09/09/2022.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var profileVM: ProfileViewModel

    @State private var image: UIImage?
    @State private var showSheet = false

    let defaultImageURL: String = "https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg"

    @State var isUploaded: Bool = false
    @State var isEditing: Bool = false

    // Core info
    @State var color = Color.theme.textColor.opacity(0.7)
    @State var gender: Gender = .male
    @State var birthDate: Date = Date()
    @State var fname = ""
    @State var lname = ""
    @State var phone = ""
    @State var email = ""

    // Extra info
    @State var weight = ""
    @State var height = ""
    @State var sportType: SportType = .none
    @State var level: Level = .none

    var body: some View {
        ScrollView {
            ZStack(alignment: .topTrailing) {
                VStack {
                    // Image setion
                    if let image = self.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(70)
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())
                            .overlay(RoundedRectangle(cornerRadius: 70).stroke(Color.theme.textColor, lineWidth: 2))
                    } else {
                        AsyncImage (
                            url: URL(string: profileVM.currentUser?.profileImage ?? defaultImageURL),
                            content: { image in
                                image.resizable()
                                    .resizable()
                                    .scaledToFill()
                                    .cornerRadius(70)
                                    .frame(width: 140, height: 140)
                                    .clipShape(Circle())
                            },
                            placeholder: {
                                ProgressView()
                                    .cornerRadius(70)
                                    .frame(width: 140, height: 140)
                                    .background(Color(uiColor: .systemGray6))
                                    .clipShape(Circle())
                            }
                        )
                            .overlay(RoundedRectangle(cornerRadius: 70).stroke(Color(uiColor: .systemGray), lineWidth: 2))
                    }

                    Text(self.image == nil ? "Edit Avatar" : !self.isUploaded ? "Save New Avatar" : "Edit Avatar")
                        .font(.headline)
                        .foregroundColor(Color.accentColor)
                        .padding(.horizontal, 20)
                        .onTapGesture {

                        if let image = self.image {
                            if !self.isUploaded {
                                profileVM.uploadImage(image)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    self.isUploaded = true
                                }
                            }
                        } else {
                            self.showSheet = true
                            self.isUploaded = false
                        }
                    }

                    // Core info section
                    coreInfo

                    // Extra info section
                    extraInfo

                    // Log out button
                    Button(action: {
                        profileVM.logout()
                    }) {
                        Text("Log out")
                            .foregroundColor(.white)
                            .padding(.vertical)
                    }
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        .padding(.top, 25)
                }
                    .sheet(isPresented: $showSheet) {
                    ImagePicker(image: self.$image)
                }
                    .padding(.horizontal)
                    .padding(.top, 10)

                HStack {
                    if isEditing {
                        Button {
                            initValue()
                            self.isEditing.toggle()
                        } label: {
                            Text("Cancel")
                        }
                    }

                    Spacer()

                    if isEditing {
                        Button {
                            // Assign new value
                            updateEditableValue()

                            profileVM.updateUser()

                            self.isEditing.toggle()
                        } label: {
                            Text("Save")
                        }
                    } else {
                        Button {
                            self.isEditing.toggle()
                        } label: {
                            Text("Edit")
                        }
                    }
                }
                    .font(.system(size: 16))
                    .padding(.horizontal)
                    .padding(.top, 10)
            }
        }
            .onAppear {
            initValue()
        }
    }

    func initValue() {
        self.gender = Gender.init(rawValue: profileVM.currentUser?.gender ?? "male") ?? .male
        self.birthDate = Date(timeIntervalSince1970: profileVM.currentUser?.bod ?? 0)
        self.fname = profileVM.currentUser?.fname ?? ""
        self.lname = profileVM.currentUser?.lname ?? ""
        self.phone = profileVM.currentUser?.phone ?? ""
        self.email = profileVM.currentUser?.email ?? ""
        self.weight = String(format: "%.1f", profileVM.currentUser?.weight ?? 0.0)
        self.height = String(format: "%.2f", profileVM.currentUser?.height ?? 0.0)
        self.sportType = SportType.init(rawValue: profileVM.currentUser?.sportType ?? "none") ?? .none
        self.level = Level.init(rawValue: profileVM.currentUser?.level ?? "none") ?? .none
    }

    func updateEditableValue() {
        profileVM.currentUser?.phone = self.phone
        profileVM.currentUser?.email = self.email
        profileVM.currentUser?.weight = Double(self.weight) ?? 60
        profileVM.currentUser?.height = Double(self.height) ?? 1.70
        profileVM.currentUser?.sportType = self.sportType.rawValue
        profileVM.currentUser?.level = self.level.rawValue
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(ProfileViewModel())
    }
}

extension ProfileView {
    private var coreInfo: some View {
        VStack {
            HStack (spacing: 15) {
                InputTextBox(title: "First Name",
                             text: self.$fname,
                             placeholder: "John")

                InputTextBox(title: "Last Name",
                             text: self.$lname,
                             placeholder: "Smith")
            }
                .disabled(true)

            VStack {
                DatePicker(selection: $birthDate, in: ...Date(), displayedComponents: .date) {
                    Text("Day of Birth")
                        .font(.headline)
                }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(Color.accentColor, lineWidth: 2))
                    .padding(.top, 25)
                    .disabled(true)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text("Gender")
                    .font(.headline)
                Picker("Gender", selection: $gender) {
                    ForEach(Gender.allCases) { gender in
                        Text(gender.rawValue.capitalized).tag(gender)
                    }
                }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(Color.accentColor, lineWidth: 2))
            }
                .disabled(true)
                .padding(.top, 25)



            InputTextBox(title: "Phone Number",
                         text: self.$phone,
                         placeholder: "+84...",
                         numberOnly: true)
                .disabled(!isEditing)

            InputTextBox(title: "Email",
                         text: self.$email,
                         placeholder: "abc@gmail.com")
                .disabled(!isEditing)
        }
            .foregroundColor(!isEditing ? Color(uiColor: .systemGray) : Color.theme.textColor)
    }


    private var extraInfo: some View {
        VStack {
            Text("Sports Related Info")
                .foregroundColor(Color.accentColor)
                .font(.title3)
                .bold()
            VStack {
                HStack (spacing: 15) {
                    InputTextBox(title: "Weight (in kg)",
                                 text: self.$weight,
                                 placeholder: "Eg. 62",
                                 numberOnly: true)

                    InputTextBox(title: "Height (in m)",
                                 text: self.$height,
                                 placeholder: "Eg. 1.72",
                                 numberOnly: true)
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text("Level")
                        .font(.headline)
                    Picker("Level", selection: $level) {
                        ForEach(Level.allCases) { level in
                            Text(level.rawValue.capitalized).tag(level)
                        }
                    }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(Color.accentColor, lineWidth: 2))
                }
                    .padding(.top, 25)

                VStack(alignment: .leading, spacing: 5) {
                    Text("Sport Type")
                        .font(.headline)
                    Picker("Sport Type", selection: $sportType) {
                        ForEach(SportType.allCases) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(Color.accentColor, lineWidth: 2))
                }
                    .padding(.top, 25)
            }
                .disabled(!isEditing)
                .foregroundColor(!isEditing ? Color(uiColor: .systemGray) : Color.theme.textColor)
        }
            .padding(.top, 25)
    }
}
