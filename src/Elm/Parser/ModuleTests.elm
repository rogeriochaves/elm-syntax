module Elm.Parser.ModuleTests exposing (..)

import Elm.Parser.CombineTestUtil exposing (..)
import Elm.Parser.Modules as Parser
import Elm.Syntax.Exposing exposing (..)
import Elm.Syntax.Module exposing (..)
import Elm.Syntax.Range exposing (emptyRange)
import Expect
import Test exposing (..)


main =
    Tuple.second all


all : Test
all =
    describe "ModuleTests"
        [ test "formatted moduleDefinition" <|
            \() ->
                parseFullStringWithNullState "module Foo exposing (Bar)" Parser.moduleDefinition
                    |> Maybe.map noRangeModule
                    |> Expect.equal
                        (Just
                            (NormalModule
                                { moduleName = [ "Foo" ]
                                , exposingList = Explicit [ ( emptyRange, TypeOrAliasExpose "Bar" ) ]
                                }
                            )
                        )
        , test "port moduleDefinition" <|
            \() ->
                parseFullStringWithNullState "port module Foo exposing (Bar)" Parser.moduleDefinition
                    |> Maybe.map noRangeModule
                    |> Expect.equal (Just (PortModule { moduleName = [ "Foo" ], exposingList = Explicit [ ( emptyRange, TypeOrAliasExpose "Bar" ) ] }))
        , test "port moduleDefinition with spacing" <|
            \() ->
                parseFullStringWithNullState "port module Foo exposing ( Bar )" Parser.moduleDefinition
                    |> Maybe.map noRangeModule
                    |> Expect.equal (Just (PortModule { moduleName = [ "Foo" ], exposingList = Explicit [ ( emptyRange, TypeOrAliasExpose "Bar" ) ] }))
        , test "effect moduleDefinition" <|
            \() ->
                parseFullStringWithNullState "effect module Foo where {command = MyCmd, subscription = MySub } exposing (Bar)" Parser.moduleDefinition
                    |> Maybe.map noRangeModule
                    |> Expect.equal
                        (Just
                            (EffectModule
                                { moduleName = [ "Foo" ]
                                , exposingList = Explicit [ ( emptyRange, TypeOrAliasExpose "Bar" ) ]
                                , command = Just "MyCmd"
                                , subscription = Just "MySub"
                                }
                            )
                        )
        , test "unformatted" <|
            \() ->
                parseFullStringWithNullState "module \n Foo \n exposing  (..)" Parser.moduleDefinition
                    |> Maybe.map noRangeModule
                    |> Expect.equal (Just (NormalModule { moduleName = [ "Foo" ], exposingList = All emptyRange }))
        , test "unformatted wrong" <|
            \() ->
                parseFullStringWithNullState "module \nFoo \n exposing  (..)" Parser.moduleDefinition
                    |> Expect.equal Nothing
        , test "exposing all" <|
            \() ->
                parseFullStringWithNullState "module Foo exposing (..)" Parser.moduleDefinition
                    |> Maybe.map noRangeModule
                    |> Expect.equal (Just (NormalModule { moduleName = [ "Foo" ], exposingList = All emptyRange }))
        , test "module name with _" <|
            \() ->
                parseFullStringWithNullState "module I_en_gb exposing (..)" Parser.moduleDefinition
                    |> Maybe.map noRangeModule
                    |> Expect.equal (Just (NormalModule { moduleName = [ "I_en_gb" ], exposingList = All emptyRange }))
        ]
