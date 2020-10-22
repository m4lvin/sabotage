# The Sabotage Game

A naive, explicit state implementation of the Sabotage Game as proposed in
[*An Essay on Sabotage and Obstruction*](https://doi.org/10.1007/978-3-540-32254-2_16)
by Johan van Benthem (2005).

## Data Type

```.haskell
data Model =
  Mo
    [Node]        -- all nodes
    [Node]        -- goal nodes where Traveller wins
    [(Node,Node)] -- undirected edges between nodes
    Node          -- current position of traveller
    Player        -- whose turn is it
```

## Example Output

```
λ> play squareExample
Mo [1,2,3,4] [4] [(1,2),(1,3),(2,4),(3,4),(2,4),(3,4)] 1 D
[T] can win.
Remove (1,2)
  GoTo 3
    Remove (1,3)
      GoTo 4
        Traveller wins.
    Remove (2,4)
      GoTo 4
        Traveller wins.
      GoTo 1
        Remove (1,3)
          Daemon wins.
        Remove (3,4)
      ...
  ...
```


## Original Reference

Johan van Benthem: *An Essay on Sabotage and Obstruction*, in: Dieter Hutter and
Werner Stephan (eds.):  *Mechanizing Mathematical Reasoning: Essays in Honor of
Jörg H. Siekmann on the Occasion of His 60th Birthday*, 2005, pages 268--276,
https://doi.org/10.1007/978-3-540-32254-2_16
