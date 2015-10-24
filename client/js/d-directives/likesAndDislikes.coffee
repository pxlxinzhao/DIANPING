dianPing.directive 'likeDislike', ($compile) ->
  {
  replace: true
  transclude: true
  scope: true
  link: (scope, elem, attrs) ->
    target = attrs.target
    template = '<span ng-click="like(' + target + ')" ng-hide="isLiked(' + target + ')" class="glyphicon glyphicon-thumbs-up"></span>
                <span ng-click="dislike(' + target + ')" ng-show="isLiked(' + target + ')" class="glyphicon glyphicon-thumbs-up liked"></span>
                <span ng-class="{liked: isLiked(' + target + ')}">{{likeCount(' + target + ')}}</span>
                <span ng-click="hate(' + target + ')" ng-hide="isHated(' + target + ')" class="glyphicon glyphicon-thumbs-down margin-left-small"></span>
                <span ng-click="dishate(' + target + ')" ng-show="isHated(' + target + ')" class="glyphicon glyphicon-thumbs-down hated margin-left-small"></span>
                <span ng-class="{hated: isHated(' + target + ')}">{{hateCount(' + target + ')}}</span>'

    elem.html(template).show();
    $compile(elem.contents())(scope)
  }