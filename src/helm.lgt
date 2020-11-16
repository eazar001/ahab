:- object(helm,
    imports(metric_sort)).

    :- info([
        version is 0:5:0,
        author is 'Ebrahim Azarisooreh',
        date is 2020-11-07,
        comment is 'Top level object for processing and displaying scores to user.'
    ]).

    :- public(scores/1).
    :- mode(scores(-list(compound)), one).
    :- info(scores/1, [
        comment is 'Retrieves a list of compound terms with the first argument being the stock ticker symbol, and the second being the overall score.'
    ]).

    :- public(write_score_output/0).
    :- mode(write_score_output, one).
    :- info(write_score_output/0, [
        comment is 'Writes the final scores of each stock to a JSON file.'
    ]).

    scores(Scores) :-
        logtalk::asserta(message_hook(Message, comment, stock, _) :- Message \= calculate_scores(_)),
        lgtunit::benchmark(helm::stock_scores(Scores0), Time),
        logtalk::print_message(comment, stock, calculate_scores(Time)),
        list::length(Scores0, N),
        Top10Percent is floor(0.10 * N),
        list::msort(::score_sort, Scores0, Scores1),
        list::take(Top10Percent, Scores1, Scores),
        logtalk::retractall(message_hook(_, comment, stock, _)).
    
    stock_scores(Scores) :-
        findall(score(Stock, Score), stock_score(Stock, Score), Scores).

    stock_score(Stock, Score) :-
        extends_object(Stock, stock),
        Stock::score(Score).

    write_score_output :-
        scores(Scores),
        meta::map(stock_score_json_term, Scores, JSONscores),
        logtalk::expand_library_path(root('../out.json'), Path),
        {   dict_create(Dict, _, JSONscores),
            setup_call_cleanup(
                open(Path, write, Stream),
                json_write_dict(Stream, Dict),
                close(Stream)
            )
        }.

    stock_score_json_term(score(Ticker, Score), Ticker : Dict) :-
        Ticker::name(Name),
        Ticker::peers(Peers),
        Ticker::exchange(Exchange),
        Ticker::industry(Industry),
        Ticker::website(Website),
        Ticker::description(Description),
        Ticker::sector(Sector),
        exchange_morningstar(Exchange, Mx),
        !,
        Dict = _{
            name: Name,
            peers: Peers,
            score: Score,
            exchange: Exchange,
            industry: Industry,
            website: Website,
            description: Description,
            sector: Sector,
            mx: Mx
        }.

    exchange_morningstar('NASDAQ', xnas).
    exchange_morningstar('New York Stock Exchange', xnys).
    exchange_morningstar(_, xyns).

:- end_object.
