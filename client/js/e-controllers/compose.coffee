
dianPing.controller 'composer', [
  '$scope'
  '$meteor'
  'uiGmapIsReady'
  'toastService'
  ($scope, $meteor, IsReady, toastService) ->

    IsReady.promise().then (maps) ->
      $scope.gMap = maps[0].map

    $scope.showMap = true
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
#          console.log map == $scope.gMap
          google.maps.event.trigger(map, 'resize')
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
      else
        console.log 'here'
        toastService('Please fill title and message fields')

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

    $scope.toggleMap = ->
      if $scope.showMap
        $scope.showMap = false
      else
        $scope.showMap = true
        console.log $scope.gMap
        if $scope.gMap
          #have two resize events to fit animation
          setTimeout (-> google.maps.event.trigger($scope.gMap, 'resize')), 10
          setTimeout (-> google.maps.event.trigger($scope.gMap, 'resize')), 600




]
