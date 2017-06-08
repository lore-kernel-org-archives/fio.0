Return-Path: <sbates130272@gmail.com>
Return-Path: <sbates130272@gmail.com>
From: sbates@raithlin.com
Subject: [PATCH] man: Update buffer_pattern entry in man pages
Date: Thu,  8 Jun 2017 12:10:10 -0600
Message-Id: <1496945410-14579-1-git-send-email-sbates@raithlin.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: sagi@grimberg.me, logang@deltatee.com, muli@lightbitslabs.com, Stephen Bates <sbates@raithlin.com>
List-ID: <fio@vger.kernel.org>

From: Stephen Bates <sbates@raithlin.com>

Update the fio man page to reflect the new usage of buffer_pattern.

Signed-off-by: Stephen Bates <sbates@raithlin.com>
---
 fio.1 | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fio.1 b/fio.1
index e153d46..96eceaf 100644
--- a/fio.1
+++ b/fio.1
@@ -611,13 +611,20 @@ the remaining zeroed. With this set to some chunk size smaller than the block
 size, fio can alternate random and zeroed data throughout the IO buffer.
 .TP
 .BI buffer_pattern \fR=\fPstr
-If set, fio will fill the IO buffers with this pattern. If not set, the contents
-of IO buffers is defined by the other options related to buffer contents. The
-setting can be any pattern of bytes, and can be prefixed with 0x for hex
-values. It may also be a string, where the string must then be wrapped with
-"", e.g.:
+If set, fio will fill the I/O buffers with this pattern or with the contents
+of a file. If not set, the contents of I/O buffers are defined by the other
+options related to buffer contents. The setting can be any pattern of bytes,
+and can be prefixed with 0x for hex values. It may also be a string, where
+the string must then be wrapped with ``""``. Or it may also be a filename,
+where the filename must be wrapped with ``''`` in which case the file is
+opened and read. Note that not all the file contents will be read if that
+would cause the buffers to overflow. So, for example:
 .RS
 .RS
+\fBbuffer_pattern\fR='filename'
+.RS
+or
+.RE
 \fBbuffer_pattern\fR="abcd"
 .RS
 or
@@ -632,7 +639,7 @@ or
 Also you can combine everything together in any order:
 .LP
 .RS
-\fBbuffer_pattern\fR=0xdeadface"abcd"-12
+\fBbuffer_pattern\fR=0xdeadface"abcd"-12'filename'
 .RE
 .RE
 .TP
-- 
2.7.4


