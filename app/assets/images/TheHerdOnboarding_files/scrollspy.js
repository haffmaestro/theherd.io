(function() {
  var app;

  $(".awesome-tooltip").tooltip({
    placement: "left"
  });

  $("body").scrollspy({
    target: "#mainnav",
    offset: "000"
  });

  $(function() {
    return $(document).on("click", "a[href*=#]:not([href=#])", function() {
      var target;
      if (location.pathname.replace(/^\//, "") === this.pathname.replace(/^\//, "") && location.hostname === this.hostname) {
        target = $(this.hash);
        target = (target.length ? target : $("[name=" + this.hash.slice(1) + "]"));
        if (target.length) {
          $("html,body").animate({
            scrollTop: target.offset().top - 75
          }, 500);
          return false;
        }
      }
    });
  });

  app = angular.module('app');

  app.directive('scrollList', function() {
    return {
      restrict: 'E',
      resplace: true,
      scope: {
        list: '='
      },
      template: "<nav id=\"mainnav\">\n  <ul class=\"dotnav dotnav-vertical dotnav-right nav\">\n    <li ng-repeat=\"item in list\" >\n      <a href=\"{{item.href}}\" tooltips title=\"{{item.name}}\" tooltip-side=\"left\"></a>\n    </li>\n  </ul>\n</nav> "
    };
  });

}).call(this);
