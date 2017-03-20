package queenattack

import (
	"errors"
	"math"
)

// QueenAttack determines whether two queens can attack each other in chess
func QueenAttack(posOne, posTwo string) {
	if posOne == posTwo {
		return errors.New("queens on same space")
	} else if (posOne[0] == posTwo[0]) || (posOne[1] == posTwo[1]) {
		return true
	} else if posOne[0]-posTwo[0] == math.Abs(posOne[1]-posTwo[1]) {
		return true
	}

	return false
}
