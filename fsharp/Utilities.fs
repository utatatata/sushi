namespace Sushi

open System


module Utilities =

  let modulo div n =
    (n % div + div) % div


  let explode s =
    [for c in s -> c]


  let implode: char list -> string =
    String.Concat

