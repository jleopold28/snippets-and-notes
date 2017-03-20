package strain

// Keep retain values passing lambda
func Keep(ints []int, lambda func(int) bool) (result []int) {
	for _, aInt := range ints {
		if lambda(aInt) {
			result = append(result, aInt)
		}
	}
	return result
}

// Discard remove values failing lambda
func Discard(ints []int, lambda func(int) bool) (result []int) {
	for _, aInt := range ints {
		if !lambda(aInt) {
			result = append(result, aInt)
		}
	}
	return result
}
