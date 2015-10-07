Meteor.methods
  'updateCurrentUserPosition': (position) ->
    if position
      Meteor.users.update { _id: Meteor.userId() }, { $set: position: position}
  'updateCurrentUserAddress': (address) ->
    if address
      Meteor.users.update { _id: Meteor.userId() }, { $set: address: address}