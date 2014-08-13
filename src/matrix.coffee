if typeof define isnt 'function'
  define = (require('amdefine') ) (module)

define ['./utils', 'chai'], (utils, {expect} ) =>

  # @param m [Array<Array<Number>>] Matrix to copy.
  # @return [Array<Array<Number>>]
  copy = (m) ->
    newMatrix = []
    for row, rowIndex in m
      newMatrix.push([])
      for c in row
        newMatrix[rowIndex].push(c)
    return newMatrix

  class LUP
    # @property [Matrix] Lower triangular matrix
    l: null
    # @property [Matrix] Upper triangular matrix
    u: null
    # @property [Matrix] Permutation matrix
    p: null

  # Represents a Matrix
  class Matrix

    # Solve the matrix equation Ax = b for x.
    # @param A [Matrix] NxN
    # @param b [Matrix] Nx1
    # @return [Matrix] Nx1
    @solve = (A, b) ->
      # TODO assert sizes are correct
      size = A.getNumOfRows()

      {l, u, p} = A.decompose()
      pb = p.times(b)
      y = Matrix.createBlankMatrix(size, 1)

      # Use inner arrays for clarity
      Am = A._m
      pbm = pb._m
      Lm = l._m
      Um = u._m
      ym = y._m

      # Solve Ly = Pb where y = Ux using forward substitution
      for rowIndex in [0...size]
        ym[rowIndex][0] = pbm[rowIndex][0]
        for colIndex in [0...rowIndex]
          ym[rowIndex][0] -= Lm[rowIndex][colIndex] * ym[colIndex][0]
        ym[rowIndex][0] /= Lm[rowIndex][rowIndex]

      x = Matrix.createBlankMatrix(size, 1)
      xm = x._m

      # Solve Ux = y using backward substitution
      for rowIndex in [size - 1..0]
        xm[rowIndex][0] = ym[rowIndex][0]
        for colIndex in [rowIndex + 1...size]
          xm[rowIndex][0] -= Um[rowIndex][colIndex] * xm[colIndex][0]
        xm[rowIndex][0] /= Um[rowIndex][rowIndex]

      x

    # @param size [Integer]
    # @return [Matrix] The identity matrix of given size.
    @createIdentityMatrix = (size) ->
      expect(size, 'Matrix size').to.be.at.least 0
      if size is 0
        return new Matrix()
      m = new Array(size)
      for i in [0...size]
        m[i] = new Array(size)
        for j in [0...size]
          m[i][j] = if i is j then 1 else 0
      return new Matrix(m)

    # @param numOfRows [Integer]
    # @param numOfCols [Integer] Defaults to numOfRows.
    # @return [Matrix] The identity matrix of given size.
    @createBlankMatrix = (numOfRows, numOfCols = numOfRows) ->
      expect(numOfRows, 'Number of rows').to.be.at.least 0
      expect(numOfCols, 'Number of columns').to.be.at.least 0
      if numOfRows is 0 or numOfCols is 0
        return new Matrix()
      b = new Array(numOfRows)
      for i in [0...numOfRows]
        b[i] = new Array(numOfCols)
        for j in [0...numOfCols]
          b[i][j] = 0
      return new Matrix(b)

    # @private
    # @property [Array<Array<Number>>]
    #   [rows][columns]
    # @example A 3x3 matrix
    #   [[ 2, 3, 2]
    #   [ 2, 1, 0.5]
    #   [ 4, 4, -1]]
    _m: [[]]

    # @param array [Array<Array<Number>>]
    constructor: (array) ->
      # TODO assert that all rows are arrays of equal length
      if array?
        expect(array, 'Matrix constructor array').to.be.an.instanceof Array
        expect(array[0], 'Matrix constructor array').to.be.an.instanceof Array
        @_m = array

    # Add this matrix to another matrix.
    # @param m2 [Matrix]
    # @throw [IllegalArgumentException] If the matrix size is incorrect.
    # @return [Matrix]
    plus: (m2) ->
      if @getSize() isnt m2.getSize()
        throw {
          name: 'IllegalArgumentException'
          message: "Can't add a #{@getSize()} matrix to a #{m2.getSize()} matrix."
        }

      n = m2._m

      r = new Array(@getNumOfRows())

      for i in [0...@getNumOfRows() ]
        r[i] = new Array(@getNumOfColumns())
        for j in [0...@getNumOfColumns()]
          r[i][j] = @_m[i][j] + n[i][j]
      return new Matrix(r)

    # Multiply this matrix by another matrix.
    # @param m2 [Matrix] Another matrix, with a number of rows equal to the number of columns in this matrix.
    # @throw [IllegalArgumentException] If the matrix size is incorrect.
    # @return [Matrix]
    times: (m2) ->
      if @getNumOfColumns() isnt m2.getNumOfRows()
        throw {
          name: 'IllegalArgumentException'
          message: "Can't multiply a #{@getSize()} matrix by a #{m2.getSize()} matrix."
        }

      # work with the inner array
      n = m2._m

      # initialise result
      r = new Array(@getNumOfRows())

      for i in [0...@getNumOfRows() ]
        r[i] = new Array(m2.getNumOfColumns())
        for j in [0...m2.getNumOfColumns() ]
          r[i][j] = 0
          for k in [0...@getNumOfColumns() ]
            r[i][j] += @_m[i][k] * n[k][j]
      return new Matrix(r)

    # @return [Integer]
    getNumOfColumns: ->
      @_m[0].length

    # @return [Integer]
    getNumOfRows: ->
      if @_m[0].length > 0
        @_m.length
      else # special case for empty matrix
        0

    # @return [Integer]
    getDimensions: ->
      [@getNumOfRows(), @getNumOfColumns() ]

    # Get a string representation of the matrix size.
    # @return [String]
    getSize: ->
      [numOfRows, numOfCols] = @getDimensions()
      "#{numOfRows}x#{numOfCols}"

    # @return [Boolean]
    isSquare: ->
      @getNumOfRows() is @getNumOfColumns()

    # @return [Boolean]
    isLowerTriangular: ->
      [numOfRows, numOfColumns] = @getDimensions()
      return no if numOfRows is 0 or numOfColumns is 0
      return yes if numOfColumns is 1

      for i in [0...numOfRows]
        for j in [(i + 1)...numOfColumns]
          return no if @_m[i][j] isnt 0
      return yes

    # @return [Boolean]
    isUpperTriangular: ->
      [numOfRows, numOfColumns] = @getDimensions()
      return no if numOfRows is 0 or numOfColumns is 0
      return yes if numOfRows is 1

      for i in [1...numOfRows]
        rowToCountTo = Math.min(i - 1, numOfColumns - 1)
        for j in [0..rowToCountTo]
          return no if @_m[i][j] isnt 0
      return yes

    # Decompose this matrix into lower and upper triangular matrices.
    # @throw [SingularMatrixException]
    # @return [LUP] Lower and upper triangular matrices, and a permutation matrix.
    decompose: ->
      if not @isSquare()
        throw {
          name: 'NotImplementedException',
          message: 'LU Decomposition not implemented for non-square matrices.'
        }

      size = @getNumOfRows()
      if(size is 0)
        return {l: new Matrix(), u: new Matrix(), p: new Matrix() }

      # initialise l and u
      l = Matrix.createIdentityMatrix(size)._m
      u = @copy()._m
      p = Matrix.createIdentityMatrix(size)._m

      ###
      Gaussian elimination w / partial pivoting
      ###
      for i in [0...size - 1] # reduce size of square subset each iteration
        # choose pivot
        pivotRowIndex = i
        maxFirstElement = u[i][i]
        for r in [i...size] # for rows in sub-square
          if u[r][i] > maxFirstElement
            maxFirstElement = u[r][i]
            pivotRowIndex = r
        if maxFirstElement is 0
          throw {
            name: 'SingularMatrixException',
            message: 'Singular matrix'
            cause: @
          }

        # row swap
        if pivotRowIndex isnt i
          for e in [i...size] # swap rows in u
            [u[i][e], u[pivotRowIndex][e]] = [u[pivotRowIndex][e], u[i][e]]
          for e in [0...i] # swap rows in l
            [l[i][e], l[pivotRowIndex][e]] = [l[pivotRowIndex][e], l[i][e]]
          [p[i], p[pivotRowIndex]] = [p[pivotRowIndex], p[i]]

        # Gaussian Elimination
        for j in [i + 1...size] # for every row in this sub-square
          l[j][i] = u[j][i] / u[i][i] # work out the factor to make first element zero
          for k in [i...size] # for each element in row in sub-square
            u[j][k] -= l[j][i] * u[i][k] # row = row - factor*topRowInSubset

      return {l: new Matrix(l), u: new Matrix(u), p: new Matrix(p) }

    # @param row [Integer]
    # @param col [Integer]
    # @example Set row 0 column 1 to a given number.
    #   set(0, 1).to 5
    # @example Increment row 0 column 1 by a given 5.
    #   set(0, 1).plusEquals 5
    set: (row, col) ->
      m = @_m
      {
        to: (value) ->
          m[row][col] = value
        plusEquals: (value) ->
          m[row][col] += value
      }

    # @param row [Integer]
    # @param col [Integer]
    increment: (row, col) ->
      @_m[row][col]++

    # @param row [Integer]
    # @param col [Integer]
    get: (row, col) ->
      @_m[row][col]

    # Make a copy of this matrix.
    # @return [Matrix]
    copy: ->
      return new Matrix(copy(@_m) )

    # @param otherMatrix [Matrix]
    # @return [Boolean]
    equals: (otherMatrix) ->
      utils.deepEquals(@_m, otherMatrix._m)

    # @return [String]
    toString: ->
      @_m.toString()

    # @return [?]
    valueOf: ->
      @_m.valueOf()
