module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Page.Decrement
import Page.Increment
import Page.Top
import Route exposing (..)
import Url
import Url.Builder


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = UrlRequested
        }


type alias Model =
    { key : Nav.Key
    , page : Page
    }


type Page
    = NotFound
    | TopPage Page.Top.Model
    | IncrementPage Page.Increment.Model
    | DecrementPage Page.Decrement.Model


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | TopMsg Page.Top.Msg
    | IncrementMsg Page.Increment.Msg
    | DecrementMsg Page.Decrement.Msg


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ( topPageModel, topPageMsg ) =
            Page.Top.init
    in
    Model key (TopPage topPageModel)
        |> goTo (Route.parse url)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlRequested request ->
            case request of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            goTo (Route.parse url) model

        TopMsg topMsg ->
            case model.page of
                TopPage topModel ->
                    let
                        ( newTopModel, topCmd ) =
                            Page.Top.update topMsg topModel
                    in
                    ( { model | page = TopPage newTopModel }
                    , Cmd.map TopMsg topCmd
                    )

                _ ->
                    ( model, Cmd.none )

        IncrementMsg incrementMsg ->
            case model.page of
                IncrementPage incrementModel ->
                    let
                        ( newincrementModel, incrementCmd ) =
                            Page.Increment.update incrementMsg incrementModel
                    in
                    ( { model | page = IncrementPage newincrementModel }
                    , Cmd.map IncrementMsg incrementCmd
                    )

                _ ->
                    ( model, Cmd.none )

        DecrementMsg decrementMsg ->
            case model.page of
                DecrementPage decrementModel ->
                    let
                        ( newdecrementModel, decrementCmd ) =
                            Page.Decrement.update decrementMsg decrementModel
                    in
                    ( { model | page = DecrementPage newdecrementModel }
                    , Cmd.map DecrementMsg decrementCmd
                    )

                _ ->
                    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Browser.Document Msg
view model =
    { title = "SPATest"
    , body =
        [ viewLink "/increment" "Increment"
        , viewLink "/decrement" "Decrement"
        , viewLink "/" "Top"
        , case model.page of
            TopPage topPageModel ->
                Page.Top.view topPageModel
                    |> Html.map TopMsg

            IncrementPage incrementPageModel ->
                Page.Increment.view incrementPageModel
                    |> Html.map IncrementMsg

            DecrementPage decrementPageModel ->
                Page.Decrement.view decrementPageModel
                    |> Html.map DecrementMsg

            NotFound ->
                text "NotFound"
        ]
    }


viewLink : String -> String -> Html Msg
viewLink path displayName =
    a [ href path ] [ h1 [] [ text displayName ] ]


goTo : Maybe Route -> Model -> ( Model, Cmd Msg )
goTo maybeRoute model =
    case maybeRoute of
        Nothing ->
            ( { model | page = NotFound }, Cmd.none )

        Just Increment ->
            let
                ( incrementModel, incrementMsg ) =
                    Page.Increment.init
            in
            ( { model | page = IncrementPage incrementModel }, Cmd.none )

        Just Decrement ->
            let
                ( decrementModel, decrementMsg ) =
                    Page.Decrement.init
            in
            ( { model | page = DecrementPage decrementModel }, Cmd.none )

        Just Top ->
            let
                ( topModel, topMsg ) =
                    Page.Top.init
            in
            ( { model | page = TopPage topModel }, Cmd.none )
