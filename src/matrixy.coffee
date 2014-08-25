###*
 * @module matrixy
###

arrayFns = require './arrays'
{expect} = require 'chai'
{compose, createLiftFunctions} = require './functional_utils'

{liftInput, lift1, lift2, lift2Infix, liftAllOutputs} = createLiftFunctions {
  wrap: (arrays) -> createMatrix arrays
  unwrap: (matrix) -> matrix()
}

###*
 * A Matrix.
 * @typedef {function} Matrix
###

# Create a Matrix from a 2D array.
# @param arrays [Array<Array<Number>>] 2D array
# @return [Matrix]
createMatrix = (arrays) ->
  expect(arrays, 'createMatrix').to.not.be.empty
  expect(arrays[0], 'createMatrix').to.not.be.empty
  # TODO check that the size of the arrays can be a valid matrix
  wrapper = (op) ->
    op?(wrapper) or arrays

# Create an immutable Matrix from a 2D array.
# @param arrays [Array<Array<Number>>]
# @return [Matrix]
createImmutableMatrix = (arrays) ->
  wrapper = (op) ->
    op?(wrapper) or arrayFns.copy arrays

createIdentityMatrix = compose createMatrix, arrayFns.createIdentity

createBlankMatrix = compose createMatrix, arrayFns.createBlank

copy = (matrix) ->
  createMatrix arrayFns.copy matrix()

get = (row, col) ->
  (m) ->
    m()[row][col]

set = (row, col) ->
  {
    to: (value) ->
      (m) ->
        m()[row][col] = value
    plusEquals: (value) ->
      (m) ->
        m()[row][col] += value
  }

numOfRowsOf = liftInput arrayFns.getNumOfRows

numOfColsOf = liftInput arrayFns.getNumOfColumns

getDimensionsOf = liftInput arrayFns.getDimensions

sizeOf = liftInput arrayFns.getSize

isLowerTriangular = liftInput arrayFns.isLowerTriangular

isUpperTriangular = liftInput arrayFns.isUpperTriangular

innerArraysOf = liftInput (arrays) -> arrays

# @private
checkSizesMatch = (a1, a2) ->
  size1 = arrayFns.getSize a1
  size2 = arrayFns.getSize a2
  expect(size1, 'Matrix size').to.equal size2

# @private
checkCanMultiply = (a1, a2) ->
  numOfColsIn1 = arrayFns.getNumOfColumns a1
  numOfRowsIn2 = arrayFns.getNumOfRows a2
  if numOfColsIn1 isnt numOfRowsIn2
    size1 = arrayFns.getSize a1
    size2 = arrayFns.getSize a2
    throw {
      name: 'IllegalArgumentException'
      message: "Can't multiply a #{size1} matrix by a #{size2} matrix."
    }

plus = lift2Infix (a1, a2) ->
  checkSizesMatch a1, a2
  arrayFns.add a1, a2

minus = lift2Infix (a1, a2) ->
  checkSizesMatch a1, a2
  arrayFns.subtract a1, a2

times = lift2Infix (a1, a2) ->
  checkCanMultiply a1, a2
  arrayFns.multiply a1, a2

decompose = liftAllOutputs arrayFns.decompose

solve = lift2 arrayFns.solve

transpose = lift1 arrayFns.transpose

invert = lift1 arrayFns.invert

module.exports =
  createMatrix: createMatrix
  createImmutableMatrix: createImmutableMatrix
  createIdentityMatrix: createIdentityMatrix
  createBlankMatrix: createBlankMatrix
  copy: copy
  get: get
  set: set
  plus: plus
  minus: minus
  times: times
  sizeOf: sizeOf
  getDimensionsOf: getDimensionsOf
  innerArraysOf: innerArraysOf
  numOfRowsOf: numOfRowsOf
  numOfColsOf: numOfColsOf
  isLowerTriangular: isLowerTriangular
  isUpperTriangular: isUpperTriangular
  decompose: decompose
  transpose: transpose
  invert: invert
  solve: solve
