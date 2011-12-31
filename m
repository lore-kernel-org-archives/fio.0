Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40980 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab1LaKQo (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 31 Dec 2011 05:16:44 -0500
Received: by iaeh11 with SMTP id h11so26592016iae.19
        for <fio@vger.kernel.org>; Sat, 31 Dec 2011 02:16:43 -0800 (PST)
From: Zhu Yanhai <zhu.yanhai@gmail.com>
Subject: [PATCH] Fix a typo
Date: Sat, 31 Dec 2011 18:16:36 +0800
Message-Id: <1325326596-19908-1-git-send-email-gaoyang.zyh@taobao.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Zhu Yanhai <gaoyang.zyh@taobao.com>

The man page line of 'fadvise_hit' is exactly opposite to its true meaning.

Signed-off-by: Zhu Yanhai <gaoyang.zyh@taobao.com>

diff --git a/fio.1 b/fio.1
index aeba39a..75c8ec6 100644
--- a/fio.1
+++ b/fio.1
@@ -281,7 +281,7 @@ because ZFS doesn't support it. Default: 'posix'.
 .RE
 .TP
 .BI fadvise_hint \fR=\fPbool
-Disable use of \fIposix_fadvise\fR\|(2) to advise the kernel what I/O patterns
+Use of \fIposix_fadvise\fR\|(2) to advise the kernel what I/O patterns
 are likely to be issued. Default: true.
 .TP
 .BI size \fR=\fPint
-- 
1.7.4.1

