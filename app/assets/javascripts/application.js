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
//= require hammer.min
//= require angular
//= require angular-preloaded
//= require angular-material
//= require angular-animate
//= require angular-aria
//= require angular-tooltips
//= require angular-ui-router.min
//= require elastic
//= require angular-marked
//= require jquery.vide.min
//= require marked
//= require highlight.pack
//= require underscore
//= require_self
//= require_tree .


angular.module('app', ['gs.preloaded', 'ngMaterial', 'ngAnimate', '720kb.tooltips','monospaced.elastic', 'hc.marked', 'ui.router']).
  controller('ApplicationController', function($scope) {
  });
