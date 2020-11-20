Return-Path: <fio-owner@vger.kernel.org>
Received: from arsenic.locationd.net ([88.99.195.146]:54604 "EHLO
        arsenic.locationd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgKTFGl (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 20 Nov 2020 00:06:41 -0500
Received: from arsenic.locationd.net (localhost.localdomain [127.0.0.1])
        by mail-int.locationd.net (Postfix) with ESMTP id 6B7BE1B60F5C
        for <fio@vger.kernel.org>; Fri, 20 Nov 2020 06:00:08 +0100 (CET)
Received: from copper (unknown [IPv6:2601:647:4a00:4a25::834])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by arsenic.locationd.net (Postfix) with ESMTPSA id 8E05B1B60F58
        for <fio@vger.kernel.org>; Fri, 20 Nov 2020 06:00:07 +0100 (CET)
From: Kushal Kumaran <kushal@locationd.net>
Subject: [RFC PATCH] error out if ENOSPC during file layout
Date: Thu, 19 Nov 2020 21:00:05 -0800
Message-ID: <87d0088vxm.fsf@copper.locationd.net>
MIME-Version: 1.0
Content-Type: text/plain
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

When I run fio with --create_only=1 and it runs out of space, it still
exits with status 0.  I could not figure out if this was intentional
(except for the fill_device case, where this is obviously the expected
behavior).

$ cat ~/fio 
[global]
ioengine=posixaio
rw=readwrite
size=2g
directory=${HOME}/mounts/testdisk
thread=1

[trivial-readwrite-1g]
$ df -h .
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop6      976M  2.6M  907M   1% /home/kushal/mounts/testdisk
$ fio ~/fio --create_only=1
trivial-readwrite-1g: (g=0): rw=rw, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=pos
ixaio, iodepth=1                                                                                     
fio-3.12
Starting 1 thread
trivial-readwrite-1g: Laying out IO file (1 file / 2048MiB)
fio: ENOSPC on laying out file, stopping


Run status group 0 (all jobs):

Disk stats (read/write):
  loop6: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
$ echo $?
0

A trivial patch for this gives me the behavior I expect.

---
 filesetup.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index f4360a6f..42c5f630 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -231,13 +231,12 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 						break;
 					log_info("fio: ENOSPC on laying out "
 						 "file, stopping\n");
-					break;
 				}
 				td_verror(td, errno, "write");
 			} else
 				td_verror(td, EIO, "write");
 
-			break;
+			goto err;
 		}
 	}
 
-- 
2.20.1

