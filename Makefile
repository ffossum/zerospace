APP = zerospace
BUILD_DIR = build
BUNDLE = $(BUILD_DIR)/$(APP).app

.PHONY: all clean run

all: $(BUNDLE)

$(BUNDLE): main.swift Info.plist
	@mkdir -p $(BUNDLE)/Contents/MacOS
	swiftc -O -whole-module-optimization -o $(BUNDLE)/Contents/MacOS/$(APP) main.swift
	cp Info.plist $(BUNDLE)/Contents/

run: $(BUNDLE)
	open $(BUNDLE)

clean:
	rm -rf $(BUILD_DIR)
