CC := clang
CXX := clang++

OBJDIR := ../../obj/
BINDIR := ../../bin/

INCLUDEDIR := $(CDIR)include/

CFLAGS := -Wall -Wextra -Wunused-parameter
CPPFLAGS := -I$(INCLUDEDIR)
CXXFLAGS := $(CFLAGS)

CSRCS = $(wildcard *.c)
CXXSRCS = $(wildcard *.cxx)

COBJS = $(patsubst %.c,$(OBJDIR)%.tools.fatrd.c.o,$(CSRCS))
CXXOBJS = $(patsubst %.cxx,$(OBJDIR)%.tools.fatrd.cxx.o,$(CXXSRCS))

EXECFILE = $(BINDIR)fatrd

.PHONY: all clean

all: $(EXECFILE)

clean:
	rm $(EXECFILE)
	rm $(CXXOBJS) $(COBJS)

$(EXECFILE): $(COBJS) $(CXXOBJS)
	$(CXX) -o $@ $^

$(OBJDIR)%.tools.fatrd.c.o: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

$(OBJDIR)%.tools.fatrd.cxx.o: %.cxx
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c -o $@ $<
