Return-Path: <axboe@kernel.dk>
Subject: Re: fio-f1480f9: AIX 6.1 build KO against gcc function overlap
References: <VI1PR05MB1343197BD54DC24EA6A2AF65B1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681C3ED.2000708@kernel.dk>
 <VI1PR05MB1343C677E9AD2577F510184DB1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681C9E2.3040006@kernel.dk>
 <VI1PR05MB13430153F93BD34C56DFB4CAB1FB0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681D0A8.8030507@kernel.dk>
 <VI1PR05MB1343AD6DF9BD33ED9A3C0C88B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5681D65A.10200@kernel.dk>
 <VI1PR05MB134330236BC82EF62F5219C0B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5682A81A.8010008@kernel.dk>
 <VI1PR05MB134366A0B6A8833617A18D4FB1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <VI1PR05MB1343AFE71D15E197D549461FB1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <56834ED5.40506@kernel.dk> <568356A8.1040904@kernel.dk>
 <VI1PR05MB13431E57B67F7322189A74E2B1FD0@VI1PR05MB1343.eurprd05.prod.outlook.com>
 <5684089C.7000201@kernel.dk> <56840B48.4040301@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56840B75.5070002@kernel.dk>
Date: Wed, 30 Dec 2015 09:51:01 -0700
MIME-Version: 1.0
In-Reply-To: <56840B48.4040301@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------020203080103070607090601"
To: Thierry BERTAUD <tbertaud@conforama.fr>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020203080103070607090601
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 12/30/2015 09:50 AM, Jens Axboe wrote:
> On 12/30/2015 09:38 AM, Jens Axboe wrote:
>> so that logic does look correct. Maybe the configure check for the error
>> return of lex -o isn't working. Do you have CONFIG_LEX_USE_O in your
>> config-host.mak, if you run configure --enable-lex?
>
> If the latter is the case, then the attached patch should hopefully
> work. That'll force NOT using -o for AIX always, if lex is enabled.

Gah, missed a 'fi'. New one attached.


-- 
Jens Axboe


--------------020203080103070607090601
Content-Type: text/x-patch;
 name="no-lex-o-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="no-lex-o-v2.patch"

diff --git a/configure b/configure
index e92e96b879b5..517668233fc7 100755
--- a/configure
+++ b/configure
@@ -247,6 +247,8 @@ AIX)
   # Unless explicitly enabled, turn off lex.
   if test -z "$disable_lex" ; then
     disable_lex="yes"
+  else
+    force_no_lex_o="yes"
   fi
   ;;
 Darwin)
@@ -1505,6 +1507,9 @@ fi
 
 # Check if lex fails using -o
 if test "$arith" = "yes" ; then
+if test "$force_no_lex_o" = "yes" ; then
+  lex_use_o="no"
+else
 $LEX -o lex.yy.c exp/expression-parser.l 2> /dev/null
 if test "$?" = "0" ; then
   lex_use_o="yes"
@@ -1512,6 +1517,7 @@ else
   lex_use_o="no"
 fi
 fi
+fi
 
 echo "lex/yacc for arithmetic       $arith"
 

--------------020203080103070607090601--

