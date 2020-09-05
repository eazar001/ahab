:- object(refinery,
    imports(metric_sort)).

    % Equities analysis refinery: where all common stock equities mined from the cloud are sent to be processed via
    % contextual analysis of fundamental metrics.

    :- public(sort_pe_ratios/2).

    :- public(sort_div_rankings/2).

    % rank PE ratios of several companies (based on their peer lists) from best to worst
    sort_pe_ratios(Ticker, Ratios) :-
        Ticker::peers(Peers),
        findall(
            pe_rank(Peer, Ratio),
            (   list::member(Peer, [Ticker|Peers]),
                current_object(Peer),
                Peer::pe_ratio(Ratio)
            ),
            Ratios0
        ),
        list::sort(::pe_sort, Ratios0, Ratios).

    sort_div_rankings(Ticker, Yields) :-
        Ticker::peers(Peers),
        findall(
            div_yield(Peer, Div),
            (   list::member(Peer, [Ticker|Peers]),
                current_object(Peer),
                Peer::div_yield(Div)
            ),
            Yields0
        ),
        list::sort(::div_sort, Yields0, Yields).
        
    profit_margin_score(0.0, -0.25).
    profit_margin_score(Margin, Score) :-
        Margin < 0.0,
        Score is -0.25 * Margin -0.25,
        !.
    profit_margin_score(Margin, Margin) :-
        Margin > 0.0.

    % generate score based off of a company's PE ratio relative to a competitor
    pe_score(Ratio, Ratio, 0.0) :-
        !.
    pe_score(Ratio1, Ratio2, Score) :-
        Ratio1 < Ratio2,
        !,
        Score is (Ratio2 - Ratio1) / Ratio1.
    pe_score(Ratio1, Ratio2, Score) :-
        Score is (Ratio1 - Ratio2) / Ratio2.

    % generate score based off of a company's div yield relative to a competitor
    div_score(Div, Div, 0.0) :-
        !.
    div_score(Div1, Div2, Score) :-
        Div1 < Div2,
        !,
        Score is (Div1 - Div2) / Div1.
    div_score(Div1, Div2, Score) :-
        Score is (Div1 - Div2) / Div2.

    % generate score based off of a company's PEG ratio
    peg_score(1.0, 0.0) :-
        !.
    peg_score(Ratio, Score) :-
        Score is 1.0 - Ratio.

    % generate score based off of a company's P/B (price-to-book) ratio
    pb_score(3.0, 0.0) :-
        !.
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
        Ratio < 1.0,
        !,
        Score is 2 * (1.0 - Ratio).

    % generate free cash flow score 
    cash_flow_score(C, C, 0.0) :-
        !.
    cash_flow_score(C1, C2, Score) :-
        C1 < C2,
        !,
        Score is (C1 - C2) / C1.
    cash_flow_score(C1, C2, Score) :-
        Score is (C1 - C2) / C2.

    % generate profit margin score
    profit_margin_score(Margin, Margin, 0.0) :-
        !.
    profit_margin_score(Margin1, Margin2, Score) :-
        Margin1 < Margin2,
        !,
        Score is (Margin1 - Margin2) / Margin1.
    profit_margin_score(Margin1, Margin2, Score) :-
        Score is (Margin1 - Margin2) / Margin2.

:- end_object.
