module Financial.Taxes where
	
	import Financial.Types (Currency, pln)
	import Data.List (minimum)
	
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

	-- TODO: Make periods configurable.
	-- TODO: Rename to deductLosses.
	-- Profits -> profits and losses after loss deduction.
	deduct :: [Currency] -> [Currency]
	deduct = integrate . doDeduct . zipDupOf
		where
			integrate :: [(Currency, Currency)] -> [Currency]
			integrate xs = map select xs
			 where
				select (orig, acc)	
					| orig > 0 = acc	-- Profit: use calculation result.
					| otherwise = orig	-- Loss: ignore calculation results, use original value.
			
	-- Profits -> profits interleaved with amounts of losses that couldn't be deducted.
	deduct' :: [Currency] -> [Currency]
	deduct' = snd . unzip . doDeduct . zipDupOf
			
	doDeduct :: [(Currency, Currency)] -> [(Currency, Currency)]
	doDeduct = reverse . foldr (deduct2 5) [] . reverse

	zipDupOf :: [a] -> [(a, a)]
	zipDupOf xs = zip xs xs 
		
	-- TODO: No more than 50% of each loss but not the current one but the original ones!!
	deduct2 :: Int -> (Currency, Currency) -> [(Currency, Currency)] -> [(Currency, Currency)]
	deduct2 deductiblePeriods crnt past = (foldr step [crnt] $ deductiblePast) ++ nonDeductiblePast
		where
			(deductiblePast, nonDeductiblePast) = splitAt deductiblePeriods past
			step :: (Currency, Currency) -> [(Currency, Currency)] -> [(Currency, Currency)]
			step (orig, acc) ((orig', acc'):xs) = (orig', acc' + dl) : (orig, acc - dl) : xs
				where
					dl = deductibleLoss acc' acc orig

	scanDeduct past = reverse $ scanr (deduct2 5) [] $ reverse $ zip past past

	deductibleLoss :: Currency -> Currency -> Currency -> Currency
	deductibleLoss currentProfit accumulatedLoss origLoss
		| currentProfit > 0 && accumulatedLoss < 0 = - minimum [currentProfit, - origLoss / 2, - accumulatedLoss]
		| otherwise = 0
		
-- TODO: Remove dist/ from git and ignore it.