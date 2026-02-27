Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D41ECA4E
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 08:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772179955; cv=none; b=Vnwcp1J4XCKTOiywpMYvERIzBZV9+ooEqiqrZEW9KDZFm8g+hz7mJs2OWjz7cXLnchjLRJHBS3RCaoNNMzSjbi/GQPSzC4iNQopXOjVKc4uyODXmS+qxQ9re+4acgveOGDqyiW/cc7wkcMeq41HGOA9M89agSvEP9CnRN7wXLeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772179955; c=relaxed/simple;
	bh=syyLibF3ON/dsVDPo39ctl+XfUP9Or1ZpSp22rOErQE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ixjti4rj1Vg70vSC+S1qsFcrjpzJIMRYBKNgKEWr0KGZY9OecREoQV9SzN1i0AVYmlK4KBnyYJoWC0eCi+BMsBswevrFgCExnRx02cTQ7Ik7JBfyhTPHJxd/vvroP6V7BGR43dqc7PpYSMdnrTE2K5OOVu4TdOuVB9aKudU31Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OJYADJKU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OJYADJKU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F69C116C6;
	Fri, 27 Feb 2026 08:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772179955;
	bh=syyLibF3ON/dsVDPo39ctl+XfUP9Or1ZpSp22rOErQE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OJYADJKUxs+0tbCuoNqexm3ZtSlwUBMqSWwaZASDQ7MLFDGh0HsbKM18wQdLO4y0e
	 dVpIzLzpQQfiG+JMyuG2f/aaavv/kKcBBZLW/OO7NsWySmGoTri5yVstN2QSZ9ewf6
	 aVlCVr410yV8vCKgsyvluSq8Cd+v4Nyu4EirVDk/sOO5zcdRbcJ2kJBcoy47gXdK8q
	 XpVYufMQetzbfR9Y7MvJFkNPhQo4kZ9QjkSqA8GzawFchxk4GeA2fayox5oafIgR3j
	 KfNRezGq/5GVTBhRCD6GsjVWLYxWmk3HiWqgZiYHHrC27FLvhNmC6GfTM0UrYTAVzR
	 r/1RkaIcyQIkw==
From: Damien Le Moal <dlemoal@kernel.org>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH v4 8/8] engines: posixaio: add support for DDIR_SYNCFS
Date: Fri, 27 Feb 2026 17:07:11 +0900
Message-ID: <20260227080712.2422380-9-dlemoal@kernel.org>
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

