//
//  NumberAppTCAApp.swift
//  NumberAppTCA
//
//  Created by Oliver Foggin on 06/03/2022.
//

import SwiftUI
import Firebase
import ComposableArchitecture

@main
struct NumberAppTCAApp: App {
	init() {
		FirebaseApp.configure()
	}

	var body: some Scene {
		WindowGroup {
			ContentView(
				store: .init(
					initialState: .init(),
					reducer: numberReducer,
					environment: .live
				)
			)
		}
	}
}
