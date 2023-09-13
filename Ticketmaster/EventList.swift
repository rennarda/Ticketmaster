//
//  ContentView.swift
//  Ticketmaster
//
//  Created by Andrew Rennard on 11/09/2023.
//

import SwiftUI
import SwiftData
import TicketmasterClient
import CachedAsyncImage

struct EventList: View {
    @State var viewModel: EventListViewModel
    @State var searchText: String = ""
    @State var showSearch = false
    
    @Query var events: [Event]

    var body: some View {
        ZStack {
            List {
                ForEach(events) { event in
                    EventRow(event: event)
                }
            }

            if viewModel.searching {
                VStack(spacing: 10) {
                    ProgressView()
                    Text("loading").foregroundColor(.secondary)
                }
                .padding(40)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(uiColor: .systemFill))
                }
            }

        }
        .listStyle(.plain)
        .searchable(text: $searchText, isPresented: $showSearch, prompt: "searchPrompt")
        .onSubmit(of: .search) {
            showSearch = false
            Task {
                await viewModel.getEvents(keyword: searchText)
            }
        }
        .alert("error", isPresented: $viewModel.showError) {
            Button("ok", role: .cancel){}
        } message: {
            Text(viewModel.error?.localizedDescription ?? "")
        }
    }
}

struct EventRow: View {
    @Environment(\.displayScale) var displayScale: CGFloat
    let event: Event
    static let imageWidth = 100
    
    var body: some View {
        HStack {
            CachedAsyncImage(url: event.imageOfWidthOrLess(Self.imageWidth * Int(displayScale))) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: CGFloat(integerLiteral: Self.imageWidth))
            } placeholder: {
                Image(systemName: "photo")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: CGFloat(integerLiteral: Self.imageWidth))
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
