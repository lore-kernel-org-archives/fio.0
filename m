Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:41392 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbbKLNAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 12 Nov 2015 08:00:07 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZwrTx-0004uJ-TT
	for fio@vger.kernel.org; Thu, 12 Nov 2015 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151112130002.868982C00CE@kernel.dk>
Date: Thu, 12 Nov 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ced5db250347606cbd966d28cd193cc9f0880dff:

  Fix verification error with bsrange and split read/write phase (2015-11-10 18:13:40 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 236d24dff4826a469d2e980c2b71c2adba3b907e:

  json output fixups (2015-11-11 11:26:37 -0700)

----------------------------------------------------------------
Vincent Fu (1):
      json output fixups

 diskutil.c | 2 +-
 idletime.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/diskutil.c b/diskutil.c
index f83fc47..c3181b5 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -714,7 +714,7 @@ void show_disk_util(int terse, struct json_object *parent,
 
 	if (output_format & FIO_OUTPUT_JSON)
 		json_object_add_disk_utils(parent, &disk_list);
-	if (output_format & ~(FIO_OUTPUT_JSON)) {
+	if (output_format & ~(FIO_OUTPUT_JSON | FIO_OUTPUT_JSON_PLUS)) {
 		flist_for_each(entry, &disk_list) {
 			du = flist_entry(entry, struct disk_util, list);
 
diff --git a/idletime.c b/idletime.c
index 5cc8b65..fab43c5 100644
--- a/idletime.c
+++ b/idletime.c
@@ -481,7 +481,7 @@ void show_idle_prof_stats(int output, struct json_object *parent,
 		return;
 	}
 
-	if ((ipc.opt != IDLE_PROF_OPT_NONE) && (output == FIO_OUTPUT_JSON)) {
+	if ((ipc.opt != IDLE_PROF_OPT_NONE) && (output & FIO_OUTPUT_JSON)) {
 		if (!parent)
 			return;
 
