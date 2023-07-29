Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09D59C0015E
	for <fio@archiver.kernel.org>; Sat, 29 Jul 2023 12:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjG2MAM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 29 Jul 2023 08:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjG2MAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 29 Jul 2023 08:00:11 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C341737
        for <fio@vger.kernel.org>; Sat, 29 Jul 2023 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=j1YDzeOoKJT51+yxGhKt13aNXE1stuzsZ6hp4E5Gip8=; b=ATkJ0YExkD9KUxFAEqPeAcThhg
        9GVSxYPJIu70YVlNkeKvtQpRkXDMG6c/ibDD9/QZ4Qvu6TYaBTexFiXjtoi7eRoyWaVJpyi87dptx
        O+8eVSXxaB1dZLGfyRp0SFuIWsZW8uSORCkJGXV/0pg5kmB2kRfeML52FakUubXOlF7crXPNfbqKo
        YacEFaNYTpxGIK9gVamvcQ8aBliOkL4UkZdyK+P6OsxHvALhvLmOiIjOaV8IDu9lGK4OVkvCigdCc
        p4T7g6rjUXIiBf1BoHK+1d3iJ+8SlzjTbQ0DaUtYDpfHwA1JXScqnIl/R5L97eJ6lB7S/ABQ7qH8F
        I7qhyqxQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qPic9-0098Ec-2e
        for fio@vger.kernel.org;
        Sat, 29 Jul 2023 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 8832D1BC0151; Sat, 29 Jul 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230729120001.8832D1BC0151@kernel.dk>
Date:   Sat, 29 Jul 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 45eb1cf5ce883ae3b170f102db38204616c8e4b1:

  Merge branch 'helper_thread-fix-missing-stdbool-header' of https://github.com/dpronin/fio (2023-07-27 13:48:26 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 824912be19542f94264e485a25d37b55a9f68f0e:

  Revert "correctly free thread_data options at the topmost parent process" (2023-07-28 11:32:22 -0600)

----------------------------------------------------------------
Denis Pronin (3):
      fix missing headers in multiple files
      correctly free thread_data options at the topmost parent process
      io_uring engine: 'atomic_load_relaxed' instead of 'atomic_load_acquire'

Jens Axboe (4):
      Merge branch 'io_uring' of https://github.com/dpronin/fio
      Merge branch 'master' of https://github.com/dpronin/fio
      Merge branch 'td-eo-double-free-fix' of https://github.com/dpronin/fio
      Revert "correctly free thread_data options at the topmost parent process"

 cairo_text_helpers.c | 2 ++
 cairo_text_helpers.h | 2 ++
 engines/io_uring.c   | 4 ++--
 goptions.h           | 2 ++
 log.c                | 2 ++
 5 files changed, 10 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/cairo_text_helpers.c b/cairo_text_helpers.c
index 19fb8e03..5bdd6021 100644
--- a/cairo_text_helpers.c
+++ b/cairo_text_helpers.c
@@ -1,3 +1,5 @@
+#include "cairo_text_helpers.h"
+
 #include <cairo.h>
 #include <gtk/gtk.h>
 #include <math.h>
diff --git a/cairo_text_helpers.h b/cairo_text_helpers.h
index 014001ad..d0f52d51 100644
--- a/cairo_text_helpers.h
+++ b/cairo_text_helpers.h
@@ -1,6 +1,8 @@
 #ifndef CAIRO_TEXT_HELPERS_H
 #define CAIRO_TEXT_HELPERS_H
 
+#include <cairo.h>
+
 void draw_centered_text(cairo_t *cr, const char *font, double x, double y,
 			       double fontsize, const char *text);
 
diff --git a/engines/io_uring.c b/engines/io_uring.c
index e1abf688..b361e6a5 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -509,7 +509,7 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 
 	tail = *ring->tail;
 	next_tail = tail + 1;
-	if (next_tail == atomic_load_acquire(ring->head))
+	if (next_tail == atomic_load_relaxed(ring->head))
 		return FIO_Q_BUSY;
 
 	if (ld->cmdprio.mode != CMDPRIO_MODE_NONE)
@@ -569,7 +569,7 @@ static int fio_ioring_commit(struct thread_data *td)
 		unsigned start = *ld->sq_ring.tail - ld->queued;
 		unsigned flags;
 
-		flags = atomic_load_acquire(ring->flags);
+		flags = atomic_load_relaxed(ring->flags);
 		if (flags & IORING_SQ_NEED_WAKEUP)
 			io_uring_enter(ld, ld->queued, 0,
 					IORING_ENTER_SQ_WAKEUP);
diff --git a/goptions.h b/goptions.h
index a225a8d1..03617509 100644
--- a/goptions.h
+++ b/goptions.h
@@ -1,6 +1,8 @@
 #ifndef GFIO_OPTIONS_H
 #define GFIO_OPTIONS_H
 
+#include <gtk/gtk.h>
+
 void gopt_get_options_window(GtkWidget *window, struct gfio_client *gc);
 void gopt_init(void);
 void gopt_exit(void);
diff --git a/log.c b/log.c
index 237bac28..df58ea07 100644
--- a/log.c
+++ b/log.c
@@ -1,3 +1,5 @@
+#include "log.h"
+
 #include <unistd.h>
 #include <string.h>
 #include <stdarg.h>
