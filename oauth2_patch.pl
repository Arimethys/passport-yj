#!/usr/bin/perl
use strict;
use warnings;
use File::Temp qw(tempfile);

my $patch = <<'EOS';
@@ -147,15 +147,17 @@

 exports.OAuth2.prototype.getOAuthAccessToken= function(code, params, callback) {
   var params= params || {};
-  params['client_id'] = this._clientId;
-  params['client_secret'] = this._clientSecret;
+  //params['client_id'] = this._clientId;
+  //params['client_secret'] = this._clientSecret;
+  params['type']= 'web_server';
   var codeParam = (params.grant_type === 'refresh_token') ? 'refresh_token' : 'code';
   params[codeParam]= code;

   var post_data= querystring.stringify( params );
   var post_headers= {
        'Content-Type': 'application/x-www-form-urlencoded'
-   };
+       , 'Authorization': "Basic " + new Buffer(this._clientId + ":" + this._clientSecret).toString('base64')
+  };


   this._request("POST", this._getAccessTokenUrl(), post_headers, post_data, null, function(error, data, response) {

EOS
my ($fh, $patchfile) = tempfile();
print $fh $patch;
close($fh);
`patch -f node_modules/passport-oauth/node_modules/oauth/lib/oauth2.js < $patchfile`;
