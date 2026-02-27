Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F583563E1
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 08:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772179952; cv=none; b=QiO2XTc1CU7ldQ4cF/uTm3PuzbD5PMMdtHQGDn3E1mVQduDIB86QU6HQmZHRp/mTR+gANNIj36ZeOOgh7x8kgn3LR90GeC9fUa+m3AVOpnQdJ0YGh7NHLhHgcpzVAj5E4BUV2D8V7PV3dxbZhxeZ+wqx1qqAcMJPReXqiUGljRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772179952; c=relaxed/simple;
	bh=nyCpRO6Uat+K2NVikanpMOkHSEcKqcyUF38XfsnAOJ0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLJhTq3Z6E7HYh+69EqL1pV2EM8zQk5etHNCR0GCfuRrKcpxcuwyrx0mMzZNot2bJeZvRtFxYLuMVI9tqB0RLjEcp7dUKKMVYECmaiW4Wuj6x/hrm1LpUGjzGxGa630Mu6qcqq23hacgMiSYYiEkuXZCXAxipe/3zFwrqeJsczk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CFKtGv3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CFKtGv3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70202C116C6;
	Fri, 27 Feb 2026 08:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772179951;
	bh=nyCpRO6Uat+K2NVikanpMOkHSEcKqcyUF38XfsnAOJ0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CFKtGv3VI6c3Zr8vIArmH3Yi9QmhvuNnHCZzHhH3cPYcChsBFPRymzlXV5xOExM9o
	 H6c7+MoNdMLOk/RmAeCYGaPQnVWXsm7dvf4lLlBnc+NgjtueTFTpNfGBMh9czH1pj9
	 yON1fvhSIG9aBCrEyDZ1ZSZ9asgLFyjhLM1av2HTS5w2/NpuGLTZRC+viNRdU9Fmns
	 M0KdJKe6HxOU/ozeX//KJ12XZL3TnV/+NgI8MYQ9CyxcU8EoRr+9TWhRrUnLg9xuPM
	 wgBle10fz/FExnBi/z/a0z+Vth4cRUhHmjq9MbMB44UVVuXiCgYG7TmlcxLezueM+o
	 LuDk1FEvJmOPg==
From: Damien Le Moal <dlemoal@kernel.org>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH v4 4/8] engines: io_uring: add support for DDIR_SYNCFS
Date: Fri, 27 Feb 2026 17:07:07 +0900
Message-ID: <20260227080712.2422380-5-dlemoal@kernel.org>
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

Flag the io_uring engine with the FIO_ASYNCIO_SYNC_SYNCFS flag to
indicate that the syncfs operation is supported, synchronously.
Modify fio_ioring_queue() to call do_io_u_sync() for an io_u that has
the DDIR_SYNCFS data direction.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 engines/io_uring.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 0ea3aba12e2c..d4dff3b8f275 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -890,12 +890,19 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 	if (ld->queued == td->o.iodepth)
 		return FIO_Q_BUSY;
 
-	/* if async trim has been tried and failed, punt to sync */
-	if (io_u->ddir == DDIR_TRIM && ld->async_trim_fail) {
+	/*
+	 * If this is a syncfs request, or if async trim has been tried and
+	 * failed, punt to sync.
+	 * */
+	if (io_u->ddir == DDIR_SYNCFS ||
+	    (io_u->ddir == DDIR_TRIM && ld->async_trim_fail)) {
 		if (ld->queued)
 			return FIO_Q_BUSY;
 
-		do_io_u_trim(td, io_u);
+		if (io_u->ddir == DDIR_TRIM)
+			do_io_u_trim(td, io_u);
+		else
+			do_io_u_sync(td, io_u);
 
 		io_u_mark_submit(td, 1);
 		io_u_mark_complete(td, 1);
@@ -2013,7 +2020,8 @@ static struct ioengine_ops ioengine_uring_cmd = {
 	.version		= FIO_IOOPS_VERSION,
 	.flags			= FIO_NO_OFFLOAD | FIO_MEMALIGN | FIO_RAWIO |
 					FIO_ASYNCIO_SETS_ISSUE_TIME |
-					FIO_MULTI_RANGE_TRIM,
+					FIO_MULTI_RANGE_TRIM |
+					FIO_ASYNCIO_SYNC_SYNCFS,
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_cmd_post_init,
 	.io_u_init		= fio_ioring_io_u_init,
-- 
2.53.0

