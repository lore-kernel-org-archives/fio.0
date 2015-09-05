Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37296 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbbIERBU (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 5 Sep 2015 13:01:20 -0400
Received: by wicfx3 with SMTP id fx3so45035251wic.0
        for <fio@vger.kernel.org>; Sat, 05 Sep 2015 10:01:19 -0700 (PDT)
From: Roman Pen <r.peniaev@gmail.com>
Subject: [PATCH 1/2] fio.1: update description for 'buffer_pattern' and 'verify_pattern'
Date: Sat,  5 Sep 2015 19:01:01 +0200
Message-Id: <1441472462-5344-1-git-send-email-r.peniaev@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 
Cc: Roman Pen <r.peniaev@gmail.com>, fio@vger.kernel.org

Now those two support combined input and 'verify_pattern' supports '%o' format.
Update corresponding doc.

Signed-off-by: Roman Pen <r.peniaev@gmail.com>
Cc: fio@vger.kernel.org
---
 fio.1 | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/fio.1 b/fio.1
index 5f8e948..7c13409 100644
--- a/fio.1
+++ b/fio.1
@@ -507,7 +507,26 @@ If set, fio will fill the IO buffers with this pattern. If not set, the contents
 of IO buffers is defined by the other options related to buffer contents. The
 setting can be any pattern of bytes, and can be prefixed with 0x for hex
 values. It may also be a string, where the string must then be wrapped with
-"".
+"", e.g.:
+.RS
+.RS
+\fBbuffer_pattern\fR="abcd"
+.RS
+or
+.RE
+\fBbuffer_pattern\fR=-12
+.RS
+or
+.RE
+\fBbuffer_pattern\fR=0xdeadface
+.RE
+.LP
+Also you can combine everything together in any order:
+.LP
+.RS
+\fBbuffer_pattern\fR=0xdeadface"abcd"-12
+.RE
+.RE
 .TP
 .BI dedupe_percentage \fR=\fPint
 If set, fio will generate this percentage of identical buffers when writing.
@@ -1167,7 +1186,19 @@ pattern for io verification purposes. Depending on the width of the pattern,
 fio will fill 1/2/3/4 bytes of the buffer at the time(it can be either a
 decimal or a hex number). The verify_pattern if larger than a 32-bit quantity
 has to be a hex number that starts with either "0x" or "0X". Use with
-\fBverify\fP=meta or \fBverify\fP=pattern.
+\fBverify\fP=meta or \fBverify\fP=pattern. Also, verify_pattern supports %o
+format, which means that for each block offset will be written and then
+verifyied back, e.g.:
+.RS
+.RS
+\fBverify_pattern\fR=%o
+.RE
+Or use combination of everything:
+.LP
+.RS
+\fBverify_pattern\fR=0xff%o"abcd"-21
+.RE
+.RE
 .TP
 .BI verify_fatal \fR=\fPbool
 If true, exit the job on the first observed verification failure.  Default:
-- 
2.5.1

