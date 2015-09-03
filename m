Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:34613 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbbICTul (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 3 Sep 2015 15:50:41 -0400
Received: by qkfq186 with SMTP id q186so72284qkf.1
        for <fio@vger.kernel.org>; Thu, 03 Sep 2015 12:50:41 -0700 (PDT)
From: Ken Raeburn <raeburn@permabit.com>
Subject: failing to flush cache
Date: Thu, 03 Sep 2015 15:50:38 -0400
Message-ID: <6eio7rqo35.fsf@just-testing.permabit.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

--=-=-=
Content-Type: text/plain


I've hit a couple test failures where fio quickly died thusly:

    fio 2.0.7
    Starting 1 thread
    fio: pid=6196, err=11/file:filesetup.c:404, func=invalidate_cache, error=Resource temporarily unavailable

(Yeah, we're a little behind. But I think the relevant code is similar.)

We're testing against Linux (RHEL 6.6) multipath block devices, and it
appears that at the time the fio test starts, the multipath maps for
those devices may still be in flux. I poked around a bit with systemtap,
and it appears that while updating the maps, multipathd "suspends" its
multipath device for a few tens of milliseconds, and the kernel
multipath code rejects ioctl calls with EAGAIN if the device is
suspended. It's a small window, but we've managed to hit it multiple
times, though it's not reliably reproducible.

I know the current sources treat failure here as non-fatal, but if we're
using fio for performance tests, trying a little harder to do the
invalidation seems like a good idea. My approach is to add a retry loop
in __file_invalidate_cache; a patch is attached.

It could also be pushed down into blockdev_invalidate_cache, where it
could be local to the Linux (and Android?) implementation, since none of
the others actually do anything. (They return either EAGAIN or zero,
both of which are taken as success indicators.)

Ken


--=-=-=
Content-Type: text/x-diff
Content-Disposition: attachment; filename=fio-invalidate.patch
Content-Description: invalidate_cache retry loop

==== //eng/albireo/src/c++/third/fio/filesetup.c#3 - /permabit/user/raeburn/alb-9/src/c++/third/fio/filesetup.c ====
--- /tmp/tmp.32669.54	2015-09-02 20:22:17.000000000 -0400
+++ /permabit/user/raeburn/alb-9/src/c++/third/fio/filesetup.c	2015-09-02 20:21:27.511490391 -0400
@@ -388,7 +388,18 @@
 	} else if (f->filetype == FIO_TYPE_FILE) {
 		ret = posix_fadvise(f->fd, off, len, POSIX_FADV_DONTNEED);
 	} else if (f->filetype == FIO_TYPE_BD) {
+		int retry_count = 0;
 		ret = blockdev_invalidate_cache(f);
+		while (ret < 0 && errno == EAGAIN && retry_count++ < 25) {
+			/*
+			 * Linux multipath devices reject ioctl while
+			 * the maps are being updated. That window can
+			 * last tens of milliseconds; we'll try up to
+			 * a quarter of a second.
+			 */
+			usleep(10000);
+			ret = blockdev_invalidate_cache(f);
+		}
 		if (ret < 0 && errno == EACCES && geteuid()) {
 			if (!root_warn) {
 				log_err("fio: only root may flush block "

--=-=-=--
