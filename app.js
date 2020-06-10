(function(){
    'use strict';
    angular.module("myFirstApp",[]).controller("myFirstController",function($scope){

        $scope.name="";
        $scope.totalNameValue=0;
        $scope.displayVal=function(){
            $scope.totalNameValue = getNameValue($scope.name);
        }

    });


function getNameValue(string){
    var sumval=0;
    for(var i=0;i<string.length;i++){
        sumval = sumval + string.charCodeAt(i);
    }
    return sumval;
}
})();