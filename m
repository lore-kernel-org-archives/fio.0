Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24D13563E1
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 08:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772179952; cv=none; b=m4H1S/r5bj/3thZvonWZLmMfPybQWbrOya2mdidhdX7A/WvIgFc1Z9+Thyk02fYDaNYlcVvrdXse9r9OzZDOEPn2ntjvhLqsaT1r9Ft11djJFYLc2uu7jnNnygksr5wWnoO5n5+98siIqmwRYUbJVlyXHyMj9u2WFpQiWNhctz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772179952; c=relaxed/simple;
	bh=gPR2bcHnWkd2abU4Qo6iZFezjqZ3xVCOXiXV5FD0hhw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbUV2JKAKi/u1o+UtZwr/mYJ817D7RhxnkEr3bFdfue7277QGJz/wtcvvf9XHZBnq4eskbd/y9/TIQsgn2DNtZpWl2xgNJJ+S09Hc5hEvoFkWtun++wflNaorEiSospgKoB2ZXV0owDasGkMG8lTWYMny+avmV6LrLyFqZqUa3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HC4oN3A9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HC4oN3A9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35308C19422;
	Fri, 27 Feb 2026 08:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772179952;
	bh=gPR2bcHnWkd2abU4Qo6iZFezjqZ3xVCOXiXV5FD0hhw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HC4oN3A9Cehr8cBJoPDD3ZkIHrzaXQuPrtiiUE3kZIRPNCsTXiza2xvMoNnEBII2n
	 hoHKTlkWtiwgP9ncg/sa8oZaeah+i4uZyRFkMvMKyoHyWnphcNtd1Z7xdkCRPnCIoH
	 IOQSPZgA/ihGuFqr3RejfcTnECl8nRxEIRNCDeYFgyoS6et4zRCDRAbnkxA/4e1ag+
	 JDryONiYFUnWFjS5LuPw0LBqip4QJH+wi851qY+UMcObrsK03ssFs/n3GDHxukOahD
	 GLKUMcj4pitcYhYlrKFfQBW6ZmOiJ7y0+mRR7TrA0nDkIpC5D7E1Bg3UoxzOtIwE5Q
	 xP9JbqcZcXjoQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH v4 5/8] engines: fallocate: add support for DDIR_SYNCFS
Date: Fri, 27 Feb 2026 17:07:08 +0900
Message-ID: <20260227080712.2422380-6-dlemoal@kernel.org>
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

Flag the fallocate IO engine with FIO_SYNCFS to indicate that it
supports the syncfs operation. Also fix fio_fallocate_queue() to use
ddir_sync() to include all variants of the sync operation for driving
the call to do_io_u_sync(), instead of testing for DDIR_SYNC only, which
leads to ignoring other sync variants.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 engines/falloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/engines/falloc.c b/engines/falloc.c
index 5bd5aa54cd20..7fc49e36a6f6 100644
--- a/engines/falloc.c
+++ b/engines/falloc.c
@@ -76,7 +76,7 @@ static enum fio_q_status fio_fallocate_queue(struct thread_data *td,
 
 	fio_ro_check(td, io_u);
 
-	if (io_u->ddir != DDIR_SYNC) {
+	if (!ddir_sync(io_u->ddir)) {
 		if (io_u->ddir == DDIR_READ)
 			flags = FALLOC_FL_KEEP_SIZE;
 		else if (io_u->ddir == DDIR_WRITE)
@@ -102,7 +102,7 @@ static struct ioengine_ops ioengine = {
 	.open_file	= open_file,
 	.close_file	= generic_close_file,
 	.get_file_size	= generic_get_file_size,
-	.flags		= FIO_SYNCIO
+	.flags		= FIO_SYNCIO | FIO_SYNCFS,
 };
 
 static void fio_init fio_syncio_register(void)
-- 
2.53.0

