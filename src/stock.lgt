:- object(stock_factory).

    :- public(new/2).

    new(Id, stock(Ticker, Peers, Stats)) :-
        {   downcase_atom(Ticker, Id),
            meta::map(downcase_atom, Peers, DownCasedPeers),
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
            peers(DownCasedPeers),
            pe_ratio(PEratio),
            peg_ratio(PEGratio),
            pb_ratio(PBratio),
            div_yield(DivYield),
            profit_margin(ProfitMargin),
            total_cash(TotalCash)
        ]).
        

:- end_object.

:- object(stock,
    imports(metric_sort)).

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
        cash_flow/1,
        total_cash/1,
        total_cash_score/1,
        profit_margin_score/1,
        pe_score/1,
        peg_score/1,
        pb_score/1,
        score/1
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

    score(Score) :-
        total_cash_score(TotalCashScore),
        profit_margin_score(ProfitMarginScore),
        pe_score(PEScore),
        peg_score(PEGScore),
        pb_score(PBScore),
        Score is ProfitMarginScore + TotalCashScore + PEScore + PEGScore + PBScore.

    sort_pe_ratios(Ratios) :-
        self(Ticker),
        ::peers(Peers),
        findall(
            pe_rank(Peer, Ratio),
            (   list::member(Peer, [Ticker|Peers]),
                current_object(Peer),
                Peer::pe_ratio(Ratio),
                Ratio \== 'None',
                Ratio >= 0.0
            ),
            Ratios0
        ),
        list::sort(::pe_sort, Ratios0, Ratios).

    sort_div_rankings(Yields) :-
        self(Ticker),
        ::peers(Peers),
        findall(
            div_yield(Peer, Div),
            (   list::member(Peer, [Ticker|Peers]),
                current_object(Peer),
                Peer::div_yield(Div),
                Div \== 'None'
            ),
            Yields0
        ),
        list::sort(::div_sort, Yields0, Yields).

    profit_margin_score(Score) :-
        ::profit_margin(Margin),
        Margin \== 'None',
        !,
        profit_margin_score(Margin, Score).
    profit_margin_score(0.0).

    profit_margin_score(0.0, -0.25) :-
        !.
    profit_margin_score(Margin, Score) :-
        Margin < 0.0,
        !,
        Score is 0.25 * Margin * 0.25.
    profit_margin_score(Margin, Margin) :-
        Margin > 0.0.

    pe_score(Score) :-
        self(Self),
        sort_pe_ratios(Ratios0),
        list::selectchk(pe_rank(Self, PE), Ratios0, Ratios1),
        \+ list::empty(Ratios1),
        !,
        meta::map(arg(2), Ratios1, Ratios2),
        meta::exclude(>(0.0), Ratios2, Ratios),
        sample::harmonic_mean(Ratios, Mean),
        pe_score(PE, Mean, Score).
    pe_score(0.0).

    % generate score based off of a company's PE ratio relative to a competitor
    pe_score(Ratio, Ratio, 0.0) :-
        !.
    pe_score(Ratio1, Ratio2, Score) :-
        Ratio1 < Ratio2,
        !,
        Score is (Ratio2 - Ratio1) / Ratio1.
    pe_score(Ratio1, Ratio2, Score) :-
        Score is -(Ratio1 - Ratio2) / Ratio2.

    % generate score based off of a company's div yield relative to a competitor
    div_score(Div, Div, 0.0) :-
        !.
    div_score(Div1, Div2, Score) :-
        Div1 < Div2,
        !,
        Score is (Div1 - Div2) / Div1.
    div_score(Div1, Div2, Score) :-
        Score is (Div1 - Div2) / Div2.

    peg_score(Score) :-
        ::peg_ratio(Ratio),
        Ratio \== 'None',
        !,
        peg_score(Ratio, Score).
    peg_score(0.0).

    % generate score based off of a company's PEG ratio
    peg_score(1.0, 0.0) :-
        !.
    peg_score(Ratio, Score) :-
        Ratio >= 0.0,
        !,
        Score is 1.0 - Ratio.
    peg_score(Ratio, Score) :-
        Ratio < 0.0,
        Score is 0.02 * Ratio.

    pb_score(Score) :-
        ::pb_ratio(Ratio),
        Ratio \== 'None',
        pb_score(Ratio, Score).

    % generate score based off of a company's P/B (price-to-book) ratio
    pb_score(3.0, 0.0) :-
        !.
    pb_score(Ratio, Score) :-
        Ratio > 3.0,
        !,
        Score is -0.02 * (Ratio - 3.0).
    pb_score(Ratio, Score) :-
        Ratio < 3.0,
        Ratio >= 2.0,
        !,
        Score is 0.5 * (3.0 - Ratio).
    pb_score(Ratio, Score) :-
        Ratio < 2.0,
        Ratio >= 1.0,
        !,
        Score is 0.5 + 0.5 * (2.0 - Ratio).
    pb_score(Ratio, Score) :-
        Ratio > 0.0,
        Ratio < 1.0,
        !,
        Score is 2 * (1.0 - Ratio).
    pb_score(Ratio, Score) :-
        Ratio < 0.0,
        Score is 0.25 * Ratio.

    % generate free cash flow score 
    cash_flow_score(C, C, 0.0) :-
        !.
    cash_flow_score(C1, C2, Score) :-
        C1 < C2,
        !,
        Score is (C1 - C2) / C1.
    cash_flow_score(C1, C2, Score) :-
        Score is (C1 - C2) / C2.
    
    total_cash_score(Score) :-
        ::total_cash(Cash),
        Cash \== 'None',
        !,
        total_cash_score(Cash, Score).
    total_cash_score(0.0).
    
    total_cash_score(0.0, -0.25) :-
        !.
    total_cash_score(Cash, Score) :-
        Cash > 0.0,
        Score is 1E-9 * Cash,
        !.
    total_cash_score(Cash, Score) :-
        Score is 1E-9 * Cash.

:- end_object.
