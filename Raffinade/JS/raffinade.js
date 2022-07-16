// Raffinade

// Toolkit for improve CoffeeScript postfix and prefix ability
// in order to write and read elegant code

// 2022 Alexander (Shurko) Stadnichenko
// Under BSD-2-Clause
// Unstable !

// Constants
/*
 * return entity/entry if any, else custom or default no entry/no entity marker
second = (arrg, noent = NOENT) ->
  if len arrg > ONE
    arr .at SECOND
  else
    noent
 */
var EXIT_OK, FIRST, LAST, LEFT, NOENT, NONE, ONE, ONLY, PENULTIMATE, RIGHT, SECOND, TWO, all_beats_one, alto, apply_to_all, apredec, aprodec, arr, asyncrange3, ato, azip, azip2, cc, cl, concat, constr, cps, cps2, empty, ensure, first, gen, generator, is_arr, join, last, len, lswap, map, mapk, max, min, min2, min3, noop, only, pack, penultimate, pick, pk, pkone, predec, prodec, pu, rswap, second, split, swap, times, u,
    splice = [].splice;

ONLY = 0;

FIRST = 0;

SECOND = 1;

LAST = -1;

PENULTIMATE = -2;

ONE = 1;

TWO = 2;

LEFT = 0;

RIGHT = 1;

u = void 0;

NONE = '}9{9Pd^T';

NOENT = 'Yr4-*<c{';

EXIT_OK = 0;

// Shortcuts
cl = console.log;

arr = Array.from;

is_arr = Array.isArray;

len = function (arr) {
    return arr.length;
};

split = function (sep, str) {
    return str.split(sep);
};

map = function (f, arr) {
    return arr.map(f);
};

join = function (s, a) {
    return a.join(s);
};

// Prefix part
lswap = swap = function (l, r, ...yarg) {
    return [r, l, ...yarg];
};

rswap = function (...yarg) {
    var l, r, ref;
    ref = yarg, [...yarg] = ref, [l, r] = splice.call(yarg, -2);
    return [...yarg, r, l];
};

empty = function (arrg) {
    return !len(arrg);
};

// pick = (idx, arr) -> arr[idx]
pick = function (idx, arr) {
    return arr.at(idx);
};

pack = pk = function (...args) {
    return args;
};

pkone = function (entt) {
    return pack(entt);
};

ensure = {};

ensure.array = ensure.list = function (any) {
    if (is_arr(any)) {
        return any;
    } else {
        return pack(any);
    }
};

concat = cc = function (arrg, ...entts) {
    arrg = ensure.array(arrg);
    return arrg.concat(entts);
};

times = function (times, opr, opd) {
    var j, ref;
    for (j = 1, ref = times; (1 <= ref ? j <= ref : j >= ref); 1 <= ref ? j++ : j--) {
        opd = opr(opd);
    }
    return opd;
};

// Functional-like construction
all_beats_one = constr = function (val, fcs) {
    fcs.map(function (fc) {
        return val = fc(val);
    });
    return val;
};

// Functional-like apply-to-all
apply_to_all = ato = function (fcs, vals) {
    [fcs, vals] = [fcs, vals].map(ensure.array);
    return vals.map(function (val) {
        fcs.forEach(function (fc) {
            return val = fc(val);
        });
        return val;
    });
};

// Alternative ato
alto = function (fcs, vals) {
    [fcs, vals] = [fcs, vals].map(ensure.array);
    return vals.map(function (val) {
        var fseq;
        fseq = [val].concat(fcs); // Rewrite to fseq = cc val, fcs
        return fseq.reduce(function (acc, fc) {
            return fc(acc);
        });
    });
};

// Functional-like composition
cps2 = function (fc1, fc2) {
    return function (any) {
        return fc1(fc2(any));
    };
};

// General functional-like composition
cps = function (...fcs) {
    fcs = fcs.reverse(u);
    return function (any) {
        return alto(fcs, any);
    };
};

// Naive Descartes production
predec = function (fc, arrs, defined) {
    var itentt, rest;
    if (empty(arrs)) {
        return fc(defined);
    } else {
        rest = arr(arrs);
        itentt = rest.shift(u);
        return itentt.forEach(function (itentr) {
            return predec(fc, rest, cc(defined, itentr));
        });
    }
};

prodec = function (fc, ...arrs) {
    return predec(fc, arrs, []);
};

// Naive async Descartes production
apredec = async function* (fc, arrs, defined) {
    var i, itentr, itentt, rest;
    if (empty(arrs)) {
        yield fc(defined);
    } else {
        rest = arr(arrs);
        itentt = rest.shift(u);
        if (is_arr(itentt)) {
            itentt = gen(itentt);
        }
        for await (itentr of itentt) {
            yield* ((await (async function () {
                var ref, results;
                ref = apredec(fc, rest, cc(defined, itentr));
                results = [];
                for await (i of ref) {
                    results.push(i);
                }
                return results;
            })()));
        }
    }
    return void 0;
};

aprodec = async function* (fc = noop, ...arrs) {
    var i;
    yield ((await (async function () {
        var ref, results;
        ref = apredec(fc, arrs, []);
        results = [];
        for await (i of ref) {
            results.push(i);
        }
        return results;
    })()));
    return void 0;
};

mapk = function (f, ...args) {
    return args.map(f);
};

first = only = function (arrg) {
    return arrg[FIRST];
};

second = function (arr) {
    return arr[SECOND];
};

last = function (arr) {
    return arr[arr.length - 1];
};

penultimate = pu = function (arr) {
    return arr[arr.length - 2];
};

min = function (one, another) {
    if (one < another) {
        return one;
    } else {
        return another;
    }
};

max = function (one, another) {
    return min(another, one);
};

// Wrap array to generator
generator = gen = async function* (arr) {
    var i;
    for await (i of arr) {
        yield i;
    }
    return void 0;
};

// Async range, 3 dot
asyncrange3 = function* (start, end) {
    var j, n, ref, ref1;
    if (start === end) {
        yield start;
        return;
    }
    for (n = j = ref = start, ref1 = end; (ref <= ref1 ? j < ref1 : j > ref1); n = ref <= ref1 ? ++j : --j) {
        yield n;
    }
    return void 0;
};


// Easy async zip for only two arrays
azip2 = async function* (l, r) {
    var i, ref;
    ref = asyncrange3(0, min(l.length, r.length));
    for await (i of ref) {
        yield pack(l[i], r[i]);
    }
    return void 0;
};

// General asinc zip for several arrays, but only up to shortest array
azip = async function* (...arrgs) {
    var arg, entry, j, len1, result, wrapped;
    wrapped = [];
    for (j = 0, len1 = arrgs.length; j < len1; j++) {
        arg = arrgs[j];
        if (is_arr(arg)) {
            arg = generator(arg);
        }
        if (typeof arg === 'function') {
            arg = arg(u);
        }
        wrapped.push(arg);
    }
    entry = {
        done: false
    };
    while (!entry.done) {
        result = [];
        for await (generator of wrapped) {
            entry = (await generator.next(u));
            if (entry.done) {
                break;
            }
            result.push(entry.value);
        }
        if (entry.done) {
            break;
        }
        yield result;
    }
    return void 0;
};

// Do nothing. Just reurn self one argument
noop = function (arg) {
    return arg;
};

// Drafts
min2 = function (...args) {
    return min(...first(args));
};

// Drafts
min3 = function (...args) {
    if (!!args.length && is_arr(first(args))) {
        args = first(args);
    }
    return min(...args);
};

export {
    ONLY,
    FIRST,
    SECOND,
    ONE,
    TWO,
    LEFT,
    RIGHT,
    LAST,
    PENULTIMATE,
    NONE,
    NOENT,
    EXIT_OK,
    u,
    cl,
    arr,
    len,
    join,
    concat,
    cc,
    noop,
    swap,
    lswap,
    rswap,
    empty,
    pick,
    pack,
    pkone,
    ensure,
    times,
    all_beats_one,
    constr,
    apply_to_all,
    ato,
    alto,
    cps2,
    cps,
    prodec,
    apredec,
    aprodec,
    map,
    mapk,
    first,
    second,
    last,
    penultimate,
    pu,
    split,
    generator,
    gen,
    asyncrange3,
    azip2,
    azip,
    max,
    min,
    min2,
    min3
};
