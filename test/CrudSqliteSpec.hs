module CrudSqliteSpec (main, spec) where

import Test.Hspec
import CrudSqlite

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
    describe "finds records in the DB" $ do
        it "finds a band by ID" $ do
            (Just band) <- findBand 1
            (name band) `shouldBe` "The Beatles"
        it "finds a band by name" $ do
            (Just band) <- findByName "The Beatles"
            (formedYear band) `shouldBe` 1960
            (genre band) `shouldBe` Just "Rock"
