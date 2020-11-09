Return-Path: <fio-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43460 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbgKIQqp (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 9 Nov 2020 11:46:45 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/3] list all available dynamic ioengines with --enghelp
Date: Mon,  9 Nov 2020 10:46:30 -0600
Message-Id: <1604940390-21215-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1604940390-21215-1-git-send-email-sandeen@redhat.com>
References: <1604940390-21215-1-git-send-email-sandeen@redhat.com>
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: sitsofe@yahoo.com, ykorman@gmail.com, rjones@redhat.com

When dynamic engines are enabled, "fio --enghelp" does not list all
available engines as the man page says it will:

	If no ioengine is given, list all available ioengines.

Fix this by opening FIO_EXT_ENG_DIR and attempting dlopen_ioengine
everything that's found there.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 ioengines.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/ioengines.c b/ioengines.c
index fb59349..c688dd1 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -15,6 +15,8 @@
 #include <dlfcn.h>
 #include <fcntl.h>
 #include <assert.h>
+#include <sys/types.h>
+#include <dirent.h>
 
 #include "fio.h"
 #include "diskutil.h"
@@ -630,6 +632,34 @@ int td_io_get_file_size(struct thread_data *td, struct fio_file *f)
 	return td->io_ops->get_file_size(td, f);
 }
 
+#ifdef CONFIG_DYNAMIC_ENGINES
+/* Load all dynamic engines in FIO_EXT_ENG_DIR for enghelp command */
+static void
+fio_load_dynamic_engines(struct thread_data *td)
+{
+	DIR *dirhandle = NULL;
+	struct dirent *dirent = NULL;
+	char engine_path[PATH_MAX];
+
+	dirhandle = opendir(FIO_EXT_ENG_DIR);
+	if (!dirhandle)
+		return;
+
+	while ((dirent = readdir(dirhandle)) != NULL) {
+		if (!strcmp(dirent->d_name, ".") ||
+		    !strcmp(dirent->d_name, ".."))
+			continue;
+
+		sprintf(engine_path, "%s/%s", FIO_EXT_ENG_DIR, dirent->d_name);
+		dlopen_ioengine(td, engine_path);
+	}
+
+	closedir(dirhandle);
+}
+#else
+#define fio_load_dynamic_engines(td) do { } while (0)
+#endif
+
 int fio_show_ioengine_help(const char *engine)
 {
 	struct flist_head *entry;
@@ -638,8 +668,11 @@ int fio_show_ioengine_help(const char *engine)
 	char *sep;
 	int ret = 1;
 
+	memset(&td, 0, sizeof(struct thread_data));
+
 	if (!engine || !*engine) {
 		log_info("Available IO engines:\n");
+		fio_load_dynamic_engines(&td);
 		flist_for_each(entry, &engine_list) {
 			io_ops = flist_entry(entry, struct ioengine_ops, list);
 			log_info("\t%s\n", io_ops->name);
@@ -652,7 +685,6 @@ int fio_show_ioengine_help(const char *engine)
 		sep++;
 	}
 
-	memset(&td, 0, sizeof(struct thread_data));
 	td.o.ioengine = (char *)engine;
 	io_ops = load_ioengine(&td);
 
-- 
1.8.3.1


