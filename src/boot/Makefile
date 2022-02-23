.PHONY: all first-stage second-stage

all: first-stage second-stage

first-stage:
	make -C ./1/

second-stage:
	make -C ./2/

clean:
	make -C ./1/ clean
	make -C ./2/ clean
