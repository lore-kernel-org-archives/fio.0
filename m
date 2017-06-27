Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH] man page: add offset unit info for offset= option
Date: Tue, 27 Jun 2017 18:20:07 +0300
Message-Id: <20170627152007.14839-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Apply below commit to fio(1) man page.
82dbb8cb (HOWTO: add offset unit info for offset= option)

Certain sections/options of the man page are not in sync with HOWTO,
but this one was identical, thus the changes are the same as above.

--
On 06/27/2017 08:56 AM, Elliott, Robert (Persistent Memory) wrote:
>>  HOWTO | 8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> The manpage (fio.1) should be updated as well - that's more visible to users.
Agree, I usually catch that.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 fio.1 | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fio.1 b/fio.1
index 6a6ea1b..ac87c9d 100644
--- a/fio.1
+++ b/fio.1
@@ -911,11 +911,13 @@ If true, use buffered I/O.  This is the opposite of the \fBdirect\fR parameter.
 Default: true.
 .TP
 .BI offset \fR=\fPint
-Start I/O at the provided offset in the file, given as either a fixed size or a
-percentage. If a percentage is given, the next \fBblockalign\fR-ed offset will
-be used. Data before the given offset will not be touched. This effectively
-caps the file size at (real_size - offset). Can be combined with \fBsize\fR to
-constrain the start and end range of the I/O workload.
+Start I/O at the provided offset in the file, given as either a fixed size in
+bytes or a percentage. If a percentage is given, the next \fBblockalign\fR-ed
+offset will be used. Data before the given offset will not be touched. This
+effectively caps the file size at (real_size - offset). Can be combined with
+\fBsize\fR to constrain the start and end range of the I/O workload. A percentage
+can be specified by the percentage number plus 1 with preceding '-'. For example,
+-1 is parsed as 0%, -10 is parsed as 9%, -101 is parsed as 100%.
 .TP
 .BI offset_increment \fR=\fPint
 If this is provided, then the real offset becomes the
-- 
2.9.4


