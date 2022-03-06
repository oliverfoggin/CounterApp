//
//  ContentView.swift
//  NumberAppTCA
//
//  Created by Oliver Foggin on 06/03/2022.
//

import SwiftUI
import ComposableArchitecture
import FirebaseAnalytics

struct ContentView: View {
	let store: Store<NumberState, NumberAction>
	@ObservedObject var viewStore: ViewStore<NumberState, NumberAction>

	init(store: Store<NumberState, NumberAction>) {
		self.store = store
		self.viewStore = ViewStore(store)
	}

	var body: some View {
		NavigationView {
			VStack {
				Text("\(viewStore.number)")
					.font(.title)
					.fontWeight(.bold)
					.padding()

				HStack {
					Button {
						viewStore.send(.decrementTapped)
					} label: {
						Text(Image(systemName: "minus"))
							.font(.title)
							.fontWeight(.bold)
							.foregroundColor(Color(white: 0.5))
							.frame(width: 44, height: 44)
							.padding()
							.background(Color(white: 0.95))
							.clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
					}

					Button {
						viewStore.send(.incrementTapped)
					} label: {
						Text(Image(systemName: "plus"))
							.font(.title)
							.fontWeight(.bold)
							.foregroundColor(Color(white: 0.5))
							.frame(width: 44, height: 44)
							.padding()
							.background(Color(white: 0.95))
							.clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
					}
				}

				Button {
					viewStore.send(.getFactTapped)
				} label: {
					Text("Get Fact")
						.font(.title)
						.foregroundColor(Color(white: 0.5))
						.padding()
						.frame(width: 150, alignment: .center)
						.background(Color(white: 0.95))
						.clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
				}
			}
			.alert(store.scope(state: \.factAlertState), dismiss: .dismissAlertTapped)
			.navigationTitle("Number App")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						viewStore.send(.getRandomNumberTapped)
					} label: {
						Text(Image(systemName: "questionmark"))
							.font(.title)
							.fontWeight(.bold)
							.foregroundColor(Color(white: 0.5))
					}
				}
			}
			.onAppear {
				viewStore.send(.onAppear)
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(
			store: .init(
				initialState: .init(),
				reducer: numberReducer,
				environment: .live
			)
		)
	}
}
