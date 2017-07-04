Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 2/7] man: sync "JOB FILE FORMAT" section with HOWTO
Date: Tue,  4 Jul 2017 21:08:11 +0300
Message-Id: <20170704180816.39585-3-tkusumi@tuxera.com>
In-Reply-To: <20170704180816.39585-1-tkusumi@tuxera.com>
References: <20170704180816.39585-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This commit brings in updates from HOWTO to man page. As a result it
replaces some entire paragraphs with the corresponding ones in HOWTO,
though not much difference for the replaced part as it only had small
modification basically saying the same thing.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 fio.1 | 39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/fio.1 b/fio.1
index 016fb67..b22989a 100644
--- a/fio.1
+++ b/fio.1
@@ -160,21 +160,30 @@ Set this command as remote trigger.
 .BI \-\-aux-path \fR=\fPpath
 Use this path for fio state generated files.
 .SH "JOB FILE FORMAT"
-Job files are in `ini' format. They consist of one or more
-job definitions, which begin with a job name in square brackets and
-extend to the next job name.  The job name can be any ASCII string
-except `global', which has a special meaning.  Following the job name is
-a sequence of zero or more parameters, one per line, that define the
-behavior of the job.  Any line starting with a `;' or `#' character is
-considered a comment and ignored.
-.P
-If \fIjobfile\fR is specified as `-', the job file will be read from
-standard input.
-.SS "Global Section"
-The global section contains default parameters for jobs specified in the
-job file.  A job is only affected by global sections residing above it,
-and there may be any number of global sections.  Specific job definitions
-may override any parameter set in global sections.
+Any parameters following the options will be assumed to be job files, unless
+they match a job file parameter. Multiple job files can be listed and each job
+file will be regarded as a separate group. Fio will `stonewall` execution
+between each group.
+
+Fio accepts one or more job files describing what it is
+supposed to do. The job file format is the classic ini file, where the names
+enclosed in [] brackets define the job name. You are free to use any ASCII name
+you want, except *global* which has special meaning. Following the job name is
+a sequence of zero or more parameters, one per line, that define the behavior of
+the job. If the first character in a line is a ';' or a '#', the entire line is
+discarded as a comment.
+
+A *global* section sets defaults for the jobs described in that file. A job may
+override a *global* section parameter, and a job file may even have several
+*global* sections if so desired. A job is only affected by a *global* section
+residing above it.
+
+The \-\-cmdhelp option also lists all options. If used with an `option`
+argument, \-\-cmdhelp will detail the given `option`.
+
+See the `examples/` directory in the fio source for inspiration on how to write
+job files. Note the copyright and license requirements currently apply to
+`examples/` files.
 .SH "JOB PARAMETERS"
 .SS Types
 Some parameters may take arguments of a specific type.
-- 
2.9.4


