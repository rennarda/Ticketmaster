//
//  NetworkMonitor.swift
//  BeachStatus
//
//  Created by Andrew Rennard on 12/09/2023.
//

import SwiftUI
import Network
import Observation

@Observable
private final class NetworkMonitorViewModel {
    var showAlert = false
    let monitor = NWPathMonitor()
    
    init() {
        monitor.pathUpdateHandler = { path in
            self.showAlert = (path.status == .unsatisfied)
        }
        monitor.start(queue: .main)
    }
    
}

public struct NetworkAlert: ViewModifier{
    public init() {}
    @State fileprivate var viewModel = NetworkMonitorViewModel()
    
    @State var isVisible = true
    
    public func body(content: Content) -> some View {
        content
            .notificationOverlay(isVisible: $viewModel.showAlert) {
                FloatingAlert(color: .red,
                              foregroundColor: .primary,
                              message: "No network connection"
                )
            }
    }
}

extension View {
    public func networkAlert() -> some View {
        modifier(NetworkAlert())
    }
}

public struct NotificationOverlay<T: View>: ViewModifier{
    public init(popupContent: @escaping () -> T, isVisible: Binding<Bool>) {
        self.popupContent = popupContent
        self._isVisible = isVisible
    }

    let popupContent: () -> T
    @Binding var isVisible: Bool
    
    public func body(content: Content) -> some View {
        GeometryReader { g in
            ZStack {
                content
                GeometryReader { g in
                    VStack {
                        Spacer()
                        popupContent()
                    }
                }
                .frame(idealHeight: .zero)
                .offset(x: 0, y: isVisible ? 0 : g.size.height)
                .opacity(isVisible ? 1.0 : 0.0)
                .animation(.spring(), value: isVisible)
            }
        }
    }
    
    public init(isVisible: Binding<Bool>, popupContent: @escaping () -> T) {
        self.popupContent = popupContent
        self._isVisible = isVisible
    }
}


extension View {
    public func notificationOverlay<T: View>(isVisible: Binding<Bool>, content: @escaping () -> T) -> some View {
        modifier(NotificationOverlay(isVisible: isVisible, popupContent: content))
    }
}

public struct FloatingAlert: View {
    public init(color: Color, foregroundColor: Color, message: String) {
        self.color = color
        self.message = message
        self.foregroundColor = foregroundColor
    }
    
    @ScaledMetric(relativeTo: .body) var alertHeight = 60.0
    var color: Color
    var foregroundColor: Color
    var message: String
    
    public var body: some View {
        color
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 1)
            .overlay(
                Text(message)
                    .bold()
                    .foregroundColor(foregroundColor)
                    .padding(10)
            )
            .padding(10)
            .frame(height: alertHeight)
    }
}
