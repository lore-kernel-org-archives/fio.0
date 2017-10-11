Return-Path: <josef@toxicpanda.com>
Return-Path: <josef@toxicpanda.com>
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 2/2] add documentation about filename_format directory behavior
Date: Wed, 11 Oct 2017 16:15:19 -0400
Message-Id: <1507752919-14323-2-git-send-email-josef@toxicpanda.com>
In-Reply-To: <1507752919-14323-1-git-send-email-josef@toxicpanda.com>
References: <1507752919-14323-1-git-send-email-josef@toxicpanda.com>
To: axboe@kernel.dk, fio@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
List-ID: <fio@vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

We've changed the behavior of filename_format, document that fact.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 HOWTO | 7 +++++++
 fio.1 | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/HOWTO b/HOWTO
index d3f957bf4db7..a1513e1259f7 100644
--- a/HOWTO
+++ b/HOWTO
@@ -795,6 +795,13 @@ Target file/device
 	named :file:`testfiles.4`. The default of :file:`$jobname.$jobnum.$filenum`
 	will be used if no other format specifier is given.
 
+	If you specify a path then the directories will be created up to the
+	main directory for the file.  So for example if you specify
+	``filename_format=a/b/c/$jobnum`` then the directories a/b/c will be
+	created before the file setup part of the job.  If you specify
+	:option:`directory` then the path will be relative that directory,
+	otherwise it is treated as the absolute path.
+
 .. option:: unique_filename=bool
 
 	To avoid collisions between networked clients, fio defaults to prefixing any
diff --git a/fio.1 b/fio.1
index 6e7d1f8b1e46..7787ef29c2b3 100644
--- a/fio.1
+++ b/fio.1
@@ -578,6 +578,12 @@ fio generate filenames that are shared between the two. For instance, if
 `testfiles.$filenum' is specified, file number 4 for any job will be
 named `testfiles.4'. The default of `$jobname.$jobnum.$filenum'
 will be used if no other format specifier is given.
+.P
+If you specify a path then the directories will be created up to the main
+directory for the file.  So for example if you specify `a/b/c/$jobnum` then the
+directories a/b/c will be created before the file setup part of the job.  If you
+specify \fBdirectory\fR then the path will be relative that directory, otherwise
+it is treated as the absolute path.
 .RE
 .TP
 .BI unique_filename \fR=\fPbool
-- 
2.7.4


