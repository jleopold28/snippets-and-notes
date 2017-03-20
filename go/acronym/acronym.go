package acronym

import "regexp"

// Acronym converts a phrase into an acronym
func Acronym(phrase string) (abbrev string) {
	for _, char := range phrase {
		if regexp.MatchString("[A-Z]", char) {
			abbrev += char
		}
	}
	return abbrev
}
