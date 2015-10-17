dianPing.directive 'profileImg', ->
  {
  restrict: 'E'
  replace: true
  template: '<img data-id="{{photo.c.public_id}}" ng-src="{{photo.c.url}}" ng-dblclick="changePhoto(photo)" class="img img-large"/>'
  link: (scope, elem, attrs) ->
    elem.bind 'mouseover', ->
      elem.css 'cursor', 'pointer'
  }