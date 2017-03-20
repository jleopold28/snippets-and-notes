package gradeschool

import "sort"

type School map[int][]string

type Grade struct {
	Level    int
	Students []string
}

// New school constructor
func New() *School {
	return &School{}
}

// Add add a kv pair to school
func (school *School) Add(student string, grade int) {
	*school[grade] = append(*school[grade], student)
}

// Grade list all values for a non-unique key
func (school *School) Grade(grade int) []string {
	return *school[grade]
}

// Enrollment lists all sorted values for each sorted key
func (school *School) Enrollment() []Grade {
	// this is awful in go
}
