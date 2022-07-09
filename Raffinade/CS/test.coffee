
import { u, cl, prodec } from './raffinade.js'


fc = (arg) ->
    cl arg .reduce (acc, itm) -> acc * itm

prodec fc, [1, 2,], [3, 4,], [5, 6,]

# 15, 18, 20, 24, 30, 36, 40, 48
