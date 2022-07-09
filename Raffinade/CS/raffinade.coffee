
# Raffinade

# Toolkit for improve CoffeeScript postfix and prefix ability
# in order to write and read elegant code

# 2022 Alexander (Shurko) Stadnichenko
# Under BSD-2-Clause
# Unstable !




# Constants

ONLY = 0
FIRST = 0
SECOND = 1
ONE = 1
TWO = 2
LEFT = 0
RIGHT = 1
u = undefined

EXIT_OK = 0


# Shortcuts

cl = console .log
arr = Array .from
is_arr = Array .isArray
len = (arr) -> arr .length
split = (sep, str) -> str .split sep
map = (f, arr) -> arr .map f


# Prefix part

lswap = swap = (l, r, ...yarg) -> [r, l, ...yarg]
rswap = (...yarg, l, r) -> [...yarg, r, l]

empty = (arrg) -> not len arrg

# pick = (idx, arr) -> arr[idx]
pick = (idx, arr) -> arr .at idx

pack = pk = (...args) -> args
pkone = (entt) -> pack entt


ensure = {}

ensure .array = ensure .list = (any) ->
	if is_arr any
		any
	else
		pack any


concat = cc =  (arrg, ...entts) ->
	arrg = ensure .array arrg
	arrg .concat entts


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
			predec fc, rest, cc defined, itentr

prodec = (fc, ...arrs) ->
	predec fc, arrs, []



mapk = (f, ...args) -> args .map f


first = only = (arrg) -> arrg[FIRST] # Rewrite to arrg .at FIRST

second = (arr) -> arr[SECOND]

last = (arr) -> arr[arr .length - 1]
penultimate = pu = (arr) -> arr[arr .length - 2]

min = (one, another) -> if one < another then one else another
max = (one, another) -> min another, one


# Wrap array to generator
generator = gen = (arr) ->
	yield i for await i from arr
	undefined


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
azip = (...args) ->
	wrapped = []

	for arg in args
		if is_arr arg
			arg = generator arg

		if typeof arg  == 'function'
			arg = arg u

		wrapped .push arg

	entry = done: false

	while not entry .done
		result = []

		for await generator from wrapped
			entry  = await generator .next u

			if entry .done
				break

			result .push entry .value

		if entry .done
			break

		yield result
	undefined




# Drafts
min2 = (...args) ->
	min ...first args
# Drafts
min3 = (...args) ->
	args = first args if !! args .length and is_arr first args
	min ...args


export \
	{
		ONLY,
		FIRST, SECOND,
		ONE, TWO,
		LEFT, RIGHT,
		EXIT_OK,
		u,
		cl,
		arr,
		len,
		concat, cc,
		swap,
		lswap,
		rswap,
		empty,
		pick,
		pack,
		pkone,
		ensure,
		times,
		all_beats_one, constr,
		apply_to_all, ato, alto,
		cps2, cps,
		prodec,
		map,
		mapk,
		first,
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
		min2,
		min3
	}
