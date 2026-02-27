Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7002F1FBEA6
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 06:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772172060; cv=none; b=oC+BLk2Vf3b0tzhBacxvzVpCiQPef5kdzvZuWKxqCC4XdXGojI2+QIG8GQFvz0BGBr4CqprkR5ImFrE8F4pdTpv/LOz6ook7i1VMTcfBB+RNed9xwYDRPi4NUSeoaWkxvYLGcugPjac8fys1oYTBxF5qvbwsv1rax3L68btG1fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772172060; c=relaxed/simple;
	bh=JBrPN+HHMjYraxhj5uBPJkxJyrBYWAMvLBpwclcWuw0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=faiinmR6IR8vNER0h647ZDu6Qkn2AtRrOm0KtbLPjSqQgjVvAgWGnlw9X+QeD5A6r3SHrcKh56oNuNcmjPeLK+/27/3pqlKO1KWp+/Ux5OfofWfL6drSO10dQi/JMOrSS8brShNW2cY1dXFXCxBJK7A8z3wDxk7/YHPof0Gj+vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O23gA1ki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O23gA1ki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF00C116C6;
	Fri, 27 Feb 2026 06:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772172060;
	bh=JBrPN+HHMjYraxhj5uBPJkxJyrBYWAMvLBpwclcWuw0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=O23gA1ki89LIuGiozSmUpnIUUfN2vUn5JaghmT6OaIvWnqmAynSZHxaAWnyHRcOqB
	 574im3HTxyM9Eami12Mb1Nk7+JFUjDfWiwVlntT6MquP936Z5YJH7NSo/gmHV8WmEk
	 4YuCTK67bT91oxuJjvITYMyJurK6poDrQy7kcdAjEYAuPab5/V1mv9iJlJkBL8HSzj
	 Aq8iXzx4V8V6lFhulgyx/jcrAE5b816v8EiCRFM1hZt52UT23PAWnGkUu9rAs2s6rh
	 crgh1orumy8GwJxBe8WXawCKRrdnmaGykTM34WEBIbBrGKEfA7eKGHM/vBl15zpkYp
	 wT2HOBUj9c7Rw==
From: Damien Le Moal <dlemoal@kernel.org>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH v3 6/8] engines: fileoperations: add support for DDIR_SYNCFS
Date: Fri, 27 Feb 2026 14:55:36 +0900
Message-ID: <20260227055538.2334916-7-dlemoal@kernel.org>
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

Flag the filecreate, filedelete, dircreate and dirdelete IO engines with
FIO_SYNCFS to indicate that they support the syncfs operation. Change
the queue_io() function to use ddir_sync() to include all variants of
the sync operations for driving the call to do_io_u_sync(), instead of
testing for DDIR_SYNC only, which leads to ignoring other sync variants.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 engines/fileoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/engines/fileoperations.c b/engines/fileoperations.c
index ce3e7c39b1a5..880eab1ebf6b 100644
--- a/engines/fileoperations.c
+++ b/engines/fileoperations.c
@@ -264,7 +264,7 @@ static int invalidate_do_nothing(struct thread_data *td, struct fio_file *f)
 
 static enum fio_q_status queue_io(struct thread_data *td, struct io_u *io_u)
 {
-	if (io_u->ddir == DDIR_SYNC && do_io_u_sync(td, io_u))
+	if (ddir_sync(io_u->ddir) && do_io_u_sync(td, io_u))
 		io_u->error = errno;
 	return FIO_Q_COMPLETED;
 }
@@ -329,7 +329,7 @@ static struct ioengine_ops ioengine_filecreate = {
 	.open_file	= open_file,
 	.close_file	= generic_close_file,
 	.flags		= FIO_DISKLESSIO | FIO_SYNCIO | FIO_FAKEIO |
-				FIO_NOSTATS | FIO_NOFILEHASH,
+				FIO_SYNCFS | FIO_NOSTATS | FIO_NOFILEHASH,
 };
 
 static struct ioengine_ops ioengine_filestat = {
@@ -357,7 +357,7 @@ static struct ioengine_ops ioengine_filedelete = {
 	.get_file_size	= generic_get_file_size,
 	.open_file	= delete_file,
 	.flags		=  FIO_SYNCIO | FIO_FAKEIO |
-				FIO_NOSTATS | FIO_NOFILEHASH,
+				FIO_SYNCFS | FIO_NOSTATS | FIO_NOFILEHASH,
 };
 
 static struct ioengine_ops ioengine_dircreate = {
@@ -403,7 +403,7 @@ static struct ioengine_ops ioengine_dirdelete = {
 	.open_file	= delete_file,
 	.unlink_file	= remove_dir,
 	.flags		= FIO_DISKLESSIO | FIO_SYNCIO | FIO_FAKEIO |
-				FIO_NOSTATS | FIO_NOFILEHASH,
+				FIO_SYNCFS | FIO_NOSTATS | FIO_NOFILEHASH,
 };
 
 static void fio_init fio_fileoperations_register(void)
-- 
2.53.0

