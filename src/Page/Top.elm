module Page.Top exposing (Model, Msg(..), init, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Route exposing (..)
import Url
import Url.Builder


type alias Model =
    { message : String
    }


type Msg
    = TopPageAccess


init : ( Model, Cmd Msg )
init =
    ( { message = "This is TopPage" }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TopPageAccess ->
            ( model, Cmd.none )


view : model -> Html Msg
view model =
    div []
        [ text "TopPage"
        ]
