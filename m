Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/5] skeleton: add option example
Date: Thu, 31 Aug 2017 23:13:04 +0300
Message-Id: <20170831201308.47933-2-tkusumi@tuxera.com>
In-Reply-To: <20170831201308.47933-1-tkusumi@tuxera.com>
References: <20170831201308.47933-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Add an example of ioengine specific options, which can/should exist
within each ioengine code. Also fix/add documentation.

Also see e59b9e11('move skip_bad= option to engines/mtd.c').

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO                       |  4 +++-
 engines/skeleton_external.c | 32 +++++++++++++++++++++++++++++++-
 fio.1                       |  4 +++-
 3 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/HOWTO b/HOWTO
index 3a720c3..2a70b7c 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1791,7 +1791,9 @@ I/O engine
 		**external**
 			Prefix to specify loading an external I/O engine object file. Append
 			the engine filename, e.g. ``ioengine=external:/tmp/foo.o`` to load
-			ioengine :file:`foo.o` in :file:`/tmp`.
+			ioengine :file:`foo.o` in :file:`/tmp`. The path can be either
+			absolute or relative. See :file:`engines/skeleton_external.c` for
+			details of writing an external I/O engine.
 
 
 I/O engine specific parameters
diff --git a/engines/skeleton_external.c b/engines/skeleton_external.c
index 4bebcc4..56f89f9 100644
--- a/engines/skeleton_external.c
+++ b/engines/skeleton_external.c
@@ -3,7 +3,8 @@
  *
  * Should be compiled with:
  *
- * gcc -Wall -O2 -g -shared -rdynamic -fPIC -o engine.o engine.c
+ * gcc -Wall -O2 -g -shared -rdynamic -fPIC -o skeleton_external.o skeleton_external.c
+ * (also requires -D_GNU_SOURCE -DCONFIG_STRSEP on Linux)
  *
  */
 #include <stdio.h>
@@ -13,6 +14,7 @@
 #include <assert.h>
 
 #include "../fio.h"
+#include "../optgroup.h"
 
 /*
  * The core of the module is identical to the ones included with fio,
@@ -21,6 +23,32 @@
  */
 
 /*
+ * The io engine can define its own options within the io engine source.
+ * The option member must not be at offset 0, due to the way fio parses
+ * the given option. Just add a padding pointer unless the io engine has
+ * something usable.
+ */
+struct fio_skeleton_options {
+	void *pad; /* avoid ->off1 of fio_option becomes 0 */
+	unsigned int dummy;
+};
+
+static struct fio_option options[] = {
+	{
+		.name	= "dummy",
+		.lname	= "ldummy",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct fio_skeleton_options, dummy),
+		.help	= "Set dummy",
+		.category = FIO_OPT_C_ENGINE, /* always use this */
+		.group	= FIO_OPT_G_INVALID, /* this can be different */
+	},
+	{
+		.name	= NULL,
+	},
+};
+
+/*
  * The ->event() hook is called to match an event number with an io_u.
  * After the core has called ->getevents() and it has returned eg 3,
  * the ->event() hook must return the 3 events that have completed for
@@ -140,4 +168,6 @@ struct ioengine_ops ioengine = {
 	.cleanup	= fio_skeleton_cleanup,
 	.open_file	= fio_skeleton_open,
 	.close_file	= fio_skeleton_close,
+	.options	= options,
+	.option_struct_size	= sizeof(struct fio_skeleton_options),
 };
diff --git a/fio.1 b/fio.1
index 5b63dfd..97133da 100644
--- a/fio.1
+++ b/fio.1
@@ -1572,7 +1572,9 @@ Read and write using device DAX to a persistent memory device (e.g.,
 .B external
 Prefix to specify loading an external I/O engine object file. Append
 the engine filename, e.g. `ioengine=external:/tmp/foo.o' to load
-ioengine `foo.o' in `/tmp'.
+ioengine `foo.o' in `/tmp'. The path can be either
+absolute or relative. See `engines/skeleton_external.c' in the fio source for
+details of writing an external I/O engine.
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
-- 
2.9.5


