Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33952877F8
	for <fio@vger.kernel.org>; Wed,  9 Jul 2025 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752062411; cv=none; b=FoGDwVJ1UwlgQN/kRQewDeqR+aIWatPV/E7IVu3Ua79xY0N3iq0DAuL11r+TRZ0p241vAA6td7/t8d/Zz3rjCRpQiu+3BqfM8IQAhvSJzXiYtuKeVYlLp6p/GOp/bqeIZTvekoDOn0f0YUZYckEaZFIvuOEvmm6q/zsfP8w+q88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752062411; c=relaxed/simple;
	bh=wsLgL1HEI0uVNx75FALhRh+wR8fzruXSP3uenKZlc9A=;
	h=Subject:From:To:Message-Id:Date; b=oNhXOe/1xRc0+eMP6QuHG7dIhmzbCu3JcHCxqS2dFARag2RdQEF2pztzS8hHZ7yyWin/mUfwy4AhZQgdM9HDAzX2Oul38Uapebmu0CAmpu28vv0vYGign9/c0+uqIUH505bjFkxnW3AvmBZYWYbVGoyRzBVrpWaVyEGIsotMVdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=szE/4MZS; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="szE/4MZS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=UmwJOxiNN6zGCfDhXzb+dYAVkJ1xwoeMYDUKMkZLHFo=; b=szE/4MZSCnlmZ4oCdY1vaBknm2
	/VI7pbxZhRkuq2vnYq0tjGAfFC4M1uViNwQs7uNGIyDppnx++rGiTUisM3/tZXwrpzcTpEMPTX+od
	AD6HBmS14tpQbm6qsn72arTQn6fr2kXHn5bj7wJ43KcHf4xIB+5baDbTAcNTzGWZQIs3M7cL+53hC
	K9Y9PmHHw5wDuYww7yoLoD23EEf6MvtR/0qmX/axG6G+4AhhIvWfQF8wi+V4x+o2M78kWDascQGem
	OX7DghFb299AyIgnj3AlAX6CC7CE2iDJhekL20fDnl9MhYFLWx4BI5lVrHDZ36PfydXEy0kW3tWdY
	9bOs9ilA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uZTT2-00000003otI-2vg3
	for fio@vger.kernel.org;
	Wed, 09 Jul 2025 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 8D68B1BC0166; Wed,  9 Jul 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250709120001.8D68B1BC0166@kernel.dk>
Date: Wed,  9 Jul 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 5db7e6b26bd07824c6207dcbac1a8e7a95a3f20c:

  Merge branch 'fix-randtrimwrite' of https://github.com/minwooim/fio (2025-06-30 07:42:00 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 010b8ba409a18ec1edbf3b776fb7652f26a99b81:

  Merge branch 'http-filename-fix' of https://github.com/sfc-gh-rnarubin/fio (2025-07-08 11:54:05 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'http-filename-fix' of https://github.com/sfc-gh-rnarubin/fio

Renar Narubin (1):
      engines/http: fix file name

 engines/http.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/http.c b/engines/http.c
index 99f4e119..217aa575 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -643,7 +643,7 @@ static enum fio_q_status fio_http_queue(struct thread_data *td,
 
 	fio_ro_check(td, io_u);
 	memset(&_curl_stream, 0, sizeof(_curl_stream));
-	snprintf(object, sizeof(object), "%s_%llu_%llu", td->files[0]->file_name,
+	snprintf(object, sizeof(object), "%s_%llu_%llu", io_u->file->file_name,
 		io_u->offset, io_u->xfer_buflen);
 	if (o->https == FIO_HTTPS_OFF)
 		snprintf(url, sizeof(url), "http://%s%s", o->host, object);
