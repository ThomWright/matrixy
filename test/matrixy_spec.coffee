matrixy = require '../src/matrixy'
{createMatrix} = matrixy

describe 'matrixy:', ->
  describe 'Matrix creation', ->
    describe 'createMatrix', ->
      it 'should take an array of arrays and return a Function', ->
        expect(createMatrix [[5]] ).to.be.a 'Function'

      it 'should throw an exception if the arrays are empty', ->
        expect(-> createMatrix [[]] ).to.throw /.*createMatrix.*/

      it 'should throw an exception for a single-dimension array', ->
        expect(-> createMatrix [] ).to.throw /.*createMatrix.*/

    describe 'createImmutableMatrix', ->
      {createImmutableMatrix} = matrixy
      it 'should not modify the original when the underlying array is modified', ->
        original = [[1, 2]]
        immutableMatrix = createImmutableMatrix original
        immutableMatrix()[0][0] = 23
        expect(immutableMatrix() ).to.eql original
      it 'should not let operations modify the matrix', ->
        {set} = matrixy
        original = [[1, 2]]
        immutableMatrix = createImmutableMatrix original
        immutableMatrix set(0, 0).to 23
        expect(immutableMatrix() ).to.eql original

    describe 'createIdentityMatrix', ->
      {createIdentityMatrix} = matrixy
      it 'should create an identity matrix', ->
        identity2x2 = createIdentityMatrix 2
        expect(identity2x2() ).to.eql [[1, 0]
                                       [0, 1]]

    describe 'createBlankMatrix', ->
      {createBlankMatrix} = matrixy
      it 'should create a blank matrix', ->
        blank2x2 = createBlankMatrix 2
        expect(blank2x2() ).to.eql [[0, 0]
                                       [0, 0]]

  describe 'matrix()', ->
    it 'should return the inner arrays when given no args', ->
      matrix = createMatrix [[5, 5]]
      expect(matrix() ).to.eql [[5, 5]]

  describe 'matrix(f)', ->
    it 'should call the given function with itself as a param', ->
      matrix = createMatrix [[1, 2]]
      p = null
      matrix (param) -> p = param
      expect(p ).to.eql matrix
      expect(p() ).to.eql matrix()

  describe 'copy(matrix)', ->
    {copy} = matrixy
    it 'should make a copy of a matrix', ->
      m = createMatrix [[1, 2]]
      c = copy m
      expect(c()).to.eql m()
    it 'should return a copy, not a reference', ->
      {set, get} = matrixy
      m = createMatrix [[1, 2]]
      c = copy m
      m set(0, 0).to 23
      expect(c get(0, 0)).to.eql 1

  describe 'get()', ->
    {get} = matrixy
    it 'should get the correct entry', ->
      m = createMatrix [[1, 2, 3]]
      expect(m get(0, 1) ).to.equal 2

  describe 'set', ->
    {set, get} = matrixy
    describe 'set().to()', ->
      it 'should set an entry in the matrix', ->
        m = createMatrix [[1, 2, 3]]
        m set(0, 1).to(6)
        expect(m get(0, 1) ).to.equal 6

    describe 'set().plusEquals()', ->
      it 'should be equivalent to +=', ->
        m = createMatrix [[1, 2, 3]]
        m set(0, 1).plusEquals(4)
        expect(m get(0, 1) ).to.equal 6

  describe 'Basic arithmetic:', ->
    a2x3 = createMatrix [[1, 2, 3]
                         [4, 5, 6]]
    b2x3 = createMatrix [[1, 1, 1]
                         [1, 1, 1]]
    threeByTwo = createMatrix [[1, 2]
                               [3, 4]
                               [5, 6]]

    describe 'Addition', ->
      {plus} = matrixy
      it "should throw an error if the matrices aren't the same size", ->
        expect(-> a2x3 plus threeByTwo ).to.throw /.*Matrix size.*/
      it 'should add two 2x3 matrices', ->
        result = a2x3 plus a2x3
        expect(result() ).to.eql [[2, 4, 6]
                                  [8, 10, 12]]

    describe 'Subtraction', ->
      {minus} = matrixy
      it "should throw an error if the matrices aren't the same size", ->
        expect(-> a2x3 minus threeByTwo ).to.throw /.*Matrix size.*/
      it 'should subtract two 2x3 matrices', ->
        result = a2x3 minus b2x3
        expect(result() ).to.eql [[0, 1, 2]
                                  [3, 4, 5]]
