use ooc-gsl
import matrix, eigen, blas
import math

use clustering
import data

data := Data loadFromFile("./vec_merged.txt")

x := data toMatrix()

aff := Matrix new(x size1(), x size1())
for(i in 0..x size1()){
    ta := x getRow(i)
    aff set(i, i, 0.)
    for(j in i+1..x size1()){
        tb := x getRow(j)
        sum := 0.0
        (ta - tb) get(|x| sum += x * x)
        kern := 2.7183 pow(-(sum * sum / (0.9 * 0.9)))
        aff set(i, j, sum sqrt())
        aff set(j, i, sum sqrt())
    }
}

x free()
x = aff

D := Matrix new ~zero (x size1(), x size1())
D set(|i, j| if(i == j){
        sum := 0.0 as Double
        tr := x getRow(i)
        tr get(|x| sum += x)
        tr free()
        return 1. as Double / (sum sqrt())
    }
    return 0)

// memory leaks because D * x generate new matrix which is not freed
L := D * x * D

(vc, vv) := L eigenVector()

eigenGensymmvSort(vv, vc, EigenSort VALDESC)

col1 := vc getCol(0)
col2 := vc getCol(1)
col3 := vc getCol(2)

for(i in 0..x size1()){ "%lf %lf %lf" printfln(col1 get(i), col2 get(i), col3 get(i)) }

col1 free()
col2 free()

L free()
vc free()
vv free()
x free()
D free()
data free()
