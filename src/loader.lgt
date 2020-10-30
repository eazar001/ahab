:- initialization((
    logtalk_load_context(directory, Root),
    assertz(logtalk_library_path(root, Root)),
    logtalk::expand_library_path(root(data), Data),
    assertz(logtalk_library_path(data, Data)),
    use_module(library(http/json)),
    logtalk_load([
        basic_types(loader),
        reader(loader),
        meta(loader),
        statistics(loader),
        metric_sort,
        stock,
        helm,
        equity_extractor
    ], [optimize(on)]),
    equity_extractor::extract_and_load(data('equities.lgt')),
    helm::write_score_output
)).