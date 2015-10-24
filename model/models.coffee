@DianPings = new Mongo.Collection 'dianPings'

DianPings.allow
  insert: (userId, comment) ->
    userId and comment.owner == userId
  update: (userId, comment, fields, modifier) ->
    userId and comment.owner == userId
  remove: (userId, comment) ->
    userId and comment.owner == userId

@Photos = new Mongo.Collection 'photos'

Photos.allow
  insert: (userId, photo) ->
    true
  update: (userId, photo, fields, modifier) ->
    true
  remove: (userId, photo) ->
    true


@Likes = new Mongo.Collection 'likes'
@Follows = new Mongo.Collection 'follows'
@Followers = new Mongo.Collection 'followers'
@Profiles = new Mongo.Collection 'profiles'
@Replies = new Mongo.Collection 'replies'
@Hates = new Mongo.Collection 'hates'