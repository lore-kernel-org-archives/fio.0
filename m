Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/5] fix load_ioengine() not to support no "external:" prefix
Date: Thu, 31 Aug 2017 23:13:07 +0300
Message-Id: <20170831201308.47933-5-tkusumi@tuxera.com>
In-Reply-To: <20170831201308.47933-1-tkusumi@tuxera.com>
References: <20170831201308.47933-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

To load ioengines, it should be done by either
 1) find the ioengine from the existing (static linked) ioengines or
 2) dlopen the path in case of external ioengine,

but not to do 2 if 1 failed, as fio doesn't expect an ioengine to be
dynamically loaded unless with "external:" prefix by design.

The current implementation (i.e. do 2 if 1 failed) happened to have
been able to load an external ioengine with below syntax without
"external:" prefix, but this is a bug rather than a feature.

(--)ioengine=./engines/skeleton_external.so

The design of the external ioengine option since below commits in 2007
 7b395ca5('Prefix external io engine loading with 'external'')
 8a7bd877('Document loading external io engines')
is to use "external:/path/to/so" syntax.

This commit fixes above bug, which also potentially avoids the case
where "/path/to/so" within the given "external:/path/to/so" happens
to match the existing name, though this is normally unlikely to happen.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 ioengines.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/ioengines.c b/ioengines.c
index 54aa5a6..0c631e8 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -125,26 +125,29 @@ static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 
 struct ioengine_ops *load_ioengine(struct thread_data *td)
 {
-	struct ioengine_ops *ops;
-	char engine[64];
-	char *name;
-
-	name = td->o.ioengine_so_path ?: td->o.ioengine;
+	struct ioengine_ops *ops = NULL;
+	const char *name = NULL;
 
-	dprint(FD_IO, "load ioengine %s\n", name);
+	if (strcmp(td->o.ioengine, "external")) {
+		char engine[64];
 
-	engine[sizeof(engine) - 1] = '\0';
-	strncpy(engine, name, sizeof(engine) - 1);
+		name = td->o.ioengine;
+		engine[sizeof(engine) - 1] = '\0';
+		strncpy(engine, name, sizeof(engine) - 1);
 
-	/*
-	 * linux libaio has alias names, so convert to what we want
-	 */
-	if (!strncmp(engine, "linuxaio", 8) || !strncmp(engine, "aio", 3))
-		strcpy(engine, "libaio");
+		/*
+		 * linux libaio has alias names, so convert to what we want
+		 */
+		if (!strncmp(engine, "linuxaio", 8) || !strncmp(engine, "aio", 3))
+			strcpy(engine, "libaio");
 
-	ops = find_ioengine(engine);
-	if (!ops)
+		dprint(FD_IO, "load ioengine %s\n", engine);
+		ops = find_ioengine(engine);
+	} else if (td->o.ioengine_so_path) {
+		name = td->o.ioengine_so_path;
 		ops = dlopen_ioengine(td, name);
+	} else
+		log_err("fio: missing external ioengine path\n");
 
 	if (!ops) {
 		log_err("fio: engine %s not loadable\n", name);
-- 
2.9.5


