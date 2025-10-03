# Initialize
init:
	sh scripts/init.sh

# Run swiftformat
format:
	swiftformat . --swiftversion 5
	