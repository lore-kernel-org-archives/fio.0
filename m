Return-Path: <fio-owner@vger.kernel.org>
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46084 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728558AbgKFWHg (ORCPT
        <rfc822;fio@vger.kernel.org>); Fri, 6 Nov 2020 17:07:36 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDFCD1006700
        for <fio@vger.kernel.org>; Fri,  6 Nov 2020 22:07:32 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B879D21ECD
        for <fio@vger.kernel.org>; Fri,  6 Nov 2020 22:07:32 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH, RFC] list all available dynamic ioengines with --enghelp
Message-ID: <30a0bc27-4938-0ef3-ffa9-5e06fb8efb3c@redhat.com>
Date: Fri, 6 Nov 2020 16:07:32 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

When dynamic engines are enabled, "fio --enghelp" does not list all
available engines as the man page says it will:

	If no ioengine is given, list all available ioengines.

Fix this by opening FIO_EXT_ENG_DIR and attempting dlopen_ioengine
everything that's found there.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(not sure if I'm DTRT with thread_data here ...)

diff --git a/ioengines.c b/ioengines.c
index fb59349a..c688dd1d 100644
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
 


