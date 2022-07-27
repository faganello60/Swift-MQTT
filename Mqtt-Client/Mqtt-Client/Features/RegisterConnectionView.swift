//
//  RegisterConnectionView.swift
//  Mqtt-Client
//
//  Created by Bruno Faganello on 19/07/22.
//

import SwiftUI
import MQTTNIO

struct RegisterConnectionView: View {
    
    @State var connectionName = ""
    @State var hostName = ""
    @State var portNumberStr = "1883"
    @State var user = ""
    @State var password = ""
    @State var topicName = ""
    @State var dataToSend = ""
    @State var isRetain = false
    @Environment(\.managedObjectContext) private var viewContext
    
    let client = MQTTClient(configuration: .init(url: URL(fileURLWithPath: "")))
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Generic Information")) {
                    TextField("Connection Name", text: $connectionName)
                }
                
                Section(header: Text("Host Information")) {
                    TextField("Host Name", text: $hostName)
                    TextField("Port Number", text: $portNumberStr)
                    TextField("User", text: $user)
                    TextField("Password", text: $password)
                    Toggle("Retain", isOn: $isRetain)
                }
                
                Section(header: Text("Topic")) {
                    TextField("Topic", text: $topicName)
                    TextField("Data",text: $dataToSend)
                }
            }
            
            Button {
                tryConnection()
            } label: {
                HStack {
                    Spacer()
                    Text("Try Connection")
                    Spacer()
                }
            }
            .buttonStyle(.borderless)
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.accentColor)
            .overlay(
                RoundedRectangle(cornerRadius: 32)
                    .stroke(Color.accentColor, lineWidth: 1)
            )
            .padding(16)
            
            Button {
                saveConnection()
            } label: {
                HStack {
                    Spacer()
                    Text("Save")
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
            .navigationBarTitle("Create Connection")
        }
    }
    
    private func saveConnection() {
        withAnimation {
            let newConnection = Connection(context: viewContext)
            newConnection.name = connectionName
            newConnection.host = hostName
            newConnection.port = Int32(portNumberStr)!
            newConnection.user = user
            newConnection.password = password
            newConnection.topic = topicName
            newConnection.retains = isRetain
            newConnection.id = UUID()
            newConnection.timeAdded = Date()
            try? viewContext.save()
        }
    }
    
    private func tryConnection() {
        client.configuration = .init(
            target: .host(hostName, port: Int(portNumberStr)!),
            clientId: connectionName,
            credentials: .init(username: user, password: password)
        )
        
        client.connect()
        client.publish(dataToSend, to: topicName)
    }
}

struct RegisterConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterConnectionView()
    }
}
