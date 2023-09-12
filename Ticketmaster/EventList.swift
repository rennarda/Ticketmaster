//
//  ContentView.swift
//  Ticketmaster
//
//  Created by Andrew Rennard on 11/09/2023.
//

import SwiftUI
import TicketmasterClient
import CachedAsyncImage

/// The main list of events
struct EventList: View {
    @State var viewModel: EventListViewModel
    @State var searchText: String = ""
    @State var showSearch = false
    
    var body: some View {
        ZStack {
            List {
                ForEach(viewModel.events) { event in
                    EventRow(event: event)
                }
            }

            if viewModel.searching {
                VStack(spacing: 10) {
                    ProgressView()
                    Text("Loading…").foregroundColor(.secondary)
                }
                .padding(40)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(uiColor: .systemFill))
                }
            }

        }
        .listStyle(.plain)
        .searchable(text: $searchText, isPresented: $showSearch, prompt: "Search for a event or location")
        .onSubmit(of: .search) {
            showSearch = false
            Task {
                await viewModel.getEvents(keyword: searchText)
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel){}
        } message: {
            Text(viewModel.error?.localizedDescription ?? "")
        }
    }
}

/// A row in the event list
struct EventRow: View {
    let event: Event
    var body: some View {
        HStack {
            CachedAsyncImage(url: event.thumbnailImageURL) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
            } placeholder: {
                Image(systemName: "photo")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
            }
            VStack(alignment: .leading) {
                Text(event.name)
                    .font(.headline)
                if let date = event.date {
                    Text(date.formatted(.dateTime.year().month().day().hour().minute()))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        EventList(viewModel: EventListViewModel())
    }
}
