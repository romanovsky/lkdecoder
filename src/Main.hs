module Main where

{-# LANGUAGE OverlappingInstances #-}

import Prelude
import System.IO
import Data.Time
import Data.Attoparsec.Char8
import Text.ParserCombinators.ReadP (many)
import Control.Applicative ((<*))
import Data.Either
import qualified Data.ByteString as BC
--import qualified Data.ByteString.Char8 as BC

data Language = English | Russian deriving Eq

initialLocale = Russian
logFilePath :: FilePath
logFilePath = "/home/serega/IdeaProjects/lkdecoder/log-sample.log"

newtype LogMessage = LogMessage String deriving (Show)

detectLanguage :: String -> Language
detectLanguage s =
    English

convertLine :: String -> String
convertLine s =
    s

instance Show LogMessage where
    show ( LogMessage a ) = do
        if detectLanguage(a) == initialLocale
            then a
            else a

data LogEntry =
    LogEntry { entryTime :: String
             , message :: LogMessage
             } deriving Show


type Log = [LogEntry]

timeParser :: Parser LogEntry
timeParser = do
  stub  <- skipWhile (==" > ")
  return $ LogEntry stub

messageParser :: Parser LogEntry
messageParser = do
    message <- takeByteString
    return $ LogEntry message

logEntryParser :: Parser LogEntry
logEntryParser = do
    t <- timeParser
    char " > "
    m <- messageParser
    return $ LogEntry t m

logParser :: Parser Log
logParser = many $ logEntryParser <* endOfLine


--main = do
--    logFileContents
--    withFile logFilePath  ReadMode (\handle -> do
--        contents <- hGetContents handle
--        let output = map ( \line -> processLine line ) (lines contents)
--        putStrLn $ unlines output
--        )

main = do
    let -- Parsed logs
        logs :: [Log]
        logs = rights $ fmap (parseOnly logParser) [logFilePath]
    BC.putStrLn $ logs
        -- Merged log
--      mergedLog :: Log
--      mergedLog = foldr merge [] logs
--    BC.putStrLn $ renderLog mergedLog
