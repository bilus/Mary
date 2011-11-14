module Data.Random.MonteCarlo2 where

	import System.Random (RandomGen, mkStdGen)
	import Data.Random.Normal (normals')
	import Data.Number.Erf (inverf)
	import Data.List (transpose)
	
	type Value = Float
	type ConfidenceLevel = Float

	class NameTag a where
		nameTag :: a -> String
	
	class SampleSource a where
		samples :: a -> [Value]
		
	class Transform a where
		transform :: (SampleSource b) => a -> [b] -> [SimulationVariable]
		transformRow :: a -> [Value] -> [Value]
	
	data SimulationVariable = SampleSet String [Value]
		deriving (Show)
	
	instance SampleSource SimulationVariable where
		samples (SampleSet _ xs) = xs
		
	instance NameTag SimulationVariable where
		nameTag (SampleSet x _) = x
	
	mkNormRangeVar :: RandomGen g => String -> (Value, Value) -> ConfidenceLevel -> g -> SimulationVariable
	mkNormRangeVar varName (minVal, maxVal) cl gen = SampleSet varName $ normals' (mean, stdDev) gen
		where
			mean = (minVal + maxVal) / 2
			stdDev = estimatedStdDev (minVal, maxVal) cl
			
	mkSetVar :: String -> [Value] -> SimulationVariable
	mkSetVar varName xs = SampleSet varName xs
		
	-- Standard deviation used to calculate sample values for normal distribution given minimum and maximum 
	-- value (minX, maxX) and confidence level (confLevel).
	-- If minX is 4.5, maxX is 9.5 and the confidence level is 95%, then we say that 
	-- "We estimate with 95% confidence that the true value of the population mean is between 4.5 and 9.5."
	estimatedStdDev :: (Value, Value) -> ConfidenceLevel -> Float
	estimatedStdDev (minX, maxX) confLevel
		| maxX > minX && confLevel > 0 && confLevel <= 1 = (maxX - minX) / ((n confLevel) * 2)
		| otherwise = error "Invalid arguments"
		    where
				n cl = (inverf cl) * sqrt(2)
				-- Example values of n:
		        -- n 0.80 = 1.281551565545
		        -- n 0.999 = 3.290526731492
		        -- n 0.90 = 1.644853626951       

	simulate :: (SampleSource b, Transform a, NameTag a) =>  a -> [b] -> [SimulationVariable]
	simulate t = map mkVariable . transpose . (applyTransform t) . transpose . map samples
		where
			applyTransform x = map (transformRow x)
			mkVariable :: [Value] -> SimulationVariable
			mkVariable xs = mkSetVar (nameTag t) xs
			
	
	data Transformation = Transformation String ([Value] -> [Value])
	mkTransformation :: String -> ([Value] -> [Value]) -> Transformation
	mkTransformation n f = Transformation n f
	
	instance NameTag Transformation where
		nameTag (Transformation n _) = n
	instance Transform Transformation where
		transformRow (Transformation _ f) = f
		transform = simulate