module Main exposing (main)

import Url
import Browser
import Browser.Navigation as Navigation
import Html

import Route exposing (Route, fromUrl)
import Page.Home as Home
import Page.Friends as Friends



-- ############################################################################
-- モデル
-- ############################################################################
type alias Session =
    { key : Navigation.Key
    , url : Url.Url
    }
type Model
    = Home Session Home.Model
    | Friends Session Friends.Model
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
    | GotHome Home.Msg
    | GotFriends Friends.Msg




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
            (Home session Home.init, Cmd.none)
        Just Route.Friends ->
            (Friends session Friends.init, Cmd.none)

{-
  モデルからSessionを取得する
-}
toSession : Model -> Session
toSession model =
    case model of
        Home sess _ ->
            sess
        Friends sess _ ->
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
    case (msg, model) of
        -- 画面遷移のリクエスト
        (LinkClicked urlReq, _) ->
            case urlReq of
                -- 内部リンク
                Browser.Internal url ->
                    ( model, Navigation.pushUrl session.key (Url.toString url) )

                -- 外部リンク
                Browser.External href ->
                    ( model, Navigation.load href )

        -- urlが変更された時
        (UrlChanged url, _) ->
              -- 本当はココで画面表示用のデータをサーバから取得する
            (  model , Cmd.none )

        {-
          1. Mainのモデルからサブモデルにパターンマッチ(メッセージも)
          2. サブのupdateを実行
          3. サブのモデルとメッセージをMainのモデルとメッセージに変換
        -}
        (GotHome subMsg, Home sess home) ->
            Home.update subMsg home |> updateWith (Home sess) GotHome

        (GotFriends subMsg, Friends sess friends) ->
            Friends.update subMsg friends |> updateWith (Friends sess) GotFriends

        ( _, _ ) ->
            -- Disregard messages that arrived for the wrong page.
            ( model, Cmd.none )

{-
    サブモデルとサブメッセージからMainのモデルとメッセージに変換
-}
updateWith : (subModel -> Model) -> (subMsg -> Msg) -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )


-- ############################################################################
-- view
-- ############################################################################
view : Model -> Browser.Document Msg
view model =
    let
        {-
          サブメッセージからMainのメッセージに変換
        -}
        viewPage : (a -> Msg)  -> Browser.Document a -> Browser.Document Msg
        viewPage toMsg {title, body} =
            { title = title
            , body = List.map (Html.map toMsg) body
            }
    in
    case model of
        {-
          Mainのモデルからサブモデルにパターンマッチ
        -}
        Home sess homeModel ->
            Home.view homeModel |> viewPage GotHome

        Friends sess friendsModel ->
            Friends.view friendsModel |> viewPage GotFriends

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

