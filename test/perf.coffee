###
For quick and dirty performance testing of functions.
TODO extract into own project and write some tests for this?
Is there anything else on NPM which does something similar?
###

getDiffInMillis = (startTime) ->
  [secs, nanos] = process.hrtime(startTime)
  (secs * 1e9 + nanos) / 1e6

# @param testFunction [Function]
# @param numOfIterations [Integer]
perfTest = (testFunction, numOfIterations = 1000) ->
  diffs = []

  time = process.hrtime()

  for i in [0...numOfIterations]
    startTime = process.hrtime()
    testFunction()
    diffs[i] = getDiffInMillis startTime

  total = getDiffInMillis time

  averageTime = (times) ->
    sum = times.reduce (acc, time) ->
      acc + time
    sum / times.length

  highest = (times) ->
    times.reduce (acc, time) ->
      Math.max acc, time

  lowest = (times) ->
    times.reduce (acc, time) ->
      Math.min acc, time

  # TODO std dev? median? what is actually useful?
  ave: averageTime(diffs)
  highest: highest(diffs)
  lowest: lowest(diffs)
  total: total

class NamedFunction
  # @property [String]
  name: null
  # @property [Function]
  func: null

# @param functions [Array<NamedFunction>]
# @example
#   compare([
#   {
#     name: 'current'
#     func: func1.bind(this, M)
#   }
#   {
#     name: 'contender'
#     func: func2.bind(this, N)
#   }
#   ])
compare = (functions) ->
  results = []
  for {name, func} in functions
    results.push name: name, time: perfTest func
  results

module.exports.perfTest = perfTest
module.exports.compare = compare
