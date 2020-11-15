:- category(stock_messages).

    :- info([
        version is 0:5:0,
        author is 'Ebrahim Azarisooreh',
        date is 2020-11-15,
        comment is 'Messages that are related to operations in the stock object.'
    ]).

    :- multifile(logtalk::message_tokens//2).
    :- dynamic(logtalk::message_tokens//2).

    logtalk::message_tokens(value_score(PEscore, growth), stock) -->
        ['PE score less than or equal to ~w, focusing weight on PEG' - [PEscore], nl].

    logtalk::message_tokens(value_score_book_modifier, stock) -->
        ['PEG is greater than 1.0, doubling weight of P/B ratio', nl].

    logtalk::message_tokens(value_score(start), stock) -->
        [nl, '--- Computing value score ---', nl, nl].

    logtalk::message_tokens(growth_score(start), stock) -->
        [nl, '--- Computing growth score ---', nl, nl].

    logtalk::message_tokens(stock_performance_score(Change, Score), stock) -->
        { Percent is Change * 100 },
        ['5 year stock performance is ~w%, adjusting stock peformance score to ~w' - [Percent, Score]].

    logtalk::message_tokens(profit_margin_score(Margin, AverageMargin, Score), stock) -->
        ['Margin is ~w, peer average margin is ~w, adjusting profit margin score to ~w' - [Margin, AverageMargin, Score], nl].

    logtalk::message_tokens(pe_score_by_peer(Ratio, Others, Score), stock) -->
        ['PE ratio is ~w, peer ratios are ~w, adjusting PE peer score to ~w' - [Ratio, Others, Score], nl].

    logtalk::message_tokens(peg_score(Ratio, Score), stock) -->
        ['PEG ratio is ~w, adjusting PEG score to ~w' - [Ratio, Score], nl].

    logtalk::message_tokens(pb_score(Ratio, Score), stock) -->
        ['PB ratio is ~w, adjusting PB score to ~w' - [Ratio, Score], nl].

    logtalk::message_tokens(debt_to_equity_score(Ratio, Score), stock) -->
        ['Debt-to-equity ratio is ~w, adjusting debt-to-equity score to ~w' - [Ratio, Score], nl].

    logtalk::message_tokens(computing(Stock), stock) -->
        [nl, '--- Computing score for ~w ---' - [Stock], nl, nl].

:- end_category.
