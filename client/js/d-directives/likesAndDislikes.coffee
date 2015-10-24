dianPing.directive 'likeDislike', ->
  {
  replace: true
  transclude: true
  scope:
    target: '@'
  template: '<div><span ng-click="like(reply)" ng-hide="isLiked(reply)" class="glyphicon glyphicon-thumbs-up"></span
                <span ng-click="dislike(reply)" ng-show="isLiked(reply)" class="glyphicon glyphicon-thumbs-up liked"></span>
                <span ng-class="{liked: isLiked(reply)}">{{likeCount(reply)}}</span><div>'

  link: (scope, elem, attrs) ->

  }