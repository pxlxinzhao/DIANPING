#angular.module('profileMod', [
#  'ngMaterial'
#  'ngMessages'
#])
dianPing.directive 'fileread', [ ->
  {
  scope: fileread: '='
  link: (scope, element, attributes) ->
    element.bind 'change', (changeEvent) ->
      scope.$apply ->
        scope.fileread = changeEvent.target.files[0]
  }
]


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

      $scope.fileread = {};
      $scope.upload = ->
        console.log $scope.fileread
  ]
#  console.log $scope.nav
)

dianPing.controller('photoUploadCtrl', [
    '$scope'
    '$meteor'
    ($scope, $meteor) ->

###########     define a function
      countPhotoAndSetToScope = ->
        Meteor.call 'countPhotos', (err, result) ->
          if err
            console.log err
          if result
            $scope.photoCount = result;
            $scope.$apply()
      ##############

      countPhotoAndSetToScope()
      $scope.photos = $meteor.collection(Photos).subscribe 'photos'
#      $meteor.autorun ->
#        $scope.photoCount = Session.get 'photoCount'
      $scope.maxPhotoCount = 15
#      count does not work. totally have no idea..
#      console.log $scope.photos, $scope.photos.length, Photos.find({}).count()
      $scope.upload = (image2) ->
        console.log 'calling upload'
        Meteor.call 'countPhotos', (err, result) ->
          if err
            console.log err
          if result and result <= $scope.maxPhotoCount
            console.log 'count', result
            file = dataURItoBlob(image2)
            Cloudinary.upload [file], null, (err, res) ->
              console.log 'error', err
              console.log 'success', res
              if res
                console.log 'saving'
                $scope.photos.push
                  owner: Meteor.userId()
                  c: res
                console.log 'saved'
                $scope.photoCount =  $scope.photoCount + 1
                $scope.$apply()
  ]
#  console.log $scope.nav
)


# functions
dataURItoBlob = (file) ->
  dataURI = file.dataURL
# convert base64 to raw binary data held in a string
# doesn't handle URLEncoded DataURIs - see SO answer #6850276 for code that does this
  byteString = atob(dataURI.split(',')[1])
  # separate out the mime component
  mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]
  # write the bytes of the string to an ArrayBuffer
  ab = new ArrayBuffer(byteString.length)
  ia = new Uint8Array(ab)
  i = 0
  while i < byteString.length
    ia[i] = byteString.charCodeAt(i)
    i++
  # write the ArrayBuffer to a blob, and you're done
  bb = new Blob([ab],{type: file.type})
  bb
