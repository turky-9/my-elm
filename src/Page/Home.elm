module Page.Home exposing(Model, Msg, update, view, init)

import Html
import Browser

type alias Model =
    { name : String
    , age: Int
    }

init : Model
init =
    { name="Yoshiharu Ueno"
    , age = 41
    }

type Msg = Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    (model, Cmd.none)

view : Model -> Browser.Document Msg
view model =
    { title = "Home"
    , body =
        [ Html.p [] [Html.text model.name]
        , Html.p [] [Html.text (String.fromInt model.age)]
        ]
    }