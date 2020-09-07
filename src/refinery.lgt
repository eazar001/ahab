:- object(refinery,
    imports(metric_sort)).

    :- info([
        version is 0:1:0,
        author is 'Ebrahim Azarisooreh',
        date is 2020-09-07,
        comment is 'Top level object for processing and displaying scores to user.'
    ]).

    :- public(scores/1).

    scores(Scores) :-
        findall(
            score(Stock, Score),
            (   extends_object(Stock, stock),
                Stock::score(Score)
            ),
            Scores0
        ),
        list::sort(::score_sort, Scores0, Scores).

:- end_object.
