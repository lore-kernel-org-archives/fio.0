Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F1FC433EF
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 10:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE23260E74
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 10:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235763AbhJKK3m (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 11 Oct 2021 06:29:42 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:42298 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235446AbhJKK3m (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Oct 2021 06:29:42 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C92682004C;
        Mon, 11 Oct 2021 10:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633948061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hfgwd/ccHqpk8XmWmMmBq8LMrWa4TpLfEr1d+nGp4L0=;
        b=0v0tPJdjH/zmZKw4XV+IOIW0DGrQVY28vVfuvAW0qB2Flerxg1Z53azus/RptjqXsmZHEZ
        uI5Mj7S0bmgPbtxbLfhYdGZswwR15QsAF4e0LFAcp4OPy2+faaQUcHwSfDCk8TzZiLccW+
        mqhaqqPMjPuweEUJZfRNHIRo8pwZiLA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633948061;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hfgwd/ccHqpk8XmWmMmBq8LMrWa4TpLfEr1d+nGp4L0=;
        b=DXx8Uk8pQEgxfWGufKlB2qmaMvl3rK5PySxjwbTx4wGS2ax0uqA8jqEpiLOKHrKc2zxx7y
        agsy16FY0qDZqCCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 877FE13C4C;
        Mon, 11 Oct 2021 10:27:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4CIPHp0RZGGVOAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 11 Oct 2021 10:27:41 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 8aaebaf9;
        Mon, 11 Oct 2021 10:27:40 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH] fio: make sure io_u->file isn't NULL before using it
Date:   Mon, 11 Oct 2021 11:27:39 +0100
Message-Id: <20211011102739.10429-1-lhenriques@suse.de>
In-Reply-To: <6f867fa0-c3e9-6f65-d97f-4779c029ef81@kernel.dk>
References: <6f867fa0-c3e9-6f65-d97f-4779c029ef81@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

While running fstests generic/095 against ext4 on a zram device I started
seeing fio crashing.  Fix it by making sure io_u->file isn't NULL before
accessing it.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 io_u.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_u.c b/io_u.c
index 5289b5d1d9c6..b8e715d4118c 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2009,7 +2009,8 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 			io_u->xfer_buf += bytes;
 			io_u->offset += bytes;
 			td->ts.short_io_u[io_u->ddir]++;
-			if (io_u->offset < io_u->file->real_file_size) {
+			if (io_u->file &&
+			    (io_u->offset < io_u->file->real_file_size)) {
 				requeue_io_u(td, io_u_ptr);
 				return;
 			}
