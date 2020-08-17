:- module(stock, [pe_ratio/2,
                  peg_ratio/2,
                  pb_ratio/2,
                  peers/2,
                  div_yield/2,
                  profit_margin/2,
                  cash_flow/2]).

% set of attributes, statistics, and metrics that are attached to a stock equity

:- dynamic(stock/4).

stock(ticker('AAPL'), pe_ratio(34.95), peers(['MSFT', 'NOK', 'IBM', 'BBRY', 'HPQ', 'GOOGL', 'XLK']), peg_ratio(1.89), pb_ratio(1.1), div_yield(1.1), profit_margin(22.39), cash_flow(23000.12)).
stock(ticker('MSFT'), pe_ratio(36.33), peers(['OLCR','IBM','GOOGL','HPQ','OCCS','APPL','SPA']), peg_ratio(2.38), pb_ratio(2.2), div_yield(3.2), profit_margin(22.39), cash_flow(23000.12)).
stock(ticker('GOOGL'), pe_ratio(33.16), peers(['OLCR','IBM','GOOGL','HPQ','OCCS','APPL','SPA']), peg_ratio(2.04), pb_ratio(2.83), div_yield(2.2), profit_margin(22.39), cash_flow(23000.12)).

pe_ratio(Ticker, Ratio) :-
    stock(ticker(Ticker), pe_ratio(Ratio), _, _, _, _, _, _).

peg_ratio(Ticker, Ratio) :-
    stock(ticker(Ticker), _, _, peg_ratio(Ratio), _, _, _, _).

pb_ratio(Ticker, Ratio) :-
    stock(ticker(Ticker), _, _, _, pb_ratio(Ratio), _, _, _).

div_yield(Ticker, Yield) :-
    stock(ticker(Ticker), _, _, _, _, div_yield(Yield), _, _).

profit_margin(Ticker, Margin) :-
    stock(ticker(Ticker), _, _, _, _, _, profit_margin(Margin), _).

cash_flow(Ticker, CashFlow) :-
    stock(ticker(Ticker), _, _, _, _, _, _, cash_flow(CashFlow)).

peers(Ticker, Peers) :-
    stock(ticker(Ticker), _, peers(Peers), _, _, _, _, _).
