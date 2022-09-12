//
//  NewEventForm.swift
//  Sporter
//
//  Created by Trang Nguyen on 12/09/2022.
//

import SwiftUI

struct NewEventForm: View {
    // TODO: Fix navigation bug
    
    let venue: Venue
    
    @State var title = ""
    @State var description = ""
    @State var date: Date = Date()
    @State var time: Date = Date()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                // Heading
                Text("New Event")
                    .foregroundColor(Color.accentColor)
                    .font(.title)
                    .bold()
                    .padding(.bottom, 0)
                
                // Event form
                VStack {
                    InputTextBox(title: "Title",
                                 text: self.$title,
                                 placeholder: "Cool Event")
                
                    InputTextBox(title: "Description",
                                 text: self.$description,
                                 placeholder: "Let's meet up and exercise together!")
                    
                    // Date Time picker
                    DatePicker("Date", selection: self.$date, displayedComponents: [.date, .hourAndMinute])
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.accentColor, lineWidth: 2))
                    .padding(.top, 25)
                    
                }
                .padding(.bottom)
                
                // Venue info (pre-populated)
                VStack(spacing: 10) {
                    Text("Venue Information")
                        .foregroundColor(Color.accentColor)
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 5)
                
                    HStack(alignment: .top) {
                        Image(systemName: "house.fill").padding(.trailing, -4)
                        Text("Name: ").bold() + Text(venue.name)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)

                    HStack(alignment: .top) {
                        Image(systemName: "mappin.and.ellipse").padding(.trailing, -4)
                        Text("Address: ").bold() + Text(venue.address)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    
                    HStack(alignment: .top) {
                        Image(systemName: "phone.fill").padding(.trailing, -4)
                        Text("Phone: ").bold() + Text(venue.phone)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    
                    HStack(alignment: .top) {
                        Image(systemName: "clock.fill").padding(.trailing, -4)
                        Text("Hours: ").bold() + Text("\(venue.open_time) - \(venue.close_time)")
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical)
                
                // Save button
                Button(action: {
                    // Save new event to Firebase
                }, label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                })
                .padding(.vertical)

                // Push everything up
                Spacer()
            }
            .padding(.horizontal, 25)
        }
    }
}

struct NewEventForm_Previews: PreviewProvider {
    static var previews: some View {
        NewEventForm(venue: Venue.sampleData[0])
    }
}
