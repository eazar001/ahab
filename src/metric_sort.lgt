:- category(metric_sort).

    :- private(pe_sort/3).
    :- private(div_sort/3).

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

:- end_category.
