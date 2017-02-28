/*
 This class is used to allow for the developer to have a 2-Dimensional Array to help represent the
 game of tetris (which is in a 2-Dimensional space). I am not entirely sure this is necessary in
 Swift 3, because one could create a 2-Dimensional area like so:
 
 Array(repeating: Array(repeating: nil, count: rows), count: columns)
 */
class Array2D<T> {
    let columns: Int
    let rows: Int
    var array: Array<T?>
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        
        array = Array<T?>(repeating: nil, count: rows*columns)
    }
    
    subscript(column: Int, row: Int) -> T? {
        /*
         Takes column first then row. The return is the value at array[row][column]
         */
        get {
            return array[(row * columns) + column]
        }
        set(newValue) {
            array[(row * columns) + column] = newValue
        }
    }
}
