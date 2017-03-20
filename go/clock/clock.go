package clock

import "fmt"

// Clock type
type Clock int

// New Clock
func New(hour, min int) Clock {
	clock := Clock((hour*60 + min) % 1440)

	for clock < 0 {
		clock += 1440
	}

	return clock
}

// String return Clock as string
func (clock *Clock) String() string {
	return fmt.Sprintf("%02d:%02d", clock/60, clock%60)
}

// Add add time to a clock
func (clock *Clock) Add(min int) Clock {
	return New(0, int(clock)+min)
}
