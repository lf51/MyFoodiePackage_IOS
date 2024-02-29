// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyFoodiePackage",
    platforms: [
        .macOS(.v11),
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MyFoodiePackage",
            targets: ["MyFoodiePackage"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        //.package(url:"https://github.com/lf51/MyPackView_L0.git", from: "0.0.9")
        .package(url: "https://github.com/lf51/MyFilterPackage.git", from: "0.5.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MyFoodiePackage",
            dependencies: [
               //.product(name: "MyPackView_L0", package: "MyPackView_L0")
                .product(name: "MyFilterPackage", package: "MyFilterPackage")
            ]),
    ]
)
