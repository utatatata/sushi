module Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Lane (Pos(..), lane, direction)
import Node.Process.Ext (columns, rows)



main :: Effect Unit
main = do
  w <- columns
  h <- rows
  case direction (lane w h) 113 of
    Top ->
      log "Top"
    Right ->
      log "Right"

    Bottom ->
      log "Bottom"

    Left ->
      log "Left"

