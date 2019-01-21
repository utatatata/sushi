module Lane (Lane, Pos(..), lane, direction) where

import Prelude
import Data.Tuple (Tuple(..))


data Lane
  = Lane Dimension

type Dimension = Tuple Int Int

type Index = Int

data Pos
  = Top
  | Right
  | Bottom
  | Left

lane :: Int -> Int -> Lane
lane w h =
  Lane (Tuple w h)


offsetX :: Int
offsetX = 1

offsetY :: Int
offsetY = 1

length :: Lane -> Int
length l =
  ((width l) + (height l)) * 2

width :: Lane -> Int
width (Lane (Tuple w _)) =
  w - offsetX * 2 - 1

height :: Lane -> Int
height (Lane (Tuple _ h)) =
  h - offsetY * 2 - 1

direction :: Lane -> Index -> Pos
direction
  l i | i < 0 = direction l $ i + (length l)
      | i < width l = Top
      | i < (width l) + (height l) = Right
      | i < (width l) * 2 + (height l) = Bottom
      | i < (width l) * 2 + (height l) * 2 = Left
      | otherwise = direction l $ i - (length l)

idxToCoord :: Lane -> Index -> Coord
idxToCoord l i =
  case direction li of
    -- TODO
    Top ->

    Right ->

    Bottom ->

    Left ->

