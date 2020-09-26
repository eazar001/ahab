:- object(equity_extractor).

    :- info([
        version is 0:2:0,
        author is 'Ebrahim Azarisooreh',
        date is 2020-09-19,
        comment is 'Extract equities from a Logtalk/Prolog database to instantiate their objects dynamically.'
    ]).

    :- public(extract_and_load/1).
    :- mode(extract_and_load(+path), one).
    :- info(extract_and_load/1, [
        comment is 'Extracts and loads stock information dynamically provided a logical database.',
        arguments is [
            'Path' - 'An abstract path that points to a file containing a logical database of stock information.'
        ]
    ]).

    extract_and_load(Path) :-
        logtalk::expand_library_path(Path, File),
        reader::file_to_terms(File, Terms),
        meta::map(convert_term, Terms, Stocks),
        forall(
            list::member(Stock, Stocks),
            stock_factory::new(_Id, Stock)
        ).

    convert_term(stock(Ticker, Company, Peers, AdvancedStats), stock(Ticker, CompanyDict, Peers, AdvancedStatsDict)) :-
        {   dict_create(AdvancedStatsDict, _, AdvancedStats),
            dict_create(CompanyDict, _, Company)
        }.

:- end_object.
