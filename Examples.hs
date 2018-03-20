module Examples where

import Sabotage

simpleExample :: Model
simpleExample =
  Mo
    [1,2]
    [2]
    [(1,2)]
    1
    Daemon

threeExample :: Model
threeExample =
  Mo
    [1,2,3]
    [3]
    [(1,2),(2,3),(1,3),(2,3)]
    1
    Daemon

squareExample :: Model
squareExample =
  Mo
    [1,2,3,4]
    [4]
    [(1,2),(1,3),(2,4),(3,4),(2,4),(3,4)]
    1
    Daemon

line :: Int -> Int -> Model
line k n =
  Mo
    [1..k]
    [k]
    (concat [ replicate n (l,l+1) | l <- [1..(k-1)]])
    1
    Daemon

grid :: Int -> Model
grid k =
  Mo
    [1..(k^(2::Int))]
    [k^(2::Int)]
    (  [(l,l+1) | row <- [0..(k-1)], l <- [((row*k) + 1) .. ((row*k) + (k-1))] ]
    ++ [(l,l+k) | row <- [0..(k-2)], l <- [((row*k) + 1) .. ((row*k) + k)] ] )
    1
    Daemon
