Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE8A376BEC
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 08:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772179954; cv=none; b=YMj2uAGQ27xxxYkrT0AeixgbYXAU4hrsc21i1ahBqpKC8AbX2fJgVx8TtAagZST4ZZlnRcZzvXw/KAddPG7w3/KX3Jymr74qlzlacAmtCpeJHDoknOIxbLGJtSSaMGQX/lpKZ1VTRHd6cHpWwvFRb7VuB/lusRPCON/oZYTEA6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772179954; c=relaxed/simple;
	bh=itZbVUZLg0DWkVE4p5FZIVOtVY3yHf4Ryhd7NMJ3dLk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9DWN3C9ojpuOQpyhL465b5qztQtGTnO61q2X2RoLyu6EFy2Rot5XU8OPT83gtKBzMK9QVNhh857l5iFXAOUAzx65qK9XFeM7Yu5ft8yFPzOSKVHh68Npz/B05Qdjds1dfeVyR+xRfe+KxVxNFjhW4v6IlPW+n/ZOaCyBHUw45A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZZOdQ7ky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZZOdQ7ky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC04AC19422;
	Fri, 27 Feb 2026 08:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772179954;
	bh=itZbVUZLg0DWkVE4p5FZIVOtVY3yHf4Ryhd7NMJ3dLk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZZOdQ7kyzsDmJSAxdwsAVPYkcEw0EyMrG26Tw+RK81eVIIDmUBn3mvkwvjLpzlizC
	 X8F7Ugubgldw4PSwLNdZJFc2kS9ad8yvFuFT8yTJ1+Ze6zZ7KPnuCJc23g37PNDltU
	 GailVhTk8pxPC7GL9Xo8xXQ8TmTZWcqoH9QNpbqEjgXpwV6UMUMmCmZHU7MrhI/I6t
	 N8lRS4YOM1+SGBcy8V578Tq5jL+Ltm20OJNOlKRoq7hWW7Ei2XWeWjQDnepmr+9DvD
	 FOFD5AzHaURZYpJSw3xHvVpCG7e/uvpHofibyW0QI+6OaB80ONrw/ylFtLAG0un1zc
	 CWsgwIgJw18Ow==
From: Damien Le Moal <dlemoal@kernel.org>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH v4 7/8] engines: ftruncate: add support for DDIR_SYNCFS
Date: Fri, 27 Feb 2026 17:07:10 +0900
Message-ID: <20260227080712.2422380-8-dlemoal@kernel.org>
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

Flag the ftruncate IO engine with FIO_SYNCFS to indicate that it
supports the syncfs operation. Also change fio_ftruncate_queue() to use
ddir_sync() to include all variants of the sync operation for driving
the call to do_io_u_sync(), instead of testing for DDIR_SYNC only as
that leads to ignoring other sync variants.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 engines/ftruncate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/engines/ftruncate.c b/engines/ftruncate.c
index 70211e0705f7..c1dcba7dc46f 100644
--- a/engines/ftruncate.c
+++ b/engines/ftruncate.c
@@ -21,7 +21,7 @@ static enum fio_q_status fio_ftruncate_queue(struct thread_data *td,
 
 	if (io_u->ddir == DDIR_WRITE)
 		ret = ftruncate(f->fd, io_u->offset);
-	else if (io_u->ddir == DDIR_SYNC)
+	else if (ddir_sync(io_u->ddir))
 		ret = do_io_u_sync(td, io_u);
 	else
 		io_u->error = EINVAL;
@@ -39,7 +39,7 @@ static struct ioengine_ops ioengine = {
 	.open_file	= generic_open_file,
 	.close_file	= generic_close_file,
 	.get_file_size	= generic_get_file_size,
-	.flags		= FIO_SYNCIO | FIO_FAKEIO
+	.flags		= FIO_SYNCIO | FIO_FAKEIO | FIO_SYNCFS,
 };
 
 static void fio_init fio_syncio_register(void)
-- 
2.53.0

