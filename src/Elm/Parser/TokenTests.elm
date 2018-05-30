module Elm.Parser.TokenTests exposing (all)

import Elm.Parser.CombineTestUtil exposing (..)
import Elm.Parser.Tokens as Parser
import Expect
import Test exposing (..)


main =
    Tuple.second all


longString : String
longString =
    "\"" ++ String.repeat (5 * 10 ^ 5) "a" ++ "\""


longMultiLineString : String
longMultiLineString =
    "\"\"\"" ++ String.repeat (5 * 10 ^ 5) "a" ++ "\"\"\""


all : Test
all =
    describe "TokenTests"
        [ test "functionName" <|
            \() ->
                parseFullString "foo" Parser.functionName
                    |> Expect.equal (Just "foo")
        , test "functionName not empty" <|
            \() ->
                parseFullString "" Parser.functionName
                    |> Expect.equal Nothing
        , test "functionName with number" <|
            \() ->
                parseFullString "n1" Parser.functionName
                    |> Expect.equal (Just "n1")
        , test "alias can be a functionName (it is not reserved)" <|
            \() ->
                parseFullString "alias" Parser.functionName
                    |> Expect.equal (Just "alias")
        , test "functionName is not matched with 'if'" <|
            \() ->
                parseFullString "if" Parser.functionName
                    |> Expect.equal Nothing
        , test "functionName with _" <|
            \() ->
                parseFullString "foo_" Parser.functionName
                    |> Expect.equal (Just "foo_")
        , test "typeName" <|
            \() ->
                parseFullString "MyCmd" Parser.typeName
                    |> Expect.equal (Just "MyCmd")
        , test "typeName not empty" <|
            \() ->
                parseFullString "" Parser.typeName
                    |> Expect.equal Nothing
        , test "typeName with number" <|
            \() ->
                parseFullString "T1" Parser.typeName
                    |> Expect.equal (Just "T1")
        , test "functionOrTypeName as function" <|
            \() ->
                parseFullString "foo" Parser.functionOrTypeName
                    |> Expect.equal (Just "foo")
        , test "functionOrTypeName as type" <|
            \() ->
                parseFullString "Foo" Parser.functionOrTypeName
                    |> Expect.equal (Just "Foo")
        , test "moduleToken" <|
            \() ->
                parseFullString "module" Parser.moduleToken
                    |> Expect.equal (Just "module")
        , test "exposingToken" <|
            \() ->
                parseFullString "exposing" Parser.exposingToken
                    |> Expect.equal (Just "exposing")
        , test "operatorToken 1" <|
            \() ->
                parseFullString "++" Parser.infixOperatorToken
                    |> Expect.equal (Just "++")
        , test "operatorToken 2" <|
            \() ->
                parseFullString "//" Parser.infixOperatorToken
                    |> Expect.equal (Just "//")
        , test "operatorToken 3" <|
            \() ->
                parseFullString "*" Parser.infixOperatorToken
                    |> Expect.equal (Just "*")
        , test "operatorToken 4" <|
            \() ->
                parseFullString ":" Parser.infixOperatorToken
                    |> Expect.equal Nothing
        , test "operatorToken 5" <|
            \() ->
                parseFullString "->" Parser.infixOperatorToken
                    |> Expect.equal Nothing
        , test "operatorToken 6" <|
            \() ->
                parseFullString "\\" Parser.infixOperatorToken
                    |> Expect.equal Nothing
        , test "operatorToken 7" <|
            \() ->
                parseFullString "." Parser.infixOperatorToken
                    |> Expect.equal (Just ".")
        , test "operatorToken 8" <|
            \() ->
                parseFullString "$" Parser.infixOperatorToken
                    |> Expect.equal (Just "$")
        , test "operatorToken 9" <|
            \() ->
                parseFullString "#" Parser.infixOperatorToken
                    |> Expect.equal (Just "#")
        , test "operatorToken 10 - , is not an infix operator" <|
            \() ->
                parseFullString "," Parser.infixOperatorToken
                    |> Expect.equal Nothing
        , test "operatorToken 11 -- is not an operator" <|
            \() ->
                parseFullString "--" Parser.prefixOperatorToken
                    |> Expect.equal Nothing
        , test "operatorToken 12" <|
            \() ->
                parseFullString "≡" Parser.prefixOperatorToken
                    |> Expect.equal (Just "≡")
        , test "operatorToken 13" <|
            \() ->
                parseFullString "~" Parser.prefixOperatorToken
                    |> Expect.equal (Just "~")
        , test "operatorToken 14" <|
            \() ->
                parseFullString "=" Parser.prefixOperatorToken
                    |> Expect.equal Nothing
        , test "operatorToken 15" <|
            \() ->
                parseFullString "?" Parser.prefixOperatorToken
                    |> Expect.equal (Just "?")
        , test "operatorToken 16" <|
            \() ->
                parseFullString "@" Parser.prefixOperatorToken
                    |> Expect.equal (Just "@")
        , test "multiline string" <|
            \() ->
                parseFullString "\"\"\"Bar foo \n a\"\"\"" Parser.multiLineStringLiteral
                    |> Expect.equal (Just "Bar foo \n a")
        , test "multiline string escape" <|
            \() ->
                parseFullString """\"\"\" \\\"\"\" \"\"\"""" Parser.multiLineStringLiteral
                    |> Expect.equal (Just """ \"\"\" """)
        , test "character escaped" <|
            \() ->
                parseFullString "'\\''" Parser.characterLiteral
                    |> Expect.equal (Just '\'')
        , test "string escaped 3" <|
            \() ->
                parseFullString "\"\\\"\"" Parser.stringLiteral
                    |> Expect.equal (Just "\"")
        , test "string escaped" <|
            \() ->
                parseFullString "\"foo\\\\\"" Parser.stringLiteral
                    |> Expect.equal (Just "foo\\")
        , test "character escaped 3" <|
            \() ->
                parseFullString "'\\n'" Parser.characterLiteral
                    |> Expect.equal (Just '\n')
        , test "arrow operator" <|
            \() ->
                parseAsFarAsPossible "->" Parser.infixOperatorToken
                    |> Expect.equal Nothing
        , test "long string" <|
            \() ->
                parseFullString longString Parser.stringLiteral
                    |> Expect.notEqual Nothing
        , test "long multi line string" <|
            \() ->
                parseFullString longMultiLineString Parser.multiLineStringLiteral
                    |> Expect.notEqual Nothing
        ]
