Return-Path: <fio-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:19811 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbZELUIy (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 12 May 2009 16:08:54 -0400
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by acsinet12.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n4CK8hC0023235
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <fio@vger.kernel.org>; Tue, 12 May 2009 20:08:44 GMT
Received: from abhmt006.oracle.com (abhmt006.oracle.com [141.146.116.15])
	by acsinet15.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n4CK9KFe019233
	for <fio@vger.kernel.org>; Tue, 12 May 2009 20:09:20 GMT
Message-ID: <4A09D7CF.2050707@oracle.com>
Date: Tue, 12 May 2009 13:10:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
Subject: [patch] fio howto typo fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>


Fix a few typos in the fio HOWTO file.
---

 HOWTO |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -Naurp fio-20090511/HOWTO~fix512 fio-20090511/HOWTO
--- fio-20090511/HOWTO~fix512	2009-05-11 01:37:33.000000000 -0700
+++ fio-20090511/HOWTO	2009-05-12 11:25:57.000000000 -0700
@@ -230,7 +230,7 @@ description=str	Text description of the 
 		dump this text description when this job is run. It's
 		not parsed.
 
-directory=str	Prefix filenames with this directory. Used to places files
+directory=str	Prefix filenames with this directory. Used to place files
 		in a different location than "./".
 
 filename=str	Fio normally makes up a filename based on the job name,
@@ -250,7 +250,7 @@ filename=str	Fio normally makes up a fil
 opendir=str	Tell fio to recursively add any file it can find in this
 		directory and down the file system tree.
 
-lockfile=str	Fio defaults to not doing any locking files before it does
+lockfile=str	Fio defaults to not locking any files before it does
 		IO to them. If a file or file descriptor is shared, fio
 		can serialize IO to that file to make the end result
 		consistent. This is usual for emulating real workloads that
@@ -303,7 +303,7 @@ fadvise_hint=bool By default, fio will u
 size=int	The total size of file io for this job. Fio will run until
 		this many bytes has been transferred, unless runtime is
 		limited by other options (such as 'runtime', for instance).
-		Unless specific nr_files and filesize options are given,
+		Unless specific nrfiles and filesize options are given,
 		fio will divide this size between the available files
 		specified by the job.
 



-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
