
import { u, cl, arr, aprodec, join } from './raffinade.js'


fc = (arg) ->
    arg .reduce (acc, itm) -> acc * itm

cl '# ' + join ', ', arr aprodec fc, [1, 2,], [3, 4,], [5, 6,]

# 15, 18, 20, 24, 30, 36, 40, 48
