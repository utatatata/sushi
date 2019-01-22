namespace Sushi

open System


module Main =

  let rec mainLoop idx = async {
    let dim: ConveyorBelt.Dimension =
      { Width = Console.WindowWidth;
        // - 1 is offset for a curosr
        Height = Console.WindowHeight - 1 }

    let cb =
      "sushi"
        |> Utilities.explode
        |> List.mapi
          (fun i c ->
            ConveyorBelt.idxToCoord dim (i + idx), c
          )
        |> List.fold
          (fun cb ({ X = x; Y = y }: ConveyorBelt.Coord, c) ->
            Matrix.set x y c cb
          )
          (List.map
            Utilities.explode
            (ConveyorBelt.conveyorBelt dim)
          )
        |> List.map
          Utilities.implode

    System.Console.Clear ()

    cb
      |> List.iter
        (printfn "%s")

    do! Async.Sleep 50

    return! mainLoop (idx + 1)
  }



  [<EntryPoint>]
  let main argv =
      Async.RunSynchronously (mainLoop 0)
      0 // return an integer exit code

