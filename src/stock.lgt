:- object(stock_factory).

    :- public(new/2).

    new(Id, stock(Ticker, Peers, Stats)) :-
        {	downcase_atom(Ticker, Id),
            Name = Stats.companyName,
            PEratio = Stats.peRatio,
            PEGratio = Stats.pegRatio,
            PBratio = Stats.priceToBook,
            DivYield = Stats.dividendYield,
            ProfitMargin = Stats.profitMargin,
            TotalCash = Stats.totalCash
        },
        create_object(Id, [extends(stock)], [], [
            name(Name),
            peers(Peers),
            pe_ratio(PEratio),
            peg_ratio(PEGratio),
            pb_ratio(PBratio),
            div_yield(DivYield),
            profit_margin(ProfitMargin),
            total_cash(TotalCash)
        ]).
        

:- end_object.

:- object(stock,
    implements(stockp)).

    % set of attributes, statistics, and metrics that are attached to a stock equity


:- end_object.

