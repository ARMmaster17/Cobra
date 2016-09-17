/*global GetInjectedUsage*/
var app = angular.module('data-view', [])
    .controller('refresh_control', function($scope, $interval) {
        $scope.percentage = "Please Wait...";
        var sec = 15;
        UpdateView($scope, $interval);
        $interval(function() {
            UpdateView($scope, $interval);
            sec = 15;
        }, 15000);
        $interval(function() {
            $scope.secs = sec;
            sec--;
        }, 1000);
    });

function UpdateView($scope, $interval) {
    var prct = GetInjectedUsage()
    var vis = d3.select("#svg_donut");
    var fullarc = d3.svg.arc()
        .innerRadius(50)
        .outerRadius(100)
        .startAngle(2 * prct * Math.PI)
        .endAngle(2 * Math.PI);
    var arc = d3.svg.arc()
        .innerRadius(50)
        .outerRadius(100)
        .startAngle(0)
        .endAngle(2 * prct * Math.PI);
    var myNode = document.getElementById("svg_donut");
    while (myNode.firstChild) {
        myNode.removeChild(myNode.firstChild);
    }
    vis.append("path")
        .attr("d", fullarc)
        .attr("transform", "translate(100,100)")
        .attr("id", "graph-backarc");
    vis.append("path")
        .attr("d", arc)
        .attr("transform", "translate(100,100)")
        .attr("id", "graph-arc1");
    $scope.percentage = "Usage: " + Math.round(prct * 100) + "%"
}

function GetUsage(url) {
    var Httpreq = new XMLHttpRequest(); // a new request
    Httpreq.open("GET", url, false);
    Httpreq.send(null);
    return JSON.parse(Httpreq.responseText).usage / 100;
}