use ooc-gsl
import matrix
import structs/ArrayList

import io/[FileReader, StringReader, Reader]
import text/StringTokenizer

readInt: func(buf: Reader) -> Int{
    number : String = ""
    while(buf hasNext?() && (buf peek() < '0' || '9' < buf peek())){
        buf read()
    }
    while(buf hasNext?() && ('0' <= buf peek() && buf peek() <= '9')){
        number += buf read()
    }
    number size > 0 ? number toInt() : 0
}

readFloat: func(buf: Reader) -> Double{
    number := ""
    while(buf hasNext?() && ((buf peek() < '0' || '9' < buf peek()) && buf peek() != '.' )) buf read()
    while(buf hasNext?() && (('0' <= buf peek() && buf peek() <= '9') || buf peek() == '.')){ 
        number += buf read()
    }
    number size > 0 ? number toDouble() : 0.
}

Data: class {
    dim : SizeT
    data := ArrayList<Vector> new()

    init: func(=dim)

    loadFromFile: static func(filename: String) -> This{
        dimension : SizeT = 0
        dataNumber: SizeT = 0

        fr := FileReader new(filename)
        content := fr readAll()
        fr close()

        list := content split("\n")
        // zero, jump over comment
        i := 0
        while(list[i] startsWith?("//")) i+=1
        // first, read dimension and number of instances
        rb := StringReader new(list[i])
        dimension = readInt(rb)
        dataNumber = readInt(rb)

        r := This new(dimension)

        i += 1
        for(j in 0..dataNumber){
            v := Vector new(dimension)
            bf := StringReader new(list[i])
            for(k in 0..dimension){
                v set(k, readFloat(bf))
            }
            r data add(v)
            i += 1
        }
        r
    }

    free: func{
        for(v in data) v free()
        data clear()
    }

    toMatrix: func ~rowmaj -> Matrix {
        m := Matrix new(data size, dim)
        m set(|i,j| data get(i) get(j))
        m
    }

    toArrayList: func -> ArrayList<Vector> { data }

    toVector: func(i: Int) -> Vector {data get(i)}

    clone : func -> This{ null }

    dimension: func -> SizeT{ dim }

    size: func -> SizeT{ data size }

    get: func(i: Int) -> Vector { data[i] }

    set: func(i: Int, d: Vector) {
        if(i >= dim){ Exception new("[ListData set] index overflow!") throw() }
        while(i >= data size){ data add(d) }
    }
}
