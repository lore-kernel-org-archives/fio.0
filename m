Return-Path: <fio-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:6600 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752168AbdFMTmn (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Jun 2017 15:42:43 -0400
From: Jim Harris <james.r.harris@intel.com>
Subject: [PATCH] set td->io_ops to NULL before dlclose()
Date: Tue, 13 Jun 2017 12:45:42 -0700
Message-Id: <20170613194542.136566-1-james.r.harris@intel.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Jim Harris <james.r.harris@intel.com>

If using ioengine=/path/to/ioengine to dynamically load
an ioengine, there is a race between free_ioengine()'s
dlclose() and the td->io_ops dereference in reap_threads().

To resolve, td->io_ops must be set to NULL before calling
dlclose() - this ensures the name check in reap_threads()
does not try to reference memory no longer accessible due
to the ioengine getting closed.

Signed-off-by: Jim Harris <james.r.harris@intel.com>
---
 ioengines.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ioengines.c b/ioengines.c
index c90a2ca5..6caf73da 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -170,10 +170,10 @@ void free_ioengine(struct thread_data *td)
 		td->eo = NULL;
 	}
 
+	td->io_ops = NULL;
+
 	if (td->io_ops_dlhandle)
 		dlclose(td->io_ops_dlhandle);
-
-	td->io_ops = NULL;
 }
 
 void close_ioengine(struct thread_data *td)
-- 
2.12.2

