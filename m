Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D67C636CC
	for <fio@archiver.kernel.org>; Wed,  8 Feb 2023 13:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjBHNAN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Feb 2023 08:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjBHNAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Feb 2023 08:00:13 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F5E5B8D
        for <fio@vger.kernel.org>; Wed,  8 Feb 2023 05:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=SnXdzPB4V/qW97BBFa7zv3YsDrHq4dhYIHOhXg67u2A=; b=cwf25JdVOnS8qmN2DE1ANWgs72
        GPV56075SoY38B69SqJLtS9y1asd64gaR120wMLKaryQXgFLWUB7Xc4cD+AAYyNBL6Kh2Eg2WYwGm
        qfLTvJhoqw1EpZMeHwcr75b/4HoYdxR2ScIKK9WiZWpegiuJHpEXoBDYhw1BbcweN1qvlRWKaGxO5
        9l68PmLKyeStVgKoYy9xv5VEkdCreTErcI6GTHjYbFS5ayXk4dNj5nhhwOp/++vlSiaIlqsiPKDxI
        272GQbA6AY/8clXq+xqzgwnYb/aUQCl+mtAfOS9UvdS2Id+gDOpVGjU4w7dCyqbUp736zXsQx4TJQ
        tyyptm8w==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pPk2s-007P8n-2N
        for fio@vger.kernel.org;
        Wed, 08 Feb 2023 12:59:31 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id C34F71BC014D; Wed,  8 Feb 2023 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230208130001.C34F71BC014D@kernel.dk>
Date:   Wed,  8 Feb 2023 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 6d7f8d9a31f9ecdeab0eed8f23c63b9a94ec61f6:

  engines/libzbc: set FIO_RO_NEEDS_RW_OPEN engine flag (2023-02-06 12:36:37 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f0c8ab1c36369d8d6aa214fba572dacefa3a8677:

  ioengines: clarify FIO_RO_NEEDS_RW_OPEN flag (2023-02-07 10:44:00 -0500)

----------------------------------------------------------------
Vincent Fu (3):
      Revert "engines/libzbc: set FIO_RO_NEEDS_RW_OPEN engine flag"
      engines/libzbc: for read workloads always open devices with O_RDONLY flag
      ioengines: clarify FIO_RO_NEEDS_RW_OPEN flag

 engines/libzbc.c | 6 +-----
 ioengines.h      | 3 ++-
 2 files changed, 3 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/engines/libzbc.c b/engines/libzbc.c
index dae4fe16..cb3e9ca5 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -68,9 +68,6 @@ static int libzbc_open_dev(struct thread_data *td, struct fio_file *f,
 		if (!read_only)
 			flags |= O_RDWR;
 	} else if (td_read(td)) {
-		if (f->filetype == FIO_TYPE_CHAR && !read_only)
-			flags |= O_RDWR;
-		else
 			flags |= O_RDONLY;
 	}
 
@@ -469,8 +466,7 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.get_max_open_zones	= libzbc_get_max_open_zones,
 	.finish_zone		= libzbc_finish_zone,
 	.queue			= libzbc_queue,
-	.flags			= FIO_SYNCIO | FIO_NOEXTEND | FIO_RAWIO |
-				  FIO_RO_NEEDS_RW_OPEN,
+	.flags			= FIO_SYNCIO | FIO_NOEXTEND | FIO_RAWIO,
 };
 
 static void fio_init fio_libzbc_register(void)
diff --git a/ioengines.h b/ioengines.h
index 2cb9743e..ea799180 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -90,7 +90,8 @@ enum fio_ioengine_flags {
 	FIO_SKIPPABLE_IOMEM_ALLOC
 			= 1 << 17,	/* skip iomem_alloc & iomem_free if job sets mem/iomem */
 	FIO_RO_NEEDS_RW_OPEN
-			= 1 << 18,	/* open files in rw mode even if we have a read job */
+			= 1 << 18,	/* open files in rw mode even if we have a read job; only
+					   affects ioengines using generic_open_file */
 };
 
 /*
