package robot

import (
	"fmt"
	"math/rand"
)

// supposed to not have any repeated names, but go handles arrays poorly so not attempting

// Robot struct
type Robot struct {
	name string
}

// Name Robot constructor
func (robo *Robot) Name() string {
	if robo.name == "" {
		robo.name = fmt.Sprintf("%c%c%03d", 'A'+byte(rand.Intn(26)), 'A'+byte(rand.Intn(26)), rand.Intn(1000))
	}
	return robo.name
}

// Reset Robot destructor
func (robo *Robot) Reset() {
	*robo = Robot{}
}
