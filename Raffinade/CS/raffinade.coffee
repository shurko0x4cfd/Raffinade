
# Raffinade

# Toolkit for improve CoffeeScript postfix and prefix ability
# in order to write and read elegant code

# 2022 Alexander (Shurko) Stadnichenko
# Under BSD-2-Clause
# Unstable !


# Constants

ONLY	= 0
FIRST	= 0
SECOND	= 1
LAST	= -1
PENULTIMATE = -2
NULL	= 0
ONE		= 1
TWO		= 2
LEFT	= 0
RIGHT	= 1
u = undefined

EXIT_OK = 0


# Shortcuts

cl = console .log
arr = Array .from
is_arr = Array .isArray
len = (arr) -> arr .length
split = (sep, str) -> str .split sep
map = (f, arr) -> arr .map f
join = (s, a) -> a .join s
min = (arrg) -> Math .min ...arrg
max = (arrg) -> Math .max ...arrg
bind = (ctx, ...args, fn) -> fn .bind ctx, ...args
nbind = (...args, fn) -> fn .bind null, ...args


# Do nothing. Just returns undefined
noop = v = -> u


lswap = swap = (l, r, ...yarg) -> [r, l, ...yarg]
rswap = (...yarg, l, r) -> [...yarg, r, l]

empty = (arrg) -> not len arrg

at = (idx, arr) -> arr .at idx

### Get property ###
gp = (key, obj) -> obj[key]

### Set property ###
sp = (key, val, obj) -> obj[key] = val


# Move first argument of function to end of its arguments
export roll = (fn, ...not_callable_args, callable_arg) ->
	fn callable_arg, ...not_callable_args


# Deletion by index
indelone = (idx, arrg) ->
	if is_arr arrg
		delete arrg[idx]

	
indel = (idx, ...arrgs) ->
	arrgs .forEach indelone .bind null, idx


pack = pk = (...args) -> args


ensure = {}

ensure .array = ensure .list = (any) ->
	if is_arr any
		any
	else
		pack any


extend =  (arrg, ...entts) ->
	arrg = ensure .array arrg
	arrg .concat entts


concarr = cc =  (...arrgs) ->
	arrgs .reduce (acc, arr) -> pack ...acc, ...arr


# Just discard empty slots in JS array
refusempty = (arrg) -> arrg .filter (itm) -> itm


times = (times, opr, opd) ->
	opd = opr opd for [1..times]
	opd


# Functional-like construction
all_beats_one = constr = (val, fcs) ->
	fcs .map (fc) -> val = fc val
	val


# Functional-like apply-to-all
apply_to_all = ato = (fcs, vals) ->
	[fcs, vals] = [fcs, vals] .map ensure .array
	
	vals .map (val) ->
		fcs .forEach (fc) -> val = fc val
		val


# Alternative ato
alto = (fcs, vals) ->
	[fcs, vals] = [fcs, vals] .map ensure .array
	
	vals .map (val) ->
		fseq = [val] .concat fcs # Rewrite to fseq = cc val, fcs
		fseq .reduce (acc, fc) -> fc acc


# Functional-like composition
cps2 = (fc1, fc2) -> (any) -> fc1 fc2 any


# General functional-like composition
cps = (...fcs) -> 
	fcs = fcs .reverse u
	(any) -> alto fcs, any


# Naive Descartes production
predec = (fc, arrs, defined) ->
	if empty arrs
		fc defined

	else
		rest = arr arrs
		itentt = rest .shift u

		itentt .forEach (itentr) ->
			predec fc, rest, extend defined, itentr

prodec = (fc, ...arrs) ->
	predec fc, arrs, []


# Naive async Descartes production
# Only first argument in arrs can be an ogject-generator sience first argument
# iterated once and hence need not second using, which is impossible sience is
# not an iterator and we hence has no perfect way to recreate it
apredec = (fc, arrs, defined) ->

	if empty arrs
		yield fc defined

	else
		rest = arr arrs
		itentt = rest .shift u

		if is_arr itentt
			itentt = gen itentt

		for await itentr from itentt
			yield i for await i from apredec fc, rest, extend defined, itentr

	undefined

aprodec = (fc = noop, ...arrs) ->
	yield i for await i from apredec fc, arrs, []
	undefined


mapk = (f, ...args) -> args .map f

first = only = (arrg) -> arrg .at FIRST

second = (arrg) -> arrg .at SECOND


last = (arrg) -> arrg .at LAST
penultimate = pu = (arrg) -> arrg .at PENULTIMATE


# Wrap array to generator
generator = gen = (arr) ->
	yield i for await i from arr
	undefined


# Wrap array to destructive generator
### degenerator = deger = (arrg) ->
	cnt = len arrg

	while 0 < cnt--
		yield arrg .shift u
	undefined ###


# Async range, 3 dot
asyncrange3 = (start, end) ->
	if start == end
		yield start
		return
	yield n for n in [start...end]
	undefined


# Easy async zip for only two arrays
azip2 = (l, r) ->
	yield pack l[i], r[i] for await i from asyncrange3 0, min l .length, r .length
	undefined


# General asinc zip for several arrays, but only up to shortest array

azip = (...arrgs) ->

	generators = arrgs .map (ent) ->

		if ent .next
			return ent

		if ent[Symbol.iterator]
			return ent[Symbol.iterator] u

		return gen pack ent

	while true
		array = (gtr .next u for gtr from generators)

		if array .find (entry) -> entry .done
			return
			
		yield array .map (entry) -> entry .value
	undefined
		

# Yields natural numbers
naturange = (c = ONE) ->
	while c >= 0
		yield c++
	undefined

	
# Async Python-like enumerate ()
enumerate = (iterable, starts_with = NULL) ->
	yield i for i from azip iterable, naturange starts_with
	undefined


# Named enumerate
enamerate = (iterable, entry_name = 'val', index_name = 'idx', start_from = NULL) ->

	names = pack entry_name, index_name
	pairs = enumerate iterable, start_from

	for pair from pairs
		yield Object .fromEntries azip names, pair

	undefined


export \
	{
		ONLY,
		FIRST, SECOND,
		NULL, ONE, TWO,
		LEFT, RIGHT,
		LAST, PENULTIMATE,
		EXIT_OK,
		u,
		cl,
		arr, is_arr,
		len,
		join,
		bind, nbind,
		extend, concarr, cc,
		refusempty,
		naturange,
		enumerate, enamerate,
		noop, v,
		swap,
		lswap,
		rswap,
		empty,
		at,
		pack,
		ensure,
		times,
		all_beats_one, constr,
		apply_to_all, ato, alto,
		cps2, cps,
		prodec, apredec, aprodec,
		map,
		mapk,
		first, only,
		second,
		last,
		penultimate, pu,
		split,
		generator, gen,
		asyncrange3,
		azip2,
		azip,
		max,
		min,
		indelone, indel,
		gp, sp
	}
