:- initialization((
    logtalk_load_context(directory, Root),
    assertz(logtalk_library_path(root, Root)),
    logtalk::expand_library_path(root(data), Data),
    assertz(logtalk_library_path(data, Data)),
    use_module(library(http/json)),
    % logtalk_load(debugger(loader)),
    % set_logtalk_flag(debug, on),
    % set_logtalk_flag(source_data, on),
    logtalk_load([
        basic_types(loader),
        reader(loader),
        meta(loader),
        statistics(loader),
        metric_sort,
        stock,
        refinery,
        equity_extractor
    ], [optimize(on)]),
    equity_extractor::extract_and_load(data('equities.lgt')),
    refinery::write_score_output
)).