-------------
Ahab Website
-------------

Welcome to the new and improved Ahab website. It may look like the same old
basic equity_refinery, but looks are definitely deceiving.

Features
---------

- List up to 10000+ stocks on the same page
- Sort by name, ticker, and score
- Filter in real time

Secret Features
----------------

The white whale has a lot of secrets to behold. A little relic from the days
of equity_refinery now brought to life. The power users dream. Presenting!
The underscore functionality.

In the search bar, type out the following for special functionality:

- `_?` -> Random Sort Button

This sorts all the stocks randomly in the list. Good for finding out new
stocks that you may not have seen before

- `_$` -> Ticker List Button

Tired of seeing all the stocks, then write out a list of stocks that you want
to see delimited by spaces. Then click 'Ticker List'.

Argument Example: `_$ A TSLA AA GOOGL`

- `_%` -> Investment Calculator Button (Prototype)

Sometimes you just want to calculate how much money you'll be making over the
years. Click Calculate to complete. The Arguments go in this order:

- Rate of Return (Ex: .25)

The Rate of Return is the amount of investment interest

- Principal (Ex: 1000)

The initial amount of money within your investment

- Contribution (Ex: 100)

How much money is being contributed per 'Compounding Frequency'

- Compounding Frequency (Ex: .25)

The amount of times this investment compounds interest
.25 = Quarterly
1 = Yearly

- Investment Time (5)

The amount of investment years

Argument Example: `_% .25 1000 100 .25 5`

Website
--------
An automated stock screener, to score candidates for the highest value stocks
in a given set.

Access with 'localhost:8081'.
