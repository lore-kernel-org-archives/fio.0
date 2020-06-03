Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgFCMAW (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 3 Jun 2020 08:00:22 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93930C08C5C0
        for <fio@vger.kernel.org>; Wed,  3 Jun 2020 05:00:21 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jgS3w-0006E6-PB
        for fio@vger.kernel.org; Wed, 03 Jun 2020 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200603120002.4679A1BC0173@kernel.dk>
Date: Wed,  3 Jun 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2f6cbfdcf0ce3b53e83713e3a6b5a0bb6a76a1e9:

  Merge branch 'pshared1' of https://github.com/kusumi/fio (2020-05-29 08:16:10 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 63a4b9cca4ba3aa4101051402cbbe946ced17a49:

  gfio: don't have multiple versions of main_ui (2020-06-02 08:20:03 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      gfio: don't have multiple versions of main_ui

 gfio.c | 4 +++-
 gfio.h | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/gfio.c b/gfio.c
index 28053968..734651b6 100644
--- a/gfio.c
+++ b/gfio.c
@@ -38,6 +38,8 @@
 #include "gclient.h"
 #include "graph.h"
 
+struct gui main_ui;
+
 static bool gfio_server_running;
 static unsigned int gfio_graph_limit = 100;
 
@@ -223,7 +225,7 @@ static void update_button_states(struct gui *ui, struct gui_entry *ge)
 	switch (ge->state) {
 	default:
 		gfio_report_error(ge, "Bad client state: %u\n", ge->state);
-		/* fall through to new state */
+		/* fall-through */
 	case GE_STATE_NEW:
 		connect_state = 1;
 		edit_state = 1;
diff --git a/gfio.h b/gfio.h
index aa14e3c7..2bf0ea24 100644
--- a/gfio.h
+++ b/gfio.h
@@ -78,7 +78,9 @@ struct gui {
 	int handler_running;
 
 	GHashTable *ge_hash;
-} main_ui;
+};
+
+extern struct gui main_ui;
 
 enum {
 	GE_STATE_NEW = 1,

