//
//  NewEventForm.swift
//  Sporter
//
//  Created by Trang Nguyen on 12/09/2022.
//

import SwiftUI
import Firebase

struct NewEventForm: View {
    @EnvironmentObject var eventRepository: EventRespository
    // TODO: Fix navigation bug
    @Binding var isCreatingEvent: Bool
    let venue: Venue

    @State var title = ""
    @State var description = ""
    @State var date: Date = Date()
    @State var isLoading: Bool = false
    @State var alert = false
    @State var error = ""

    // Only allow 1-week booking from now
    var closedRange: ClosedRange<Date> {
        let today = Date()
        let untilNextWeek = Calendar.current.date(byAdding: .day, value: 7, to: Date())!
        return today...untilNextWeek
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .center) {
                    // Heading
                    Text("Create New Event")
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
                        DatePicker("Date", selection: self.$date, in: closedRange ,displayedComponents: [.date, .hourAndMinute])
                            .padding()
                            .background(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.theme.textColor.opacity(0.7), lineWidth: 2))
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
                    HStack (spacing: 20) {
                        Button(action: {
                            // Disable
                            isCreatingEvent = false
                        }, label: {
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(Color.accentColor)
                                .background(RoundedRectangle(cornerRadius: 10).stroke())
                        })
                            .padding(.vertical)

                        Button(action: {
                            // Save new event to Firebase
                            createEvent()
                        }, label: {
                            if self.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .padding(.vertical)
                                    .frame(width: UIScreen.main.bounds.width - 50)
                            }
                            else {
                                Text("Save")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.accentColor)
                                    .cornerRadius(10)
                                }
                        })
                            .padding(.vertical)
                    }

                    // Push everything up
                    Spacer()
                }
                    .padding(.horizontal, 25)
            }
            
            if self.alert {
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
    }
    
    func createEvent() {
        self.isLoading = true
        if !self.title.isBlank {
            let id = UserDefaults.standard.value(forKey: "currentUser") as? String ?? ""
            
            if !id.isBlank {
                eventRepository.createEvent(Event(title: self.title.trimmingCharacters(in: .whitespacesAndNewlines),
                                                  description: self.description.trimmingCharacters(in: .whitespacesAndNewlines),
                                                  creator: id,
                                                  venue: self.venue.id,
                                                  dateTime: self.date.timeIntervalSince1970))
                self.isLoading = false
                isCreatingEvent = false
            }
        }
        else {
            self.error = "Please fill the event title"
            self.alert.toggle()
            self.isLoading = false
        }
    }
}

struct NewEventForm_Previews: PreviewProvider {
    static var previews: some View {
        NewEventForm(isCreatingEvent: .constant(false), venue: Venue.sampleData[0])
    }
}
