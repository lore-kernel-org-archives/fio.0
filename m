Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1443563E1
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 08:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772179951; cv=none; b=dHM4yw4aIJxVshvb/iPtN9zBf3TRq71hJFeUW6AvF4OpjR0wswMy9RmR21+ysodJE9sMlIzfG2w1RMsPFGLLnjUlCUTLJcly3tYuRDamYyX/hNA0qcqVXdV9+jVTgi5TXHoD3IBFY17TnNmMKcsD5w74qY6GU9FY7lyiLEH8+eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772179951; c=relaxed/simple;
	bh=06F6TJDFoB0GSIedWwlZgVYaTIy3QRaGRStZwONrCyA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6Ll5BtjYPDU5pDcyT+tC6VXu7NL0TOFcjTjvhbETMPC2kHMvo9U+CiTeYrPs84fpQ/DWhBD3zYJdJPMV3PtSC1NM1Mu1thVF134A69AyyP85tuxh8eU0L7QC4D5P6TXNt8x/cT1Y1Io64VfzKAdnGbo0/Bgw7eaXtrl9l04S0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P5cl7gOM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P5cl7gOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA891C19422;
	Fri, 27 Feb 2026 08:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772179951;
	bh=06F6TJDFoB0GSIedWwlZgVYaTIy3QRaGRStZwONrCyA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=P5cl7gOM+1Y6dFEAn9G/5PUnwGYueR0ebaOb2c8YqSabHn42BV4vE3st5kOTgOMi+
	 B3Fg5nT+aj2xGtSmJSXh1UwsXq0rk8DWw+8iLJAQT56YOj8ZPN0dBGWyUYljTKpIA+
	 N+Dc8MfAJzTwVzOjbJUuThkczE8KcHgKlANbX39/ErnnrOaYW4GqU0dRgyuMHSj8NH
	 CR/tP/+452QWMzlCZyXobF6EHg4K6Qw733skpaB2JfxPOWEOqsmSeLjWi29b4Ma2+n
	 0Hb+29EdB46/n3vSOZzNUt1UZbjcFmOLcoy/7Q9ww3qa5mSA8LnBdBX8hdAkzJE998
	 +CkpeZSp4jQlQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH v4 3/8] engines: libaio: add support for DDIR_SYNCFS
Date: Fri, 27 Feb 2026 17:07:06 +0900
Message-ID: <20260227080712.2422380-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260227080712.2422380-1-dlemoal@kernel.org>
References: <20260227080712.2422380-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Flag the libaio engine with the FIO_ASYNCIO_SYNC_SYNCFS flag to indicate
that the syncfs operation is supported, with synchronous processing.
Modify fio_libaio_queue() to call do_io_u_syncfs() for an io_u that has
the DDIR_SYNCFS data direction.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 engines/libaio.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/engines/libaio.c b/engines/libaio.c
index 0c207d60d94a..3242dadd4e0b 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -274,11 +274,14 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
 	if (ld->queued == td->o.iodepth)
 		return FIO_Q_BUSY;
 
-	if (io_u->ddir == DDIR_TRIM) {
+	if (io_u->ddir == DDIR_TRIM || io_u->ddir == DDIR_SYNCFS) {
 		if (ld->queued)
 			return FIO_Q_BUSY;
 
-		do_io_u_trim(td, io_u);
+		if (io_u->ddir == DDIR_TRIM)
+			do_io_u_trim(td, io_u);
+		else
+			do_io_u_sync(td, io_u);
 		io_u_mark_submit(td, 1);
 		io_u_mark_complete(td, 1);
 		return FIO_Q_COMPLETED;
@@ -456,6 +459,7 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.name			= "libaio",
 	.version		= FIO_IOOPS_VERSION,
 	.flags			= FIO_ASYNCIO_SYNC_TRIM |
+					FIO_ASYNCIO_SYNC_SYNCFS |
 					FIO_ASYNCIO_SETS_ISSUE_TIME |
 					FIO_ATOMICWRITES,
 	.init			= fio_libaio_init,
-- 
2.53.0

