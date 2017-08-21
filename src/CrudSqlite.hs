{-# LANGUAGE OverloadedStrings #-}

module CrudSqlite
    ( someFunc
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

someFunc :: IO ()
someFunc = do
    band <- findBand 1
    case band of
      Nothing -> putStrLn "The band with the id of 1 was not found"
      Just band -> putStrLn $ "The band's name is " ++ (name band)

findBand :: Int -> IO (Maybe Band)
findBand id = do
    let sql = fromString("SELECT id, name, \
        \formed_year, \
        \genre \
        \FROM bands WHERE id = ?") :: Query
    result <- runQuery sql id
    if length result == 1
       then return $ Just (head result)
       else return Nothing

{- runQuery :: Query -> a -> IO [Band] -}
runQuery :: TF.ToField a =>
                Query -> a -> IO [Band]
runQuery sql value =
    withDBConn (\conn -> do
        query conn (sql :: Query) (Only value) :: IO [Band]
    )

withDBConn :: (Connection -> IO b) -> IO b
withDBConn task = do
    conn <- open "db/crud-db.sqlt"
    result <- (task conn)
    close conn
    return result
