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
    'photoUrlService'
    ($scope, navService, photoUrlService) ->

      $scope.nav = navService

      Tracker.autorun ->
        $scope.photoUrl = photoUrlService Meteor.userId(), 'large'
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
    '$rootScope'
    'toastService'
    ($scope, $meteor, $rootScope, toastService) ->

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

      console.log '$rootScope', $rootScope

      $scope.mode = 'determinate'
      $scope.photos = $meteor.collection(Photos).subscribe 'photos'

      $scope.changePhoto = (photo) ->
        Meteor.call 'updatePhotoUrl', photo.c.url, (err, data) ->
          if err
            console.log err
          else
            toastService 'Photo updated'

      $scope.maxPhotoCount = 15
#      count does not work. totally have no idea..
#      console.log $scope.photos, $scope.photos.length, Photos.find({}).count()
      $scope.upload = (image2) ->
        if (image2)
          $scope.mode = 'query'
          console.log 'calling upload'
          Meteor.call 'countPhotos', (err, result) ->
            if err
              console.log err
              $scope.mode = 'determinate'
            if result and result <= $scope.maxPhotoCount
              console.log 'count', result
              file = dataURItoBlob(image2)
              Cloudinary.upload [file], null, (err, res) ->
                if err
                  console.log 'error', err
                if res
                  console.log 'saving', res
                  $scope.photos.push
                    owner: Meteor.userId()
                    c: res
                  console.log 'saved'
                  $scope.photoCount =  $scope.photoCount + 1
                  $scope.$apply()
                $scope.mode = 'determinate'
                toastService('Successfully uploaded')
            else
              $scope.mode = 'determinate'
        else
          toastService('No file chosen')
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
