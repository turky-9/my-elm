module Main exposing (main)

import Url
import Browser
import Browser.Navigation as Navigation
import Html




--
-- モデル
--
-- You need to keep track of the view state for the navbar in your model


type alias Model =
    { key : Navigation.Key
    , url : Url.Url
    }



--
-- フラグ
--


type alias Flags =
    {}



--
-- メッセージ
--


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url



--
-- init
--


init : Flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    ( { key = key, url = url }, Cmd.none )



--
-- subscriptions
--


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- 画面遷移のリクエスト
        LinkClicked urlReq ->
            case urlReq of
                -- 内部リンク
                Browser.Internal url ->
                    ( model, Navigation.pushUrl model.key (Url.toString url) )

                -- 外部リンク
                Browser.External href ->
                    ( model, Navigation.load href )

        -- urlが変更された時
        UrlChanged url ->
            ( { model | url = url }
              -- 本当はココで画面表示用のデータをサーバから取得する
            , Cmd.none
            )



--
-- view
--


view : Model -> Browser.Document Msg
view model =
    { title = "Elm first spa"
    , body =
        [ Html.text "this is elm"
        ]
    }


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
