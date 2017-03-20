package triangle

// Triangle determines triangle type
func Triangle(a, b, c float64) string {
	if (a == b) && (a == c) {
		return "equilateral"
	} else if (a == b) || (b == c) {
		return "isosceles"
	} else if (a > b+c) || (b > a+c) || (c > a+b) {
		return "not a triangle"
	}
	return "scalene"
}
