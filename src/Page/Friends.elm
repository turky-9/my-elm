module Page.Friends exposing(Model, Msg, init, view, update)


import Html
import Browser

type alias NickName =
    { aka : String
    }
type alias Model =
    List NickName

init : Model
init =
    [ {aka= "hoge"}
    , {aka= "foo"}
    , {aka= "bar"}
    ]

type Msg = Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    (model, Cmd.none)

view : Model -> Browser.Document Msg
view model =
    { title = "Home"
    , body = [renderFriends model]
    }

renderFriends : Model -> Html.Html Msg
renderFriends model =
    Html.ul [] (List.map renderFriend model)

renderFriend : NickName -> Html.Html Msg
renderFriend nickName =
    Html.li [] [Html.text nickName.aka]