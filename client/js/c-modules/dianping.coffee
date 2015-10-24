@API_KEY = 'AIzaSyBVPdFgguDJjJPsJt1iCTXLIHPUORucziQ'
@TIME_FORMAT = 'MM/DD/YYYY HH:mm:ss'

@dianPing = angular.module('dianPing', ['angular-meteor', 'uiGmapgoogle-maps', 'ui.router',
'ngMaterial', 'ngMessages', 'imageupload'])
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
      .state 'userView',
        url: '/user/:userId'
        templateUrl: 'client/html/ng/userView.ng.html'
      .state 'profile-photo',
        url: '/photo'
        templateUrl: 'client/html/ng/profile-photo.ng.html'
      $urlRouterProvider.otherwise '/'
  ]
  .config ['uiGmapGoogleMapApiProvider',  (GoogleMapApi) ->
    GoogleMapApi.configure
      key: API_KEY,
      v: '3.17',
      libraries: 'places'
  ]
  .config ($mdThemingProvider) ->
    # Configure a dark theme with primary foreground yellow
    $mdThemingProvider.theme('docs-dark', 'default').primaryPalette('green').dark()

  .run ['$templateCache', ($templateCache) ->
    $templateCache.put('searchbox.tpl.html', '<input id="pac-input" class="pac-controls" type="text" placeholder="Search">')
    $templateCache.put('window.tpl.html', '<div ng-controller="WindowCtrl" ng-init="showPlaceDetails(parameter)">{{place.name}}</div>')
    $templateCache.put('panelFooter.tpl.html', '<div>{{getTime}}<span>{{getDist}}</span>/div>')
  ]

dianPing.controller 'rootCtrl', [
  '$scope'
  '$rootScope'
  ($scope, $rootScope, $mdToast, $document) ->
      $rootScope.getCurrentUsername = getCurrentUsername
      #this guy is not working
      $rootScope.print = (obj) ->
        console.log obj

]

#register services
dianPing.factory 'navService', ->
  nav = []
  nav.push
    name: 'Edit Profile'
    url: '/profile'
  nav.push
    name: 'Photos'
    url: '/photo'
  nav.push
    name: 'Favorites'
  nav.push
    name: 'Messages'
  nav.push
    name: 'Preview'
  nav

dianPing.factory 'toastService', [
  '$rootScope'
  '$mdToast'
  ($rootScope, $mdToast) ->

    showSimpleToast = (content, time)->
      toast =  $mdToast.simple().content(if content then content else 'no content')
      .position('top right').hideDelay(if time then time else 2000)
      $mdToast.show toast

    showSimpleToast
]

dianPing.factory 'photoUrlService',  ->
  getPhotoUrl


##define functions
@getUserById = (userId) ->
  Meteor.users.findOne({_id: userId})

@getUsernameById = (userId) ->
  user = getUserById(userId)
#  console.log user
  if user and user.profile then user.profile.name else 'UNKNOWN'

@getCurrentUsername = ->
  if Meteor.user() and Meteor.user().profile then  Meteor.user().profile.name else 'UNKNOWN'

@getPhotoUrl = (userId, type) ->
  if userId
    if userId == Meteor.userId() and  Meteor.user() and Meteor.user().photoId
      photoId = Meteor.user().photoId
      photo = Photos.findOne({_id: photoId})
      photo.c.url
    else
      user = getUserById(userId)
      if user and user.services and user.services.facebook.id
        if type
          'http://graph.facebook.com/' + user.services.facebook.id + '/picture?type=' + type
        else
          'http://graph.facebook.com/' + user.services.facebook.id + '/picture'
      else
        'img/default.png'