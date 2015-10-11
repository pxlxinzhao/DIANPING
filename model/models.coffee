@DianPings = new Mongo.Collection 'dianPings'

DianPings.allow
  insert: (userId, comment) ->
    userId and comment.owner == userId
  update: (userId, comment, fields, modifier) ->
    userId and comment.owner == userId
  remove: (userId, comment) ->
    userId and comment.owner == userId
