/*
 * AppController.j
 * ClassifierSandbox
 *
 * Created by You on January 19, 2013.
 * Copyright 2013, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>
@import <Ratatosk/Ratatosk.j>
@import "Scripts/Base64.js"
@import "Scripts/Deflate.js"
@import "Scripts/PNG.js"

@implementation AppController : CPObject
{
    CPWindow    theWindow; //this "outlet" is connected automatically by the Cib
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var keyStr = "ABCDEFGHIJKLMNOP" +
                   "QRSTUVWXYZabcdef" +
                   "ghijklmnopqrstuv" +
                   "wxyz0123456789+/" +
                   "=";
                   
    function decode64(input) {
         var output = "";
         var chr1, chr2, chr3 = "";
         var enc1, enc2, enc3, enc4 = "";
         var i = 0;

         // remove all characters that are not A-Z, a-z, 0-9, +, /, or =
         var base64test = /[^A-Za-z0-9\+\/\=]/g;
         if (base64test.exec(input)) {
            alert("There were invalid base64 characters in the input text.\n" +
                  "Valid base64 characters are A-Z, a-z, 0-9, '+', '/',and '='\n" +
                  "Expect errors in decoding.");
         }
         input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

         do {
            enc1 = keyStr.indexOf(input.charAt(i++));
            enc2 = keyStr.indexOf(input.charAt(i++));
            enc3 = keyStr.indexOf(input.charAt(i++));
            enc4 = keyStr.indexOf(input.charAt(i++));

            chr1 = (enc1 << 2) | (enc2 >> 4);
            chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
            chr3 = ((enc3 & 3) << 6) | enc4;

            output = output + String.fromCharCode(chr1);

            if (enc3 != 64) {
               output = output + String.fromCharCode(chr2);
            }
            if (enc4 != 64) {
               output = output + String.fromCharCode(chr3);
            }

            chr1 = chr2 = chr3 = "";
            enc1 = enc2 = enc3 = enc4 = "";

         } while (i < input.length);

         return unescape(output);
      }
    // This is called when the application is done loading.
    var glyphTokens = encodedGlyphs.split(",");
    var tests = glyphTokens[0].split("[&#39;");
    var tests2 = tests[1].split("&#39;");
    //console.log(decode64(tests2[0]));
    String.prototype.padRight = function(c, n){
    	var txt = '';
    	for(var i=0;i<n-this.length;i++) txt += c;
    	return txt + this;
    };
    
    function show(data){
    	var png = new PNG(data);
    	var img = document.getElementById('image'), limg = document.getElementById('largeimage');
    	document.getElementById('nativeimage').src = 'data:image/png;base64,' + data;
    	img.innerHTML = '';
    	limg.innerHTML = '';
    	img.style.width = png.width + 'px';
    	img.style.height = png.height + 'px';
    	limg.style.width = (png.width * 3) + 'px';
    	limg.style.width = (png.height * 3) + 'px';
    	var line;
    	while(line = png.readLine())
    	{
    		for (var x = 0; x < line.length; x++){
    			var px = document.createElement('div'), px2 = document.createElement('div');
    			px.className = px2.className = 'pixel';
    			px.style.backgroundColor = px2.style.backgroundColor = '#' + line[x].toString(16).padRight('0', 6);
    			img.appendChild(px);
    			limg.appendChild(px2);
    		}
    	}
    }
    console.log(tests2[0]);
    show(tests2[0]);
}

- (void)awakeFromCib
{
    // This is called when the cib is done loading.
    // You can implement this method on any object instantiated from a Cib.
    // It's a useful hook for setting up current UI values, and other things.

    [WLRemoteLink setDefaultBaseURL:@""];

    // In this case, we want the window from Cib to become our full browser window
    [theWindow setFullPlatformWindow:YES];
}

@end
