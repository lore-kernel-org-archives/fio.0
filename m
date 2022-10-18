Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 394B0C43217
	for <fio@archiver.kernel.org>; Tue, 18 Oct 2022 04:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiJRERb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Oct 2022 00:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiJRERa (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Oct 2022 00:17:30 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B7596221
        for <fio@vger.kernel.org>; Mon, 17 Oct 2022 21:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666066649; x=1697602649;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Eld8vrDIY6YfNDPqE8QpRF5/+L9NANOfM0Pq2XuaJ+I=;
  b=PThMhAxLkd2CB8gHvl8GysdjvRClq83kSgkNk0DDSICoI3UpMW36161h
   lqtg47wy6Du3IXTNpgBnq+mIOJUX2UYdZdCGgFDh6NRkfjJTHf3K9nX05
   Q654j/JAyZaLYdOXV1KCAnld1VwiCFvYHrXzK5cvCBWeRCvKu5eO+9aLk
   cCo1oOyJF/XU20gMOaxj4dL9OyUwVPTGp9CZVGLNJ89QR4FhFMN+4AmHw
   +vucfIGM9383YjyoFt0pElyrYkpg3cBRsYvckZ17Q8uXAzkodmQgO9tz/
   hUVOuJnRuMYzLRUiWDCDlaKkJQCjhywyS9WPP3nXuwNNTfWliIhUqm3US
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,193,1661788800"; 
   d="scan'208";a="214084028"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Oct 2022 12:17:29 +0800
IronPort-SDR: r93WvUqS9okcPNaPxPxvtr4Gm33hTfqzxj7aQMYE5ZxM/3aDYfse1BkNK4MRK3dTUfbEyjVNJ8
 zlnl9s5n+M0gBtAK/ryEBTdImscWUZJf6MGBxrogLAXs3kNRMzkYnHLmdCc8CJ1uBfweiopQri
 csfzbjLFVyRQ5HEj8hDbqYyl4xU87zskN0RKI+SReevcXxC5ny/wDSkpll6FnjayxEGYQ1e+8A
 GijNuzZBXam1ACklMc3xLTRRQhQ81Oqgur9IkpwnfGX2sWuz2duqbsnvGOaC0RgmF7GAvgIpGo
 TFqCSMR4vjGnw/J6CoyeJ/m5
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Oct 2022 20:37:01 -0700
IronPort-SDR: 0uvIV5gKbUUhBRBFQUM3qr3QWGxE5BSZc5JZ44IHRsYowOtNoFAyw3s27XIPxquHyLHHyAQgsQ
 sR9nq4edU5+ihBtUr9JLL3VWrqFn8oHdL47cqWSHhB1OqqOJQuSVJNXKexYXhKvC9cho/T+l/5
 w02lmAOefGXhLXn4hmWLIStiY+gLMstf58Y0116oD3NThS/Ljvdm0b8rmjERALiqeaCPkfWM9M
 v8r6nyIw3haG3eDfyXO46fSMvsQTzT7eRnSZB0cZSHbQ69xnl3MxVNPznLbGodrROR6N9qzY6C
 rXM=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 17 Oct 2022 21:17:28 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 2/4] verify: fix numberio accounting of experimental verify
Date:   Tue, 18 Oct 2022 13:17:23 +0900
Message-Id: <20221018041725.807940-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221018041725.807940-1-shinichiro.kawasaki@wdc.com>
References: <20221018041725.807940-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

As for non-experimental verify, numberio is compared between the numbers
saved in metadata and written data header. As for experimental verify,
the metadata is not available. Instead of numberio in metadata, it
refers td->io_issues[] as the numberio value for the comparison.
However, td->io_issues[] is used not only for verify reads but also for
normal I/Os. It results in comparison with wrong numberio value and
verification failure.

Fix this issue by adding a new field td->verify_read_issues which counts
up number of verify reads. Substitute td->verify_read_issues to
io_u->numberio to refer it for the comparison in experimental verify
path. Also move td->io_issues[] substitution to io_u->numberio out of
populate_verify_io_u() to keep same behavior in non-experimental verify
path.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 backend.c | 6 +++++-
 fio.h     | 1 +
 verify.c  | 2 --
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/backend.c b/backend.c
index 15c6e0b3..ba954a6b 100644
--- a/backend.c
+++ b/backend.c
@@ -711,6 +711,8 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 					break;
 				} else if (io_u->ddir == DDIR_WRITE) {
 					io_u->ddir = DDIR_READ;
+					io_u->numberio = td->verify_read_issues;
+					td->verify_read_issues++;
 					populate_verify_io_u(td, io_u);
 					break;
 				} else {
@@ -1030,8 +1032,10 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 			break;
 		}
 
-		if (io_u->ddir == DDIR_WRITE && td->flags & TD_F_DO_VERIFY)
+		if (io_u->ddir == DDIR_WRITE && td->flags & TD_F_DO_VERIFY) {
+			io_u->numberio = td->io_issues[io_u->ddir];
 			populate_verify_io_u(td, io_u);
+		}
 
 		ddir = io_u->ddir;
 
diff --git a/fio.h b/fio.h
index 0592a4c3..8da77640 100644
--- a/fio.h
+++ b/fio.h
@@ -356,6 +356,7 @@ struct thread_data {
 	 * Issue side
 	 */
 	uint64_t io_issues[DDIR_RWDIR_CNT];
+	uint64_t verify_read_issues;
 	uint64_t io_issue_bytes[DDIR_RWDIR_CNT];
 	uint64_t loops;
 
diff --git a/verify.c b/verify.c
index 0e1e4639..d6a229ca 100644
--- a/verify.c
+++ b/verify.c
@@ -1287,8 +1287,6 @@ void populate_verify_io_u(struct thread_data *td, struct io_u *io_u)
 	if (td->o.verify == VERIFY_NULL)
 		return;
 
-	io_u->numberio = td->io_issues[io_u->ddir];
-
 	fill_pattern_headers(td, io_u, 0, 0);
 }
 
-- 
2.37.1

