Meteor.methods
  'updateCurrentUserPosition': (position) ->
    if position
      Meteor.users.update { _id: Meteor.userId() }, { $set: position: position}
  'updateCurrentUserAddress': (address) ->
    if address
      Meteor.users.update { _id: Meteor.userId() }, { $set: address: address}
  'deleteLike': (id) ->
    Likes.remove({target: id, user: Meteor.userId()})
  'countPhotos': ->
    count = Photos.find().count()
    count
  'updatePhotoId': (photo)->
    Meteor.users.upsert {_id: Meteor.userId()}, {$set: photoId: photo._id}
  'deletePhoto': (photo) ->
    Photos.remove _id: photo._id