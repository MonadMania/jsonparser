module Main where

-- TODO: implement applicative instance for Parser.

import Data.Char

data JsonValue = JsonNull
               | JsonBool Bool
               | JsonNumber Integer  --NOTE: No support for floats
               | JsonString String
               | JsonArray [JsonValue]
               | JsonObject [(String, JsonValue)] -- Should be a Map (lookup times are long) or a similar container type
               deriving (Show, Eq)

-- Improve by adding error reporting and auxiliary structure
newtype Parser a = Parser { runParser :: String -> Maybe (String, a) }

instance Functor Parser where
  fmap f (Parser p) = 
    Parser $ \input -> do
      (input', x) <- p input
      Just (input', f x)

jsonNull :: Parser JsonValue
jsonNull = undefined

-- Parse a single character, namely the first character in the input String
charP :: Char -> Parser Char
charP x = Parser f
  where f (y:ys)  
          | y == x = Just (ys, x)
          | otherwise = Nothing
        f [] = Nothing

-- Parse a given string, namely the initial segment of input
-- Looking to use sequenceA to invert an applicative and a traversable
stringP :: String -> Parser String
stringP = undefined --sequenceA . map charP

jsonValue :: Parser JsonValue
jsonValue = undefined

main :: IO ()
main = undefined
