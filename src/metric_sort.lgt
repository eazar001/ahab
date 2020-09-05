:- category(metric_sort).

    :- private(pe_sort/3).
    :- private(div_sort/3).
    :- private(score_sort/3).

    % sort competitors by relative PE ranking
    pe_sort(<, pe_rank(_, R1), pe_rank(_, R2)) :-
        R1 < R2,
        !.
    pe_sort(>, pe_rank(_, R1), pe_rank(_, R2)) :-
        R1 > R2,
        !.
    pe_sort(=, pe_rank(_, _), pe_rank(_, _)).

    % sort competitors by relative div yield
    div_sort(>, div_yield(_, R1), div_yield(_, R2)) :-
        R1 < R2,
        !.
    div_sort(<, div_yield(_, R1), div_yield(_, R2)) :-
        R1 > R2,
        !.
    div_sort(=, div_yield(_, _), div_yield(_, _)).

    % sort stocks by top level score
    score_sort(>, score(_, S1), score(_, S2)) :-
        S1 < S2,
        !.
    score_sort(<, score(_, S1), score(_, S2)) :-
        S1 > S2,
        !.
    score_sort(=, score(_, S1), score(_, S1)).

:- end_category.
