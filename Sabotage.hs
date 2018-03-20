module Sabotage where

import Data.List

(!) :: Eq a => [(a,b)] -> a -> b
(!) rel x = y where Just y = lookup x rel

type Node = Int

data Player = Traveller | Daemon deriving (Eq)

instance (Show Player) where
  show Traveller = "T"
  show Daemon    = "D"

other :: Player -> Player
other Traveller = Daemon
other Daemon    = Traveller

data Model =
  Mo
    [Node]        -- all nodes
    [Node]        -- goal nodes where Traveller wins
    [(Node,Node)] -- undirected edges between nodes
    Node          -- current position of traveller
    Player        -- whose turn is it
  deriving (Show)

data Move = GoTo Node | Remove (Node,Node) deriving (Eq,Show)

availableMoves :: Model -> [Move]
availableMoves (Mo _ _ links pos Traveller) = map GoTo . nub $
  [ y | (x,y) <- links, x == pos ] ++ [ x | (x,y) <- links, y == pos ]
availableMoves (Mo _ _ links _ Daemon) = map Remove $ nub links

doMove :: Model -> Move -> Model
doMove (Mo nodes goals links _   Traveller) (GoTo newpos) = Mo nodes goals links newpos Daemon
doMove (Mo nodes goals links pos Daemon   ) (Remove l   ) = Mo nodes goals (delete l links) pos Traveller
doMove (Mo _     _     _     _   Traveller) (Remove _   ) = error "Not your turn, Traveller!"
doMove (Mo _     _     _     _   Daemon   ) (GoTo _     ) = error "Not your turn, Daemon!"

hasWon :: Player -> Model -> Bool
hasWon Traveller    (Mo _ goals _ pos _) = pos `elem` goals
hasWon Daemon    mo@(Mo _ goals _ pos _) = pos `notElem` goals && null (availableMoves mo)

canWin :: Player -> Model -> Bool
canWin p mo@(Mo _ _ _ _ turn)
  | hasWon p mo         = True
  | hasWon (other p) mo = False
  | turn == p           = any (canWin p . doMove mo) (availableMoves mo)
  | otherwise           = all (canWin p . doMove mo) (availableMoves mo)

test :: Model -> IO ()
test m = putStrLn $ show (filter (`canWin` m) [Daemon,Traveller]) ++ " can win."

play :: Model -> IO ()
play m = do
  print m
  test m
  play' "" m where
  play' :: String -> Model ->  IO ()
  play' prefix mo
    | hasWon Daemon    mo = putStrLn $ prefix ++ "Daemon wins."
    | hasWon Traveller mo = putStrLn $ prefix ++ "Traveller wins."
    | otherwise           = mapM_ (\move -> do
        putStrLn $ prefix ++ show move
        let newprefix = prefix ++ "  "
        let newmo = doMove mo move
        play' newprefix newmo
        ) (availableMoves mo)
