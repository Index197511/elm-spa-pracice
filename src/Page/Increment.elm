module Page.Increment exposing (Model, Msg(..), init, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Url
import Url.Builder


type alias Model =
    { counter : Int
    }


init : ( Model, Cmd Msg )
init =
    ( { counter = 0 }, Cmd.none )


type Msg
    = PushedIncrement


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        PushedIncrement ->
            ( { model | counter = model.counter + 1 }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ text <| String.fromInt <| model.counter
        , button [ onClick PushedIncrement ] [ text "+" ]
        ]
