Meteor.publish 'allUsers', ->
  Meteor.users.find()

Meteor.publish 'allComments', ->
  DianPings.find({}, {sort: {createdTime: -1}})
