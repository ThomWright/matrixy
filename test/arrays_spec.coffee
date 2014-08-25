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
    describe 'add', ->
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
      it 'should multiply a 3x3 by a 3x1 matrix to form a 3x1 matrix', ->
        threeByThree = [[0, 0, 1]
                        [0, 1, 0]
                        [1, 0, 0]]
        threeByOne = [[6]
                      [ - 4]
                      [27]]
        expect(multiply threeByThree, threeByOne ).to.eql [[27]
                                                           [ - 4]
                                                           [6]]

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
    it 'should throw an exception for non-square matrices', ->
      expect(-> decompose [[1, 2]] ).to.throw "LU Decomposition not implemented for non-square 2D arrays."

    describe 'Singular matrix handling', ->
      singularMatrix = [[0, 1]
                        [0, 1]]
      it 'should throw an exception for singular matrices', ->
        expect(-> decompose singularMatrix ).to.throw "Singular matrix"
      it 'should throw an exception which contains the problem matrix', ->
        try
          decompose singularMatrix
        catch error
          expect(error).to.have.ownProperty 'cause'
          expect(error.cause).to.eql singularMatrix

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

  describe 'invert()', ->
    {invert} = arrays
    it 'should invert a matrix', ->
      invertable = [[2, -1, 0]
                    [-1, 2, -1]
                    [0, -1, 2]]

      expect(invert invertable).to.almost.eql [[0.75, 0.5, 0.25]
                                               [0.5, 1, 0.5]
                                               [0.25, 0.5, 0.75]], 10