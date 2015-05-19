{-# LANGUAGE OverlappingInstances #-}
module Main where



import Prelude
import System.IO
import Data.Time
import Data.Attoparsec.Char8
import Text.ParserCombinators.ReadP (many)
import Control.Applicative ((<*))
import Data.Either
import qualified Data.ByteString as BC-- (ByteString, unpack)
import Data.Char (chr)
--import Data.ByteString.Char8 (unpack)

data Language = English | Russian deriving Eq

initialLocale = Russian
logFilePath :: FilePath
logFilePath = "/home/serega/IdeaProjects/lkdecoder/log-sample.log"

detectLanguage :: String -> Language
detectLanguage s =
    English

convertLine :: String -> String
convertLine s =
    s

data LogMessage = LogMessage String

instance Show LogMessage where
    show ( LogMessage a ) = do
        if detectLanguage(a) == initialLocale
            then a
            else a

{-# LANGUAGE OverlappingInstances #-}

data LogEntry =
    LogEntry { entryTime :: LocalTime
             , message :: LogMessage
             }


type Log = [LogEntry]

timeParser :: Parser LocalTime
timeParser = do
  stub  <- skipWhile (=='>')
  let y = 1
  let mm = 1
  let d = 1
  let h = 1
  let m = 1
  let s = 1
  return $ LocalTime { localDay = fromGregorian (read y) (read mm) (read d)
                     , localTimeOfDay = TimeOfDay (read h) (read m) (read s)
                     }

logMessageParser :: Parser LogMessage
logMessageParser = do
    message <- takeByteString
    return $ LogMessage $ map (chr . fromEnum) . BC.unpack $ message

logEntryParser :: Parser LogEntry
logEntryParser = do
    t <- timeParser
    char '>'
    m <- logMessageParser
    return $ LogEntry t m

logParser :: Parser Log
logParser = many $ logEntryParser <* endOfLine
--logParser = do
--    let z =logEntryParser <* endOfLine
--    return $ many z


--main = do
--    logFileContents
--    withFile logFilePath  ReadMode (\handle -> do
--        contents <- hGetContents handle
--        let output = map ( \line -> processLine line ) (lines contents)
--        putStrLn $ unlines output
--        )

--main = do
--    let -- Parsed logs
--        logs :: [Log]
--        logs = rights $ fmap (parseOnly logParser) [logFilePath]
--    BC.putStrLn $ logs

main = do
    putStrLn "a"

        -- Merged log
--      mergedLog :: Log
--      mergedLog = foldr merge [] logs
--    BC.putStrLn $ renderLog mergedLog
