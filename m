Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE1ADE7544F
	for <fio@archiver.kernel.org>; Tue,  3 Oct 2023 12:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbjJCMAP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 3 Oct 2023 08:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbjJCMAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 3 Oct 2023 08:00:15 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0873CA6
        for <fio@vger.kernel.org>; Tue,  3 Oct 2023 05:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=BA4VhUtiUEvNbo5h3Xj14ZuD4vekVMomaYPRqJ5OWsw=; b=Y4jUbpNwkeGykU6o1AnEe9TUZk
        In4RuCBlKJl5hcgLBhLkfCL394AGzvP4e1/ihzo+oOqEIJycN1CJ6rfXi4s8ZxxuHIqS3IKZ9J0Ra
        gMSTSNE2XqBml+jgRGvQKulRaamlzleb4zs16dwp1aYSp/sLx5iLOlM8lold0oQ5jykuSiKYTilDL
        U8IvayuTrj0rNrHE30WW9a5FxeJtuZ/3+dFqGSz2Apc5RPxl17MZoQW5Sdd4ImZakqMZLn+IAsDGr
        dJTPUQzXP51sm6u1rx8eHxmX1UREQ9n7dSkc1xmxAaeKt4Z+A8Wvj3kdc+ph/JF56BY82TXNranvA
        1ryWll4A==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qne4O-009rkH-1w
        for fio@vger.kernel.org;
        Tue, 03 Oct 2023 12:00:10 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 674E41BC017F; Tue,  3 Oct 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20231003120001.674E41BC017F@kernel.dk>
Date:   Tue,  3 Oct 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit c95b52caacc8ef5c1235fb3754186e981b109bdb:

  ci: switch macos runs from macos-12 to macos-13 (2023-09-29 11:51:10 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6f9cdcfcc7598c7d7b19c4a5120a251a80dab183:

  iolog: don't truncate time values (2023-10-02 14:29:29 +0000)

----------------------------------------------------------------
Vincent Fu (1):
      iolog: don't truncate time values

 iolog.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/iolog.c b/iolog.c
index 97ba4396..5213c60f 100644
--- a/iolog.c
+++ b/iolog.c
@@ -1002,14 +1002,14 @@ void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 
 	if (log_offset) {
 		if (log_prio)
-			fmt = "%lu, %" PRId64 ", %u, %llu, %llu, 0x%04x\n";
+			fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %llu, 0x%04x\n";
 		else
-			fmt = "%lu, %" PRId64 ", %u, %llu, %llu, %u\n";
+			fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %llu, %u\n";
 	} else {
 		if (log_prio)
-			fmt = "%lu, %" PRId64 ", %u, %llu, 0x%04x\n";
+			fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, 0x%04x\n";
 		else
-			fmt = "%lu, %" PRId64 ", %u, %llu, %u\n";
+			fmt = "%" PRIu64 ", %" PRId64 ", %u, %llu, %u\n";
 	}
 
 	nr_samples = sample_size / __log_entry_sz(log_offset);
@@ -1024,7 +1024,7 @@ void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 
 		if (!log_offset) {
 			fprintf(f, fmt,
-				(unsigned long) s->time,
+				s->time,
 				s->data.val,
 				io_sample_ddir(s), (unsigned long long) s->bs,
 				prio_val);
@@ -1032,7 +1032,7 @@ void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 			struct io_sample_offset *so = (void *) s;
 
 			fprintf(f, fmt,
-				(unsigned long) s->time,
+				s->time,
 				s->data.val,
 				io_sample_ddir(s), (unsigned long long) s->bs,
 				(unsigned long long) so->offset,
