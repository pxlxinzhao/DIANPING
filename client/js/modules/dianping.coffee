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
    $scope.markerIndex = 0
    $scope.map =
      center:
        latitude: 45
        longitude: -79
      zoom: 8
      markers: []
      events:
        click: (map, eventName, originalEventArgs) ->
          e = originalEventArgs[0]
          lat = e.latLng.lat()
          lon = e.latLng.lng()
          marker =
            id: 'marker' + $scope.markerIndex++
            coords:
              latitude: lat
              longitude: lon
            options: draggable: true
            events: dragend: (marker, eventName, args) ->
              $scope.map.markers[0].coords.latitude = marker.getPosition().lat()
              $scope.map.markers[0].coords.longitude = marker.getPosition().lng()
              console.log $scope.map.markers[0].coords
          $scope.map.markers.pop()
          $scope.map.markers.push marker
          console.log $scope.map.markers
          $scope.$apply()
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
    $scope.getFooter = (comment) ->
      'Posted by ' + getUsername(comment.owner) + ' on ' + moment(comment.createdTime).format('MM/DD/YYYY HH:mm:ss')
]

##define functions
getUserById = (userId) ->
  Meteor.users.findOne({_id: userId})

getUsername = (userId) ->
  user = getUserById(userId)
  console.log user
  if user and user.profile then user.profile.name else 'UNKNOWN'

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