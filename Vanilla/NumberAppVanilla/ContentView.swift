//
//  ContentView.swift
//  NumberAppVanilla
//
//  Created by Oliver Foggin on 06/03/2022.
//

import SwiftUI

struct ContentView: View {
	@ObservedObject var viewModel: ViewModel = .init()

	var body: some View {
		NavigationView {
			VStack {
				Text("\(viewModel.number)")
					.font(.title)
					.fontWeight(.bold)
					.padding()

				HStack {
					Button {
						viewModel.decrement()
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
						viewModel.increment()
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
					viewModel.getFact()
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
			.alert(
				"Number Fact",
				isPresented: Binding(
					get: {
						switch viewModel.numberFact {
						case .success: return true
						default: return false
						}
					},
					set: {
						if !$0 {
							viewModel.numberFact = .notAsked
						}
					}
				),
				presenting: viewModel.numberFact,
				actions: { _ in }
			) { fact in
				switch fact {
				case let .success(f):
					Text(f.text)
				default:
					Text("No fact found")
				}
			}
			.navigationTitle("Number App")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						viewModel.getRandomNumber()
					} label: {
						Text(Image(systemName: "questionmark"))
							.font(.title)
							.fontWeight(.bold)
							.foregroundColor(Color(white: 0.5))
					}
				}
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
