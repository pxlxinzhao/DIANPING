dianPing = angular.module('dianPing', ['angular-meteor'])

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
    $scope.title = ''
    $scope.message = ''
    $scope.print = ->
      console.log $scope.title, $scope.message
    $scope.save = ->
      if $scope.title and $scope.message then
      $scope.comments.push
        owner: Meteor.userId()
        title: $scope.title
        message: $scope.message
        createdTime: moment().valueOf()
]

dianPing.controller 'comments', [
  '$scope'
  '$meteor'
  ($scope, $meteor) ->
    $scope.comments = $meteor.collection DianPings
    $scope.getPhoto = (comment) ->
      getFacebookPhotoUrlById comment.owner
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