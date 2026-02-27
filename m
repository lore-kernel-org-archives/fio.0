Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35F1376BEC
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 08:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772179953; cv=none; b=MAXH3l8qZg0iPvNrHuHKQLaymqnPQWj07Vy3bejp2VzxhPGLj3/v1KtBuTuZAmKHpmhETb1oM4lru6BzLX9F1Fyg98Qhf6Mkp4qi6kn/5L+PQSXvSqIk40MfsommtroDE/ydgxVhfbWsYFgwMjNtoaBlSpIpNwkKpxAgqLOCRtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772179953; c=relaxed/simple;
	bh=JBrPN+HHMjYraxhj5uBPJkxJyrBYWAMvLBpwclcWuw0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpiq0DiSNGodbXtgg90Ij2PNZFew2imGSTF2rXzbypiXLqIT/T1YNZZkfiA9jVZi3bQ0vhSMRyDG3cs3HZ+rJ3uB6vpJvTuzNboR5WELg51eQrHffqXbHcaiAIMMOnTv8ELtgf6SuH8naGlWVObmulCg+KNgvH18H6YYD+sTfPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qiqJHnb1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qiqJHnb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8DBC19421;
	Fri, 27 Feb 2026 08:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772179953;
	bh=JBrPN+HHMjYraxhj5uBPJkxJyrBYWAMvLBpwclcWuw0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=qiqJHnb1xzEX+cmvuA3PuSHligElwGUA30CmGLEtVS+3BGgoRvFFEXwc/Lt95aFIF
	 6HVmx9UMoqaljsBGg//xmpHaD9A8ocC9DM1za2/2SYN7Diy/DAwKU4W1syaz2cZai+
	 VJIn/lK3oQRDITn2d2Ezf3Lxtl7XFrgBwgoS9ejK7ra4SLq80ojke/ivb2WcTjdjoo
	 4vSj32ItXp5jMpzwYCki05dLmdE5Go8vpGNNdP/WxV0voZMDkxx3Q8bQjCIhTxhPyP
	 zqDord87ZPsksvPzoAgT8ThMcV4LunknwBdz1ppZ2bXvIaF3N0/M6+8HQ2ySBB74jq
	 bIoO4AkUkEQsw==
From: Damien Le Moal <dlemoal@kernel.org>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH v4 6/8] engines: fileoperations: add support for DDIR_SYNCFS
Date: Fri, 27 Feb 2026 17:07:09 +0900
Message-ID: <20260227080712.2422380-7-dlemoal@kernel.org>
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

