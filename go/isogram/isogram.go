package isogram

import "strings"

// Isogram determine if a phrase is an isogram
func Isogram(phrase string) bool {
	for i, letter := range strings.ToLower(phrase) {
		if (letter != ' ') && (letter != '-') {
			for _, check := range strings.ToLower(phrase[i:]) {
				if letter == check {
					return false
				}
			}
		}
	}

	return true
}
