dianPing = angular.module('dianPing', ['angular-meteor', 'uiGmapgoogle-maps'])

#register services
dianPing.factory 'dpService', ->
  getFacebookPhotoUrl: getFacebookPhotoUrl

dianPing.controller 'userPanel', [
  '$scope'
  'dpService'
  ($scope, dpService) ->
    console.log Meteor.user()
    console.log Meteor.userId()
    $scope.photoUrl = dpService.getFacebookPhotoUrl Meteor.user()
    $scope.username = getCurrentUsername()
]

dianPing.controller 'composer', [
  '$scope'
  '$meteor'
  ($scope, $meteor) ->
    $scope.comments = $meteor.collection DianPings
    $scope.comment = {}
    $scope.comment.owner = Meteor.userId()
    $scope.comment.title = ''
    $scope.comment.message = ''
    $scope.idkey = 'tempKey'
    $scope.map =
      center:
        latitude: 45
        longitude: -79
      zoom: 8
      marker:
        options: draggable: true
        events: dragend: (marker, eventName, args) ->
          if !$scope.comment.location
            $scope.comment.location = {}
          $scope.comment.location.latitude = marker.getPosition().lat()
          $scope.comment.location.longitude = marker.getPosition().lng()
    $scope.save = ->
      if $scope.comment.title and $scope.comment.message
        $scope.comment.createdTime = moment().valueOf()
        $scope.comments.push $scope.comment
]

dianPing.controller 'comments', [
  '$scope'
  '$meteor'
  ($scope, $meteor) ->
    $scope.comments = $meteor.collection DianPings
    $scope.getPhoto = (comment) ->
      getFacebookPhotoUrlById comment.owner
    $scope.remove = (comment) ->
      $scope.comments.splice($scope.comments.indexOf(comment), 1)
]

##define functions
getUserById = (userId) ->
  Meteor.users.findOne({_id: userId})

getCurrentUsername = ->
  if Meteor.user() and Meteor.user().profile then  Meteor.user().profile.name else 'UNKNOWN'

getFacebookPhotoUrlById = (userId) ->
  if userId
    user = getUserById(userId)
#    console.log 'user: ', user
    getFacebookPhotoUrl user

getFacebookPhotoUrl = (user) ->
#  user = Meteor.user()
#  console.log user
  if user and user.services and user.services.facebook
    'http://graph.facebook.com/' + user.services.facebook.id + '/picture'
  else
    'img/locky.jpg'
##