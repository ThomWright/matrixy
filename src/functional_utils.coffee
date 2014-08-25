# @private
# Internal reference to module.exports.
t = @

# @param f [Function]
# @param g [Function]
@compose = (f, g) ->
  ->
    args = Array::slice.call arguments
    f g.apply @, args

@createLiftFunctions = ({wrap, unwrap} ) ->

  # (x -> y) -> z -> y
  liftInput: (f) ->
    (i) ->
      f unwrap i

  # (x, x -> x) -> y -> y -> y
  lift2: (f2) ->
    (i2) ->
      (i1) ->
        wrap \
          f2 unwrap(i1), unwrap(i2)
