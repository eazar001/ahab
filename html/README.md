-------------
Ahab Website
-------------

Welcome to the new and improved Ahab website. It may look like the same old
basic equity_refinery, but looks are definitely deceiving.

---------
Features
---------

- List up to 10000+ stocks on the same page
- Sort by name, ticker, and score
- Filter in real time

-----------------
Secret Features
----------------

The white whale has a lot of secrets to behold. A little relic from the days
of equity_refinery now brought to life. The power users dream. Presenting!
The underscore functionality.

In the search bar, type out the following for special functionality:

`_?` -> Random Sort Button
----------------------------

This sorts all the stocks randomly in the list. Good for finding out new
stocks that you may not have seen before

`_$` -> Ticker List Button
----------------------------

Tired of seeing all the stocks, then write out a list of stocks that you want
to see delimited by spaces. Then click 'List Tickers'.

Argument Example: `_$ A TSLA AA GOOGL`

`_#` -> Investment Calculator Button (Prototype)
-------------------------------------------------

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

- Investment Time (Ex: 5)

The amount of investment years

Argument Example: `_# .25 1000 100 .25 5`

`_+` -> String Comparison Sort (Ascending) Button
--------------------------------------------------

This sorts the list in ascending order. Works for strings only.
Argument: Which JSON key to sort by, or 'ticker' for the key

Argument Example: `_+ name`

`_-` -> String Comparison Sort (Descending) Button
---------------------------------------------------

This sorts the list in descending order. Works for strings only.
Argument: Which JSON key to sort by, or 'ticker' for the key

Argument Example: `_- ticker`

`_>` -> Alpha-Numeric Sort (Ascending) Button
-----------------------------------------------

This sorts the list in ascending order. Safest sorting method.
Argument: Which JSON key to sort by, or 'ticker' for the key

Argument Example: `_- score`

`_<` -> Alpha-Numeric Sort (Descending) Button
-----------------------------------------------

This sorts the list in descending order. Safest sorting method.
Argument: Which JSON key to sort by, or 'ticker' for the key

Argument Example: `_- description`

--------
Website
--------
An automated stock screener, to score candidates for the highest value stocks
in a given set.

Access with 'localhost:8081'.

--------------------------------
Issue and Prospect Feature List
--------------------------------

I don't feel like cluttering the issue list with junk, so I'm listing things
here since I can choose whether something is worth it or not in real time.
This is just a reminder for myself, and no way am I saying these features are
going to make it or the issues are going to be fixed.

As for how I feel about these things currently, I think I'm going to stop
doing this for a while until we get more data to play with. I did quite a
lot over two days of coding to improve the look, feel, and functionality of
the webpage, and personally this is how I'll be interacting with the data
Ahab is giving. If there are things I need to respond to, I really do not
mind responding to those things. But in terms of cranking in hours to get
something out, I think this'll be good enough until more Ahab JSON
functionality is added.

- Issue - Browser

This page currently does not operate on any mobile device once the jslist
switch had been made. Currently, the list does not show up on Apple Safari.
And possibly there is some sort of memory issue happening with it loading
on mobile devices such as Apple iPhone and Android Nexus devices.

- Secret Feature - Filter Control (@)

My initial thought for this feature is for a power user to first select the
json key, and then to type out anything to filter the list using that key.
If someone knows what they are looking for, this can make it so they can
filter the list down to the specific industry, sector, or even website they
are looking for. Should work the same as the normal filter does without needing
the extra click to do things.

- Secret Feature Extension - Multi-sort (+-<>?)

An extension to the sorting function, this feature will allow say a person
to use more than one json key to sort by. The way it would work is it'll sort
the first key asked for, then for each group that has the same value it'll
do a bunch of mini sorts. A good example is:

`_+ score ticker`

In this case, it'll first sort everything by the score. Then if the score
column has a bunch of 1.0's in it, it will then sort just the 1.0's in order
for the ticker. It'll then repeat the process for 2.0, 3.0, until the whole
list is exhausted.

I'm not all gung-ho about this feature, because we already have so many ways
of sorting the list. I mean, I can kind of see it having some use for multiple
scores. I'll think about revisiting this feature once multiple scores come in.
At the very least, the framework is in place for this.

- Secret Feature - Save List (^)

This secret feature will make a permanent button to take the visible list and
convert it to a `_$` notation. This is one of those features that I like
making because it may not seem useful at the beginning, but definitely will
come in useful later on the more we use the website.

Best case scenario: I have it copy the text to the clipboard
Worst case scenario: I have it paste the text in the search window

Another option for this is to have the text after the save notation '_^'
act like the filter in itself so you can filter down to certain things or
allow for the Ticker List functionality to peek through with a $ symbol

- Secret Feature - Change View (!)

I actually dread making this feature, which would allow power users to
programmatically edit the visible rows and columns of the list using the
search bar. I really want to make sure the entire system works completely
before attempting to improve the overall flexibility of the site.

However, if this does become complete, one can use any JSON key to determine
the columns that'll be available for viewing, and the order of those columns.
The rows are already pretty controlled by the filtering features available.

- Secret Feature Extension - Investment Calculator (#)

The Prototype is pretty good if you just want to quickly get something done.
However, we did talk about having something like a histogram chart or a bar
graph to quickly visualize the data year over year. As much as I was trying
to stay away from third party tools for this thing, I believe the investment
calculator is one of those features that needs the most tender loving care
in order for it to be a lot more useful to the users that are interacting
with it.
