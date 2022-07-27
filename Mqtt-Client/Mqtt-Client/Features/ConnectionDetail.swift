//
//  ConnectionDetail.swift
//  Mqtt-Client
//
//  Created by Bruno Faganello on 21/07/22.
//

import SwiftUI
import MQTTNIO

struct ConnectionDetail: View {
    
    let connection: Connection
    @State var topicToSubscribe = ""
    @State var dataToSend = ""
    @State var isSubscribed = false
    @State private var recivedData = ""
    private let client: MQTTClient
    
    init(connection: Connection) {
        self.connection = connection
        client = .init(configuration:
                .init(
                    target: .host(connection.host ?? "", port: Int(connection.port)),
                    clientId: connection.name ?? "",
                    credentials: .init(username: connection.user ?? "", password: connection.password ?? "")
                )
        )
    }
    
    var body: some View {
        Form {
            Section(header: Text("Generic Information")) {
                RowDetailView(title: "Connection Name", detail: connection.name ?? "")
            }
            
            Section(header: Text("Host Information")) {
                RowDetailView(title: "Host Name", detail: connection.host ?? "")
                RowDetailView(title: "Port Number", detail: String(connection.port))
                RowDetailView(title: "User", detail: connection.user ?? "")
                RowDetailView(title: "Password", detail: connection.password ?? "")
                RowDetailView(title: "Topic to Publish", detail: connection.topic ?? "")
                
            }
            
            Section(header: Text("Data to Publish")){
                TextField("Data to Publish", text: $dataToSend)
            }
            
            Section(header: Text("Topic to Subscribe")) {
                HStack{
                    TextField("Topic", text: $topicToSubscribe)
                    Spacer()
                    Button {
                        subscribe()
                    } label: {
                        Text(isSubscribed ? "Stop Listening" : "Start Listening")
                    }
                    
                }
                Text(recivedData)
            }
            
            Button {
                sendData()
            } label: {
                HStack {
                    Spacer()
                    Text("Send Data")
                    Spacer()
                }
            }
            .buttonStyle(.borderless)
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(32)
            .padding(16)
        }
        .navigationBarTitle("Connection Detail")
        .onAppear {
            self.client.whenMessage { message in
                self.recivedData = "\(self.recivedData) \n \(message.payload.string ?? "")"
            }
        }
    }
    
    private func subscribe() {
        isSubscribed.toggle()
        if isSubscribed {
            client.subscribe(to: topicToSubscribe)
            return
        }
        client.unsubscribe(from: topicToSubscribe)
    }
    
    private func sendData() {
        client.connect()
        client.publish(dataToSend, to: connection.topic ?? "")
    }
}


struct RowDetailView: View {
    let title: String
    let detail: String
    
    var body: some View {
        HStack() {
            Text(title)
            Spacer()
            Text(detail)
        }
    }
}
