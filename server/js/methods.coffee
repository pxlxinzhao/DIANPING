Meteor.methods
  'updateCurrentUserPosition': (position) ->
    if position
      Meteor.users.update { _id: Meteor.userId() }, { $set: position: position}
  'updateCurrentUserAddress': (address) ->
    if address
      Meteor.users.update { _id: Meteor.userId() }, { $set: address: address}
  'createLike': ->
    count = Likes.find({_id: Meteor.userId()}).count()
    if count == 0
      Likes.insert({userId: Meteor.userId(), likes: []})
  'countPhotos': ->
    count = Photos.find().count()
    console.log 'count:', count
    count
  'updatePhotoId': (photo)->
    Meteor.users.upsert {_id: Meteor.userId()}, {$set: photoId: photo._id}
  'deletePhoto': (photo) ->
    Photos.remove _id: photo._id