{-# LANGUAGE OverloadedStrings #-}

module CrudSqlite
    ( someFunc
    , Band(..)
    , findById
    , findByName
    ) where

import Database.SQLite.Simple
import qualified Database.SQLite.Simple.ToField as TF
import Data.String

data Band = Band { id :: Int
                 , name :: String
                 , formedYear :: Int
                 , genre :: Maybe String
                 } deriving (Show, Eq)

instance FromRow Band where
    fromRow = Band <$> field <*> --id
                       field <*> --name
                       field <*>
                       field

dbPath :: String
dbPath = "db/crud-db.sqlt"

someFunc :: IO ()
someFunc = do
    band <- findByName "The Beatles"
    case band of
      Nothing -> putStrLn "The band with the id of 1 was not found"
      Just band -> putStrLn $ "The band's name is " ++ (name band)
    {- band <- findBand 1 -}
    {- case band of -}
      {- Nothing -> putStrLn "The band with the id of 1 was not found" -}
      {- Just band -> putStrLn $ "The band's name is " ++ (name band) -}

findById :: Int -> IO (Maybe Band)
findById id = do
    let sql = fromString("SELECT id, name, \
        \formed_year, \
        \genre \
        \FROM bands WHERE id = ?") :: Query
    result <- runQuery sql id
    return $ extractResult result

findByName :: String -> IO (Maybe Band)
findByName name = do
    let sql = fromString("SELECT id, name, \
        \formed_year, \
        \genre \
        \FROM bands WHERE name = ?") :: Query
    result <- runQuery sql name
    return $ extractResult result

extractResult :: [Band] -> Maybe Band
extractResult result =
    if length result == 1
       then Just (head result)
       else Nothing

runQuery :: TF.ToField a =>
                Query -> a -> IO [Band]
runQuery sql value = do
    conn <- open dbPath
    result <- query conn (sql :: Query) (Only value) :: IO [Band]
    close conn
    return result

{-
    withDBConn (\coj
        query conn (sql :: Query) (Only value) :: IO [Band]
    )

withDBConn :: (Connection -> IO b) -> IO b
withDBConn task = do
    conn <- open dbPath
    result <- (task conn)
    close conn
    return result
-}
