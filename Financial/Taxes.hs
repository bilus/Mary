module Financial.Taxes where
    
    import Financial.Types (Currency, pln)
    import Data.List (minimum)
    
    -- incomeTax :: [Currency] -> [Currency] -> (Currency, [Currency])
    -- incomeTax profit
    -- incomeTax profit:profits profit':profits'
    --  | profit <= 0 = (profit, profits')
    --  | otherwise = deductLosses profit profits profits'
    -- 
    -- deductLosses :: Currency -> [Currency] -> [Currency] -> (Currency, [Currency])
    -- deductLosses maxDeductionPeriods profit prevProfits prevProfits' =
    --  foldl step [] profit $ take maxDeducionPeriods $ zip prevProfits prevProfits'
    --  where
    --      step 

    -- Profits -> profits and losses after loss deduction.
    deductLosses :: Int -> [Currency] -> [Currency]
    deductLosses nPeriodsToLookBack = integrate . (doDeduct nPeriodsToLookBack) . (\xs -> zip xs xs)
        where
            integrate :: [(Currency, Currency)] -> [Currency]
            integrate xs = map select xs
             where
                select (orig, acc)  
                    | orig > 0 = acc    -- Profit: use calculation result.
                    | otherwise = orig  -- Loss: ignore calculation results, use original value.
            
    -- Profits -> profits interleaved with amounts of losses that couldn't be deducted.
    deductLosses' :: Int -> [Currency] -> [Currency]
    deductLosses' nPeriodsToLookBack = snd . unzip . (doDeduct nPeriodsToLookBack) . (\xs -> zip xs xs)
            
    doDeduct :: Int -> [(Currency, Currency)] -> [(Currency, Currency)]
    doDeduct nPeriodsToLookBack = reverse . foldr (deductLossesForPeriod nPeriodsToLookBack) [] . reverse

    deductLossesForPeriod :: Int -> (Currency, Currency) -> [(Currency, Currency)] -> [(Currency, Currency)]
    deductLossesForPeriod nPeriodsToLookBack crnt past = (foldr step [crnt] deductiblePast) ++ nonDeductiblePast
        where
            (deductiblePast, nonDeductiblePast) = splitAt nPeriodsToLookBack past   -- IMPORTANT: Deduction policy (1).
            step :: (Currency, Currency) -> [(Currency, Currency)] -> [(Currency, Currency)]
            step (orig, acc) ((orig', acc'):xs) = (orig', acc' + dl) : (orig, acc - dl) : xs
                where
                    dl = deductibleLoss acc' acc orig

    -- Same as deductLosses' but returns full history of loss deductions
    scanDeductLosses nPeriodsToLookBack past = reverse $ scanr (deductLossesForPeriod nPeriodsToLookBack) [] $ reverse $ zip past past

    -- IMPORTANT: Deduction policy (2).
    deductibleLoss :: Currency -> Currency -> Currency -> Currency
    deductibleLoss currentProfit accumulatedLoss origLoss
        | currentProfit > 0 && accumulatedLoss < 0 = - minimum [currentProfit, - origLoss / 2, - accumulatedLoss]
        | otherwise = 0

        
-- TODO: Remove dist/ from git and ignore it.