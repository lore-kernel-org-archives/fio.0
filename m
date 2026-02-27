Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC45361DBA
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 06:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772172061; cv=none; b=KBijx9JTem6zBXmIsjq7Wlc/eir1ubPSlS3NV5CzrQYHm69ftllDI4Ll7YGWgJJAKTXMH6IHReg+Lnp/pyzYhX6moFHhFOivQIc6Pqx9Dy8mBYPO1BR/ANblHgbJ24lO7KLW7qfwBbCcWrfpL3JGyZuRW4YkFAsGHTTS6cMZviI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772172061; c=relaxed/simple;
	bh=itZbVUZLg0DWkVE4p5FZIVOtVY3yHf4Ryhd7NMJ3dLk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdkR/J0MN0mYYxdAE1vplgByCJ+jhGTLrAV8Git+dzXBcX4aNoE1hJdClo3Bygvg5P5FekFoUy+1vTNFEabMgJF3OEfDp0nZhuw/OYFxhpA4kAxPphqPwOR8ibr7zN6kJi+USqPJPn8dvzUHPwKWk49PaDGBC1eKisxdFXw+p7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=utR9Ukbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="utR9Ukbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB0CC19421;
	Fri, 27 Feb 2026 06:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772172061;
	bh=itZbVUZLg0DWkVE4p5FZIVOtVY3yHf4Ryhd7NMJ3dLk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=utR9UkbxPkxfUigDitNgUo/YacD0naO0BJbSumt0A6ztwmYEdse1On83KN0Mx71+/
	 GDjW0Xf6nEEqImLQ+wS3HUAmgTE9ZBGGD+++va2ehzN8belqNu1NfzAyqGchyJObkI
	 zZJ3ChTVGjYCjyZ8CqFPxfj6M//oaIV/OiRLcV6fI928K6f1xELiTibUjQJG9yCaXS
	 0+No4vX+lXEZQaHtykGtJxA6fuIuC800MZHab1EyXJebpsH81plZaTHjfduWVybNJN
	 kz+MqUJgNSDGaGCT3GN8M9jhtq9RHwoJBe0lYfWLm3hYDo6406B+O8yUUX44ANerF/
	 q91tTeZNeFJFg==
From: Damien Le Moal <dlemoal@kernel.org>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH v3 7/8] engines: ftruncate: add support for DDIR_SYNCFS
Date: Fri, 27 Feb 2026 14:55:37 +0900
Message-ID: <20260227055538.2334916-8-dlemoal@kernel.org>
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

