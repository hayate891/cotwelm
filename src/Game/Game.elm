module Game.Game exposing (..)

-- Game

import Game.Data exposing (..)
import Game.Maps exposing (..)
import Game.Collision exposing (..)
import Inventory exposing (..)
import Equipment exposing (..)
import DragDrop exposing (new)


-- Data

import GameData.Building exposing (..)


--Hero

import Hero exposing (..)


-- Common

import Lib exposing (..)
import IdGenerator exposing (..)


-- Core

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App exposing (map)


initGame : Game.Data.Model
initGame =
    { name = "A new game"
    , hero = Hero.init
    , map = Game.Maps.initMaps
    , currentScreen = InventoryScreen
    , dnd = DragDrop.new
    , equipment = Equipment.init
    , idGen = IdGenerator.new
    }


update : Game.Data.Msg -> Game.Data.Model -> ( Game.Data.Model, Cmd Game.Data.Msg )
update msg model =
    case msg of
        EquipmentMsg x ->
            ( { model | equipment = Equipment.update x model.equipment }, Cmd.none )

        KeyDir dir ->
            tryMoveHero dir model

        Map ->
            ( { model | currentScreen = MapScreen }, Cmd.none )

        Inventory ->
            ( { model | currentScreen = InventoryScreen }, Cmd.none )

        InvMsg msg ->
            ( Inventory.update msg model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


view : Game.Data.Model -> Html Game.Data.Msg
view model =
    case model.currentScreen of
        MapScreen ->
            viewMap model

        BuildingScreen building ->
            viewBuilding building

        InventoryScreen ->
            Html.App.map InvMsg (Inventory.view model)


viewMap : Game.Data.Model -> Html Game.Data.Msg
viewMap model =
    let
        title =
            h1 [] [ text ("Welcome to Castle of the Winds: " ++ model.name) ]
    in
        div []
            [ title
            , Game.Maps.view model.map
            , viewHero model.hero
            ]


viewBuilding : GameData.Building.Building -> Html Game.Data.Msg
viewBuilding building =
    div [] [ h1 [] [ text building.name ] ]


viewHero : Hero -> Html Game.Data.Msg
viewHero hero =
    div [ class "tile maleHero", vectorToHtmlStyle <| Hero.pos hero ] []
