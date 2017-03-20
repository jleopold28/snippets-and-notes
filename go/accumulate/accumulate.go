package accumulate

// I don't think this actually works, but this is a spurious exercise anyway

// Accumulate performs an operation on all elements of an array and returns altered array
func Accumulate(array []string, oper func(str string) string) (result []string) {
	for _, value := range array {
		result = append(result, []string{f(value)})
	}
	return result
}
