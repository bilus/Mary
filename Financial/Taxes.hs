module Financial.Taxes (deductLosses, deductLosses', scanDeductLosses) where
    
    import Financial.Types (Currency, pln)
    import Data.List (minimum)
    
    -- Profits -> profits and losses after loss deduction.
    deductLosses :: Int -> [Currency] -> [Currency]
    deductLosses nPeriodsToLookBack = doDeductLosses nPeriodsToLookBack useOriginalLossAndAccumulatedProfit
        where
	        useOriginalLossAndAccumulatedProfit (orig, acc)  
	            | orig > 0 = acc    -- Profit: use calculation result.
	            | otherwise = orig  -- Loss: ignore calculation results, use original value.
            
    -- Profits -> profits with deducted losses and, in case of losses, the remaining amounts that couldn't be deducted.
    deductLosses' :: Int -> [Currency] -> [Currency]
    deductLosses' nPeriodsToLookBack = doDeductLosses nPeriodsToLookBack useAccumulatedValue
		where
			useAccumulatedValue (orig, acc) = acc
            
    doDeductLosses :: Int -> ((Currency, Currency) -> Currency) -> [Currency] -> [Currency]
    doDeductLosses nPeriodsToLookBack unpackResult = map unpackResult . reverse . foldr (deductLossesForPeriod nPeriodsToLookBack) [] . reverse . (\xs -> zip xs xs)

	-- The main working engine for loss deduction.
    deductLossesForPeriod :: Int -> (Currency, Currency) -> [(Currency, Currency)] -> [(Currency, Currency)]
    deductLossesForPeriod nPeriodsToLookBack crnt past = (foldr step [crnt] deductiblePast) ++ nonDeductiblePast
        where
            (deductiblePast, nonDeductiblePast) = splitAt nPeriodsToLookBack past   -- IMPORTANT: Deduction policy (1).
            step :: (Currency, Currency) -> [(Currency, Currency)] -> [(Currency, Currency)]
            step (orig, acc) ((orig', acc'):xs) = (orig', acc' + dl) : (orig, acc - dl) : xs
                where
                    dl = deductibleLoss acc' acc orig

    -- Same as deductLosses' but returns full track of loss deductions
    scanDeductLosses nPeriodsToLookBack past = reverse $ scanr (deductLossesForPeriod nPeriodsToLookBack) [] $ reverse $ zip past past

    -- IMPORTANT: Deduction policy (2).
    deductibleLoss :: Currency -> Currency -> Currency -> Currency
    deductibleLoss currentProfit accumulatedLoss origLoss
        | currentProfit > 0 && accumulatedLoss < 0 = - minimum [currentProfit, - origLoss / 2, - accumulatedLoss]
        | otherwise = 0

        
-- TODO: Remove dist/ from git and ignore it.