
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
u = undefined


# Shortcuts

cl = console .log
arr = Array .from
is_arr = Array .isArray


# Prefix part

lswap = swap = (l, r, ...yarg) -> [r, l, ...yarg]
rswap = (...yarg, l, r) -> [...yarg, r, l]

# pick = (idx, arr) -> arr[idx]
pick = (idx, arr) -> arr .at idx

pack = (...args) -> args
pkone = (ent) -> [ent]


times = (times, opr, opd) ->
	opd = opr opd for [1..times]
	opd


many_to_one = (val, fcs) ->
	fcs .map (fc) -> val = fc val
	val


map = (f, arr) -> arr .map f
mapk = (f, ...args) -> args .map f


first = only = (arr) -> arr[FIRST]

second = (arr) -> arr[SECOND]

last = (arr) -> arr[arr .length - 1]
penultimate = (arr) -> arr[arr .length - 2]

len = (arr) -> arr .length
split = (sep, str) -> str .split sep

min = (one, another) -> if one < another then one else another
max = (one, another) -> min another, one


# Wrap array to generator
generator = (arr) ->
	yield i for await i from arr
	u


# Async range, 3 dot
asyncrange3 = (start, end) ->
	if start == end
		yield start
		return
	yield n for n in [start...end]
	u
 

# Easy async zip for only two arrays
azip2 = (l, r) ->
	yield pack l[i], r[i] for await i from asyncrange3 0, min l .length, r .length
	u


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
	u




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
	}
