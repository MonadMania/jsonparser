module Main where

-- TODO: implement applicative instance for Parser.

import Data.Char
import Control.Applicative

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

-- Notice that one parses the function first, then the value.
-- This is an example of chaining parsers together.
instance Applicative Parser where
  pure x = Parser $ \input -> Just (input, x)
  (Parser p1) <*> (Parser p2) = Parser $ \input -> do 
                                  (input', f) <- p1 input
                                  (input'', a) <- p2 input'
                                  Just (input'', f a)

instance Alternative Parser where
  empty = Parser $ \_ -> Nothing
  (Parser p1) <|> (Parser p2) = 
    Parser $ \input -> p1 input <|> p2 input

-- Like magic! If the parser fails to capture null, then mapping
-- this constant function over it gives Nothing.
-- I'm excluding all non-null cases.
jsonNull :: Parser JsonValue
jsonNull = (\_ -> JsonNull) <$> stringP "null"

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
stringP = sequenceA . map charP

-- Use the Alternative interface to attempt parsing 'true' first, then
-- 'false' if parsing 'true' fails.
jsonBool :: Parser JsonValue
jsonBool = f <$> (stringP "true" <|> stringP "false")
  where f "true"  = JsonBool True
        f "false" = JsonBool False
        -- This should never happen (never trust a comment like this).
        f _       = undefined

-- Pass a predicate, like isDigit, and parse the longest initial 
-- segment for which all characters satisfy the predicate.
spanP :: (Char -> Bool) -> Parser String
spanP f = 
  Parser $ \input -> 
    let (token, rest) = span f input 
      in Just (rest, token)

jsonNumber :: Parser JsonValue
jsonNumber = f <$> notNull (spanP isDigit)
  where f ds = JsonNumber $ read ds -- This should always work (bad comment)

-- Check if a parser of lists returns an empty list of values.
-- Helps jsonNumber.
notNull :: Parser [a] -> Parser [a]
notNull (Parser p) = Parser $ \input -> do
              (input', xs) <- p input
              if null xs
                 then Nothing
                 else Just (input', xs)

-- Room for improvement: add escaping support.
stringLiteral :: Parser String
stringLiteral = spanP (/= '"')

jsonString :: Parser JsonValue
jsonString = JsonString <$> (charP '"' *> stringLiteral  <* charP '"')

jsonValue :: Parser JsonValue
jsonValue = jsonNull <|> jsonBool <|> jsonNumber <|> jsonString

main :: IO ()
main = undefined
