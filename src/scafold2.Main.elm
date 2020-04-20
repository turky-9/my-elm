module Main exposing (main)

import Url
import Browser
import Browser.Navigation as Navigation
import Html
import Route exposing (Route, fromUrl)



-- ############################################################################
-- モデル
-- ############################################################################
type alias Session =
    { key : Navigation.Key
    , url : Url.Url
    }
type Model
    = Home Session
    | Friends Session
    | NotFound Session



-- ############################################################################
-- フラグ
-- ############################################################################
type alias Flags =
    {}



-- ############################################################################
-- メッセージ
-- ############################################################################
type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url




-- ############################################################################
-- init
-- ############################################################################
init : Flags -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    changeRouteTo url { key = key, url = url }


{-
  url -> (モデル, コマンド)の変換
-}
changeRouteTo : Url.Url -> Session -> (Model, Cmd Msg)
changeRouteTo url session =
    case fromUrl url of
        Nothing ->
            (NotFound session, Cmd.none)
        Just Route.Home ->
            (Home session, Cmd.none)
        Just Route.Friends ->
            (Friends session, Cmd.none)

{-
  モデルからSessionを取得する
-}
toSession : Model -> Session
toSession model =
    case model of
        Home sess ->
            sess
        Friends sess ->
            sess
        NotFound sess ->
            sess

-- ############################################################################
-- subscriptions
-- ############################################################################
subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


-- ############################################################################
-- update
-- ############################################################################
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        session = toSession model
    in
    case msg of
        -- 画面遷移のリクエスト
        LinkClicked urlReq ->
            case urlReq of
                -- 内部リンク
                Browser.Internal url ->
                    ( model, Navigation.pushUrl session.key (Url.toString url) )

                -- 外部リンク
                Browser.External href ->
                    ( model, Navigation.load href )

        -- urlが変更された時
        UrlChanged url ->
              -- 本当はココで画面表示用のデータをサーバから取得する
            (  model , Cmd.none )



-- ############################################################################
-- view
-- ############################################################################
view : Model -> Browser.Document Msg
view model =
    case model of
        Home sess ->
            { title = "Elm first spa"
            , body =
                [ Html.text "Home"
                ]
            }
        Friends sess ->
            { title = "Elm first spa"
            , body =
                [ Html.text "Friends"
                ]
            }
        NotFound sess ->
            { title = "Elm first spa"
            , body =
                [ Html.text "Not Found!!!"
                ]
            }


-- ############################################################################
-- main
-- ############################################################################
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

