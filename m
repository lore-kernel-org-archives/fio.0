Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yh0-f44.google.com ([209.85.213.44]:38220 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbbACOVU (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 3 Jan 2015 09:21:20 -0500
Received: by mail-yh0-f44.google.com with SMTP id c41so9508702yho.3
        for <fio@vger.kernel.org>; Sat, 03 Jan 2015 06:21:19 -0800 (PST)
From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH] axmap: fix deadlock
Date: Sat,  3 Jan 2015 22:21:09 +0800
Message-Id: <1420294869-3830-1-git-send-email-ming.lei@canonical.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, fio@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Ming Lei <ming.lei@canonical.com>

axmap_first_free() is always called with axmap->lock held,
so needn't to acquire the lock inside the function.

The deadlock is introduced in commit 12bde3697fc230d7a(axmap:
ensure we lock down the maps for shared access).

Given axmap_first_free() is only called inside lib/axmap.c,
this patch declares the function as static. In the future,
if external users need the function, axmap lock can be
considered at that time.

Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 lib/axmap.c |    4 +---
 lib/axmap.h |    1 -
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/lib/axmap.c b/lib/axmap.c
index e847a38..8247fc1 100644
--- a/lib/axmap.c
+++ b/lib/axmap.c
@@ -387,17 +387,15 @@ static uint64_t axmap_find_first_free(struct axmap *axmap, unsigned int level,
 	return (uint64_t) -1ULL;
 }
 
-uint64_t axmap_first_free(struct axmap *axmap)
+static uint64_t axmap_first_free(struct axmap *axmap)
 {
 	uint64_t ret;
 
 	if (firstfree_valid(axmap))
 		return axmap->first_free;
 
-	fio_mutex_down(&axmap->lock);
 	ret = axmap_find_first_free(axmap, axmap->nr_levels - 1, 0);
 	axmap->first_free = ret;
-	fio_mutex_up(&axmap->lock);
 
 	return ret;
 }
diff --git a/lib/axmap.h b/lib/axmap.h
index edfeba8..3705a1d 100644
--- a/lib/axmap.h
+++ b/lib/axmap.h
@@ -11,7 +11,6 @@ void axmap_clear(struct axmap *axmap, uint64_t bit_nr);
 void axmap_set(struct axmap *axmap, uint64_t bit_nr);
 unsigned int axmap_set_nr(struct axmap *axmap, uint64_t bit_nr, unsigned int nr_bits);
 int axmap_isset(struct axmap *axmap, uint64_t bit_nr);
-uint64_t axmap_first_free(struct axmap *axmap);
 uint64_t axmap_next_free(struct axmap *axmap, uint64_t bit_nr);
 void axmap_reset(struct axmap *axmap);
 
-- 
1.7.9.5

