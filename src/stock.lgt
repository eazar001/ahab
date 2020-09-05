:- object(stock_factory).

    :- public(new/2).

    new(Id, stock(Ticker, Peers, Stats)) :-
        {   downcase_atom(Ticker, Id),
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

:- object(stock).

    :- info([
        version is 0:1:0,
        author is 'Ebrahim Azarisooreh',
        date is 2020-09-03,
        comment is 'Protocol for the stock object.'
    ]).

    :- public([
        name/1,
        peg_ratio/1,
        pb_ratio/1,
        peers/1,
        div_yield/1,
        profit_margin/1,
        cash_flow/1
    ]).

    :- dynamic([
        name/1,
        peg_ratio/1,
        pb_ratio/1,
        peers/1,
        div_yield/1,
        profit_margin/1,
        total_cash/1
    ]).

    :- public(pe_ratio/1).
    :- dynamic(pe_ratio/1).
    :- mode(pe_ratio(-float), one).
    :- info(pe_ratio/1, [
        comment is 'Retrieves the p/e ratio of a stock object.'
    ]).


:- end_object.

