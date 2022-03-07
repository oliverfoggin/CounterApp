import ComposableArchitecture
import SwiftUI
import NumberCore

public struct NumberListView: View {
	let store: Store<NumberListState, NumberListAction>
	@ObservedObject var viewStore: ViewStore<NumberListState, NumberListAction>

	public init(store: Store<NumberListState, NumberListAction>) {
		self.store = store
		self.viewStore = ViewStore(store)
	}

	public var body: some View {
		List {
			ForEachStore(store.scope(state: \.numbers, action: NumberListAction.numberAction), content: { numberStore in
				WithViewStore(numberStore) { vs in
					NavigationLink {
						ContentView(store: numberStore)
					} label: {
						Text("\(vs.number)")
					}
				}
			})
				.onDelete { self.viewStore.send(.delete($0)) }
		}
		.onAppear { viewStore.send(.onAppear) }
		.navigationTitle("Numbers App")
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					viewStore.send(.addButtonTapped)
				} label: {
					Image(systemName: "plus")
				}

			}
		}
	}
}
