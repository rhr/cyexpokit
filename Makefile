FC	= gfortran
FFLAGS	= -O3

.f.o:;  $(FC) $(FFLAGS) -fPIC -c $<

%.o: ./%.f
	$(FC) $(FFLAGS) -fPIC -c $<

all: python

cyexpokit.c: cyexpokit.pyx
	cython cyexpokit.pyx

python: cyexpokit.c clock.o mataid.o my_expokit.o my_matexp.o
	python ./setup.py build_ext --inplace

