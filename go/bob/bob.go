package bob

import "strings"

// Bob determines response to greeting
func Bob(greeting string) string {
	switch greeting = strings.TrimSpace(greeting); {
	case strings.HasSuffix(greeting, "?"):
		return "Sure."
	case strings.ToUpper(greeting):
		return "Whoa, chill out!"
	case "":
		return "Fine, be that way."
	default:
		return "Whatever."
	}
}
