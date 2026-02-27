Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11DB1FBEA6
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 06:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772172059; cv=none; b=oIajs9Zxtth1rszq4Fxrqwm4Rsx4W2gP96gc4gP6k+WS3ElgNedBFY60t+vI0mjj1rkrpCdSYojw8KeL0Z6d/5rRNUz+qbmIuMgZ6vTjwugiABKSo+uPLZydwaHLfiAh4WnyZeLjcLeos2/C1IRKPnh9BkngHUI4Yb5HfJqKVT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772172059; c=relaxed/simple;
	bh=gPR2bcHnWkd2abU4Qo6iZFezjqZ3xVCOXiXV5FD0hhw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLPRDb4BlXUb0gxJpWTvKDlZdyIe8T2822sBN1M3Lfxh/cx4pOxoc9X1GB1QY1VF5eN27FQco7bZSDGEdnhMeJBBAnvM4NqdviV0rgp9FeUms6BhmWxWfQc/a4JHhabX2C3UvpO/ZZkKihoOcb8yQY/51URXbZnzt0zaxKSioh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YAMvPsgJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YAMvPsgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04318C19421;
	Fri, 27 Feb 2026 06:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772172059;
	bh=gPR2bcHnWkd2abU4Qo6iZFezjqZ3xVCOXiXV5FD0hhw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=YAMvPsgJ8gmQpZ9IusP7Dc7JQ72nAHvYKmVwmnIiOJtA6iSwL/LeCAUTIO2Torp4t
	 C1trG2jGxpHHtvOPWwHcBDqEFXE87H33Oe82PgVPl3wZfTIdpOv+lNFPW19A1iaQet
	 ZMrGCIFChhKt6CCW2WhNlWlgpknPHDs7WawWSysWz4UT5Nm25d+gI2J4XE716fQs2R
	 tFs0s0UQAwCK6X5XzgJ8jlIu3/NAxE31cobrEZ3ZPD4ytyPG4bSetH89YktVeln60R
	 taOJIPA3ZHss1sO8QYTTM7UYIG7wG3Us+ynRarCyXXSlJZxJ5mwI9wDo4BuzjRrAuz
	 UPKO6wpMAXNYw==
From: Damien Le Moal <dlemoal@kernel.org>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH v3 5/8] engines: fallocate: add support for DDIR_SYNCFS
Date: Fri, 27 Feb 2026 14:55:35 +0900
Message-ID: <20260227055538.2334916-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260227055538.2334916-1-dlemoal@kernel.org>
References: <20260227055538.2334916-1-dlemoal@kernel.org>
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

