package raindrops

import "strconv"

// Raindrops return a string based on a number
func Raindrops(num int) string {
	converted := ""

	if num%3 == 0 {
		converted = "Pling"
	}
	if num%5 == 0 {
		converted += "Plang"
	}
	if num%7 == 0 {
		converted += "Plong"
	}
	if converted == "" {
		converted = strconv.Itoa(num)
	}
	return converted
}
