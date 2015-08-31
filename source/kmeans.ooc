use ooc-gsl
import structs/[ArrayList, List]
import data, matrix
import math, math/Random

KMeans: class {
    k: SizeT
    data: Data
    center := ArrayList<Vector> new()
    cluster := ArrayList<Int> new()

    alpha : Double = 0.01

    init: func ~data (=data, =k)

    clear: func{
        for(i in 0..center size){ center[i] free() }
        center clear()
        cluster clear()
    }

    free: func{
        clear()
    }

    printCenter: func {
        for((i, c) in center){ "center %5d = %s" printfln(i, c toString()) }
    }

    printCluster: func {
        for((i,c) in cluster){
            "data %5d belongs to %5d" printfln(i, c)
        }
    }

    toClusterList: func -> List<List<Int>> {
        r := ArrayList<List<Int>> new()
        for(i in 0 .. k){ r add(cluster filter(|x| x == i)) }
        r
    }

    initCenter: func {
        if(data == null) Exception new("data is null") throw()
        selected := ArrayList<Int> new()
        for(i in 0 .. k){
            cur := Random randInt(0, data size()-1, selected)
            selected add(cur)
            center add(data toVector(cur) clone())
        }
    }

    clusterArrayList : func -> ArrayList<ArrayList<Int>>{
        r := ArrayList<List<Int>> new()
        for(i in 0..k){ r add(cluster filter(|x| x == i)) }
        r
    }

    dist: func(i, j: Vector) -> Double{ 
        ic := i clone()
        ic sub(j)
        r := ic sum(|x| x * x) sqrt() 
        ic free()
        r
    }

    clustering: func(maxiter: Int = 50) {
        clear()
        initCenter()

        kk := 0
        needrepeat := true

        tempCenter := ArrayList<Vector> new()
        for(i in 0 .. center size){ tempCenter add(center[i] clone()) }

        while(kk < maxiter && needrepeat){
            // 1 assign each point to nearest cluster
            cluster clear()
            for(i in 0..data size()){
                cachedata := data toVector(i) clone()
                clusterdist := dist(cachedata, center[0])
                clusterIdx := 0
                for(j in 1 .. k){
                    d := dist(cachedata, center[j])
                    if(clusterdist > d) {
                        clusterIdx = j
                        clusterdist = d
                    }
                }
                cluster add(clusterIdx)
                cachedata free()
            }

            // 2 calculate new cluster center
            for(i in 0..k){
                center[i] set(| | 0)
                cs : Double = 0.
                for((j, x) in cluster){
                    if(x == i){ 
                        center[i] add(data toVector(j))
                        cs += 1
                    }
                }
                if(cs > 0) center[i] div(cs)
            }
            sqe := 0.0
            for(i in 0.. tempCenter size){ 
                tempCenter[i] sub(center[i])
                sqe += tempCenter[i] sum(|x| x > 0 ? x : -x) / tempCenter[i] size() 
            }
            if(sqe / tempCenter size < alpha) needrepeat = false
            for(i in 0 .. tempCenter size) tempCenter[i] copyFrom(center[i])

            kk+=1
        }
        for(i in 0..tempCenter size){ tempCenter[i] free() }
    }
}
