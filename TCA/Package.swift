// swift-tools-version:5.5

import PackageDescription

let package = Package(
	name: "NumberAppTCA",
	platforms: [.iOS(.v15)],
	products: [
		.library(name: "Analytics", targets: ["Analytics"]),
		.library(name: "NumberCore", targets: ["NumberCore"]),
	],
	dependencies: [
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.33.1"),
		.package(url: "https://github.com/firebase/firebase-ios-sdk.git", .branch("master")),
	],
	targets: [
		.target(
			name: "Analytics",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
				.product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
			]
		),
		.target(
			name: "NumberCore",
			dependencies: [
				"Analytics",
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		),
		.testTarget(
			name: "NumberCoreTests",
			dependencies: [
				.product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
			]
		)
	]
)
