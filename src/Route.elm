module Route exposing (Route(..), parse, parser)

import Html exposing (..)
import Url
import Url.Parser exposing (..)


type Route
    = Top
    | Increment
    | Decrement


parse : Url.Url -> Maybe Route
parse url =
    Url.Parser.parse parser url


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Url.Parser.map Top top
        , Url.Parser.map Increment (Url.Parser.s "increment")
        , Url.Parser.map Decrement (Url.Parser.s "decrement")
        ]
