Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872AD217668
	for <fio@vger.kernel.org>; Thu,  5 Jun 2025 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749124812; cv=none; b=q29o48HS0PmIex/z6mPWihoeiTW9YmvFUYegqXwJOmHfdwGWtSO9z17KUX+4Ma+hAhJNxFLAKCodnm1ML0LFleRP3CEsiIHdNkAYWQ69kPZ+6W2l4a3tdOSth23qmki/n/5qG1EwDGQ83+LK6q/XyvB/YmqNN7edWj+79jdcnPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749124812; c=relaxed/simple;
	bh=uVGpLNzWp+itNHtp8Xzrg5Kl3Ttx12cscy94luIE0Ao=;
	h=Subject:From:To:Message-Id:Date; b=K7tdpKjDXdGs9JsXIY+hxvaY3bF8ghXzfUoGBEHmEjGi/NQ+6EgOHD6qiQXhgpY+OER9zWE9ds5RyTBfY7oKVSZgvnR++v1J/d7pgnN1qD0ce01GLPi1EQ1yVNXXjl2uzpA9fObxNxWh8UNyU2DlA6qLFU/chlOA0WdusKBL8jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VKpJMRsY; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VKpJMRsY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=BANKBheQVGVbV99iVaFfAQK1FDeLuE5q3UKjedoVPq0=; b=VKpJMRsYsuZGpzWlPveO2Jw1jA
	Ff2uWxsmKeR3il59lIBfPVr+8AEcej5yAwmFbb+Z/J0SQ3ODy54YXrzIwLQ43yB5CfYePPvFE3/pY
	8xhbGEgfXgqNErLfIjRaTPjo66+5vnrZZuNNX0NDvDk2nTs9Bj0uP6CcaGbvuF3CBrw9w+iJf/vMZ
	YGoGbizBQ+pvpPQDQmdVyqVaeJcTwL5lQaAKzrjB2pS8HE35VJi6s38zNWipOm9YPY1zp62MEShMF
	zn7AaS3kYgl/IirGwxlkw9o4VhLsi69sDTvI9Ngf8cPJT+e5u5CST6SZa+RMHH8xUh6KtC0sYYiiO
	VevBI1qw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uN9GP-000000019ze-2LKR
	for fio@vger.kernel.org;
	Thu, 05 Jun 2025 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 182681BC0179; Thu,  5 Jun 2025 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250605120002.182681BC0179@kernel.dk>
Date: Thu,  5 Jun 2025 06:00:02 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 02fe4fb04a141d5e72b641f7a36b3ea1e5a2b147:

  ioengines: clear in-flight bit for FIO_Q_BUSY syncs (2025-06-02 12:35:42 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 813445e7129240d51216e396a5ba8e19296b6581:

  backend: clean up requeued io_u's (2025-06-05 01:44:43 +0000)

----------------------------------------------------------------
Vincent Fu (1):
      backend: clean up requeued io_u's

 backend.c | 4 ++++
 1 file changed, 4 insertions(+)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index f2a4ad35..0cdee864 100644
--- a/backend.c
+++ b/backend.c
@@ -1284,6 +1284,10 @@ static void cleanup_io_u(struct thread_data *td)
 		fio_memfree(io_u, sizeof(*io_u), td_offload_overlap(td));
 	}
 
+	while ((io_u = io_u_rpop(&td->io_u_requeues)) != NULL) {
+		put_io_u(td, io_u);
+	}
+
 	free_io_mem(td);
 
 	io_u_rexit(&td->io_u_requeues);
