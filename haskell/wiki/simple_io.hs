main = do
  putStrLn "The base?"
  base <- getLine
  putStrLn "The height?"
  height <- getLine
  putStrLn ("The area of that triangle is " ++ show (0.5 * read base * read height))
  putStrLn "What is your name?"
  name <- getLine
  if (name == "Simon") || (name == "John") || (name == "Phil")
    then putStrLn "Haskell is a great programming language."
    else if name == "Koen"
      then putStrLn "Debugging Haskell is fun."
      else putStrLn "I do not know you."
