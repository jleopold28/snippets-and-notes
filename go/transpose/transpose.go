package transpose

// Transpose transposes a matrix
func Transpose(matrix [][]string) (newMatrix [][]string) {
	for rIndex, row := range matrix {
		for cIndex, value := range row {
			newMatrix[cIndex][rIndex] = value
		}
	}
	return newMatrix
}
