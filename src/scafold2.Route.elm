module Route exposing (Route(..), fromUrl)
 -- , fromUrl, href, replaceUrl)


import Url
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s)

type Route
    = Home
    | Friends

parser : Parser.Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map Home (s "home")
        , Parser.map Friends (s "friends")
        ]

fromUrl : Url.Url -> Maybe Route
fromUrl url =
    -- The RealWorld spec treats the fragment like a path.
    -- This makes it *literally* the path, so we can proceed
    -- with parsing as if it had been a normal path all along.
    -- { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
    --    |> Parser.parse parser
    --
    -- Y.Ueno
    -- above is elm spa sample(it use fragment as path)
    Parser.parse parser url