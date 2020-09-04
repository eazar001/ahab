:- object(equity_extractor).

    :- info([
        version is 0:1:0,
        author is 'Author',
        date is 2020-09-04,
        comment is 'Description'
    ]).

    :- public(extract_and_load/1).

    extract_and_load(Path) :-
        logtalk::expand_library_path(Path, File),
        reader::file_to_terms(File, Terms),
        meta::map(convert_term, Terms, Stocks),
        forall(
            list::member(Stock, Stocks),
            stock_factory::new(_Id, Stock)
        ).
    
    convert_term(stock(Ticker, Peers, KVs), stock(Ticker, Peers, AdvancedStatsDict)) :-
        { dict_create(AdvancedStatsDict, _, KVs) }.

:- end_object.
