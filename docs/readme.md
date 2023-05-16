# Library_cython

競技プログラミング用のライブラリです。cythonで動きます。  
筆者はやる気がないので更新頻度は控え目です。ごめんなさい。

# DataStructures

## [IntArray](https://github.com/titanium-22/Library_cython/blob/main/DataStructures/IntArray.pyx)
int型の動的配列です。pythonの`list-like`な作りです。  
`a[i], a[i] = v` よりも、`a.get(i), a.set(i, v)` の方が高速です。
