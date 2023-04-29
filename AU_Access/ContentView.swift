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

struct ContentView: View {
    
    @StateObject var vm = ViewModel()
    @State var isAUPortalTapped = false
    @State private var rectangleOffset = CGSize.zero
    @GestureState private var dragOffset = CGSize.zero
    @State private var rectangleOffset1 = CGSize.zero
    @GestureState private var dragOffset2 = CGSize.zero
    var body: some View {
        if vm.authenticated {
            VStack(spacing: 20){

                Rectangle()
                    .frame(width :500, height:40)
//
                    .foregroundColor(Color.blue)
                Image("ICON")
//                    .position(x:220,y:-160)
                Text("Welcome **\(vm.username.lowercased())**!")
//                    .position(x:210,y:-250)
                Button("Sync with AU Calendar") {
                    addEventsToCalendar()
                }
                Button("Logout",action:vm.logout)
                    .buttonStyle(.bordered)
                
                NavigationView{
                    ScrollView{
                        
                        Rectangle().foregroundColor(Color.red)
                            .frame(width:150,height:150).cornerRadius(15)
                            
                            .overlay(
                                    NavigationLink("AU Portal", destination: WebView(url: URL(string: "https://myau.american.edu")!))
                                )
                            .position(x:100,y:100)
                            .offset(rectangleOffset)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            // Update the offset of the Rectangle based on the drag gesture
                                            rectangleOffset = CGSize(width: value.translation.width, height: value.translation.height)
                                        }
                                        .onEnded { value in
                                                        // Calculate the new position based on the offset and the drag gesture's translation
                                                      
                                                        rectangleOffset = .zero
                                                    }
                                )
                            
                        Rectangle().foregroundColor(Color.yellow)
                            .frame(width:150,height:150).cornerRadius(15)
                            .overlay(
                                NavigationLink("Eagle Service", destination: WebView(url: URL(string: "https://eagleservice.american.edu")!))
                            )
                            .position(x:100,y:100)
                        Rectangle().foregroundColor(Color.brown)
                            .frame(width:150,height:150).cornerRadius(15)
                            .overlay(
                                NavigationLink("International Student Services", destination: WebView(url: URL(string: "https://www.american.edu/ocl/isss")!))
                            )
                            .position(x:100,y:100)
                            
                        
                        
                        Rectangle().foregroundColor(Color.brown)
                            .frame(width:150,height:150).cornerRadius(15)
                            .overlay(
                                NavigationLink("AU Security", destination: WebView(url: URL(string: "https://www.american.edu/finance/memos/au-campus-safety-and-security-resources-notification-2022.cfm")!))
                            )
                            .position(x:100,y:100)
                            
                        Rectangle().foregroundColor(Color.brown)
                            .frame(width:150,height:150).cornerRadius(15)
                            .overlay(
                                NavigationLink("Dining", destination: WebView(url: URL(string:"https://www.american.edu/ocl/onecarddining/")!))
                            )
                            .position(x:100,y:100)
                            
                        
                        
                        
                            
                        Rectangle().foregroundColor(Color.green)
                            .frame(width:150,height:150).cornerRadius(15)
                            .overlay(
                                NavigationLink("Canvas", destination: WebView(url: URL(string: "https://american.instructure.com")!))
                            
                            )
                            .position(x:300,y:-690)
                            
                            
                        
                        Rectangle()
                            .foregroundColor(Color.purple)
                            .frame(width:150,height:150).cornerRadius(15)
                            .overlay(
                                NavigationLink(" Student Health Portal", destination: WebView(url: URL(string: "https://american.studenthealthportal.com")!))
                            )
                            
                            .position(x:300,y:-690)
                          
                            
                        Rectangle().foregroundColor(Color.orange)
                            .frame(width:150,height:150).cornerRadius(15)
                            .overlay(
                                NavigationLink("Library", destination: WebView(url: URL(string: "https://www.american.edu/library")!))
                            )
                            .position(x:300,y:-690)
                           
                            
                        Rectangle().foregroundColor(Color.orange)
                            .frame(width:150,height:150).cornerRadius(15)
                            .overlay(
                                NavigationLink("AU Calendar", destination: WebView(url: URL(string: "https://www.american.edu/provost/registrar/academic-calendar.cfm")!))
                            )
                            .position(x:300,y:-690)
                           
                            
                        
                        Rectangle().foregroundColor(Color.orange)
                            .frame(width:150,height:150).cornerRadius(15)
                            .overlay(
                                NavigationLink("Social Clubs ", destination: WebView(url: URL(string: "https://www.american.edu/ocl/student-involvement/student-clubs.cfm")!))
                            )
                            .position(x:300,y:-690)
                            
                            
                    }
                    .navigationTitle("Dashboard")
                }
            }
            
        } else{
            ZStack {
                Rectangle()
                    .frame(width :500, height:60)
                    .position(x:215,y:20)
                    .foregroundColor(Color.blue)
                Image("ICON")
                    .position(x:220,y:30)
                Image("ppp")
//                    .resizable()
//                    .cornerRadius(0)
                    .position(x:226, y:146)
                
                Rectangle()
                    .frame(width:500,height:40)
                    .position(x:200,y:350)
                    .foregroundColor(Color.blue)
                Image("ICON")
                    .position(x:126,y:350)
                Text("SIGN IN")
                    .position(x:226,y:350)
                
                
                
                VStack(alignment: .leading,spacing: 20){
                    Spacer()
                    
                    Text("Sign in to your Account")
                        .foregroundColor(.black)
                        .font(.system(size:30,weight:.medium,design:.rounded))
                        .position(x:226,y:370)
                    TextField("Username",text:$vm.username)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .position(x:226,y:225)
                    SecureField("Password",text:$vm.password)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .position(x:226,y:75)
                        .privacySensitive()
                    
                    HStack{
                        Spacer()
                        Button("Sign in",action:vm.authenticate)
                            .buttonStyle(.bordered)
                            .position(x:296,y:-76)
                            .foregroundColor(Color.blue)
                        Rectangle()
                            .frame(width:120,height:30)
                            .position(x:-40,y:-74)
                            .foregroundColor(Color.blue)
                        Text("AnotherUser")
                            .position(x:-155,y:-71)
//                        Spacer()
                        Button("Reset an expired or forgotten password",action:vm.logPressed)
                            .position(x:-206,y:5)
                            .tint(.red.opacity(0.8))
                        Spacer()
                            
                        
                    }
                    Spacer()
                    
                }
                .alert("Access denied", isPresented:$vm.invalid){
                    Button("Dismiss",action:vm.logPressed)
                }
//                .frame(width:300)
//                .padding()
                    
            }
            .transition(.offset(x:0,y:850))
        }
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
