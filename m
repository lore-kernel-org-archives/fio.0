Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 5/7] man: refer to REPORTING-BUGS for bug reporting
Date: Tue,  4 Jul 2017 21:08:14 +0300
Message-Id: <20170704180816.39585-6-tkusumi@tuxera.com>
In-Reply-To: <20170704180816.39585-1-tkusumi@tuxera.com>
References: <20170704180816.39585-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

REPORTING-BUGS should be mentioned here rather than README, provided
REPORTING-BUGS also mentions to see README for the mailing list
in addition to details of bug reporting.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 README | 3 ++-
 fio.1  | 5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/README b/README
index ec3e9c0..a6eba8f 100644
--- a/README
+++ b/README
@@ -59,7 +59,8 @@ Mailing list
 ------------
 
 The fio project mailing list is meant for anything related to fio including
-general discussion, bug reporting, questions, and development.
+general discussion, bug reporting, questions, and development. For bug reporting,
+see REPORTING-BUGS.
 
 An automated mail detailing recent commits is automatically sent to the list at
 most daily. The list address is fio@vger.kernel.org, subscribe by sending an
diff --git a/fio.1 b/fio.1
index 1fd928f..bc477a2 100644
--- a/fio.1
+++ b/fio.1
@@ -2713,7 +2713,10 @@ This man page was written by Aaron Carroll <aaronc@cse.unsw.edu.au> based
 on documentation by Jens Axboe.
 .SH "REPORTING BUGS"
 Report bugs to the \fBfio\fR mailing list <fio@vger.kernel.org>.
-See \fBREADME\fR.
+.br
+See \fBREPORTING-BUGS\fR.
+
+\fBREPORTING-BUGS\fR: http://git.kernel.dk/cgit/fio/plain/REPORTING-BUGS
 .SH "SEE ALSO"
 For further documentation see \fBHOWTO\fR and \fBREADME\fR.
 .br
-- 
2.9.4


