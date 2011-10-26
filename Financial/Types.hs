module Financial.Types (Currency, pln) where
	
	type Currency = Float
		
	pln :: Float -> Currency
	pln x = x