use clustering
import data,kmeans
import structs/List

data := Data loadFromFile("./vec_reduced.txt")
"data size: %d" printfln(data size())
/*
for(i in 0..data size()){
    data toVector(i) get(|x| "%lf," printf(x))
    println()
}
*/

km := KMeans new(data, 3)
km clustering()
km printCenter()
km printCluster()
for((i,x) in km toClusterList()){
    "cluster %i" printfln(i)
    for(j in x as List<Int>){
        "%d, " printf(j)
    }
    println()
}

data free()
