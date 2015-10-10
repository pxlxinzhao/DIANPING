#angular.module('profileMod', [
#  'ngMaterial'
#  'ngMessages'
#])
dianPing.controller('profileNavCtrl', ($scope) ->
  $scope.nav = [
    'Edit Profile',
    'Photos',
    'Favorites',
    'Messages'
  ]
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
).config ($mdThemingProvider) ->
# Configure a dark theme with primary foreground yellow
  $mdThemingProvider.theme('docs-dark', 'default').primaryPalette('green').dark()
