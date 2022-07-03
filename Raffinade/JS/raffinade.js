  // Raffinade

// Toolkit for improve CoffeeScript postfix and prefix ability
  // in order to write and read elegant code

// 2022 Alexander (Shurko) Stadnichenko
  // Under BSD-2-Clause
  // Unstable !

// Constants
var FIRST, ONE, ONLY, SECOND, arr, asyncrange3, azip, azip2, cl, first, generator, is_arr, last, len, lswap, many_to_one, map, mapk, max, min, min2, min3, only, pack, penultimate, pick, pkone, rswap, second, split, swap, times, u,
  splice = [].splice;

ONLY = 0;

FIRST = 0;

SECOND = 1;

ONE = 1;

u = void 0;

// Shortcuts
cl = console.log;

arr = Array.from;

is_arr = Array.isArray;

// Prefix part
lswap = swap = function(l, r, ...yarg) {
  return [r, l, ...yarg];
};

rswap = function(...yarg) {
  var l, r, ref;
  ref = yarg, [...yarg] = ref, [l, r] = splice.call(yarg, -2);
  return [...yarg, r, l];
};

// pick = (idx, arr) -> arr[idx]
pick = function(idx, arr) {
  return arr.at(idx);
};

pack = function(...args) {
  return args;
};

pkone = function(ent) {
  return [ent];
};

times = function(times, opr, opd) {
  var j, ref;
  for (j = 1, ref = times; (1 <= ref ? j <= ref : j >= ref); 1 <= ref ? j++ : j--) {
    opd = opr(opd);
  }
  return opd;
};

many_to_one = function(val, fcs) {
  fcs.map(function(fc) {
    return val = fc(val);
  });
  return val;
};

map = function(f, arr) {
  return arr.map(f);
};

mapk = function(f, ...args) {
  return args.map(f);
};

first = only = function(arr) {
  return arr[FIRST];
};

second = function(arr) {
  return arr[SECOND];
};

last = function(arr) {
  return arr[arr.length - 1];
};

penultimate = function(arr) {
  return arr[arr.length - 2];
};

len = function(arr) {
  return arr.length;
};

split = function(sep, str) {
  return str.split(sep);
};

min = function(one, another) {
  if (one < another) {
    return one;
  } else {
    return another;
  }
};

max = function(one, another) {
  return min(another, one);
};

// Wrap array to generator
generator = async function*(arr) {
  var i;
  for await (i of arr) {
    yield i;
  }
  return u;
};

// Async range, 3 dot
asyncrange3 = function*(start, end) {
  var j, n, ref, ref1;
  if (start === end) {
    yield start;
    return;
  }
  for (n = j = ref = start, ref1 = end; (ref <= ref1 ? j < ref1 : j > ref1); n = ref <= ref1 ? ++j : --j) {
    yield n;
  }
  return u;
};


// Easy async zip for only two arrays
azip2 = async function*(l, r) {
  var i, ref;
  ref = asyncrange3(0, min(l.length, r.length));
  for await (i of ref) {
    yield pack(l[i], r[i]);
  }
  return u;
};

// General asinc zip for several arrays, but only up to shortest array
azip = async function*(...args) {
  var arg, entry, j, len1, result, wrapped;
  wrapped = [];
  for (j = 0, len1 = args.length; j < len1; j++) {
    arg = args[j];
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
  return u;
};

// Drafts
min2 = function(...args) {
  return min(...first(args));
};

// Drafts
min3 = function(...args) {
  if (!!args.length && is_arr(first(args))) {
    args = first(args);
  }
  return min(...args);
};

export {
  ONLY,
  FIRST,
  SECOND,
  u,
  cl,
  arr,
  swap,
  lswap,
  rswap,
  pick,
  pack,
  pkone,
  times,
  many_to_one,
  map,
  mapk,
  first,
  second,
  last,
  penultimate,
  split,
  generator,
  asyncrange3,
  azip2,
  azip,
  max,
  min,
  min2,
  min3
};
