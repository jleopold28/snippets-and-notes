package minesweeper

// Board minesweeper board
type Board [][]byte

// String board to string type conversion
func (board *Board) String() string {
	return "\n" + string(bytes.Join(board, []byte{'\n'}))
}

// Minesweeper populates numbers on minesweeper board
func (board *Board) Minesweeper() {
	for rowIndex, row := range board {
		for colIndex := range row {
			mineCount := 0
			for rowSlice := rowIndex - 1; rowSlice <= rowIndex+1; rowSlice++ {
				for colSlice := colIndex - 1; colSlice <= colIndex+1; colSlice++ {
					if board[rowSlice][colSlice] == '*' {
						mineCount++
					}
				}
			}
			board[rowIndex][colIndex] = mineCount
		}
	}
}
