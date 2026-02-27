Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD5F37106A
	for <fio@vger.kernel.org>; Fri, 27 Feb 2026 08:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772179950; cv=none; b=R8jneqfj1hTsI06OwNMmapSrWg0e6uVQw8TbBNs1Giakk9+R8AbRA2ahOb6k6jB7pVjfWPfhnueSOuTmunyxC4YAS8iaeEPLV6jUc0UbLkCakfhVbSpSwOcOekwPYAsAShZE9N2IBT8TBTpPHH5E/0g7evKhc51Os+YRJZudNuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772179950; c=relaxed/simple;
	bh=EXjx/QpSgl3qv4k5dZDJfobpQRZrzkxtfc3t5y22JQo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEJ8u5SQXCOgh6jUAU4rn+8RDXypP2snZ/KCPXdXM9MjmDF4X3ZPoflMYTzQAe41YbP9q2Ot/wrpTtkC9k/f5zHB+3dk4ro+QDFqjbc63C4dv/3nBSgO+XwCTOgOhgwC18RpB3JvDkkk9VSYSd/pWyVOYl6+NdNb853EqyguWUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I/XKsH9f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I/XKsH9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE712C19421;
	Fri, 27 Feb 2026 08:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772179950;
	bh=EXjx/QpSgl3qv4k5dZDJfobpQRZrzkxtfc3t5y22JQo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=I/XKsH9fl2ctlsTYAkilaIkIPGaisR1THcEe63pOJdjX6bXWzIx9zai1V7Wl/6SX/
	 cgqWOctdh7IlZ3ErGKnKFXMdiKwzNkdOtUbUi0a6cP+QrqwUPLfSO3gKXkPoPFTwG9
	 J20sSkZGnngoM/msxDzWuRdrXHY7ryUPPaFbwZeWK+FH0sbBIFBeJw44eyZxQVRqsG
	 kiXrL3BYjf7U/8enyYUeGeodvpSr4CuBecrhhpU9LE7M8nAuUjSXEJZvW9DYtDu7ED
	 M1Ek4y+RxXm8mgAssvDFdKvaTvC5SX6z75vp56Ehm+t1JEriGcD2A1yRPwaXKmraya
	 w+LIEwJTUBewA==
From: Damien Le Moal <dlemoal@kernel.org>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH v4 2/8] engines: sync: add support for DDIR_SYNCFS
Date: Fri, 27 Feb 2026 17:07:05 +0900
Message-ID: <20260227080712.2422380-3-dlemoal@kernel.org>
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

