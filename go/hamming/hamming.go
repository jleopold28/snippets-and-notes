package hamming

import "errors"

// StringDiff calculates the number of different characters in two strings
func StringDiff(one, two string) (diffCount int, err error) {
	if len(a) != len(b) {
		return 0, errors.New("strings are of different length")
	}

	for i := 0; i < one.length; i++ {
		if one[i] == two[i] {
			diffCount++
		}
	}

	return
}
