/**
 * cookie.js 
 */
function setCookie(name, value, path){
return document.cookie=name+"="+escape(value)+"; path="+path;
}
function getCookie(name){
var dc=document.cookie;
var prefix=name+"=";
var begin=dc.lastIndexOf(prefix);
if(begin==-1) return null;
var end=dc.indexOf(";", begin);
if(end==-1) end=dc.length;
return unescape(dc.substring(begin+prefix.length, end));
}
function deleteCookie(name, path) {
document.cookie=name+"="+"; path="+path+"; expires=Thu, 01-Jan-70 00:00:01 GMT";
return getCookie(name);
}
function getFilename(){
var href=window.location.href;
var file=href.substring(href.lastIndexOf("/")+1);
return file.substring(0,file.indexOf("#")).substring(0,file.indexOf("?"));
}
function getPath(){
var path = location.pathname;
return path.substring(0, path.lastIndexOf("/")+1);
}