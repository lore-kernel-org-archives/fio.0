Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5ADD3DA7C7
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 06:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772172062; cv=none; b=dx5M/Mk6YUcCKMfJtV8DEwPuXJOZgh9/mnDnxjR8mcw48U2N86ZPhDJGSvbyhqsC51HTELiAQ0b1Xd8+yym14vOb4qEjJxyyxztYfn6ZF5qPYUlVLevxTucWI/WUBKGoSmL9auIaaUtplUC85h8/QpwyKhjDbQ6juvrAxxpcM+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772172062; c=relaxed/simple;
	bh=syyLibF3ON/dsVDPo39ctl+XfUP9Or1ZpSp22rOErQE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgxCUAkZAvsL6dxLfJxztFFXpHCRULJ11v+J+c0Ul4J29le0d1LyWnQkkphCws6lwOpsR/yhke8ApjF8TpmrpFR32ORIi6hi0wZZy2mhZeot/vv/pcxcqvX6bRyrDEjPDRWVq33J/X90v5+an9bU6IYGUV3YkCwxnZPFUAzQnHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FFG3SYjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FFG3SYjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C2FC19422;
	Fri, 27 Feb 2026 06:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772172061;
	bh=syyLibF3ON/dsVDPo39ctl+XfUP9Or1ZpSp22rOErQE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=FFG3SYjqag/Mwe23iVZpBcRaobRFQ47FbxWtLOZ3IClBbaf5HtzXaEJ3WblpOMQzY
	 CW3+du6Pytn9CGWXtGM7xkJ4+whIk4ggmYBDqLQwJ2RY3G6qJIurtwOXgQm1/9lemm
	 V9x/F4z2Eshk3eKGNuT40FDw+iT1gDveKYWsEStt+zTG2+t5G1fUhpMsZuzjm1710m
	 1lNCXV6ID7RwKvHVYhFvrJedtBPIWqalPNM6lVh8grBbwJkATezjMnbEC9Ch8JG6YG
	 H1sU7nUVp+Sqbgos2VC0SU8P+hDTcXmg35obetdbMl37WRl3L8S/CFvEw4XoMr9LA7
	 w21EM3sjEoClg==
From: Damien Le Moal <dlemoal@kernel.org>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH v3 8/8] engines: posixaio: add support for DDIR_SYNCFS
Date: Fri, 27 Feb 2026 14:55:38 +0900
Message-ID: <20260227055538.2334916-9-dlemoal@kernel.org>
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

Flag the posixaio IO engine with FIO_ASYNCIO_SYNC_SYNCFS to indicate
that it supports the syncfs operation, synchronously. Also change
fio_posixaio_queue() to execute aio_fsync() only for sync operations
that are not a syncfs, in which case, we directly call do_io_u_sync().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 engines/posixaio.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/engines/posixaio.c b/engines/posixaio.c
index 2d0ac9fcc369..828e535157a0 100644
--- a/engines/posixaio.c
+++ b/engines/posixaio.c
@@ -142,7 +142,10 @@ static enum fio_q_status fio_posixaio_queue(struct thread_data *td,
 		return FIO_Q_COMPLETED;
 	} else {
 #ifdef CONFIG_POSIXAIO_FSYNC
-		ret = aio_fsync(O_SYNC, aiocb);
+		if (io_u->ddir != DDIR_SYNCFS)
+			ret = aio_fsync(O_SYNC, aiocb);
+		else
+			ret = 0;
 #else
 		if (pd->queued)
 			return FIO_Q_BUSY;
@@ -196,7 +199,8 @@ static int fio_posixaio_init(struct thread_data *td)
 static struct ioengine_ops ioengine = {
 	.name		= "posixaio",
 	.version	= FIO_IOOPS_VERSION,
-	.flags		= FIO_ASYNCIO_SYNC_TRIM,
+	.flags		= FIO_ASYNCIO_SYNC_TRIM |
+				FIO_ASYNCIO_SYNC_SYNCFS,
 	.init		= fio_posixaio_init,
 	.prep		= fio_posixaio_prep,
 	.queue		= fio_posixaio_queue,
-- 
2.53.0

