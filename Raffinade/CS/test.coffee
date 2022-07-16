
import { u, cl, arr, aprodec, join, gen } from './raffinade.js'


arr0 = () ->
    yield from [1, 2]

arr0 = arr0 u


fc = (arg) ->
    arg .reduce (acc, itm) -> acc * itm

cl '# ' + join ', ', i for await i from aprodec fc, arr0, [3, 4], [5, 6,]

# 15, 18, 20, 24, 30, 36, 40, 48
