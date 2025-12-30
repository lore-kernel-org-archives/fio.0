Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75881F4CA9
	for <fio@vger.kernel.org>; Tue, 30 Dec 2025 13:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767099614; cv=none; b=mPc/i2t9g0fXrCzl/5HJ4XwOStwpQ/VJ4n88rmK7V/6fcPNrswunHHY+s7W97eF+I+Jfnfu2Us9yrVNTYED53MyuXNOMG5l8JV5BNuAYW7ST7MBCe/wJVXmQHdj+YnoqbSBnUHFY8B/CCXzJvdY8TXPr14rsbNeZYEVdU5tJbwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767099614; c=relaxed/simple;
	bh=oTpyck4FkEAIsywy8LtkhFPJuo3cmm0BFUaMtzeMuSc=;
	h=Subject:From:To:Date:Message-Id; b=Xs+ufg32EOa55RGHeaLJX7zF67hv5jj7Ipcud7rZqz0XPRkw8XflLvlZ1V10KFY8/1+6nzA8kNdvNz0k4Hmk+RSRcLuImPEgtfXDfCXZyxnJmxgg/mgL2rf5JrkrNRSRHyuLX66CDwu0g3afuSuLO77XZcsefu8Ht7NT/vnq2ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q68n17Ja; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q68n17Ja"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=fd4CETN+6xmF7RFc0FggZBrIej9V78xhwHRBDXH63RU=; b=q68n17JaNEruGchNy8rISj9EWO
	O81+AxDAf/2Rq2ppsUIjZ5+Kiy79SlwNixU+ir+mvdWD7hwyhXMAHXOG8juIcNyXMgi5MGo2bJ5G5
	eJPMlkqOEcf/XGGhQNoOWgFYKwlFB9giv1bhaytRzmUlrIe0YYDoXeRRzYCx9+r3nVepFkOVuAB7o
	FpW27EK9Lktcj8e1WF1eM50ndSf7cVM5rfJwHn3cimp6YuX4451WsfK9lWjKcpm8e+jrIHJiAfHGy
	3aK5vbaKmLf1OW+v3erKt5MvFdhCu5GTRqW1XyFRq6bve2WA5K7alb1sGZwLj0jLxx30D+9vVoLI8
	VplY53lQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vaZKY-00000003lyW-0gqm
	for fio@vger.kernel.org;
	Tue, 30 Dec 2025 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id A8F061BC01A8; Tue, 30 Dec 2025 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Tue, 30 Dec 2025 06:00:01 -0700
Message-Id: <20251230130001.A8F061BC01A8@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit d028bdcb8515a29eb683a23b0a88c398cfe4d687:

  test: cleanup test artifacts as we are running (2025-12-18 16:33:42 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e12461d7864cf99581759f5417ca60dc68fee446:

  Merge branch 'master' of https://github.com/alex310110/fio (2025-12-29 13:08:16 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'master' of https://github.com/alex310110/fio

alex310110 (1):
      write_hist_log: do not require ZLIB for non-server instances

 init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index cf66ac2c..76ec96d4 100644
--- a/init.c
+++ b/init.c
@@ -1769,7 +1769,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		const char *suf;
 
 #ifndef CONFIG_ZLIB
-		if (td->client_type) {
+		if (is_backend) {
 			log_err("fio: --write_hist_log requires zlib in client/server mode\n");
 			goto err;
 		}
