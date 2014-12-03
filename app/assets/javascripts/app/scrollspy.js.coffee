$(".awesome-tooltip").tooltip placement: "left"
$("body").scrollspy
  target: "#mainnav"
  offset: "000"


# CSS Tricks smooth scrolling : http://css-tricks.com/snippets/jquery/smooth-scrolling/ 
$("a[href*=#]:not([href=#])").click ->
  if location.pathname.replace(/^\//, "") is @pathname.replace(/^\//, "") and location.hostname is @hostname
    target = $(@hash)
    target = (if target.length then target else $("[name=" + @hash.slice(1) + "]"))
    if target.length
      $("html, body").animate
        scrollTop: target.offset().top
      , 500
      false

app = angular.module('app')

app.directive('scrollList', ->
  restrict: 'E'
  resplace: true
  scope: 
    list: '='
  template: """
    <nav id="mainnav">
      <ul class="dotnav dotnav-vertical dotnav-right nav">
        <li ng-repeat="item in list" >
          <a href="{{item.href}}" tooltips title="{{item.name}}" tooltip-side="left"></a>
        </li>
      </ul>
    </nav> 
  """
  )