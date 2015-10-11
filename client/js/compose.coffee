
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
        $scope.comments.unshift $scope.comment

        console.log $scope.comments

        $scope.comment = {}
        $scope.comment.owner = Meteor.userId()

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
