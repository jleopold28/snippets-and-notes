package allergies

import "math"

var allergens = []string{"eggs", "peanuts", "shellfish", "strawberries", "tomatoes", "chocolate", "pollen", "cats"}

// Allergies a simple binary string mapping thingy
func Allergies(score uint) (result []string) {
	for i, allergen := range allergens {
		if (score-math.Pow(2, i))&score == 0 {
			result = append(result, allergen)
		}
	}
	return result
}
