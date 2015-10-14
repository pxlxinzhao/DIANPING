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
    console.log count
    count