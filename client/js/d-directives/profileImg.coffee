dianPing.directive 'profileImg', ->
  {
  restrict: 'E'
  replace: true
  transclude: true
  template: '<div class="profile-img"><img data-id="{{photo.c.public_id}}"
            ng-src="{{photo.c.url}}" ng-dblclick="changePhoto(photo)" class="img img-large"/>
            <span ng-transclude ng-click="delete(photo)" class="glyphicon glyphicon-minus-sign"></span>'

  link: (scope, elem, attrs) ->
    span = elem.find('span')
    span.hide()
    span.css 'cursor', 'default'
    elem.bind 'mouseover', ->
      span.show()
    elem.bind 'mouseleave', ->
      span.hide()
  }