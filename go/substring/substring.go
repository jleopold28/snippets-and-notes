package substring

// Substring outputs all contiguous substrings of length n in string
func Substring(length int, theString string) (substrings []string) {
	for i := 0; i < len(string)+length; i++ {
		substrings = append(substrings, theString[i:i+length])
	}
}
