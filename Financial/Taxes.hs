module Financial.Taxes where
	
	import Financial.Types (Currency, pln)
	
	-- incomeTax :: [Currency] -> [Currency] -> (Currency, [Currency])
	-- incomeTax profit
	-- incomeTax profit:profits profit':profits'
	-- 	| profit <= 0 = (profit, profits')
	-- 	| otherwise = deductLosses profit profits profits'
	-- 
	-- deductLosses :: Currency -> [Currency] -> [Currency] -> (Currency, [Currency])
	-- deductLosses maxDeductionPeriods profit prevProfits prevProfits' =
	-- 	foldl step [] profit $ take maxDeducionPeriods $ zip prevProfits prevProfits'
	-- 	where
	-- 		step 

	-- TODO Make periods configurable.
	deduct :: [Currency] -> [Currency]
	deduct = reverse . foldr (deduct2 5) [] . reverse
			
	-- TODO: No more than 50% of each loss but not the current one but the original ones!!
	deduct2 :: Int -> Currency -> [Currency] -> [Currency]
	deduct2 deductiblePeriods crnt past = (foldr step [crnt] $ deductiblePast) ++ nonDeductiblePast
		where
			(deductiblePast, nonDeductiblePast) = splitAt deductiblePeriods past
			step :: Currency -> [Currency] -> [Currency]
			step x (x':xs') = (x' + dl) : (x - dl) : xs'
				where
					dl = deductibleLoss x' x

	deductibleLoss :: Currency -> Currency -> Currency
	deductibleLoss p l
		| p > 0 && l < 0 = - (min p (- l / 2))
		| otherwise = 0