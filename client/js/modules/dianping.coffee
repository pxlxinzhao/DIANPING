API_KEY = 'AIzaSyBVPdFgguDJjJPsJt1iCTXLIHPUORucziQ'
TIME_FORMAT = 'MM/DD/YYYY HH:mm:ss'

dianPing = angular.module('dianPing', ['angular-meteor', 'uiGmapgoogle-maps', 'ui.router'])
  .config [
    '$urlRouterProvider'
    '$stateProvider'
    '$locationProvider'
    ($urlRouterProvider, $stateProvider, $locationProvider) ->
      $locationProvider.html5Mode true
      $stateProvider.state('index',
        url: '/'
        templateUrl: 'client/html/ng/main.ng.html')
      .state 'profile',
        url: '/profile'
        templateUrl: 'client/html/ng/profile.ng.html'
      $urlRouterProvider.otherwise '/'
  ]
  .config ['uiGmapGoogleMapApiProvider',  (GoogleMapApi) ->
    GoogleMapApi.configure
      key: API_KEY,
      v: '3.17',
      libraries: 'places'
  ]
  .run ['$templateCache', ($templateCache) ->
    $templateCache.put('searchbox.tpl.html', '<input id="pac-input" class="pac-controls" type="text" placeholder="Search">')
    $templateCache.put('window.tpl.html', '<div ng-controller="WindowCtrl" ng-init="showPlaceDetails(parameter)">{{place.name}}</div>')
  ]

#register services
dianPing.factory 'dpService', ->
  getFacebookPhotoUrl: getFacebookPhotoUrlByUser

dianPing.controller 'userPanel', [
  '$scope'
  '$meteor'
  'dpService'
  '$rootScope'
  ($scope, $meteor, dpService, $rootScope) ->
    initial = true
    Tracker.autorun ->
      if Meteor.user()
#        $scope.users = $meteor.collection Meteor.users
        $scope.photoUrl = dpService.getFacebookPhotoUrl Meteor.user()
        $scope.username = getCurrentUsername()
        $scope.address = Meteor.user().address
        if initial or (!Meteor.user().position || !Meteor.user().address)
          initial = false
          navigator.geolocation.getCurrentPosition (position) ->
            if position
              pos = _.clone position.coords
              Meteor.call 'updateCurrentUserPosition', pos
              geocoder = new (google.maps.Geocoder)
              latlng = new (google.maps.LatLng)(pos.latitude, pos.longitude)
              geocoder.geocode { 'latLng': latlng }, (results, status) ->
                if status == google.maps.GeocoderStatus.OK
                  if results[1]
#                    console.log results[1]
                    Meteor.call 'updateCurrentUserAddress', results[1].formatted_address
                  else
#                    console.log 'Location not found'
                else
#                  console.log 'Geocoder failed due to: ' + status
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
#              console.log $scope.map.markers[0].coords
          $scope.map.markers.pop()
          $scope.map.markers.push marker
#          console.log $scope.map.markers
          $scope.$apply()
    $scope.save = ->
      if $scope.comment.title and $scope.comment.message
        $scope.comment.createdTime = moment().valueOf()
        if $scope.map.markers[0] && $scope.map.markers[0].coords
          $scope.comment.position = $scope.map.markers[0].coords
        $scope.comments.push $scope.comment

    events = places_changed: (searchBox) ->
      place = searchBox.getPlaces()
      if !place
#        console.log 'no place data :('
        return
      $scope.map =
        'center':
          'latitude': place[0].geometry.location.lat()
          'longitude': place[0].geometry.location.lng()
        'zoom': 18
      $scope.marker =
        id: 0
        coords:
          latitude: place[0].geometry.location.lat()
          longitude: place[0].geometry.location.lng()

    $scope.searchbox =
      events: events
      template: 'searchbox.tpl.html'
      position: 'top-right'
      options:
        bounds: {}
        visible: true


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
    $scope.getTime = (comment) ->
      'Posted by ' + getUsernameById(comment.owner) + ' on ' + moment(comment.createdTime).format(TIME_FORMAT)
    $scope.getDist = (comment) ->
      if Meteor.user()
        console.log 'comment', comment.location
        #        console.log Meteor.user().position
        userPos =
          latitude: Meteor.user().position.latitude
          longitude: Meteor.user().position.longitude
        #        console.log 'userPos', userPos
        if comment.location and userPos
          Math.round(calculateDistance(comment.location, userPos)*10)/10  + 'Km'
#        console.log 'User can not be found when loading comments'

]

##define functions
getUserById = (userId) ->
  Meteor.users.findOne({_id: userId})

getUsernameById = (userId) ->
  user = getUserById(userId)
#  console.log user
  if user and user.profile then user.profile.name else 'UNKNOWN'

getCurrentUsername = ->
  if Meteor.user() and Meteor.user().profile then  Meteor.user().profile.name else 'UNKNOWN'

getFacebookPhotoUrlById = (userId) ->
  if userId
    user = getUserById(userId)
#    console.log 'user: ', user
    getFacebookPhotoUrlByUser user

getFacebookPhotoUrlByUser = (user) ->
#  user = Meteor.user()
#  console.log user
  if user and user.services and user.services.facebook
    'http://graph.facebook.com/' + user.services.facebook.id + '/picture'
  else
    'img/default.png'
##
calculateDistance = (coord1, coord2, unit) ->
  if !unit
    unit = 'K'
#  console.log coord1, coord2
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