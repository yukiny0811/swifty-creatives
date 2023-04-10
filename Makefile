all: build-macos build-ios test-macos test-ios build-example-macos build-example-ios
build-macos:
	xcodebuild -scheme SwiftyCreatives build -destination "generic/platform=macOS"
build-ios:
	xcodebuild -scheme SwiftyCreatives build -destination "generic/platform=iOS"
test-macos:
	xcodebuild -scheme SwiftyCreatives test -destination "platform=macOS,arch=x86_64"
test-ios:
	xcodebuild -scheme SwiftyCreatives test -destination "name=iPhone 14 Pro"
build-example-macos:
	cd Examples/ExampleMacOSApp && xcodebuild -scheme ExampleMacOSApp build -destination "generic/platform=macOS"
build-example-ios:
	cd Examples/ExampleiOSApp && xcodebuild -scheme ExampleiOSApp build -destination "name=iPhone 14 Pro"
