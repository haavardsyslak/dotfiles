#
# General purpose Makefile for C.
# 
# The Makefile is licensed under MIT
# and is part of the Pinit project.
#
# Author: Preben Vangberg
# Since: 21.10.2018 
#

OS = Linux

VERSION = 1.1.1
CC	= gcc

TARGET := bin/main
PARAM := -Wall

SRCDIR := src
OBJDIR := obj

SRCS := $(shell find $(SRCDIR) -name "*.c")
HDRS := $(shell find $(SRCDIR) -name "*.h")
OBJS := $(SRCS:$(SRCDIR)/%.c=$(OBJDIR)/%.o)

$(TARGET): $(OBJS)
	@mkdir -p bin
	$(CC) -o $@ $^


$(OBJDIR)/%.o: $(SRCDIR)/%.c $(HDRS)
	@mkdir -p $(shell dirname $@)
	$(CC) $(PARAM) $(@:$(OBJDIR)/%.o) -o $@ -c $<

clean: 
	rm -f $(OBJDIR)/*.o
	
all: clean $(TARGET)

