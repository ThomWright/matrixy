arrays = require '../src/arrays'

describe 'Array Functions:', ->
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