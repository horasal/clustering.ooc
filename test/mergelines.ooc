import io/FileReader
import structs/ArrayList

main: func(args: ArrayList<String> ) -> Int {
    f := FileReader new(args[1])

    i := 1
    while(f hasNext?()){
        s := f readUntil('\n')
        s substring(0, s size) print()
        " " print()
        if(i % 4 == 0){
            println()
            i = 1
        } else { i += 1 }
    }

    0
}
