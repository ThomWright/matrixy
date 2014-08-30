###*
 * API for dealing with matrices as wrapped functions.
 * @module matrixy
###

arrayFns = require './arrays'
{expect} = require 'chai'
{compose, createLiftFunctions} = require './functional_utils'

###
 * Internal reference to module.exports.
 * @private
###
t = @

{liftInput, lift1, lift2, lift2Infix, liftAllOutputs} = createLiftFunctions {
  wrap: (arrays) -> t.createMatrix arrays
  unwrap: (matrix) -> matrix()
}

###*
 * A Matrix. Can be given a {@link module:matrixy.MatrixOperation}.
 * @callback module:matrixy.Matrix
 * @param {module:matrixy.MatrixOperation} [op]
 * @return {Array.<Array.<Number>>|*} Internal 2D array if no params given, else result of op.
###

###*
 * Operation on a {@link module:matrixy.Matrix}.
 * @callback module:matrixy.MatrixOperation
 * @param {module:matrixy.Matrix} matrix
 * @return {*}
###

###*
 * Create a {@link module:matrixy.Matrix} from a 2D array.
 * @param {!Array.<Array.<Number>>} arrays - 2D array
 * @return {module:matrixy.Matrix}
###
@createMatrix = (arrays) ->
  expect(arrays, 'createMatrix').to.not.be.empty
  expect(arrays[0], 'createMatrix').to.not.be.empty
  # TODO check that the size of the arrays can be a valid matrix
  ###*
   * @param {module:matrixy.MatrixOperation} [op]
   * @return {Array.<Array.<Number>>|*} Internal 2D array if no params given, else result of op.
  ###
  wrapper = (op) ->
    op?(wrapper) or arrays

###*
 * Create an immutable {@link module:matrixy.Matrix} from a 2D array.
 * All {@link module:matrixy.MatrixOperation}s will be performed on a copy of the 2D array.
 * @param {!Array.<Array.<Number>>} arrays
 * @return {module:matrixy.Matrix}
###
@createImmutableMatrix = (arrays) ->
  wrapper = (op) ->
    op?(wrapper) or arrayFns.copy arrays

###*
 * Create an identity {@link module:matrixy.Matrix} of the given size.
 * @function
 * @param {!Integer} size
 * @return {module:matrixy.Matrix}
###
@createIdentityMatrix = compose t.createMatrix, arrayFns.createIdentity

###*
 * Create a blank {@link module:matrixy.Matrix} of the given size.
 * @function
 * @param {!Integer} size
 * @return {module:matrixy.Matrix}
###
@createBlankMatrix = compose t.createMatrix, arrayFns.createBlank

###*
 * Return a copy of the given Matrix.
 * @param  {module:matrixy.Matrix} matrix
 * @return {module:matrixy.Matrix}
###
@copy = (matrix) ->
  t.createMatrix arrayFns.copy matrix()

###*
 * Get an entry in the matrix at position (row, col).
 * @param  {Integer} row
 * @param  {Integer} col
 * @return {Number}
###
@get = (row, col) ->
  (m) ->
    m()[row][col]

###*
 * Set an entry in the matrix to a given value.
 * @param {Integer} row
 * @param {Integer} col
 * @return {module:matrixy~setter}
###
@set = (row, col) ->
  {
    ###*
     * Set to the given value.
     * @memberOf module:matrixy~setter
     * @param  {Number} value
     * @return {module:matrixy.MatrixOperation}
    ###
    to: (value) ->
      (m) ->
        m()[row][col] = value

    ###*
     * Equivalent to the += operator.
     * @memberOf module:matrixy~setter
     * @param  {Number} value
     * @return {module:matrixy.MatrixOperation}
    ###
    plusEquals: (value) ->
      (m) ->
        m()[row][col] += value
  }

###*
 * Get the number of rows in the given matrix.
 * @function
 * @param {module:matrixy.Matrix} matrix
 * @return {Number}
###
@numOfRowsOf = liftInput arrayFns.getNumOfRows

###*
 * Get the number of columns in the given matrix.
 * @function
 * @param {module:matrixy.Matrix} matrix
 * @return {Number}
###
@numOfColsOf = liftInput arrayFns.getNumOfColumns

###*
 * @see {@link module:arrays.getDimensions}
 * @function
 * @param {module:matrixy.Matrix} matrix
 * @return {Array.<Integer>} e.g. [2, 3] for a 2x3 matrix
###
@getDimensionsOf = liftInput arrayFns.getDimensions

###*
 * @see {@link module:arrays.getSize}
 * @function
 * @param {module:matrixy.Matrix} matrix
 * @return {String}
###
@sizeOf = liftInput arrayFns.getSize

###*
 * @see {@link module:arrays.isLowerTriangular}
 * @function
 * @param {module:matrixy.Matrix} matrix
 * @return {Boolean}
###
@isLowerTriangular = liftInput arrayFns.isLowerTriangular

###*
 * @see {@link module:arrays.isUpperTriangular}
 * @function
 * @param {module:matrixy.Matrix} matrix
 * @return {Boolean}
###
@isUpperTriangular = liftInput arrayFns.isUpperTriangular

###*
 * Get the wrapped 2D arrays of a {@link module:matrixy.Matrix}
 * @function
 * @param {module:matrixy.Matrix} matrix
 * @return {Array.<Array.<Number>>}
###
@innerArraysOf = liftInput (arrays) -> arrays

###
 * @private
 * @param  {Array.<Array.<Number>>} a1
 * @param  {Array.<Array.<Number>>} a2
###
checkSizesMatch = (a1, a2) ->
  size1 = arrayFns.getSize a1
  size2 = arrayFns.getSize a2
  expect(size1, 'Matrix size').to.equal size2

###
 * @private
 * @param  {Array.<Array.<Number>>} a1
 * @param  {Array.<Array.<Number>>} a2
###
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

###*
 * Infix function to add two Matrices.
 * @example
 * c = a(plus(b)); // JavaScript
 * c = a plus b # CoffeeScript
 * @function
 * @param  {module:matrixy.Matrix} matrix
 * @return {module:matrixy.MatrixOperation}
###
@plus = lift2Infix (a1, a2) ->
  checkSizesMatch a1, a2
  arrayFns.add a1, a2

###*
 * Infix function to subtract a Matrix from another
 * @example
 * c = a(minus(b)); // JavaScript
 * c = a minus b # CoffeeScript
 * @function
 * @param  {module:matrixy.Matrix} matrix
 * @return {module:matrixy.MatrixOperation}
###
@minus = lift2Infix (a1, a2) ->
  checkSizesMatch a1, a2
  arrayFns.subtract a1, a2

###*
 * Infix function to multiply two Matrices.
 * @example
 * c = a(times(b)); // JavaScript
 * c = a times b # CoffeeScript
 * @function
 * @param  {module:matrixy.Matrix} matrix
 * @return {module:matrixy.MatrixOperation}
###
@times = lift2Infix (a1, a2) ->
  checkCanMultiply a1, a2
  arrayFns.multiply a1, a2

###*
 * @typedef module:matrixy.LUP
 * @type {object}
 * @property {module:matrixy.Matrix} l - Lower triangular matrix.
 * @property {module:matrixy.Matrix} u - Upper triangular matrix.
 * @property {module:matrixy.Matrix} p - Permutation matrix.
###

###*
 * Decompose this matrix into an LU pair.
 * @see {@link module:arrays.decompose}
 * @function
 * @param {module:matrixy.Matrix} matrix
 * @return {LUP}
###
@decompose = liftAllOutputs arrayFns.decompose

###*
 * Solve the matrix equation Ax = b for x with matrix size N.
 * @see {@link module:arrays.solve}
 * @function
 * @param {module:matrixy.Matrix} A - NxN
 * @param {module:matrixy.Matrix} b - Nx1
 * @return {module:matrixy.Matrix} Nx1
###
@solve = lift2 arrayFns.solve

###*
 * Return a transposed version of the given {@link module:matrixy.Matrix}.
 * @function
 * @param {module:matrixy.Matrix} matrix
 * @return {module:matrixy.Matrix} Transposed matrix.
###
@transpose = lift1 arrayFns.transpose

###*
 * Return an inverted version of the given {@link module:matrixy.Matrix}.
 * @function
 * @param {module:matrixy.Matrix} matrix
 * @return {module:matrixy.Matrix} Inverted matrix.
###
@invert = lift1 arrayFns.invert
