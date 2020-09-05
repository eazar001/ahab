:- initialization((
    logtalk_load_context(directory, Root),
    assertz(logtalk_library_path(root, Root)),
    logtalk::expand_library_path(root(data), Data),
    assertz(logtalk_library_path(data, Data)),
    logtalk_load([
        basic_types(loader),
        reader(loader),
        meta(loader),
        metric_sort,
        stock,
        refinery,
        equity_extractor
    ]),
    equity_extractor::extract_and_load(data('equities.lgt'))
)).