Return-Path: <fio-owner@vger.kernel.org>
Received: from postman.teamix.net ([194.150.191.120]:50416 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753149Ab3CKPbH convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 11 Mar 2013 11:31:07 -0400
Subject: [PATCH] Make test for gnuplot work with empty strings.
From: Martin Steigerwald <ms@teamix.de>
Date: Mon, 11 Mar 2013 16:22:56 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201303111622.57044.ms@teamix.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, 700580@bugs.debian.org

When I launch fio_generate_plots on a system where gnuplot is not installed I
get this error :

$ fio_generate_plots test
Making bw logs
/usr/bin/fio_generate_plots: 42: /usr/bin/fio_generate_plots: -: not found

That's because the test checking whether gnuplot is installed is failing
because of an empty variable :
GNUPLOT=$(which gnuplot)
if [ ! -x $GNUPLOT ]; then
        echo You need gnuplot installed to generate graphs
        exit 1
fi

Indeed the command "test -x" is exiting with code 0.

To correct this we should enclose the variable with quotes :
if [ ! -x "$GNUPLOT" ]; then

Then the script is going into the test properly :
$ fio_generate_plots test
You need gnuplot installed to generate graphs

I copied problem description by Hervé from the Debian bug report below.

Fixes:
Bug#700580: /usr/bin/fio_generate_plots: -: not found
http://bugs.debian.org/700580

Reported-By: Hervé Werner <hwerner@score-md.com>
Tested-By: Hervé Werner <hwerner@score-md.com>
Tested-By: Martin Steigerwald <ms@teamix.de>
---
 fio_generate_plots |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fio_generate_plots b/fio_generate_plots
index 4285415..5e2febd 100755
--- a/fio_generate_plots
+++ b/fio_generate_plots
@@ -8,7 +8,7 @@ if [ "$1"x = "x" ]; then
 fi
 
 GNUPLOT=$(which gnuplot)
-if [ ! -x $GNUPLOT ]; then
+if [ ! -x "$GNUPLOT" ]; then
 	echo You need gnuplot installed to generate graphs
 	exit 1
 fi
-- 
1.7.10.4

