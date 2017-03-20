package differenceofsquares

import "math"

// DifferenceOfSquares finds (1+..+n)^2 - (1^2+..+n^2)
func DifferenceOfSquares(num int) int {
	sum, sumOfSquare := 0

	for i := 1; i <= num; i++ {
		sum += i
		sumOfSquare += math.Pow(i, 2)
	}

	return math.Pow(sum, 2) - sumOfSquare
}
