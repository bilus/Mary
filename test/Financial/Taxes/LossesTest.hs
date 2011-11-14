import Financial.Taxes.Losses
import Test.HUnit

deductLossesTests = test [
	"given empty list should return empty list" ~: [] ~=? (deductLosses 5 []), 
	"given one period should deductLosses nothing" ~: [100] ~=? (deductLosses 5 [100]),
	"it should never deductLosses more than profit" ~: [-100, 0] ~=? (deductLosses 5 [-100, 10]),
	"given multiple past losses it should deduct them correctly" ~: [-50, -150, 10] ~=? (deductLosses 5 [-50, -150, 110]),
	"it should never deduce more than 50% of each loss" ~: [-100, 150] ~=? (deductLosses 5 [-100, 200]),
	"it should never deduce more than 50% of each loss (2)" ~: [-100, -100, 100] ~=? (deductLosses 5 [-100, -100, 200]),
	"it should never deduce more than 50% of each loss (2)" ~: [-100, -100, 100, 100] ~=? (deductLosses 5 [-100, -100, 200, 200]),
	"it should never deduce go back more than 5 years" ~: [-100, 0, 0, 0, 0, 0, 100] ~=? (deductLosses 5 [-100, 0, 0, 0, 0, 0, 100]),
	"it should never deduce go back more than 5 years (2)" ~: [-100, -50, 0, 0, 0, 0, 75] ~=? (deductLosses 5 [-100, -50, 0, 0, 0, 0, 100]),
	"Magda's case" ~: [-350000, -220000,     0,     0, -150000, 240000, 665000, -420000, 990000,  1790000, -500000,      0, 1050000, -150000, 45000,      0] 
		~=? (deductLosses 5 [-350000, -220000, 50000, 40000, -150000, 600000, 850000, -420000, 1200000, 2000000, -500000, 220000, 1300000, -150000, 150000, 50000]),
	"" ~: True ~=? (True)]

main = runTestTT $ TestList [deductLossesTests]