#dianPing.controller 'userPanel', [
#  '$scope'
#  '$meteor'
#  '$rootScope'
#  'photoUrlService'
#  ($scope, $meteor, dpService, $rootScope, photoUrlService) ->
#    initial = true
#    $meteor.autorun ->
#      $meteor.subscribe('allUsers')
#      console.log 'userPanel', Meteor.user(), photoUrlService
#      if Meteor.user() && photoUrlService
#        $scope.photoUrl = photoUrlService Meteor.userId()
#        console.log '$scope.photoUrl' , $scope.photoUrl
#        $scope.username = getCurrentUsername()
#        $scope.address = Meteor.user().address
#        if initial or (!Meteor.user().position || !Meteor.user().address)
#          initial = false
#          navigator.geolocation.getCurrentPosition (position) ->
#            if position
#              try
#                pos = _.clone position.coords
#                Meteor.call 'updateCurrentUserPosition', pos
#                geocoder = new (google.maps.Geocoder)
#                latlng = new (google.maps.LatLng)(pos.latitude, pos.longitude)
#                geocoder.geocode { 'latLng': latlng }, (results, status) ->
#                  if status == google.maps.GeocoderStatus.OK
#                    if results[1]
#  #                    console.log results[1]
#                      Meteor.call 'updateCurrentUserAddress', results[1].formatted_address
#                    else
#  #                    console.log 'Location not found'
#                  else
#  #                  console.log 'Geocoder failed due to: ' + status
#              catch error
#                console.log error
#]
