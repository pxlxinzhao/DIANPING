


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
    $scope.likes = $meteor.collection Likes
    $scope.replies = $meteor.collection Replies

    if $scope.likes.length == 0 && Meteor.userId
#      console.log 'before', $scope.likes
      Meteor.call 'createLike'
#      console.log 'after', $scope.likes
    else if $scope.likes.length > 1
      console.warn 'duplicated records in Likes'
    else
      console.warn 'Meteor.userId is null'

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

    $scope.isLiked = (comment) ->
#      console.log  $scope.likes[0] && $scope.likes[0].likes.indexOf(comment._id)
      $scope.likes[0] && $scope.likes[0].likes.indexOf(comment._id) > -1
    $scope.like = (comment) ->
      if comment
        id = comment._id
#        console.log id
#        console.log 'calling like with ', $scope.isLiked comment
        if (!$scope.isLiked comment)
#          console.log $scope.likes[0]
          $scope.likes[0].likes.push id
#        console.log $scope.likes[0]
    $scope.dislike = (comment) ->
      if ($scope.likes[0] and $scope.isLiked(comment))
        $scope.likes[0].likes.splice $scope.likes[0].likes.indexOf comment._id, 1
        $scope.likes[0].likes.splice $scope.likes[0].likes.indexOf 'null', 1
#      console.log $scope.likes[0]

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
      if comment.isReplying
        comment.isReplying = false
      else
        comment.isReplying = true
    $scope.getReplies = (comment) ->
#      console.log $scope.replies
      results = _.filter $scope.replies, (reply) ->
        if reply.commentId == comment._id
          true
        else
          false

      sorted = _.sortBy results, 'createdTime'
      sorted.reverse()

    $scope.getRepliesCount = (comment) ->
      results = _.filter $scope.replies, (reply) ->
        if reply.commentId == comment._id
          true
        else
          false
      results.length

    $scope.reply = (comment) ->
      if comment.replyMessage
          $scope.replies.push
            owner: Meteor.userId()
            commentId: comment._id
            message: comment.replyMessage
            createdTime: moment().valueOf()
          console.log 'created comment reply object'
          comment.replyMessage = ''

    $scope.isOwner = (obj) ->
      Meteor.userId() == obj.owner

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
#    console.log coord1, coord2
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