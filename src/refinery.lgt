:- object(refinery,
    imports(metric_sort)).

    % Equities analysis refinery: where all common stock equities mined from the cloud are sent to be processed via
    % contextual analysis of fundamental metrics.

    :- public(scores/1).

    scores(Scores) :-
        findall(
            score(Stock, Score),
            (   current_object(Stock),
                extends_object(Stock, stock),
                Stock::score(Score)
            ),
            Scores0
        ),
        list::sort(::score_sort, Scores0, Scores).

:- end_object.
