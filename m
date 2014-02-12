Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout11.t-online.de ([194.25.134.85]:48533 "EHLO
	mailout11.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbaBLTOL (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 12 Feb 2014 14:14:11 -0500
From: "Daniel Gollub" <daniel.gollub@t-online.de>
Subject: [PATCH 1/2] Introduce get_ioengine for external engines
Date: Wed, 12 Feb 2014 20:13:45 +0100
Message-Id: <1392232426-16152-1-git-send-email-d.gollub@telekom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Daniel Gollub <d.gollub@telekom.de>

This makes life easier for plugins written in C++
since they do not need to deal with struct initilization issues
with the ioengine_ops symbol.

With g++ a non-static ioengine_ops in global scope like this:

struct ioengine_ops ioengine = {
        .name           = "null",
        .version        = FIO_IOOPS_VERSION,
        .queue          = fio_null_queue,
        .commit         = fio_null_commit,
};

Results in:

cpp_null2.cc: At global scope:
cpp_null2.cc:112:1: error: C99 designator ‘name’ outside aggregate initializer
cpp_null2.cc:112:1: sorry, unimplemented: non-trivial designated initializers not supported
cpp_null2.cc:112:1: sorry, unimplemented: non-trivial designated initializers not supported
cpp_null2.cc:112:1: sorry, unimplemented: non-trivial designated initializers not supported
cpp_null2.cc:112:1: sorry, unimplemented: non-trivial designated initializers not supported
$

Example get_iongine() symbol usage:

---8<---
extern "C" {
void get_ioengine(struct ioengine_ops **ioengine_ptr) {
        struct ioengine_ops *ioengine;
        *ioengine_ptr = (struct ioengine_ops *) malloc(sizeof(struct ioengine_ops));
        ioengine = *ioengine_ptr;

        strcpy(ioengine->name, "cpp_null");
        ioengine->version        = FIO_IOOPS_VERSION;
        ioengine->queue          = fio_null_queue;
        ioengine->commit         = fio_null_commit;
        ioengine->getevents      = fio_null_getevents;
        ioengine->event          = fio_null_event;
        ioengine->init           = fio_null_init;
        ioengine->cleanup        = fio_null_cleanup;
        ioengine->open_file      = fio_null_open;
        ioengine->flags          = FIO_DISKLESSIO;
}
}
--->8---

Signed-off-by: Daniel Gollub <d.gollub@telekom.de>
---
 ioengines.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/ioengines.c b/ioengines.c
index d71e372..c080da3 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -90,6 +90,7 @@ static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 {
 	struct ioengine_ops *ops;
 	void *dlhandle;
+	typedef void (*get_ioengine_t)(struct ioengine_ops **);
 
 	dprint(FD_IO, "dload engine %s\n", engine_lib);
 
@@ -107,6 +108,19 @@ static struct ioengine_ops *dlopen_ioengine(struct thread_data *td,
 	ops = dlsym(dlhandle, engine_lib);
 	if (!ops)
 		ops = dlsym(dlhandle, "ioengine");
+
+	/*
+	 * For some external engines (like C++ ones) it is not that trivial
+	 * to provide a non-static ionengine structure that we can reference.
+	 * Instead we call a method which allocates the required ioengine
+	 * structure.
+	 */
+	if (!ops) {
+		get_ioengine_t get_ioengine = dlsym(dlhandle, "get_ioengine");
+		if (get_ioengine)
+			get_ioengine(&ops);
+	}
+
 	if (!ops) {
 		td_vmsg(td, -1, dlerror(), "dlsym");
 		dlclose(dlhandle);
-- 
1.7.10.4

