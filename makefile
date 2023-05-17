ARGS=-lmpi_cxx -lm -lstdc++ -lhwloc -fopenmp
_RARGS=papagan.JPG out.jpg
PHOTODIR=./photos
RARGS=$(patsubst %,$(PHOTODIR)/%,$(_RARGS))
_HEADERS=stb_image.h stb_image_write.h
INCLUDEDIR=./include
HEADERS=$(patsubst %,$(INCLUDEDIR)/%,$(_HEADERS))
INCLUDE=-I./include
ODIR=./bin
SRC=./src


.PHONY: all
all: $(patsubst $(SRC)/%.cpp, $(ODIR)/%, $(wildcard $(SRC)/*.cpp))

$(ODIR)/%: $(SRC)/%.cpp $(HEADERS)
	mpicc $< -o $@ $(INCLUDE) $(ARGS)



.PHONY: run

define run_target

runParallelOpenMPCompile$(1): all
	gcc $(1) $(ODIR)/openmp_main $(RARGS)

.PHONY: runParallel$(1)

runParallelHybrid$(1): all
	mpirun -np $(1) $(ODIR)/hybrid_main $(RARGS)

.PHONY: runParallel$(1)

endef

$(foreach proc,1 2 3 4 6 8 10 12 14 16,$(eval $(call run_target,$(proc))))



.PHONY: clean
clean:
	rm -f bin/* photos/out.jpg

make emre:
	./bin/openmp_main photos/papagan.JPG photos/out.jpg 2