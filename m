Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EC53EB812
	for <fio@vger.kernel.org>; Thu, 23 Apr 2026 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776945609; cv=none; b=UiALke9RZDirHrf1zrVYDSDetW4jVAA1ePdiq5XFzs4Z9zFMepWkW0dSHa2ezTpIpQzG6vAVARdHAdUqr3gmBYtx2TrDgsPhOZshC6+KvNheWiXeFKvSxZZGqUAXGP7JxKFIJdYglwB4uDaoeocWiiE7S/7ypDVD+1OHHYQMV8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776945609; c=relaxed/simple;
	bh=mnuwOda7zdpY35npkjhnorf6AVPB4/SqeMKIs3tMo4U=;
	h=Subject:From:To:Date:Message-Id; b=hrsJPsfFdDmKTT+2nSjUkUVP8I3KARSegvG55qkQT4m6ufL4i58+7lQVKYK6kLzTqVPu2XkY9ZGQSPKigWhFD8BBzvlQXDWDdCRsf4BF5uQ7Eue8emgaVTq5Gug6M1Ld2eCr0iXNFVdBdm9/OAv4NGSzDp6esauxpONRznKUV74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eQjXhNDH; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eQjXhNDH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=YeChzf5tGhBjSGoyeXwwFAdRh1uwAR6XQPzmzvQDbOA=; b=eQjXhNDHWTcpTY1RKXqDUMd17s
	UbpOPRf1C++w+IiMwYYzcdHAdISdKvzGAxaIb+iJfvx5w5ibuC5zgiAFA3duXll04c6Z9ymjQMCZ2
	A5eWFuKx/6yFKr29cUz8OagnWCyu0dhUyPPs5CRIBASlkldDz94CbSk+5fnt58hLR6gjUqDBNL4k4
	qV27pfhoyDY/Nvwibdcs5gKSdmh8jlQIDBSLG+ZSsRyCijanyK5lf1/I/VpDssNX9qUbkrtb/gtxV
	gFlunIxb/A3vSBWCiPbvlmLRvOkzQarZZN7ewlqHPTXdlbKjZMBt+MfvPnUuufg2O4UT9XI4Hl5Pa
	KxapYfEQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFsiz-0000000Cyuw-38S9
	for fio@vger.kernel.org;
	Thu, 23 Apr 2026 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id C98C41BC015A; Thu, 23 Apr 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu, 23 Apr 2026 06:00:01 -0600
Message-Id: <20260423120001.C98C41BC015A@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit d91ab4439af20b13dbbe55021f6c29de5b6eddeb:

  Merge branch 'check-numberio-read-only' of https://github.com/minwooim/fio (2026-04-16 22:31:44 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7b1fa07c9c7d4624fefd31d40d36742e900f6e44:

  Merge branch 'prevent_large_trim_size_and_high_iodepth_causing_oom' of https://github.com/dennischerchang/fio (2026-04-22 15:59:15 -0400)

----------------------------------------------------------------
Dennis Chang (1):
      fio: prevent OOM by not allocating buffer for TRIM range

Jens Axboe (1):
      Merge branch 'fix-trigger-timeout-segfault' of https://github.com/minwooim/fio

Minwoo Im (1):
      verify: fix segfault in timedout teardown

Vincent Fu (1):
      Merge branch 'prevent_large_trim_size_and_high_iodepth_causing_oom' of https://github.com/dennischerchang/fio

 backend.c | 5 ++++-
 fio.h     | 8 ++++++++
 verify.c  | 8 +++++++-
 3 files changed, 19 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index cad43ace..7a02ea11 100644
--- a/backend.c
+++ b/backend.c
@@ -1482,7 +1482,10 @@ int init_io_u_buffers(struct thread_data *td)
 	char *p;
 
 	max_units = td->o.iodepth;
-	max_bs = td_max_bs(td);
+	if (td->trim_verify && td->o.trim_zero)
+		max_bs = td_max_bs(td);
+	else
+		max_bs = td_max_rw_bs(td);
 	min_write = td->o.min_bs[DDIR_WRITE];
 	td->orig_buffer_size = (unsigned long long) max_bs
 					* (unsigned long long) max_units;
diff --git a/fio.h b/fio.h
index 7793d35c..18196123 100644
--- a/fio.h
+++ b/fio.h
@@ -862,6 +862,14 @@ static inline bool should_check_rate(struct thread_data *td)
 	return (td->flags & TD_F_CHECK_RATE) != 0;
 }
 
+/*
+ * This function considers only read and write block sizes.
+ */
+static inline unsigned long long td_max_rw_bs(struct thread_data *td)
+{
+	return max(td->o.max_bs[DDIR_READ], td->o.max_bs[DDIR_WRITE]);
+}
+
 static inline unsigned long long td_max_bs(struct thread_data *td)
 {
 	unsigned long long max_bs;
diff --git a/verify.c b/verify.c
index e2011a0f..76da89eb 100644
--- a/verify.c
+++ b/verify.c
@@ -1676,7 +1676,13 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 		if (save_mask != IO_LIST_ALL && (__td_index + 1) != save_mask)
 			continue;
 
-		for (int i = 0; i < td->o.iodepth; i++)
+		/*
+		 * This can be called even if --verify=none &&
+		 * --verify_state_save=0 case especially when
+		 *  --trigger-timeout= is given and it's expired.  In this
+		 *  case, td->inflight_numberio == NULL, so we should check it.
+		 */
+		for (int i = 0; td->inflight_numberio && i < td->o.iodepth; i++)
 			s->inflight[i].numberio = cpu_to_le64(atomic_load_acquire(&td->inflight_numberio[i]));
 
 		s->depth = cpu_to_le32((uint32_t) td->o.iodepth);
