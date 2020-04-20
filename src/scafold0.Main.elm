module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text, hr, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (..)

import Page.Index as PageIndex


main =
  Browser.sandbox { init = init, update = update, view = view }


-- MODEL

type alias Model =
  { content : String
  , count : Int
  }

init : Model
init =
  { content = ""
  , count = 0
  }


-- UPDATE

type Msg = Increment | Decrement | Change String


update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      inc model

    Decrement ->
      dec model

    Change newContent ->
      { model | content = newContent }

inc : Model -> Model
inc model = Debug.log "hoge:" { model | count = model.count + 1 }

dec : Model -> Model
dec model = { model | count = model.count - 1 }

-- VIEW

view : Model -> Html Msg
view model =
  if model.count <= 5 then
    div []
      [ button [ onClick Decrement ] [ text "-" ]
      , div [] [ text (String.fromInt model.count) ]
      , button [ onClick Increment ] [ text "+" ]
      , hr [] []
      , text "input: "
      , input [ placeholder "Hey!", value model.content, onInput Change] []
      , div [] [ text model.content ]
      ]
  else
    PageIndex.view
