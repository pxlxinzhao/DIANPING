dianPing.directive 'profileImg', ->
  {
  restrict: 'E'
  replace: true
  transclude: true
  template: '<div class="profile-img"><img data-id="{{photo.c.public_id}}"
            ng-src="{{photo.c.url}}" ng-dblclick="changePhoto(photo)" class="img img-large"/>
            <span ng-transclude class="glyphicon glyphicon-minus-sign"></span>'

  link: (scope, elem, attrs) ->
    span = elem.find('span')
    span.hide()

    elem.bind 'mouseover', ->
      elem.css 'cursor', 'pointer'
      span.show()
    elem.bind 'mouseleave', ->
      span.hide()
  }