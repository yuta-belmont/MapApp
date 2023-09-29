//
//  Login.swift
//  Map
//
//  Created by Anthony Catino on 9/26/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth

class FirebaseManager: NSObject {
    
    let auth: Auth
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        
        super.init()
    }
}
    
    struct LoginView: View {       // invalid redeclaration of the struct? // so I renamed it to ContentView2 and all good
        
        @State var isLoginMode = false
        @State var email = ""
        @State var password = ""
        @State var path = NavigationPath()
        
        var body: some View {
            
            NavigationStack(path: $path) {
                
                    // Why was this in the ContentView file and why did he remove it for this section (creating a login page)?
                VStack(spacing:10) {
                    
                    Picker(selection: $isLoginMode, label:
                            Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                    
                    if isLoginMode {
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 100))
                                .padding()
                        }
                        
                    }
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding(12)
                        .background(.white)
                        .foregroundColor(.blue)
                    SecureField("Password", text: $password)
                        .padding(12)
                        .background(.white)
                        .foregroundColor(.black)
                    
                    Button {
                        handleAction()
                    } label: {
                        
                        HStack {
                            Spacer()
                            if !isLoginMode {
                                Text("Create Account")
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .font(.system(size: 30))
                                    .padding(.vertical, 10)
                                
                            } else {
                                Text("Login")
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .font(.system(size: 30))
                                    .padding(.vertical, 10)
                            }
                            Spacer()
                            
                        }.background(Color.green)
                        
                        //}
                        
                        Text(self.loginStatusMessage)
                            .foregroundColor(Color.red)
                        
                        //             Text("Here is my creation account page")
                    }
                    
                    .navigationDestination (for: String.self) {view in
                        if view == "ContentView" { ContentView()
                        }
                    }
                
                }
                .navigationTitle(isLoginMode ? "Log In" : "Create Account")
                .background(Color(.init(white: 0, alpha: 0.1))
                    .ignoresSafeArea())
                
                //            Image(systemName: "globe")
                //                .imageScale(.large)
                //                .foregroundColor(.accentColor)
                
                //ContentView(color: .mint)
                //Text("Let's build out our login page!")
            }
            
            //.padding()
            .ignoresSafeArea()
        }
        
        private func handleAction() {
            if isLoginMode {
                //            print("Should log in to firebase with existing credentials")
                loginUser()
            } else {
                CreateNewAccount()
                //            print("Register a new account inside of Firebase Auth and then store image in storage somehow...")
                
            }
            
        }
        @State var loginStatusMessage = ""
        
        private func loginUser() {
            FirebaseManager.shared.auth.signIn(withEmail: email, password: password) {result, err in
                if let err = err {
                    print("Failed to login user", err)
                    self.loginStatusMessage = "Failed to login user: \(err)"
                    return
                }
                
                path.append("ContentView")
                print("Successfully logged in as user: \(result?.user.uid ?? "")")
                self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
            }
        }
        
        private func CreateNewAccount() {
            FirebaseManager.shared.auth.createUser(withEmail: email, password: password) {
                result, err in
                if let err = err {
                    print("Failed to create user", err)
                    self.loginStatusMessage = "Failed to create user: \(err)"
                    return
                }
                
                
                print("Successfully created user: \(result?.user.uid ?? "")")
                self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
                
            }
            
        }
        
    }
    
    struct LoginView_Preview2: PreviewProvider {   //so when I commented this out, the invalid redec error disappeared from the same struct in the ContentView page... cannot declare struct with the same name in two different pages within same project maybe?, def can't declare twice in same page.
        static var previews: some View {
            LoginView()
        }
    }

