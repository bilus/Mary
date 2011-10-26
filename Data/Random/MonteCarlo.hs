module Data.Random.MonteCarlo (monteCarlo, exportToCsv, Param, mkNormDistParam) where
	
	import System.Random (RandomGen, mkStdGen)
	import Data.Random.Normal (normals')
	import Data.Number.Erf (inverf)
	import Data.List (transpose)

	-- Simulation parameter value.
	type Value = Float

	-- Probability [0..1]
	type Probability = Float

	-- Simulation parameter.
	data Param = 
		NormDistParam {valueRange :: (Value, Value), confLevel :: Probability} |	-- Normal distribution.
		NormDistParam2 {value :: Value, stdDev :: Float}
		-- TODO: Other distributions from the book.
		deriving (Show)

	-- Create a simulation parameter based on normal distribution.
	-- For instance, mkNormDistParam (10, 20) 0.9 means that you estimate with 90% confidence that the population mean is between 10 and 20.
	mkNormDistParam :: (Value, Value) -> Probability -> Param
	mkNormDistParam vr@(minValue, maxValue) confidenceLevel
		| minValue > maxValue = error "Maximum value must be greater or equal to minimum value"
		| confidenceLevel <= 0 || confidenceLevel > 1 = error "Confidence level must be (0, 1]"
		| otherwise = NormDistParam {valueRange = vr, confLevel = confidenceLevel}

	mkNormDistParam2 :: Value -> Float -> Param
	mkNormDistParam2 v sd = NormDistParam2 {value = v, stdDev = sd}

	-- Infinite list of normally distributed sample values based on the simulation parameter and the provided random number generator.
	samplesFor :: (RandomGen g) => Param -> g -> [Value]
	samplesFor p@(NormDistParam {valueRange = _, confLevel = _}) gen = normals' (mean, stdDev) gen
		where 
			mean = (minP + maxP) / 2
				where
					minP = fst (valueRange p)
					maxP = snd (valueRange p)
			stdDev = estimatedStdDev (valueRange p) (confLevel p)
	samplesFor p@(NormDistParam2 {value = _, stdDev = _}) gen = normals' (mean, sd) gen
		where
				mean = value p
				sd = stdDev p

	-- Infinite list of normally distributed sample values based on the simulation parameter and the random generator seed.
	mkSamplesFor :: Param -> Int -> [Value]
	mkSamplesFor p seed = samplesFor p $ mkStdGen seed

	-- Standard deviation used to calculate sample values for normal distribution given minimum and maximum 
	-- value (minX, maxX) and confidence level (confLevel).
	-- If minX is 4.5, maxX is 9.5 and the confidence level is 95%, then we say that 
	-- "We estimate with 95% confidence that the true value of the population mean is between 4.5 and 9.5."
	estimatedStdDev :: (Value, Value) -> Probability -> Float
	estimatedStdDev (minX, maxX) confLevel
		| maxX > minX && confLevel > 0 && confLevel <= 1 = (maxX - minX) / ((n confLevel) * 2)
		| otherwise = error "Invalid arguments"
		    where
				n cl = (inverf cl) * sqrt(2)
				-- Example values of n:
		        -- n 0.80 = 1.281551565545
		        -- n 0.999 = 3.290526731492
		        -- n 0.90 = 1.644853626951       

	-- Results of Monte Carlo simulation given a set of parameters and a list of optional functions to operate on simulation results.
	monteCarlo :: (RandomGen g) => [Param] -> [([Value] -> [Value])] -> g -> [[Value]]
	monteCarlo params fs gen =  augumentWith fs samples
		where 
			samples = transpose $ map (\p -> samplesFor p gen) params
			augumentWith fs = map (calc fs)
				where
					calc fs xs = xs ++ concat (map (\f -> f xs) fs)
					
	-- String containing results of Monte Carlo simulation converted to CSV format suitable for import to Excel.
	exportToCsv :: Int -> [[Value]] -> String
	exportToCsv n = export n ","

	-- String containing results of Monte Carlo simulation with provided separator between values
	export :: Int -> String -> [[Value]] -> String
	export n sep = format sep . take n
		where
			format sep = unlines . map formatRow
				where 
					formatRow = foldr join []
					join x [] = show x
					join x acc = (show x) ++ sep ++ acc
	
	---------------------------------------------------------------------------
	test = monteCarlo [mkNormDistParam (10, 20) 0.9, mkNormDistParam (0.9 * 2400, 1.1 * 2400) 0.9] [sums, mult] $ mkStdGen 1234
		where
			sums xs = [foldr (+) 0 xs, foldr (+) 100 xs]
			mult xs = [foldr (*) 1 xs]
	test2 = monteCarlo [mkNormDistParam2 49.197 (0.1251 * 49.197)] [] $ mkStdGen 1234