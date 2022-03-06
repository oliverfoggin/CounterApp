//
//  NumberAppVanillaApp.swift
//  NumberAppVanilla
//
//  Created by Oliver Foggin on 06/03/2022.
//

import SwiftUI
import Firebase

@main
struct NumberAppVanillaApp: App {
	init() {
		FirebaseApp.configure()
	}

	var body: some Scene {
		WindowGroup {
			ContentView()
		}
	}
}
