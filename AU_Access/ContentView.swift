//
//  ContentView.swift
//  AU_Access
//
//  Created by Will McCormick on 2/27/23.
//

import SwiftUI
import WebKit
import EventKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        //Update View
    }
}

struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}

struct ContentView: View {
    
    @StateObject var vm = ViewModel()
    
    struct LinkItem: Identifiable {
        let id: UUID = UUID()
        let imageName: String
        let destinationURL: String
        let text: String
        var isDeleted: Bool = false
    }
    
    @State private var links: [LinkItem] = [
        LinkItem(imageName: "AU Portal", destinationURL: "https://myau.american.edu", text: "AU Portal"),
        LinkItem(imageName: "Eagle Service", destinationURL: "https://eagleservice.american.edu", text: "Eagle Service"),
        LinkItem(imageName: "ISSS", destinationURL: "https://www.american.edu/ocl/isss", text: "ISSS"),
        LinkItem(imageName: "Canvas", destinationURL: "https://american.instructure.com", text: "Canvas"),
        LinkItem(imageName: "AU Security", destinationURL: "https://www.american.edu/finance/memos/au-campus-safety-and-security-resources-notification-2022.cfm", text: "Au Security"),
        LinkItem(imageName: "Dining", destinationURL: "https://www.american.edu/ocl/onecarddining/", text: "Dining"),
        LinkItem(imageName: "Library", destinationURL: "https://www.american.edu/library", text: "Library"),
        LinkItem(imageName: "Calendar", destinationURL: "https://www.american.edu/provost/registrar/academic-calendar.cfm", text: "AU Calendar"),
        LinkItem(imageName: "Social", destinationURL: "https://www.american.edu/ocl/student-involvement/student-clubs.cfm", text: "Social Clubs"),
        LinkItem(imageName: "SHP", destinationURL: "https://american.studenthealthportal.com", text: "Health Portal")
    ]
    
    @State private var deletedLinks: [LinkItem] = []
    @State private var activeURL: IdentifiableURL? = nil
    @State private var isCalendarSyncEnabled = false
    @State private var selectedItem: LinkItem? = nil
    
    var body: some View {
        if vm.authenticated {
            
            VStack(spacing: 0) {
                Rectangle()
                    .frame(height: 60)
                    .foregroundColor(.blue)
                    .overlay (
                        HStack {
                            Text("Welcome wm2355a!") //Change once you get access to APIs
                                .foregroundColor(.white)
                            Spacer()
                            Button("Logout", action: vm.logout)
                                .buttonStyle(.bordered)
                                .foregroundColor(.white)
                        }
                            .padding(.horizontal)
                    )
                Toggle(isOn: $isCalendarSyncEnabled) {
                    Text("Sync with AU Calender")
                        .foregroundColor(.blue)
                }
                .padding()
                .padding(.horizontal)
                .onChange(of: isCalendarSyncEnabled) { newValue in
                    if newValue {
                        addEventsToCalendar()
                    } else {
                        removeEventsFromCalendar()
                    }
                }
                    
                ScrollView {
                    VStack {
                        ForEach(0..<5) { row in
                            HStack(spacing: 20) {
                                ForEach(0..<2) { column in
                                    let index = row * 2 + column
                                    if index < links.count {
                                        let link = links[index]
                                        
                                        Button(action: {
                                            selectedItem = link
                                            
                                            if let url = URL(string: link.destinationURL) {
                                                activeURL = IdentifiableURL(url: url)
                                            }
                                        }) {
                                            VStack {
                                                Image(link.imageName)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 150, height: 150)
                                                    .cornerRadius(15)
                                                    .overlay(
                                                        Color.clear
                                                    )
                                                Text(link.text)
                                                    .font(.headline)
                                            }
                                        }
                                        .contextMenu {
                                            Button(action: {
                                                if let index = links.firstIndex(where: {$0.id == link.id}) {
                                                    deleteLink(at: index)
                                                }
                                            }) {
                                                Text("Delete")
                                                Image(systemName: "trash")
                                            }
                                        }
                                        .padding()
                                    } else {
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .sheet(item: $activeURL) { identifiableURL in
                        WebView(url: identifiableURL.url)
                    }
                    Button("Recover Deleted Links", action: recoverDeletedLinks)
                        .padding()
                }
            }
        } else {
            ZStack {
                Image("ppp")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .offset(x: -20, y: 0)
                
                VStack {
                    Rectangle()
                        .frame(height: 60)
                        .foregroundColor(.blue)
                        .overlay (
                            HStack {
                                Image("ICON")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("AU Access")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .font(.largeTitle)
                            }
                        )
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    VStack(spacing: 20) {
                        TextField("Username", text: $vm.username)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.none)
                        SecureField("Password", text: $vm.password)
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.none)
                            .privacySensitive()
                        
                        Button(action: vm.authenticate) {
                            Text("Sign-in with AU Credentials")
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Text("Reset an expired or forgotten password")
                            .foregroundColor(.red)
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
                    .padding()
                    
                    Spacer()
                }
            }
            .alert(isPresented: $vm.invalid) {
                Alert(
                    title: Text("Access denied"),
                    message: nil,
                    dismissButton: .default(Text("Dismiss"), action: vm.logPressed)
                )
            }
            .transition(.offset(x: 0, y: 850))
        }
    }
    
    func deleteLink(at index: Int) {
        let deletedLink = links.remove(at: index)
        deletedLinks.append(deletedLink)
    }
    
    func recoverDeletedLinks() {
        links.append(contentsOf: deletedLinks)
        deletedLinks.removeAll()
    }
    
    func createDate(day: Int, month: Int, year: Int, hour: Int = 0, minute: Int = 0) -> Date? {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = 0

        return calendar.date(from: dateComponents)
    }
    
    func createCalenderEvents(eventStore: EKEventStore) -> [EKEvent] {
        var events: [EKEvent] = []
        
        let eventDetails: [(title: String, startDate: (day: Int, month: Int, year: Int), endDate: (day: Int, month: Int, year: Int))] = [
                ("Spring classes end", (1, 5, 2023), (1, 5, 2023)),
                ("Theses and dissertations due in Registrar's Office for spring degree candidates", (1, 5, 2023), (1, 5, 2023)),
                ("Payment due for summer classes", (1, 5, 2023), (1, 5, 2023)),
                ("Spring study day; no classes", (2, 5, 2023), (3, 5, 2023)),
                ("Spring final examinations", (4, 5, 2023), (10, 5, 2023)),
                ("Commencement Weekend Activities", (11, 5, 2023), (14, 5, 2023)),
                ("All full-term spring classes final grades due", (12, 5, 2023), (12, 5, 2023)),
                ("Official Degree Award Date", (14, 5, 2023), (14, 5, 2023))
        ]

            for eventDetail in eventDetails {
                let startDate = createDate(day: eventDetail.startDate.day, month: eventDetail.startDate.month, year: eventDetail.startDate.year)
                let endDate = createDate(day: eventDetail.endDate.day, month: eventDetail.endDate.month, year: eventDetail.endDate.year)
                
                if let startDate = startDate, let endDate = endDate {
                    let event = EKEvent(eventStore: eventStore)
                    event.title = eventDetail.title
                    event.startDate = startDate
                    event.endDate = endDate
                    events.append(event)
                }
            }
        return events
    }
    
    private func removeEventsFromCalendar() {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { granted, error in
            if granted {
                let calendarEvents = createCalenderEvents(eventStore: eventStore)
                
                for event in calendarEvents {
                    let predicate = eventStore.predicateForEvents(withStart: event.startDate, end: event.endDate, calendars: nil)
                    let events = eventStore.events(matching: predicate)
                    
                    for eventToRemove in events {
                        if eventToRemove.title == event.title {
                            do {
                                try eventStore.remove(eventToRemove, span: .futureEvents)
                                print("Event removed from calendar: \(event.title!) on \(event.startDate!) to \(event.endDate!)")
                            } catch {
                                print("Error removing event: \(error)")
                            }
                        }
                    }
                }
            } else {
                print("Access denied to calendar")
            }
        }
    }

    private func addEventsToCalendar() {
        
        let eventStore = EKEventStore()
        let calendarEvents = createCalenderEvents(eventStore: eventStore)
        
        eventStore.requestAccess(to: .event) { granted, error in
            if granted {
                for event in calendarEvents {
                    let newEvent = EKEvent(eventStore: eventStore)
                    newEvent.title = event.title
                    newEvent.startDate = event.startDate
                    newEvent.endDate = event.endDate
                    
                    let calendar = eventStore.defaultCalendarForNewEvents
                    newEvent.calendar = calendar
                    do {
                        try eventStore.save(newEvent, span: .thisEvent)
                        print("Event added to calendar")
                    } catch {
                        print("Error saving event: \(error)")
                    }
                }
            } else {
                print("Access denied to calendar")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
