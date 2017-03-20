package pascaltriangle

// PascalTriangle compute Pascal's triangle up to n rows
func PascalTriangle(rows int) (triangle [][]int) {
	if rows < 1 {
		return
	}

	triangle = make([][]int, n)
	triangle[0][0] = 1

	if rows > 1 {
		row := []int{1, 1}
		triangle[1] = row

		for i := 2; i < rows; i++ {
			var nextRow []int
			nextRow[0] = 1
			nextRow[i] = 1

			for j := 1; j < i; j++ {
				nextRow[j] = row[j-1] + row[j]
			}

			row = nextRow
			triangle[i] = row
		}

		return triangle
	}
}
