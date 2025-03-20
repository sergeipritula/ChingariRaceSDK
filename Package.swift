// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChingariRaceSdk",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ChingariRaceSdk",
            targets: ["ChingariRaceSdk"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", .upToNextMajor(from: "5.0.0-rc.2")),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.0")),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxOptional", .upToNextMajor(from: "5.0.0")),
        //        .package(url: "https://github.com/RxSwiftCommunity/RxGesture", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/slackhq/PanModal.git", .upToNextMinor(from: "1.2.7")),
        .package(url: "https://github.com/airbnb/lottie-spm.git", .upToNextMinor(from: "4.5.0")),
        .package(url: "https://github.com/socketio/socket.io-client-swift", .upToNextMajor(from: "16.1.1")),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ChingariRaceSdk",
            dependencies: ["Alamofire",
                           "Moya",
                           "RxSwift",
                           //                           "RxGesture",
                           "RxDataSources",
                           "RxOptional",
                           "SnapKit",
                           "PanModal",
                           "SDWebImage",
                           .product(name: "Lottie", package: "lottie-spm"),
                           .product(name: "RxMoya", package: "moya"),
                           .product(name: "SocketIO", package: "socket.io-client-swift")
                          ],
            resources: [
                .process("Resources/Fonts"),
                .process("Resources/Sounds"),
                .process("Resources/Lottie"),
                .process("Resources/Country/Media.xcassets"),
                .process("Resources/Country/countries.plist"),
                .process("Resources/Assets.xcassets")]
        ),
    ],
    swiftLanguageModes: [.v5]
)
