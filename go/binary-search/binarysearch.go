package binarysearch

import "fmt"

// BinarySearch performs a binary search on a sorted array
func BinarySearch(array []int, search int) string {
	index := int(len(array) / 2)

	for {
		if array[index] == search {
			return fmt.Sprintf("%d found at index %d", search, index)
		} else if (index == 0) || (index == len(array)) || (int(index) != index) {
			if array[0] == search {
				return fmt.Sprintf("%d found at beginning of array", search)
			} else if array[len(array)] == search {
				return fmt.Sprintf("%d found at end of array", search)
			} else {
				return fmt.Sprintf("%d not found in sorted array", search)
			}
		} else if array[index] < search {
			index = (index + len(array)) / 2
		} else if array[index] > search {
			index /= 2
		}
	}
}
