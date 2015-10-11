#angular.module('profileMod', [
#  'ngMaterial'
#  'ngMessages'
#])
dianPing.controller('profileNavCtrl', [
    '$scope'
    'navService'
    ($scope, navService) ->

      $scope.nav = navService

  ]
#  console.log $scope.nav
)

dianPing.controller('profileCtrl', ($scope) ->
  $scope.user =
    title: 'Developer'
    email: 'ipsum@lorem.com'
    firstName: ''
    lastName: ''
    company: 'Google'
    address: '1600 Amphitheatre Pkwy'
    city: 'Mountain View'
    state: 'CA'
    biography: 'Loves kittens, snowboarding, and can type at 130 WPM.\n\nAnd rumor has it she bouldered up Castle Craig!'
    postalCode: '94043'
)

dianPing.controller('photoCtrl', [
    '$scope'
    'navService'
    ($scope, navService) ->

      $scope.nav = navService

      Tracker.autorun ->
        $scope.photoUrl = getFacebookPhotoUrlByUser Meteor.user(), 'large'
        console.log  $scope.photoUrl


  ]
#  console.log $scope.nav
)
