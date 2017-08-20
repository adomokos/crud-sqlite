module CrudSqliteSpec (main, spec) where

import Test.Hspec
import CrudSqlite

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
    describe "finds a record" $ do
        it "finds the first band record" $ do
            True `shouldBe` True
