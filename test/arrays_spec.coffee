arrays = require '../src/arrays'

empty = [[]]

describe 'Array Functions:', ->
  describe 'Creating 2D arrays:', ->
    describe 'createIdentity', ->
      {createIdentity} = arrays
      it 'should create an empty matrix when size is 0', ->
        empty = createIdentity 0
        expect(empty).to.eql [[]]
      it 'should create a 1x1 identity matrix', ->
        identity1x1 = createIdentity 1
        expect(identity1x1).to.eql [[1]]
      it 'should create a 2x2 identity matrix', ->
        identity2x2 = createIdentity 2
        expect(identity2x2).to.eql [[1, 0]
                                    [0, 1]]
      it 'should throw an exception when size is <0', ->
        expect(-> createIdentity -1).to.throw()

    describe 'createBlank', ->
      {createBlank} = arrays
      it 'should create an empty matrix when given zero size', ->
        expect(createBlank(0) ).to.eql [[]]

      it 'should create a 2x2 matrix of all zeros', ->
        expect(createBlank(2, 3)).to.eql [[0, 0, 0]
                                          [0, 0, 0]]
      it 'should create a square matrix when given one parameter', ->
        expect(createBlank(2)).to.eql [[0, 0]
                                       [0, 0]]

  describe 'Dimensions:', ->
    describe 'isEmpty', ->
      {isEmpty} = arrays
      it 'should return true for an empty array', ->
        expect(isEmpty []).to.be.true
      it 'should return true for an empty 2D array', ->
        expect(isEmpty [[]]).to.be.true
      it 'should return false for a non-empty matrix', ->
        expect(isEmpty [[0]]).to.be.false
      # TODO what about [5]?

    describe 'getSize', ->
      {getSize} = arrays
      it 'should return a string of the size', ->
        expect(getSize [[1, 2, 3]]).to.eql '1x3'
      it 'should cope with an empty 2D array', ->
        expect(getSize [[]]).to.eql '0x0'
      it 'should cope with an empty array', ->
        expect(getSize []).to.eql '0x0'

    describe 'getDimensions', ->
      {getDimensions} = arrays
      it 'should return correct dimensions', ->
        expect(getDimensions [[3, 2]] ).to.eql [1, 2]
      it 'should return 0 for an empty 2D array', ->
        expect(getDimensions [[]] ).to.eql [0, 0]
      it 'should return 0 for an empty array', ->
        expect(getDimensions [] ).to.eql [0, 0]

    describe 'getNumOfColumns', ->
      {getNumOfColumns} = arrays
      it 'should return the correct number of columns', ->
        expect(getNumOfColumns [[1, 2, 3]] ).to.equal 3
      it 'should return 0 for an empty 2D array', ->
        expect(getNumOfColumns [[]]).to.equal 0
      it 'should return 0 for an empty array', ->
        expect(getNumOfColumns []).to.equal 0

    describe 'getNumOfRows', ->
      {getNumOfRows} = arrays
      it 'should return the correct number of rows', ->
        expect(getNumOfRows [[1], [2], [3]] ).to.equal 3
      it 'should return 0 for an empty 2D array', ->
        expect(getNumOfRows [[]]).to.equal 0
      it 'should return 0 for an empty array', ->
        expect(getNumOfRows []).to.equal 0

    describe 'isSquare', ->
      {isSquare} = arrays
      it 'should return true for a 2x2 matrix', ->
        expect(isSquare [[1, 2], [1, 2]] ).to.be.true
      it 'should return true for a 1x1', ->
        expect(isSquare [[1]] ).to.be.true
      it 'should return false for a 0x0', ->
        expect(isSquare [[]] ).to.be.false
      it 'should return false for an empty array', ->
        expect(isSquare [] ).to.be.false
      it "should return false if the matrix isn't square", ->
        expect(isSquare [[1, 2]] ).to.be.false

  describe 'Detecting triangular matrices', ->
    describe 'isLowerTriangular', ->
      {isLowerTriangular} = arrays
      it 'should return no for empty matrix', ->
        expect(isLowerTriangular empty ).to.equal no
      it 'should return yes for one by one matrix', ->
        expect(isLowerTriangular [[5]] ).to.equal yes
      it 'should return yes for a three by three L matrix', ->
        threeLowerTriangularMatrix = [[1, 0, 0]
                                      [1, 3, 0]
                                      [7, 5, 9]]
        expect(isLowerTriangular threeLowerTriangularMatrix).to.equal yes
      it 'should return no for an almost three by three L matrix', ->
        threeAlmostLowerTriangularMatrix = [[1, 0, 1]
                                            [1, 3, 0]
                                            [7, 5, 9]]
        expect(isLowerTriangular threeAlmostLowerTriangularMatrix).to.equal no
      it 'should return yes for rectangular lower triangular matrix', ->
        rectangularLowerTriangularMatrix = [[1, 0, 0, 0]
                                            [5, 8, 0, 0]]
        expect(isLowerTriangular rectangularLowerTriangularMatrix ).to.equal yes
      it 'should return yes for single column matrix', ->
        expect(isLowerTriangular [[1]
                                  [2]] ).to.equal yes
      it 'should return no for single row matrix of all non-zero values', ->
        expect(isLowerTriangular [[1, 2]] ).to.equal no

    describe 'isUpperTriangular', ->
      {isUpperTriangular} = arrays
      it 'should return no for empty matrix', ->
        expect(isUpperTriangular empty ).to.equal no
      it 'should return yes for one by one matrix', ->
        expect(isUpperTriangular [[5]] ).to.equal yes
      it 'should return yes for a three by three U matrix', ->
        threeUpperTriangularMatrix = [[1, 1, 7]
                                      [0, 3, 5]
                                      [0, 0, 9]]
        expect(isUpperTriangular threeUpperTriangularMatrix ).to.equal yes
      it 'should return no for an almost three by three U matrix', ->
        threeAlmostUpperTriangularMatrix = [[1, 1, 7]
                                            [0, 3, 5]
                                            [1, 0, 9]]
        expect(isUpperTriangular threeAlmostUpperTriangularMatrix ).to.equal no
      it 'should return yes for single row matrix', ->
        expect(isUpperTriangular [[1,2]] ).to.equal yes
      it 'should return no for single column matrix of all non-zero values', ->
        expect(isUpperTriangular [[1]
                                  [2]] ).to.equal no
      it 'should return yes for rectangular upper triangular matrix', ->
        rectangularUpperTriangularMatrix = [[1, 5]
                                            [0, 8]
                                            [0, 0]]
        expect(isUpperTriangular rectangularUpperTriangularMatrix ).to.equal yes

  describe 'copy', ->
    {copy} = arrays
    it 'should copy itself', ->
      a = [[2, 3], [3, 2]]
      expect(copy a).to.eql(a)
    it 'should create a copy rather than a reference', ->
      a = [[2, 3], [3, 2]]
      b = copy a
      a[0][0] = 5
      expect(b[0][0]).to.eql(2)

  describe 'Basic arithmetic', ->
    a2x3 = [[1, 2, 3]
            [4, 5, 6]]
    b2x3 = [[1, 1, 1]
            [1, 1, 1]]
    threeByTwo = [[1, 2]
                  [3, 4]
                  [5, 6]]
    describe 'Addition', ->
      {add} = arrays
      it 'should add two 2x3 matrices', ->
        expect(add a2x3, a2x3 ).to.eql [[2, 4, 6]
                                        [8, 10, 12]]

    describe 'Subtraction', ->
      {subtract} = arrays
      it 'should subtract two 2x3 matrices', ->
        expect(subtract a2x3, b2x3 ).to.eql [[0, 1, 2]
                                             [3, 4, 5]]

    describe 'Multiplication', ->
      {multiply} = arrays
      threeByThree = [[0, 0, 1]
                      [0, 1, 0]
                      [1, 0, 0]]
      it 'should multiply a 3x3 by a 3x1 matrix to form a 3x1 matrix', ->
        threeByOne = [[6]
                      [ - 4]
                      [27]]
        expect(multiply threeByThree, threeByOne ).to.eql [[27]
                                                           [ - 4]
                                                           [6]]

      it 'should multiply a matrix by a constant', ->
        expect(multiply threeByThree, 3).to.eql [[0, 0, 3]
                                                 [0, 3, 0]
                                                 [3, 0, 0]]

      it 'should multiply a constant by a matrix', ->
        expect(multiply 3, threeByThree).to.eql [[0, 0, 3]
                                                 [0, 3, 0]
                                                 [3, 0, 0]]

      it 'should multiply a constant by a constant', ->
        expect(multiply 3, 3).to.eql [[9]]

    describe 'Division:', ->
      {divide} = arrays
      invertible = [[4, 3]
                    [3, 2]]

      describe 'dividing a matrix by itself', ->
        it 'should return the identiy matrix', ->
          expect(divide invertible, invertible).to.eql [[1, 0]
                                                        [0, 1]]

  describe 'LU Decomposition', ->
    {decompose, multiply} = arrays
    squareMatrix = [[1, 2]
                    [3, 4]]
    fiveMatrix = [[4, 7, 7, 2, 0]
                  [3, 4, 8, 8, 0]
                  [1, 5, 2, 9, 6]
                  [6, 1, 2, 2, 1]
                  [6, 4, 8, 2, 8]]
    it 'should decompose an empty matrix into empty {l,u,p}', ->
      {l, u, p} = decompose [[]]
      expect(l).to.eql [[]]
      expect(u).to.eql [[]]
      expect(p).to.eql [[]]
    it 'should return {l,u,p} where LU == PA for integer solutions', ->
      {l, u, p} = decompose squareMatrix
      expect(multiply l, u ).to.eql(multiply p, squareMatrix )
    it 'should return {l,u,p} where LU ~= PA for floating point solutions', ->
      {l, u, p} = decompose fiveMatrix
      expect(multiply l, u ).to.almost.eql(multiply p, fiveMatrix, 14)
    it 'should return a lower triangular matrix', ->
      {isLowerTriangular} = arrays
      {l} = decompose fiveMatrix
      expect(isLowerTriangular l).to.be.true
    it 'should return an upper triangular matrix', ->
      {isUpperTriangular} = arrays
      {u} = decompose fiveMatrix
      expect(isUpperTriangular u).to.be.true

    describe 'Singular matrix handling', ->
      singularMatrix = [[0, 1]
                        [0, 1]]
      it 'should throw an exception for singular matrices', ->
        expect(-> decompose singularMatrix ).to.throw {
                                                        name: 'SingularMatrixException',
                                                        message: 'Singular matrix'
                                                        cause: singularMatrix
                                                      }
      it 'should throw an exception which contains the problem matrix', ->
        try
          decompose singularMatrix
        catch error
          expect(error).to.have.ownProperty 'cause'
          expect(error.cause).to.eql singularMatrix

    it 'should handle negative numbers', ->
      m = [[0, -1]
           [-1, 1]]
      {l, u, p} = decompose m
      expect(multiply l, u ).to.almost.eql(multiply p, m, 14)

  describe 'Equation solver', ->
    {solve} = arrays
    it 'should solve a matrix equation of the form Ax=b for x', ->
      A = [[1, 1, 1]
           [0, 2, 5]
           [2, 5, - 1]]
      b = [[6]
           [ - 4]
           [27]]
      expect(solve A, b ).to.eql [[5]
                                  [3]
                                  [ - 2]]

  describe 'transpose()', ->
    {transpose} = arrays
    it 'should transpose a matrix', ->
      m = [[1, 2, 3]
           [4, 5, 6]]
      expect(transpose m ).to.eql [[1, 4]
                                   [2, 5]
                                   [3, 6]]

  describe 'Inversion', ->
    invertible = [[4, 3]
                   [3, 2]]

    describe 'invert()', ->
      {invert} = arrays
      it 'should invert a matrix', ->
        expect(invert invertible).to.eql [[-2, 3]
                                          [3, -4]]

    describe 'isInvertible()', ->
      {isInvertible} = arrays
      it 'should return false for a non-square matrix', ->
        expect(isInvertible [[1, 2]]).to.be.false

      it 'should return false for a matrix whose determinant is zero', ->
        expect(isInvertible [[0]]).to.be.false

      it 'should return true for an invertible matrix', ->
        expect(isInvertible invertible).to.be.true

  describe 'determinant', ->
    {determinant} = arrays
    it 'should find the determinant of a matrix', ->
      m = [[1, 0, 2, -1]
           [3, 0, 0, 5]
           [2, 1, 4, -3]
           [1, 0, 5, 0]]
      expect(determinant m ).to.equal 30
