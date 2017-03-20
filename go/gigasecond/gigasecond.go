package gigasecond

import "time"

// Gigasecond calculates time when someone has lived a gigasecond
func Gigasecond(theTime time.Time) time.Time {
	return theTime.Add(1e9 * time.Second)
}
