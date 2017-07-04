Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/7] man: sync "JOB FILE PARAMETERS" section with HOWTO
Date: Tue,  4 Jul 2017 21:08:12 +0300
Message-Id: <20170704180816.39585-4-tkusumi@tuxera.com>
In-Reply-To: <20170704180816.39585-1-tkusumi@tuxera.com>
References: <20170704180816.39585-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This commit replaces the entire section with the corresponding section
in HOWTO, since the man page is only slightly different from HOWTO
regarding this section.

It also renames the following section names to sync with HOWTO.
  "JOB PARAMETERS" to "JOB FILE PARAMETERS"
  "JOB PARAMETERS"'s sub section "Types" to non-sub section "PARAMETER TYPES"
  "JOB PARAMETERS"'s sub section "Parameter List" to non-sub section "JOB DESCRIPTION"

Since section names aren't following the typical man page convention
(man-pages(7) in Linux) to begin with, changing the section names
to conform to HOWTO does no harm unless there's a reason to keep names
that were once made.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 fio.1 | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fio.1 b/fio.1
index b22989a..629ab01 100644
--- a/fio.1
+++ b/fio.1
@@ -184,11 +184,10 @@ argument, \-\-cmdhelp will detail the given `option`.
 See the `examples/` directory in the fio source for inspiration on how to write
 job files. Note the copyright and license requirements currently apply to
 `examples/` files.
-.SH "JOB PARAMETERS"
-.SS Types
-Some parameters may take arguments of a specific type.
-Anywhere a numeric value is required, an arithmetic expression may be used,
-provided it is surrounded by parentheses. Supported operators are:
+.SH "JOB FILE PARAMETERS"
+Some parameters take an option of a given type, such as an integer or a
+string. Anywhere a numeric value is required, an arithmetic expression may be
+used, provided it is surrounded by parentheses. Supported operators are:
 .RS
 .RS
 .TP
@@ -208,7 +207,9 @@ provided it is surrounded by parentheses. Supported operators are:
 .P
 For time values in expressions, units are microseconds by default. This is
 different than for time values not in expressions (not enclosed in
-parentheses). The types used are:
+parentheses).
+.SH "PARAMETER TYPES"
+The following parameter types are used.
 .TP
 .I str
 String: a sequence of alphanumeric characters.
@@ -299,7 +300,8 @@ sets of ranges, they are separated with a `,' or `/' character. For example:
 .I float_list
 List of floating numbers: A list of floating numbers, separated by
 a ':' character.
-.SS "Parameter List"
+.SH "JOB DESCRIPTION"
+With the above in mind, here follows the complete list of fio job parameters.
 .TP
 .BI name \fR=\fPstr
 May be used to override the job name.  On the command line, this parameter
-- 
2.9.4


