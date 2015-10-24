


dianPing.controller 'comments', [
  '$scope'
  '$meteor'
  '$mdDialog'
  'photoUrlService'
  ($scope, $meteor, $mdDialog, photoUrlService) ->
    $meteor.subscribe 'allComments', {
      sort: {
        createdTime: 1
      }
    }
    $meteor.subscribe 'replies'

    $scope.comments = $meteor.collection DianPings, false
    $scope.likes = $meteor.collection(Likes).subscribe('allLikes')
    $scope.hates = $meteor.collection(Hates).subscribe('allHates')
    $scope.replies = $meteor.collection Replies

    $scope.getPhoto = (id) ->
      photoUrlService id
    $scope.remove = (comment) ->
      $scope.comments.splice($scope.comments.indexOf(comment), 1)
    $scope.getOwner = (id) ->
      getUsernameById(id)
    $scope.getTime = (obj) ->
#      getUsernameById(comment.owner) + ' ' + moment(comment.createdTime).fromNow()
      time = obj.createdTime
      moment(time).fromNow()
    $scope.getDist = (comment) ->
      if Meteor.user()
        if comment.position
          position = Meteor.user().position
        if position
          userPos =
              latitude: position.latitude
              longitude: position.longitude
          if comment.position and userPos
            Math.round(calculateDistance(comment.position, userPos)*10)/10  + 'Km'

    $scope.isLiked = (target) ->
      if target
        like = Likes.findOne({target: target._id, user: Meteor.userId()})
        !!like
    $scope.like = (target) ->
      console.log 'calling like in comment'
      ok = target and !$scope.isLiked target
      if ok
        $scope.likes.push
          target: target._id
          user: Meteor.userId()
    $scope.dislike = (target) ->
      Meteor.call 'deleteLike', target._id
    $scope.likeCount = (target) ->
      Likes.find({target: target._id}).count()

    $scope.isHated = (target) ->
      if target
        like = Hates.findOne({target: target._id, user: Meteor.userId()})
        !!like
    $scope.hate = (target) ->
      ok = target and !$scope.isHated target
      if ok
        $scope.hates.push
          target: target._id
          user: Meteor.userId()
    $scope.dishate = (target) ->
      Meteor.call 'deleteHate', target._id
    $scope.hateCount = (target) ->
      Hates.find({target: target._id}).count()


    $scope.showConfirm = (comment) ->
# Appending dialog to document.body to cover sidenav in docs app
      confirm = $mdDialog.confirm().title('Would you like to delete your comment?')
        .content('This action can not be reverted')
        .ariaLabel('Lucky day')
        .ok('Delete')
        .cancel('Cancel')
      $mdDialog.show(confirm).then (->
        $scope.remove(comment)
      )

    $scope.toggleReplying = (comment) ->
      comment.isReplying = !comment.isReplying
    $scope.getReplies = (comment) ->
#      console.log $scope.replies
      results = _.filter $scope.replies, (reply) ->
        return reply.commentId == comment._id

      sorted = _.sortBy results, 'createdTime'
      sorted.reverse()

    $scope.getRepliesCount = (comment) ->
      results = _.filter $scope.replies, (reply) ->
        return reply.commentId == comment._id
      results.length

    $scope.reply = (comment) ->
      if comment.replyMessage
          $scope.replies.push
            user: Meteor.userId()
            commentId: comment._id
            message: comment.replyMessage
            createdTime: moment().valueOf()
          console.log 'created comment reply object'
          comment.replyMessage = ''
    $scope.deleteReply = (reply) ->
      confirm = $mdDialog.confirm().title('Would you like to delete your reply?')
        .content('This action can not be reverted')
        .ariaLabel('Lucky day')
        .ok('Delete')
        .cancel('Cancel')
      $mdDialog.show(confirm).then (->
        $scope.replies.splice $scope.replies.indexOf(reply), 1
      )

    $scope.isOwner = (obj) ->
      Meteor.userId() == obj.owner || obj.user || obj.userId

    $scope.print = (obj) ->
      console.log obj

]
.filter 'timeFilter', [ ->
  (items) ->
    filtered = _.sortBy items, 'createdTime'
    filtered.reverse()
]

##comment
calculateDistance = (coord1, coord2, unit) ->
  if coord1 and coord2
    if !unit
      unit = 'K'
    lat1 = coord1.latitude
    lat2 = coord2.latitude
    lon1 = coord1.longitude
    lon2 = coord2.longitude
    radlat1 = Math.PI * lat1 / 180
    radlat2 = Math.PI * lat2 / 180
    radlon1 = Math.PI * lon1 / 180
    radlon2 = Math.PI * lon2 / 180
    theta = lon1 - lon2
    radtheta = Math.PI * theta / 180
    dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta)
    dist = Math.acos(dist)
    dist = dist * 180 / Math.PI
    dist = dist * 60 * 1.1515
    if unit == 'K'
      dist = dist * 1.609344
    if unit == 'N'
      dist = dist * 0.8684
    dist