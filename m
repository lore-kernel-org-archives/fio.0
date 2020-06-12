Return-Path: <phillip.a.chen@seagate.com>
From: Phillip Chen <phillip.a.chen@seagate.com>
Subject: [PATCH] Priority bit log file format documentation update
Date: Fri, 12 Jun 2020 12:30:24 -0600
Message-Id: <20200612183024.16159-1-phillip.a.chen@seagate.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: axboe@kernel.dk, phillip.a.chen@seagate.com
Cc: fio@vger.kernel.org, sitsofe@yahoo.com
List-ID: <fio@vger.kernel.org>

Updates the description of log file formats to include and
describe the priority bit entry.

Signed-off-by: Phillip Chen <phillip.a.chen@seagate.com>
---
 HOWTO | 5 ++++-
 fio.1 | 6 +++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/HOWTO b/HOWTO
index 9e339bb8..8cf8d650 100644
--- a/HOWTO
+++ b/HOWTO
@@ -4165,7 +4165,7 @@ Fio supports a variety of log file formats, for logging latencies, bandwidth,
 and IOPS. The logs share a common format, which looks like this:
 
     *time* (`msec`), *value*, *data direction*, *block size* (`bytes`),
-    *offset* (`bytes`)
+    *offset* (`bytes`), *command priority*
 
 *Time* for the log entry is always in milliseconds. The *value* logged depends
 on the type of log, it will be one of the following:
@@ -4190,6 +4190,9 @@ The entry's *block size* is always in bytes. The *offset* is the position in byt
 from the start of the file for that particular I/O. The logging of the offset can be
 toggled with :option:`log_offset`.
 
+*Command priority* is 0 for normal priority and 1 for high priority. This is controlled
+by the ioengine specific :option:`cmdprio_percentage`.
+
 Fio defaults to logging every individual I/O but when windowed logging is set
 through :option:`log_avg_msec`, either the average (by default) or the maximum
 (:option:`log_max_value` is set) *value* seen over the specified period of time
diff --git a/fio.1 b/fio.1
index f469c46e..f134e0bf 100644
--- a/fio.1
+++ b/fio.1
@@ -3863,7 +3863,8 @@ Fio supports a variety of log file formats, for logging latencies, bandwidth,
 and IOPS. The logs share a common format, which looks like this:
 .RS
 .P
-time (msec), value, data direction, block size (bytes), offset (bytes)
+time (msec), value, data direction, block size (bytes), offset (bytes),
+command priority
 .RE
 .P
 `Time' for the log entry is always in milliseconds. The `value' logged depends
@@ -3897,6 +3898,9 @@ The entry's `block size' is always in bytes. The `offset' is the position in byt
 from the start of the file for that particular I/O. The logging of the offset can be
 toggled with \fBlog_offset\fR.
 .P
+`Command priority` is 0 for normal priority and 1 for high priority. This is controlled
+by the ioengine specific \fBcmdprio_percentage\fR.
+.P
 Fio defaults to logging every individual I/O but when windowed logging is set
 through \fBlog_avg_msec\fR, either the average (by default) or the maximum
 (\fBlog_max_value\fR is set) `value' seen over the specified period of time
-- 
2.21.0


