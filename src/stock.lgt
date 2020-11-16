:- object(stock_factory).

    :- info([
        version is 0:5:0,
        author is 'Ebrahim Azarisooreh',
        date is 2020-11-07,
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

    new(Ticker, stock(Ticker, Company, Peers, Stats)) :-
        Keys = [dividendYield, year5ChangePercent, sharesOutstanding],
        meta::map(retrieve(Stats), Keys, [DivYield, Year5Change, SharesOutstanding]),
        Clauses = [
            name(Stats.companyName),
            peers(Peers),
            pe_ratio(Stats.peRatio),
            peg_ratio(Stats.pegRatio),
            pb_ratio(Stats.priceToBook),
            debt_to_equity_ratio(Stats.debtToEquity),
            div_yield(DivYield),
            profit_margin(Stats.profitMargin),
            year5_change(Year5Change),
            revenue(Stats.revenue),
            market_cap(Stats.marketcap),
            shares_outstanding(SharesOutstanding),
            total_cash(Stats.totalCash),
            exchange(Company.exchange),
            industry(Company.industry),
            website(Company.website),
            description(Company.description),
            sector(Company.sector)
        ],
        create_object(Ticker, [extends(stock)], [], Clauses).

    retrieve(Dict, Key, Value) :-
        catch(
            retrieve_(Key, Dict, Value),
            error(existence_error(key, _, _), _),
            optional::empty(Value)
        ).

    retrieve_(Key, Dict, Value) :-
        optional::of(Dict.Key, Value).

    delete(Id) :-
        extends_object(Id, stock),
        abolish_object(Id).

:- end_object.

:- object(stock,
    imports(metric_sort)).

    :- info([
        version is 0:5:0,
        author is 'Ebrahim Azarisooreh',
        date is 2020-11-07,
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

    :- public(debt_to_equity_ratio/1).
    :- mode(debt_to_equity_ratio(-float), one).
    :- info(debt_to_equity_ratio/1, [
        comment is 'Retrives the amount of liabilities relative to the shareholder''s equity.'
    ]).

    :- public(year5_change/1).
    :- mode(year5_change(-optional(float)), one).
    :- info(year5_change/1, [
        comment is 'A proportion representing the percent change in stock price over 5 years.'
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

    :- public(roe/1).
    :- mode(roe(-float), one).
    :- info(roe/1, [
        comment is 'Return on equity - calculated as net income as a proportion of shareholder''s equity (book value).'
    ]).

    :- public(net_income/1).
    :- mode(net_income(-float), one).
    :- info(net_income/1, [
        comment is 'The net profit after deducting the cost of goods and services.'
    ]).

    :- public(revenue/1).
    :- mode(revenue(-float), one).
    :- info(revenue/1, [
        comment is 'Business income generated from normal business activities such as the sale of goods and services.'
    ]).

    :- public(market_cap/1).
    :- mode(market_cap(-integer), one).
    :- info(market_cap/1, [
        comment is 'Total market capitalization (shares outstanding * previous day close price).'
    ]).

    :- public(shares_outstanding/1).
    :- mode(shares_outstanding(-integer), one).
    :- info(shares_outstanding/1, [
        comment is 'Total number of shares outstanding for the given stock in question.'
    ]).

    :- public(previous_day_close/1).
    :- mode(previous_day_close(-float), one).
    :- info(previous_day_close/1, [
        comment is 'Previous day close price.'
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
            'Score' - 'A continuous score from 1.0 to 5.0, where 1.0 is an intriguing investment decision, and 5.0 is a questionable one.'
        ]
    ]).

    :- public(scores/3).
    :- mode(scores(-float, -float, -float), one).
    :- info(scores/3, [
        comment is 'Returns the value of the overall, value, and growth score for the stock in question.',
        arguments is [
            'Score' - 'A continuous score from 1.0 to 5.0, where 1.0 is an intriguing investment decision, and 5.0 is a questionable one.',
            'ValueScore' - 'A continous score from 1.0 to 5.0, where 1.0 has a high chance of being a discounted stock relative to fair value, and 5.0 is most likely trading at a premium.',
            'GrowthScore' - 'A continous score from 1.0 to 5.0, where 1.0 has a high chance of rapid growth, and 5.0 is most likely to have stagnant growth.'
        ]
    ]).

    score(Score) :-
        scores(Score, _, _).

    scores(Score, ValueScore, GrowthScore) :-
        self(Self),
        logtalk::print_message(comment, stock, computing(start, Self)),
        pe_score(PEscore0),
        bound_score(PEscore0, PEscore),
        logtalk::print_message(comment, stock, value_score(start)),
        value_score(PEscore, ValueScore0),
        logtalk::print_message(comment, stock, growth_score(start)),
        growth_score(GrowthScore0),
        meta::map(translate_score, [ValueScore0, GrowthScore0], [ValueScore1, GrowthScore1]),
        format(atom(ValueScoreAtom), '~1f', [ValueScore1]),
        format(atom(GrowthScoreAtom), '~1f', [GrowthScore1]),
        meta::map(atom_number, [ValueScoreAtom, GrowthScoreAtom], [ValueScore, GrowthScore]),
        logtalk::print_message(comment, stock, score_summary_header),
        logtalk::print_message(comment, stock, value_score(done, ValueScore)),
        logtalk::print_message(comment, stock, growth_score(done, GrowthScore)),
        population::arithmetic_mean([ValueScore, GrowthScore], Score0),
        format(atom(ScoreAtom), '~1f', [Score0]),
        atom_number(ScoreAtom, Score),
        logtalk::print_message(comment, stock, overall_score(done, Score)),
        logtalk::print_message(comment, stock, computing(stop, Self)).

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

    growth_score(Score) :-
        profit_margin_score(ProfitMarginScore0),
        stock_performance_score(PerformanceScore0),
        meta::map(bound_score, [ProfitMarginScore0, PerformanceScore0], [ProfitMarginScore, PerformanceScore]),
        population::arithmetic_mean([ProfitMarginScore, PerformanceScore], Score).

    value_score(PEscore, Score) :-
        Limit = 3.0,
        PEscore =< 3.0,
        !,
        logtalk::print_message(comment, stock, value_score(PEscore, Limit, growth)),
        growth_focused_value_score(PEscore, Score).
    value_score(PEscore, Score) :-
        earnings_focused_value_score(PEscore, Score).

    value_score_book_modifier(PBscore, PBscore) :-
        ::peg_ratio(PEG),
        PEG \= 'None',
        PEG >= 0.0,
        PEG =< 1.0,
        !.
    value_score_book_modifier(PBscore, NewPBscore) :-
        logtalk::print_message(comment, stock, value_score_book_modifier),
        NewPBscore is 2 * PBscore.

    earnings_focused_value_score(PE, Score) :-
        core_value_metrics(PEG, PB, DE),
        Score0 is (1.25 * PE + PEG + PB + DE) / 4,
        bound_score(Score0, Score).

    growth_focused_value_score(PE, Score) :-
        core_value_metrics(PEG, PB, DE),
        Score0 is (PE + 1.25 * PEG + PB + DE) / 4,
        bound_score(Score0, Score).

    core_value_metrics(PEG, PB, DE) :-
        peg_score(PEG0),
        pb_score(PB0),
        debt_to_equity_score(DE0),
        meta::map(bound_score, [PEG0, PB0, DE0], [PEG, PB1, DE]),
        value_score_book_modifier(PB1, PB2),
        bound_score(PB2, PB).

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
        list::msort(::pe_sort, Ratios0, Ratios).

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
        list::msort(::div_sort, Yields0, Yields).

    peer_profit_margins(Margins) :-
        ::peers(Peers),
        findall(
            Margin,
            (   list::member(Peer, Peers),
                extends_object(Peer, stock),
                Peer::profit_margin(Margin),
                Margin \== 'None'
            ),
            Margins
        ).

    stock_performance_score(Score) :-
        ::year5_change(Change),
        optional(Change)::map(stock_performance_score, OptionalScore),
        optional(OptionalScore)::or_else(Score, 3.0).

    stock_performance_score(Change, Score) :-
        Change > 0.0,
        !,
        stock_performance_score_(Change, Score),
        logtalk::print_message(comment, stock, stock_performance_score(Change, Score)).
    stock_performance_score(_, 1.0).

    stock_performance_score_(Change, 2.0) :-
        Change >= 0.25,
        Change < 0.50,
        !.
    stock_performance_score_(Change, 3.0) :-
        Change >= 0.50,
        Change < 0.61,
        !.
    stock_performance_score_(Change, 3.5) :-
        Change >= 0.61,
        Change < 1.0,
        !.
    stock_performance_score_(Change, 4.0) :-
        Change >= 1.0,
        Change < 1.0113,
        !.
    stock_performance_score_(Change, 4.5) :-
        Change >= 1.0113,
        Change < 1.25,
        !.
    stock_performance_score_(Change, 5.0) :-
        Change >= 1.25,
        !.
    stock_performance_score_(_, 1.0).

    profit_margin_score(Score) :-
        ::profit_margin(Margin),
        Margin \== 'None',
        Margin > 0.0,
        !,
        peer_profit_margins(Margins),
        (   population::arithmetic_mean(Margins, AverageMargin)
        ->  profit_margin_score(Margin, AverageMargin, Score),
            logtalk::print_message(comment, stock, profit_margin_score(Margin, AverageMargin, Score))
        ;   Score = 3.0
        ).
    profit_margin_score(3.0) :-
        ::profit_margin('None'),
        !.
    profit_margin_score(1.0).

    profit_margin_score(Margin, AverageMargin, 3.0) :-
        Lower is 0.95 * AverageMargin,
        Upper is 1.05 * AverageMargin,
        Margin >= Lower,
        Margin =< Upper,
        !.
    profit_margin_score(Margin, AverageMargin, 3.5) :-
        Upper is 1.05 * AverageMargin,
        Margin >= AverageMargin,
        Margin =< Upper,
        !.
    profit_margin_score(Margin, AverageMargin, 4.0) :-
        Lower is 1.05 * AverageMargin,
        Upper is 1.08 * AverageMargin,
        Margin >= Lower,
        Margin =< Upper,
        !.
    profit_margin_score(Margin, AverageMargin, 4.5) :-
        Lower is 1.05 * AverageMargin,
        Upper is 1.10 * AverageMargin,
        Margin >= Lower,
        Margin =< Upper,
        !.
    profit_margin_score(Margin, AverageMargin, 5.0) :-
        Margin > AverageMargin,
        !.
    profit_margin_score(Margin, AverageMargin, 2.0) :-
        Lower is 0.95 * AverageMargin,
        Margin < Lower,
        !.
    profit_margin_score(_, _, 1.0).

    pe_score(Score) :-
        self(Self),
        sort_pe_ratios(Ratios0),
        list::selectchk(pe_rank(Self, PE), Ratios0, Ratios1),
        PE >= 0.0,
        \+ list::empty(Ratios1),
        !,
        meta::map(arg(2), Ratios1, Ratios2),
        meta::exclude(>(0.0), Ratios2, Ratios),
        list::length(Ratios2, Total),
        pe_score_by_peer(Ratios2, Total, PeerScore),
        logtalk::print_message(comment, stock, pe_score_by_peer(PE, Ratios2, PeerScore)),
        population::harmonic_mean(Ratios, Mean),
        pe_bonus_by_average(PE, Mean, AverageBonus),
        Score is AverageBonus + PeerScore.
    pe_score(1.0).

    pe_score_by_peer(PEs, Total, Score) :-
        pe_score_by_peer(PEs, 1.0, Total, Score).

    pe_score_by_peer([], Count, Total, Score) :-
        Unit is 4.0 / Total,
        Score is Count * Unit.
    pe_score_by_peer([OtherPE|PEs], Count0, Total, Score) :-
        ::pe_ratio(PE),
        OtherPE >= 0.0,
        OtherPE > PE,
        PE / OtherPE =< 0.85,
        !,
        Count is Count0 + 1,
        pe_score_by_peer(PEs, Count, Total, Score).
    pe_score_by_peer([OtherPE|PEs], Count0, Total, Score) :-
        OtherPE < 0.0,
        !,
        Count is Count0 + 1,
        pe_score_by_peer(PEs, Count, Total, Score).
    pe_score_by_peer([_|PEs], Count, Total, Score) :-
        pe_score_by_peer(PEs, Count, Total, Score).

    pe_bonus_by_average(Ratio, Ratio, 0.0) :-
        !.
    pe_bonus_by_average(Ratio1, Ratio2, 1.0) :-
        Ratio1 < Ratio2,
        !.
    pe_bonus_by_average(_, _, 0.0).

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
        Ratio >= 0.0,
        !,
        peg_score(Ratio, Score),
        logtalk::print_message(comment, stock, peg_score(Ratio, Score)).
    peg_score(1.0).

    peg_score(Ratio, 3.0) :-
        Ratio >= 1.0,
        !.
    peg_score(Ratio, Score) :-
        Score is (4 - Ratio) + 1.0.

    pb_score(Score) :-
        ::pb_ratio(Ratio),
        Ratio \== 'None',
        !,
        pb_score(Ratio, Score),
        logtalk::print_message(comment, stock, pb_score(Ratio, Score)).
    pb_score(3.0).

    pb_score(3.0, 2.0) :-
        !.
    pb_score(Ratio, 3.0) :-
        Ratio > 1.0,
        Ratio < 3.0,
        !.
    pb_score(1.0, 3.5) :-
        !.
    pb_score(Ratio, Score) :-
        Ratio >= 0.0,
        Ratio < 1.0,
        !,
        Score is (4 - Ratio) + 1.0.
    pb_score(_, 1.0).

    debt_to_equity_score(Score) :-
        ::debt_to_equity_ratio(Ratio),
        Ratio \== 'None',
        Ratio >= 0.0,
        !,
        debt_to_equity_score(Ratio, Score),
        logtalk::print_message(comment, stock, debt_to_equity_score(Ratio, Score)).
    debt_to_equity_score(3.0) :-
        ::debt_to_equity_ratio('None'),
        !.
    debt_to_equity_score(1.0).

    debt_to_equity_score(Ratio, 5.0) :-
        Ratio =< 1.0,
        !.
    debt_to_equity_score(Ratio, 4.0) :-
        Ratio =< 1.5,
        !.
    debt_to_equity_score(Ratio, 3.0) :-
        Ratio =< 2.0,
        !.
    debt_to_equity_score(Ratio, 2.0) :-
        Ratio =< 2.5,
        !.
    debt_to_equity_score(_, 1.0).

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

    roe(Return) :-
        net_income(Net),
        book_value(Book),
        Book \== 'None',
        !,
        Return is Net / Book.
    roe('None').

    % net income, net earnings
    net_income(Net) :-
        ::profit_margin(ProfitMargin),
        ::revenue(Revenue),
        ProfitMargin \== 'None',
        Net is ProfitMargin * Revenue.

    previous_day_close(Price) :-
        ::market_cap(MarketCap),
        ::shares_outstanding(Shares),
        Shares \== 'None',
        !,
        Price is MarketCap / Shares.
    previous_day_close('None').

    book_value(Book) :-
        ::pb_ratio(Ratio),
        ::shares_outstanding(Shares),
        Shares \== 'None',
        previous_day_close(Price),
        Price \== 'None',
        !,
        BVS is Price / Ratio,
        Book is BVS * Shares.
    book_value('None').

    kth_order_stat(Sample, N, X) :-
        list::msort(Sample, Sample0),
        list::nth1(N, Sample0, X).

    sum_of_squares(Data, S) :-
        population::arithmetic_mean(Data, Mean),
        meta::fold_left({Mean}/[Sum0, X, Sum]>> ( Sum is Sum0 + (X - Mean)^2 ), 0, Data, S).

:- end_object.
