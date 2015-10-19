Meteor.publish 'allUsers', ->
  Meteor.users.find()

Meteor.publish 'allComments', ->
  DianPings.find({}, {sort: {createdTime: -1}})

Meteor.publish 'allLikes', ->
  Likes.find({userId: this.userId})

Meteor.publish 'replies', ->
  Replies.find({}, {sort: {createdTime: -1}})

Meteor.publish 'photos', ->
  Photos.find({owner: this.userId})