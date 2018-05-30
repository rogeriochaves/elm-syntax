module Elm.Parser.Comments exposing (multilineComment, singleLineComment)

import Combine exposing (Parser, count, lazy, modifyState, string, succeed)
import Combine.Char exposing (anyChar)
import Elm.Parser.Ranges exposing (withRange)
import Elm.Parser.State exposing (State, addComment)
import Elm.Parser.Whitespace exposing (untilNewlineToken)
import Elm.Syntax.Ranged exposing (Ranged)
import Parser as Core exposing (Nestable(..))


addCommentToState : Parser State (Ranged String) -> Parser State ()
addCommentToState p =
    p |> Combine.andThen (\pair -> modifyState (addComment pair) |> Combine.continueWith (succeed ()))


parseComment : Parser State String -> Parser State ()
parseComment commentParser =
    withRange
        (Combine.map (\a b -> ( b, a )) commentParser)
        |> addCommentToState


singleLineComment : Parser State ()
singleLineComment =
    parseComment
        (succeed (++)
            |> Combine.andMap (string "--")
            |> Combine.andMap untilNewlineToken
        )


multilineCommentInner : Parser State String
multilineCommentInner =
    Core.getChompedString (Core.multiComment "{-" "-}" Nestable)
        |> Combine.fromCore


multilineComment : Parser State ()
multilineComment =
    lazy (\() -> parseComment multilineCommentInner)
