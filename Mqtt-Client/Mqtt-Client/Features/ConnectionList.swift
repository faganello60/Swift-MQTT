//
//  ContentView.swift
//  Mqtt-Client
//
//  Created by Bruno Faganello on 19/07/22.
//

import SwiftUI
import MQTTNIO

struct ConnectionList: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Connection.timeAdded, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Connection>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        ConnectionDetail(connection: item)
                    } label: {
                        Text(item.name ?? "Not Set")
                    }
                    .contextMenu {
                        Button(action: {
                            deleteItem(item)
                        }){
                            Text("Delete")
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationBarTitle("Connections")
            .navigationBarItems(
                trailing:
                    Button(action: {
                        
                    }, label: {
                        NavigationLink(destination: RegisterConnectionView()) {
                            Text("Add Connection")
                        }
                    })
            )
        }
    }
    
    private func deleteItem(_ item: Connection) {
        viewContext.delete(item)
        try? viewContext.save()
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            try? viewContext.save()
        }
    }
}
