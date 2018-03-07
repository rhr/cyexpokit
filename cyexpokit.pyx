from cpython.array cimport array, clone
import numpy as np
cimport numpy as np
np.import_array()

intarray = array('i')
dblarray = array('d')

cdef extern:
    void wrapalldmexpv_(int* n, int* m, double* t, double* v, double* w,
                        double* tol, double* anorm, double* wsp, int* lwsp,
                        int* iwsp, int *liwsp, int* itrace, int* iflag,
		        int* ia, int* ja, double* a, int* nz, double* res)
    void wrapsingledmexpv_(int* n, int* m, double* t, double* v, double* w,
                           double* tol, double* anorm, double* wsp, int * lwsp,
                           int* iwsp, int* liwsp, int* itrace, int* iflag,
                           int* ia, int* ja, double* a, int* nz, double* res)

cdef class SparseExpm:
    cdef int n, m, nz, ideg, iflag, lwsp, liwsp, itrace
    cdef double tol, t, anorm
    cdef int[:] ia, ja, iwsp
    cdef double[:] a, v, w, wsp, res

    def __init__(self, int n):
        self.n = n
        self.m = min(n-1, 30)
        self.v = clone(dblarray, n, True)
        self.w = clone(dblarray, n, False)
        self.tol = 1
        self.iflag = 0
        cdef int m = self.m
        cdef int ideg = 6
        self.lwsp = n*(m+1)+n+pow((m+2.),2)+4*pow((m+2.),2)+ideg+1
        self.wsp = clone(dblarray, self.lwsp, False)
        self.liwsp = m+4
        self.iwsp = clone(intarray, self.liwsp, False)
        self.anorm = 0
        self.itrace = 0
        self.res = clone(dblarray, n, False)

    def expm(self, int[:] ia, int[:] ja, double[:] data, int col, double t):
        cdef int nz = len(data)
        self.v[col] = 1
        wrapsingledmexpv_(
            &self.n, &self.m, &t,
            &self.v[0], &self.w[0],
            &self.tol, &self.anorm,
            &self.wsp[0], &self.lwsp,
            &self.iwsp[0], &self.liwsp,
            &self.itrace, &self.iflag, &ia[0], &ja[0],
            &data[0], &nz, &self.res[0])
        print(self.res)
        self.v[col] = 0

