//
//  ContentView.swift
//  MyCar
//
//  Created by Radu Dan on 11/02/2020.
//  Copyright © 2020 Radu Dan. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showingNissanAlert = false
    @State private var showingPorscheAlert = false
    @State private var showingFordAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("default_background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 20) {
                    HStack(spacing: 15) {
                        NavigationLink(destination: CarDetectionView()
                            .environment(\.useUpdateClassifier, false)) {
                            Text("🤖👾")
                                .padding()
                                .clipShape(Circle())
                                .font(.largeTitle)
                                .background(Color.white)
                                .cornerRadius(40)
                        }
                        NavigationLink(destination: CarDetectionView()
                            .environment(\.useUpdateClassifier, true)) {
                            Text("🧠🤯")
                                .padding()
                                .clipShape(Circle())
                                .font(.largeTitle)
                                .background(Color.white)
                                .cornerRadius(40)
                        }
                    }.padding(.top, 50)
                    Spacer()
                    HStack(spacing: 20) {
                        Button(action: {
                            let trainer = Trainer(car: .nissan)
                            trainer.updateModel {
                                self.showingNissanAlert = true
                            }
                        }) {
                            Text("🚐")
                                .padding()
                                .clipShape(Circle())
                                .font(.largeTitle)
                                .background(Color.white)
                                .cornerRadius(40)
                        }.alert(isPresented: $showingNissanAlert) {
                            Alert(title: Text("Training complete"), message: Text("Your nissan 🚐 classifier has been updated. "), dismissButton: .default(Text("OK")))
                        }
                        
                        Button(action: {
                            let trainer = Trainer(car: .porsche)
                            trainer.updateModel {
                                self.showingPorscheAlert = true
                            }
                        }) {
                            Text("🏎")
                                .padding()
                                .clipShape(Circle())
                                .font(.largeTitle)
                                .background(Color.white)
                                .cornerRadius(40)
                        }.alert(isPresented: $showingPorscheAlert) {
                            Alert(title: Text("Training complete"), message: Text("Your porsche 🏎 classifier has been updated. "), dismissButton: .default(Text("OK")))
                        }
                        
                        Button(action: {
                            let trainer = Trainer(car: .ford)
                            trainer.updateModel {
                                self.showingFordAlert = true
                            }
                        }) {
                            Text("🚓")
                            .padding()
                                .clipShape(Circle())
                                .font(.largeTitle)
                                .background(Color.white)
                                .cornerRadius(40)
                        }.alert(isPresented: $showingFordAlert) {
                            Alert(title: Text("Training complete"), message: Text("Your ford 🚓 classifier has been updated. "), dismissButton: .default(Text("OK")))
                        }
                    }
                    Spacer()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
