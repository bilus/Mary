module Simulation.Node (Node, nodeResult) where
	
	import Data.Random.MonteCarlo2 (SimulationVariable, Transform)
	import Data.List (concat)
	
	data Node = InputNode [SimulationVariable] 
		| TransformationNode ([SimulationVariable] -> [SimulationVariable]) [Node] 
		
	nodeResult :: Node -> [SimulationVariable]
	nodeResult (InputNode xs) = xs
	nodeResult (TransformationNode f xs) = f $ concat $ map nodeResult xs
	
	