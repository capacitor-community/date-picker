// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorCommunityDatePicker",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "CapacitorCommunityDatePicker",
            targets: ["DatePickerPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "DatePickerPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/DatePickerPlugin"),
        .testTarget(
            name: "DatePickerPluginTests",
            dependencies: ["DatePickerPlugin"],
            path: "ios/Tests/DatePickerPluginTests")
    ]
)
