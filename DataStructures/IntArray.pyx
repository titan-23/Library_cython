# cython: language_level = 3

from libc.stdlib cimport malloc, realloc, free

cdef class IntArray():

  cdef:
    int *start
    int stop, end, ite

  def __cinit__(self, a=None):
    self.start = NULL
    self.end = 0
    self.stop = 0
    cdef int e
    if a is not None:
      for e in a:
        self.append(e)

  cdef void resize(self, size_t n, int x=0):
    cdef int i
    cdef int *mem
    mem = <int*> malloc(n*sizeof(int))
    for i in range(n):
      mem[i] = x
    self.start = mem
    self.stop = int(n)
    self.end = int(n)

  cdef void reserve(self, size_t n):
    cdef int *mem
    mem = <int*> realloc(self.start, (n+self.end)*sizeof(int))
    if mem is NULL: raise MemoryError
    self.start = mem
    self.end += int(n)

  cdef void append(self, int x):
    if self.stop >= self.end:
      self.reserve(self.end+1)
    self.start[self.stop] = x
    self.stop += 1

  cdef void remove(self, int x):
    cdef int i, j
    for i in range(self.stop):
      if self.start[i] == x:
        for j in range(i+1, self.stop):
          self.start[j-1] = self.start[j]
        self.stop -= 1
        return
    raise ValueError

  cdef int index(self, int x):
    cdef int i
    for i in range(self.stop):
      if self.start[i] == x:
        return i
    raise ValueError

  cdef int pop(self):
    if self.stop == 0:
      raise IndexError
    self.stop -= 1
    return self.start[self.stop]

  def __dealloc__(self):
    free(self.start)

  def __iter__(self):
    self.ite = 0
    return self

  def __next__(self):
    self.ite += 1
    if self.ite > self.stop:
      raise StopIteration
    return self.start[self.ite-1]

  cdef int count(self, int x):
    cdef int res, i
    res = 0
    for i in range(self.stop):
      if self.start[i] == x:
        res += 1
    return res

  cdef bint empty(self):
    return self.stop == 0

  cdef int size(self):
    return self.stop

  cdef int get(self, int k):
    return self.start[k]

  cdef void set(self, int k, int v):
    self.start[k] = v

  def __getitem__(self, int k):
    return self.start[k]

  def __setitem__(self, int k, int v):
    self.start[k] = v

  def __len__(self):
    return self.stop

  def __str__(self):
    return '[' + ', '.join(map(str, self)) + ']'

