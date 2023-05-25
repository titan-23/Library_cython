# cython: language_level = 3

from libc.stdlib cimport malloc, realloc, free

cdef class UnionFind():

  cdef:
    int *par

  def __cinit__(self, size_t n):
    cdef:
      int *p
      int i
    p = <int*> malloc(n*sizeof(int))
    if p is NULL: raise MemoryError
    for i in range(n):
      p[i] = -1
    self.par = p

  cdef int root(self, int x):
    cdef:
      int a, y
    a = x
    while self.par[a] >= 0:
      a = self.par[a]
    while self.par[x] >= 0:
      y = x
      x = self.par[x]
      self.par[y] = a
    return a

  cdef bint unite(self, int x, int y):
    x = self.root(x)
    y = self.root(y)
    if x == y:
      return False
    if self.par[x] > self.par[y]:
      x, y = y, x
    self.par[x] += self.par[y]
    self.par[y] = x
    return True

  cdef bint same(self, int x, int y):
    return self.root(x) == self.root(y)

  cdef int size(self, int x):
    return self.par[self.root(x)]

  def __dealloc__(self):
    free(self.p)

