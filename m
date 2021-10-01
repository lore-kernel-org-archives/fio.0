Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C89DC433F5
	for <fio@archiver.kernel.org>; Fri,  1 Oct 2021 12:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82B0B61054
	for <fio@archiver.kernel.org>; Fri,  1 Oct 2021 12:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354265AbhJAMDa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 1 Oct 2021 08:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354247AbhJAMDZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 1 Oct 2021 08:03:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC43CC06177C
        for <fio@vger.kernel.org>; Fri,  1 Oct 2021 05:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=JjnYryx4dAo1NW83RoSiC39gsX6Fc0LeG6xBc19im34=; b=PqFX/ZFBY2tQTbwcDTJCryv3th
        /DjRPWEhRQm3zmG5m+rETtW79JnooLeStGcSFs+Ncws8Wqqb0NanU4P/boPmWmGfzjh8wnJ0K2dGu
        OlAReFGUWgfpuo0E+NYMZQsg2VTnkR4xbDljJbuEE0ukqBb5ovB10+yDXdURbmHo4FHIbXrCX24a6
        2BVP/rol+Vb+Tagtekdc+4uMLBFj7UY6X6yznaMYekKjLiWGOP34VyVX/LTT9dVFZ8EIKFAy89DAL
        /zRcQTXh8sli6RXgWV/b/z580UFbLMGacI2fgThJCqWjER6q3t+zqYoKtCdfun8dDnUAuPZDRzAfx
        L27xuc6A==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mWHCu-00Dqaw-Nw
        for fio@vger.kernel.org; Fri, 01 Oct 2021 12:00:30 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id CC0641BC0126; Fri,  1 Oct 2021 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211001120001.CC0641BC0126@kernel.dk>
Date:   Fri,  1 Oct 2021 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 203e4c2624493c0db8c69c9ad830090c5b79be67:

  t/io_uring: store TSC rate in local file (2021-09-29 20:16:54 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0f77c977ab44a10d69268546a849376efc327d47:

  zbd: Fix unexpected job termination by open zone search failure (2021-09-30 10:05:23 -0600)

----------------------------------------------------------------
Shin'ichiro Kawasaki (1):
      zbd: Fix unexpected job termination by open zone search failure

 zbd.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

---

Diff of recent changes:

diff --git a/zbd.c b/zbd.c
index 64415d2b..c0b0b81c 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1204,6 +1204,19 @@ static uint32_t pick_random_zone_idx(const struct fio_file *f,
 		f->io_size;
 }
 
+static bool any_io_in_flight(void)
+{
+	struct thread_data *td;
+	int i;
+
+	for_each_td(td, i) {
+		if (td->io_u_in_flight)
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * Modify the offset of an I/O unit that does not refer to an open zone such
  * that it refers to an open zone. Close an open zone and open a new zone if
@@ -1223,6 +1236,8 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 	uint32_t zone_idx, new_zone_idx;
 	int i;
 	bool wait_zone_close;
+	bool in_flight;
+	bool should_retry = true;
 
 	assert(is_valid_offset(f, io_u->offset));
 
@@ -1337,6 +1352,7 @@ open_other_zone:
 		io_u_quiesce(td);
 	}
 
+retry:
 	/* Zone 'z' is full, so try to open a new zone. */
 	for (i = f->io_size / zbdi->zone_size; i > 0; i--) {
 		zone_idx++;
@@ -1376,6 +1392,24 @@ open_other_zone:
 			goto out;
 		pthread_mutex_lock(&zbdi->mutex);
 	}
+
+	/*
+	 * When any I/O is in-flight or when all I/Os in-flight get completed,
+	 * the I/Os might have closed zones then retry the steps to open a zone.
+	 * Before retry, call io_u_quiesce() to complete in-flight writes.
+	 */
+	in_flight = any_io_in_flight();
+	if (in_flight || should_retry) {
+		dprint(FD_ZBD, "%s(%s): wait zone close and retry open zones\n",
+		       __func__, f->file_name);
+		pthread_mutex_unlock(&zbdi->mutex);
+		zone_unlock(z);
+		io_u_quiesce(td);
+		zone_lock(td, f, z);
+		should_retry = in_flight;
+		goto retry;
+	}
+
 	pthread_mutex_unlock(&zbdi->mutex);
 	zone_unlock(z);
 	dprint(FD_ZBD, "%s(%s): did not open another zone\n", __func__,
