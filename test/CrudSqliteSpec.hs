module CrudSqliteSpec (main, spec) where

import Test.Hspec
import CrudSqlite

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
    describe "finds records in the DB" $ do
        it "finds a band by ID" $ do
            Just band <- findById 1
            name band `shouldBe` "The Beatles"
        it "will not find a band with incorrect ID" $ do
            band <- findById 15
            band `shouldBe` Nothing
        it "finds a band by name" $ do
            Just band <- findByName "The Beatles"
            formedYear band `shouldBe` 1960
            genre band `shouldBe` Just "Rock"
        it "updates a band's formedYear" $ do
            result <- updateBand 1 "The Beatles"
            result `shouldBe` 1
            {- Just band <- findBand 1 -}
            {- setL formedYear 1964 band -}
            {- name band `shouldBe` "The Beatles" -}

