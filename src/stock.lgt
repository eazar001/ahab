:- object(stock_factory).

    :- info([
        version is 0:2:0,
        author is 'Ebrahim Azarisooreh',
        date is 2020-09-19,
        comment is 'Constructor/destructor for the stock object.'
    ]).

    :- public(new/2).
    :- mode(new(?object_identifier, +compound), one).
    :- info(new/2, [
        comment is 'Creates a new stock object when provided a compound term representing stock information.',
        arguments is [
            'Id' - 'An object identifier for the stock object to be created.',
            'Stock' - 'A three argument compound term containing the ticker symbol, a list of peers, and statistics for the stock object to be created.'
        ]
    ]).

    :- public(delete/1).
    :- mode(delete(+object_identifier), one).
    :- info(delete/1, [
        comment is 'Deletes an object that extends the stock object.'
    ]).

    new(Id, stock(Ticker, Company, Peers, Stats)) :-
        { downcase_atom(Ticker, Id) },
        meta::map(downcase_atom, Peers, DownCasedPeers),
        Clauses = [
            name(Stats.companyName),
            peers(DownCasedPeers),
            pe_ratio(Stats.peRatio),
            peg_ratio(Stats.pegRatio),
            pb_ratio(Stats.priceToBook),
            div_yield(Stats.dividendYield),
            profit_margin(Stats.profitMargin),
            total_cash(Stats.totalCash),
            exchange(Company.exchange),
            industry(Company.industry),
            website(Company.website),
            description(Company.description),
            sector(Company.sector)
        ],
        create_object(Id, [extends(stock)], [], Clauses).

    delete(Id) :-
        extends_object(Id, stock),
        abolish_object(Id).

:- end_object.

:- object(stock,
    imports(metric_sort)).

    :- info([
        version is 0:2:0,
        author is 'Ebrahim Azarisooreh',
        date is 2020-09-19,
        comment is 'Abstract representation of a common stock security.'
    ]).

    :- public(name/1).
    :- mode(name(-atom), one).
    :- info(name/1, [
        comment is 'Retrieves the name of the company.'
    ]).

    :- public(exchange/1).
    :- mode(exchange(-atom), one).
    :- info(exchange/1, [
        comment is 'Retrieves the name of the stock exchange that the stock is listed on.'
    ]).

    :- public(industry/1).
    :- mode(industry(-atom), one).
    :- info(industry/1, [
        comment is 'Retrieves the industry-type specific to the stock in question.'
    ]).

    :- public(website/1).
    :- mode(website(-atom), one).
    :- info(website/1, [
        comment is 'Retrieves the company website for the stock.'
    ]).

    :- public(description/1).
    :- mode(description(-atom), one).
    :- info(description/1, [
        comment is 'Retrieves the company description for the stock.'
    ]).

    :- public(sector/1).
    :- mode(sector(-atom), one).
    :- info(sector/1, [
        comment is 'Retrieves the sector-type for the stock.'
    ]).

    :- public(pe_ratio/1).
    :- mode(pe_ratio(-float), one).
    :- info(pe_ratio/1, [
        comment is 'Retrieves the price to earnings per share ratio.'
    ]).

    :- public(peg_ratio/1).
    :- mode(peg_ratio(-float), one).
    :- info(peg_ratio/1 ,[
        comment is 'Retrieves the PEG ratio (P/E relative to growth).'
    ]).

    :- public(pb_ratio/1).
    :- mode(pb_ratio(-float), one).
    :- info(pb_ratio/1, [
        comment is 'Retrieves the price to book value (assets minus liabilities) per share ratio.'
    ]).

    :- public(peers/1).
    :- mode(peers(-list(atom)), one).
    :- info(peers/1, [
        comment is 'Retrieves a list of stock ticker symbols representing the peers (competitors).'
    ]).

    :- public(div_yield/1).
    :- mode(div_yield(-float), one).
    :- info(div_yield/1, [
        comment is 'Retrieves the dividend yield as a proportion.'
    ]).

    :- public(profit_margin/1).
    :- mode(profit_margin(-float), one).
    :- info(profit_margin/1, [
        comment is 'Retrieves the profit margin as a proportion.'
    ]).

    :- public(total_cash/1).
    :- mode(total_cash(-integer), one).
    :- info(total_cash/1, [
        comment is 'The sum of all the cash recorded on the company''s books, as an integer.'
    ]).

    :- public(score/1).
    :- mode(score(-float), one).
    :- info(score/1, [
        comment is 'The total composite score of the stock, indicating how valuable the company is as an investment decision',
        arguments is [
            'Score' - 'A continuous score from 1.0 to 5.0, where 1.0 is an excellent investment decision, and 5.0 is a dangerous one.'
        ]
    ]).

    score(Score) :-
        total_cash_score(TotalCashScore),
        profit_margin_score(ProfitMarginScore),
        pe_score(PEscore0),
        bound_score(PEscore0, PEscore),
        value_score(PEscore, PriceScore),
        Score is ProfitMarginScore + TotalCashScore + PriceScore.

    bound_score(Score0, 5.0) :-
        Score0 > 5.0,
        !.
    bound_score(Score0, 1.0) :-
        Score0 < 1.0,
        !.
    bound_score(Score, Score).

    translate_score(Score0, Score) :-
        Score0 > 4.0,
        !,
        Score is 5.0 - Score0 + 1.0.
    translate_score(Score0, Score) :-
        Score0 > 3.0,
        !,
        Score is 4.0 - Score0 + 2.0.
    translate_score(Score0, Score) :-
        Score0 > 2.0,
        !,
        Score is 3.0 - Score0 + 3.0.
    translate_score(Score0, Score) :-
        Score0 >= 1.0,
        Score is 2.0 - Score0 + 4.0.

    % not useful quite yet ...
    % compute_total_score(Scores, Score) :-
    %     catch(
    %         compute_scores_with_skewness(Scores, Score),
    %         error(evaluation_error(undefined), _),
    %         population::arithmetic_mean(Scores, Score)
    %     ).

    compute_total_score(Scores, Score) :-
        population::arithmetic_mean(Scores, Score).

    compute_scores_with_skewness(Scores, Score) :-
        population::skewness(Scores, Skew),
        abs(Skew) < 1.0,
        !,
        population::arithmetic_mean(Scores, Score).
    compute_scores_with_skewness(Scores, Score) :-
        population::median(Scores, Score).

    value_score(PEscore, Score) :-
        PEscore =< 4.0,
        !,
        growth_focused_price_score(Score).
    value_score(_, Score) :-
        earnings_focused_price_score(Score).

    price_score_book_modifier(PBscore, NewPBscore) :-
        ::peg_ratio(PEG),
        PEG \= 'None',
        PEG >= 0.0,
        PEG =< 1.0,
        !,
        NewPBscore is 2 * PBscore.
    price_score_book_modifier(PBscore, PBscore).

    earnings_focused_price_score(Score) :-
        pe_score(PE0),
        peg_score(PEG),
        pb_score(PB0),
        bound_score(PE0, PE),
        price_score_book_modifier(PB0, PB),
        Score is PE + 0.25 * PEG + PB.

    growth_focused_price_score(Score) :-
        pe_score(PE0),
        peg_score(PEG),
        pb_score(PB0),
        bound_score(PE0, PE),
        price_score_book_modifier(PB0, PB),
        Score is 0.25 * PE + PEG + PB.

    sort_pe_ratios(Ratios) :-
        self(Ticker),
        ::peers(Peers),
        findall(
            pe_rank(Peer, Ratio),
            (   list::member(Peer, [Ticker|Peers]),
                extends_object(Peer, stock),
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
                extends_object(Peer, stock),
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
        Score is 0.25 + Margin * 0.25.
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
        list::length(Ratios, Total),
        pe_score_by_peer(Ratios, Total, PeerScore),
        population::harmonic_mean(Ratios, Mean),
        pe_score_by_average(PE, Mean, AverageScore),
        population::arithmetic_mean([PeerScore, AverageScore], Score).
    pe_score(1.0).

    pe_score_by_peer(PEs, Total, Score) :-
        pe_score_by_peer(PEs, 0, Total, Score).

    pe_score_by_peer([], Count, Total, Score) :-
        Unit is 4.0 / Total,
        Score is Count * Unit + 1.0.
    pe_score_by_peer([OtherPE|PEs], Count0, Total, Score) :-
        ::pe_ratio(PE),
        1 - PE / OtherPE >= 0.05,
        !,
        Count is Count0 + 1,
        pe_score_by_peer(PEs, Count, Total, Score).
    pe_score_by_peer([_|PEs], Count, Total, Score) :-
        pe_score_by_peer(PEs, Count, Total, Score).

    pe_score_by_average(Ratio, Ratio, 0.0) :-
        !.
    pe_score_by_average(Ratio1, Ratio2, 2.0) :-
        Ratio1 < Ratio2,
        !.
    pe_score_by_average(_, _, 1.0).

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
        Score is 1E-10 * Cash,
        !.
    total_cash_score(Cash, Score) :-
        Score is 1E-10 * Cash.

    kth_order_stat(Sample, N, X) :-
        list::msort(Sample, Sample0),
        list::nth1(N, Sample0, X).

    sum_of_squares(Data, S) :-
        population::arithmetic_mean(Data, Mean),
        meta::fold_left({Mean}/[Sum0, X, Sum]>> ( Sum is Sum0 + (X - Mean)^2 ), 0, Data, S).

:- end_object.
