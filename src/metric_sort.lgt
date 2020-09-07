:- category(metric_sort).

    :- info([
        version is 0:1:0,
        author is 'Ebrahim Azarisooreh',
        date is 2020-09-07,
        comment is 'Sorting schemes for interal metrics and scores.'
    ]).

	:- private(pe_sort/3).
    :- mode(pe_sort(+atom, +compound, +compound), one).
    :- info(pe_sort/3, [
        comment is 'Sorting scheme to compare PE ratios.',
        arguments is [
            'Order' - 'The returned order (greater, less, or equal).',
            'R1' - 'a compound term of the form: pe_rank(Symbol, PEratio), for the first P/E ratio.',
            'R2' - 'a compound term of the form: pe_rank(Symbol, PEratio), for the second P/E ratio.'
        ]
    ]).

	:- private(div_sort/3).
    :- mode(div_sort(+atom, +compound, +compound), one).
    :- info(div_sort/3, [
        comment is 'Sorting scheme to compare dividend yields.',
        arguments is [
            'Order' - 'The returned order (greater, less, or equal).',
            'R1' - 'a compound term of the form: div_yield(Symbol, Yield), for the first div yield.',
            'R2' - 'a compound term of the form: div_yield(Symbol, Yield), for the second div yield.'
        ]
    ]).

	:- private(score_sort/3).
    :- mode(score_sort(+atom, +compound, +compound), one).
    :- info(score_sort/3, [
        comment is 'Sorting scheme to compare composite scores.',
        arguments is [
            'Order' - 'The returned order (greater, less, or equal).',
            'R1' - 'a compound term of the form: score(Symbol, Score), for the first composite score.',
            'R2' - 'a compound term of the form: score(Symbol, Score), for the second composite score.'
        ]
    ]).

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
