:- ensure_loaded('equities.lgt').

:- dynamic(stock/2).

:- initialization(find_stocks).


find_stocks :-
    forall(
        stock(Ticker, Dicts),
        build_stock(Ticker, Dicts)        
    ),
    sort_stocks(Stocks),
    setup_call_cleanup(
        open('out.txt', append, Stream),
        forall(
            member(stock(Ticker, Growth), Stocks),
            format(Stream, '~a: ~w~n', [Ticker, Growth])
        ),
        close(Stream)
    ). 
    

build_stock(Ticker, Dicts) :-
    retractall(stock(Ticker, _)),
    forall(
        member(Dict, Dicts),
        asserta(stock(Ticker, Dict.totalRevenue))
    ),
    forall(
        findall(Revenue, stock(Ticker, Revenue), Revenues),
        (   retractall(stock(Ticker, _)),
            (   revenue_growth(Revenues, Percentage)
            ->  true
            ;   Percentage = 0
            ),
            assertz(stock(Ticker, Percentage))
        )
    ).

sort_stocks(Stocks) :-
    findall(stock(Ticker, Percentage), stock(Ticker, Percentage), Stocks0),
    sort(2, @>=, Stocks0, Stocks).

revenue_growth([], 0) :-
    !.
revenue_growth([_], 0) :-
    !.
revenue_growth([X, Y|Rest], Percentage) :-
    X > 0,
    revenue_growth_([X, Y|Rest], Growths),
    geometric_mean(Growths, Value),
    Percentage is (Value - 1) * 100.

revenue_growth_([], []) :-
    !.
revenue_growth_([_], []) :-
    !.
revenue_growth_([X, Y|Rest], [G|Values]) :-
    Y > 0,
    G is Y / X,
    revenue_growth_([Y|Rest], Values).

geometric_mean([X, Y|Rest], Mean) :-
    geometric_mean_([X, Y|Rest], 0, 1, Mean).

geometric_mean_([], N, Product, Mean) :-
    Mean is Product^(1/N).
geometric_mean_([X|Rest], N0, P0, Mean) :-
    P1 is P0 * X,
    N1 is N0 + 1,
    geometric_mean_(Rest, N1, P1, Mean).
