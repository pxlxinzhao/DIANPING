Meteor.publish 'allUsers', ->
  Meteor.users.find()

Meteor.publish 'allComments', ->
  DianPings.find({}, {sort: {createdTime: -1}})

Meteor.publish 'allLikes', ->
  Likes.find({userId: this.userId()})