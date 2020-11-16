:- initialization((
    set_logtalk_flag(debug, on),
    logtalk_load_context(directory, Root),
    assertz(logtalk_library_path(root, Root)),
    logtalk::expand_library_path(root(data), Data),
    assertz(logtalk_library_path(data, Data)),
    use_module(library(http/json)),
    logtalk_load([
        debugger(loader),
        basic_types(loader),
        reader(loader),
        meta(loader),
        statistics(loader),
        optionals(loader),
        stock_messages,
        metric_sort,
        stock,
        helm,
        equity_extractor
    ]),
    equity_extractor::extract_and_load(data('equities.lgt')),
    helm::write_score_output
)).