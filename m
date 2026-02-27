Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACB81FBEA6
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 06:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772172057; cv=none; b=aTOL93bhiCeDiXUFx9A5fjnEgx0hHfSUeWbfCa0beRe0D64dZodTzU28EEfidhoOYC/kEooLWF8FM/03NI3EOujiyS+pja+eLcOcltTiH6h7wWdBsW8l7BcGYVoRyBcBIAdQ28yde41zu6j1rSEHMxJwPi9WyAam0xfPRhtr7xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772172057; c=relaxed/simple;
	bh=EXjx/QpSgl3qv4k5dZDJfobpQRZrzkxtfc3t5y22JQo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeBmTWFW2PNdEDkUxi4mEFaVx2hg/ce4GZsJ7LmfgyHRkbNWp8H+BgXyWRn9f4CKcLIF2zjWay2eDdCcSzHlzLTz087HdMj01P+T/wGt/kHOKbJjUNMWg+2SFWw5rcBcDBG0PAjw+Tgq7fEIiUe5TFvzZlwTRuKCP06+UPW0L84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHC9BrVS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHC9BrVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3447C116C6;
	Fri, 27 Feb 2026 06:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772172057;
	bh=EXjx/QpSgl3qv4k5dZDJfobpQRZrzkxtfc3t5y22JQo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=QHC9BrVS1kSN+08q3UZP9IANzxg5jrd4RxgZPtpgETKbkIYnAoECSCV8vwTWrvihi
	 DSVGvbxI1RH45DtxTInVRhpu89MHTyBLMsdtfsEb2a042p8XnQhT4bQCUIV5splCU9
	 X83FYmkhFg630/7h3DX+P13zExZspH00ZEiLKxgnzhAfUmfGco1MPGq+r02nPu1gVB
	 0NcS0J+Soz5gwkiJS/43vlDMhR0BTUg48EBQvtAik1HU87x8a7hceA8L6n4W7jJ5t1
	 O2MfcXwIEfwxTquq5ffFuFJZKkr5q+FQWCBkGnSIwgI2Db+9J5n4Tr4hP1zCVA8IL3
	 wls9Q5pBU7uTw==
From: Damien Le Moal <dlemoal@kernel.org>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH v3 2/8] engines: sync: add support for DDIR_SYNCFS
Date: Fri, 27 Feb 2026 14:55:32 +0900
Message-ID: <20260227055538.2334916-3-dlemoal@kernel.org>
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

Flag the sync IO engine with the FIO_SYNCFS flag to indicate that syncfs
operations are supported. No additional changes are needed to enable
syncfs processing as this IO engine already processes all sync operation
variants using do_io_u_sync().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 engines/sync.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/engines/sync.c b/engines/sync.c
index 89466ca596aa..ba71ee04801d 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -433,7 +433,7 @@ static struct ioengine_ops ioengine_rw = {
 	.open_file	= generic_open_file,
 	.close_file	= generic_close_file,
 	.get_file_size	= generic_get_file_size,
-	.flags		= FIO_SYNCIO,
+	.flags		= FIO_SYNCIO | FIO_SYNCFS,
 };
 
 static struct ioengine_ops ioengine_prw = {
@@ -443,7 +443,7 @@ static struct ioengine_ops ioengine_prw = {
 	.open_file	= generic_open_file,
 	.close_file	= generic_close_file,
 	.get_file_size	= generic_get_file_size,
-	.flags		= FIO_SYNCIO,
+	.flags		= FIO_SYNCIO | FIO_SYNCFS,
 };
 
 static struct ioengine_ops ioengine_vrw = {
@@ -458,7 +458,7 @@ static struct ioengine_ops ioengine_vrw = {
 	.open_file	= generic_open_file,
 	.close_file	= generic_close_file,
 	.get_file_size	= generic_get_file_size,
-	.flags		= FIO_SYNCIO,
+	.flags		= FIO_SYNCIO | FIO_SYNCFS,
 };
 
 #ifdef CONFIG_PWRITEV
@@ -471,7 +471,7 @@ static struct ioengine_ops ioengine_pvrw = {
 	.open_file	= generic_open_file,
 	.close_file	= generic_close_file,
 	.get_file_size	= generic_get_file_size,
-	.flags		= FIO_SYNCIO,
+	.flags		= FIO_SYNCIO | FIO_SYNCFS,
 };
 #endif
 
@@ -485,8 +485,7 @@ static struct ioengine_ops ioengine_pvrw2 = {
 	.open_file	= generic_open_file,
 	.close_file	= generic_close_file,
 	.get_file_size	= generic_get_file_size,
-	.flags		= FIO_SYNCIO |
-			  FIO_ATOMICWRITES,
+	.flags		= FIO_SYNCIO | FIO_ATOMICWRITES | FIO_SYNCFS,
 	.options	= options,
 	.option_struct_size	= sizeof(struct psyncv2_options),
 };
-- 
2.53.0

