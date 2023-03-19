//
//  ContentView.swift
//  AU_Access
//
//  Created by Will McCormick on 2/27/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = ViewModel()
    @State var isAUPortalTapped = false
    var body: some View {
        if vm.authenticated {
            VStack(spacing: 20){
                Rectangle()
                    .frame(width :500, height:40)
//                    .position(x:215,y:10)
                    .foregroundColor(Color.blue)
                Image("ICON")
//                    .position(x:220,y:-160)
                Text("Welcome **\(vm.username.lowercased())**!")
//                    .position(x:210,y:-250)
                Text("Today is:**\(Date().formatted(.dateTime))**")
//                    .position(x:220,y:-370)
                
                NavigationView{
                    ScrollView{
                        Rectangle().foregroundColor(Color.red)
                            .frame(width:150,height:150).cornerRadius(15)
                            .position(x:100,y:100)
                            .overlay(
                                NavigationLink("Test",destination:Text("www.auportal.com")))
                                
                        Text("AU Portal")
                            .position(x:100,y:-60)
                            .font(.system(size:20))
                            .onTapGesture {
                                isAUPortalTapped.toggle()
                            }
                        
                            
                        
                        Rectangle().foregroundColor(Color.yellow)
                            .frame(width:150,height:150).cornerRadius(15)
                            .position(x:100,y:100)
                        Rectangle().foregroundColor(Color.brown)
                            .frame(width:150,height:150).cornerRadius(15)
                            .position(x:100,y:100)
                        Rectangle().foregroundColor(Color.green)
                            .frame(width:150,height:150).cornerRadius(15)
                            .position(x:300,y:-375)
                        Rectangle().foregroundColor(Color.purple)
                            .frame(width:150,height:150).cornerRadius(15)
                            .position(x:300,y:-375)
                        Rectangle().foregroundColor(Color.orange)
                            .frame(width:150,height:150).cornerRadius(15)
                            .position(x:300,y:-375)
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
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
