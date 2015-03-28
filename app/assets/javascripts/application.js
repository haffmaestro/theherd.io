// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require hammerjs/hammer.min
//= require marked/lib/marked
//= require angular/angular
//= require angular-preloaded
//= require angular-material/angular-material
//= require angular-animate/angular-animate
//= require angular-aria/angular-aria
//= require angular-tooltips
//= require angular-marked/angular-marked
//= require angular-elastic/elastic
//= require message-center/message-center
//= require angular-ui-router/release/angular-ui-router
//= require angular-rails-templates
//= require angular-flux-helpers/angular-flux
//= require angular-tour/dist/angular-tour-tpls.min.js
//= require vide/dist/jquery.vide.min
//= require underscore/underscore
//= require_self
//= require_tree ./templates
//= require_tree .


angular.module('app', ['gs.preloaded', 'ngMaterial', 'ngAnimate', '720kb.tooltips', 'hc.marked',
  'MessageCenterModule', 'monospaced.elastic', 'ui.router', 'templates', 'ngFlux','angular-tour']).
  controller('ApplicationController', function($scope) {
  }).
  config(['$mdThemingProvider', function($mdThemingProvider){
    $mdThemingProvider.theme('default')
      .primaryPalette('blue', {
        'default':'600',
        'hue-1' : 'A400',
        'hue-2' : '600',
        'hue-3' : '900'

      })
      .accentPalette('orange', {
        'default': '800'
      })
  }]);
