# Spimple Makefile for Go
#       __ 
#   |_|(_   
#   | |__)
#   Author: Håvard Syslak 
#   Date: 31.01.2021   

TARGET := bin/main

ifeq (run,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(RUN_ARGS):;@:)
endif


build:
	@mkdir -p bin
	go build -o $(TARGET) *.go

get: 
	@echo "Installing dependencies"
	go get

run: build
	./bin/saps $(RUN_ARGS)
	
all: get build	

