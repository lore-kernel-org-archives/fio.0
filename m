Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:38032 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbbDPKWa (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 16 Apr 2015 06:22:30 -0400
Received: by igbhj9 with SMTP id hj9so2271302igb.1
        for <fio@vger.kernel.org>; Thu, 16 Apr 2015 03:22:29 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 16 Apr 2015 18:22:29 +0800
Message-ID: <CABtFm2USrxVrNJyow6sFFNGdJFKoMieFepCWiPBHckg4e_k3-w@mail.gmail.com>
Subject: lex/yacc not configured properly.
From: Srinivasa Chamarthy <chamarthy.raju@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Srinivasa Chamarthy <chamarthy.raju@gmail.com>

There seems to be a small issue with configure while checking
lex/yacc. Eventhough lex/yacc is available, it fails as the library
name for lex is not what is expected.

library for lex should be "-lfl" instead of "-ll".

+ echo 'Compiling test case lex'
+ do_cc -D_GNU_SOURCE -include config-host.h -o
/tmp/fio-conf-1068-8707-30378.exe /tmp/fio-conf-10872-8707-1500.c -ll
-lnuma -lrt -laio -lz
+ echo gcc -D_GNU_SOURCE -include config-host.h -o
/tmp/fio-conf-1068-8707-30378.exe /tmp/fio-conf-10872-8707-1500.c -ll
-lnuma -lrt -laio -lz
+ gcc -D_GNU_SOURCE -include config-host.h -o
/tmp/fio-conf-1068-8707-30378.exe /tmp/fio-conf-10872-8707-1500.c -ll
-lnuma -lrt -laio -lz
+ return 1
+ arith=no
+ echo 'lex/yacc for arithmetic       no'

The following fixes the issue:
------------------------
--- configure.old       2015-04-16 06:19:44.016796602 -0400
+++ configure   2015-04-16 06:19:55.272796870 -0400
@@ -1420,8 +1420,8 @@ int main(int argc, char **argv)
   return 0;
 }
 EOF
-if compile_prog "" "-ll" "lex"; then
-  LIBS="-ll $LIBS"
+if compile_prog "" "-lfl" "lex"; then
+  LIBS="-lfl $LIBS"
 else
   arith="no"
 fi
-------------------

lex/yacc for arithmetic       yes

-- 
Srinivasa R Chamarthy
