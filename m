Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEA72EA720
	for <fio@vger.kernel.org>; Fri, 26 Sep 2025 12:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758888010; cv=none; b=t++b32xGvzKOZBB7EJ1w9w1na/NY2yG8V8wHOIkwBmy7S/gginEa+DwDMXLHnNWJ93Vey5ZPYrTWkNtHUUm6XheE9bTtViHgQEg/iO7eS0ZbUSXmU2RlUE2Z2zEmVfsV3oGMpo7IylrGI0OHkZL9Nj77WbEnPJBpwqpw9yQcdiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758888010; c=relaxed/simple;
	bh=mRXIVaEzerhXwbke7j224WaPr8cEeC9u3b10JfNVxtg=;
	h=Subject:From:To:Message-Id:Date; b=ZTfSpibQYNBKu2rYFHRiibzMWf6Mszq0btQIisegFYj49G6P3LuVy+VGXqeeNUr10u5v5soQfeJtpCZhM4OhvCZyO3VSKXdzyaKbHz/aZwanaYeDQBjtkKMKGL3ucK6DJQ/LJE6eNx9OaKtyoAAi0PrtioLrqxbPSxtHGVdYwZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JYexup5J; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JYexup5J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=hCqBCt2Wpk7ujOdozkoLf37zAnhfL/JDiur7ZJMZhXc=; b=JYexup5JV8ohuPjQbpCwNobNEt
	G02In2RymiypS5Tf+XgyqGpwDXT7diyvAs2IRAORSrvxAX4MSv8nIabiT9FBFAs5XTD6GX0f7CLiP
	Rp7o7wmBkczsNA2/jWrv9yhZrW4klNXOxN817SnanRKrz6WFo3mF1N6vCcy2bdtVWG7RJnJrWzCn2
	c6QBD47BQ6Crl7GglR2G2ZyCcMtC7kSFVQdonk1vrEhOlJ4ZjALmz5GjG2W74QkF3/hmADPBRm/Qt
	qr8LXyh7mmMO0YgiI8aegeEydDUQz2svUvrwFwBx49KJOKKPbn2PpiG42MlXvQWlop+UYDnjBLtGG
	Gin3SAFA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v277L-0000000Belk-1pBJ
	for fio@vger.kernel.org;
	Fri, 26 Sep 2025 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 9C4501BC0178; Fri, 26 Sep 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250926120001.9C4501BC0178@kernel.dk>
Date: Fri, 26 Sep 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 6a39dfaffdb8a6c2080eec0dc7fb1ee532d54025:

  options: check for NULL input string and fail (2025-09-23 11:50:46 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to cda225765af700722a1c621aacda2ceb45929e52:

  Merge branch 'master' of https://github.com/kaimeyer-arcserve/fio (2025-09-25 23:06:37 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'master' of https://github.com/kaimeyer-arcserve/fio

Kai Meyer (1):
      Fixing mingw out of tree builds.

 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index aa6e27df..7393a327 100644
--- a/Makefile
+++ b/Makefile
@@ -276,7 +276,7 @@ ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
   SOURCE += os/windows/cpu-affinity.c os/windows/posix.c os/windows/dlls.c
   WINDOWS_OBJS = os/windows/cpu-affinity.o os/windows/posix.o os/windows/dlls.o lib/hweight.o
   LIBS	 += -lpthread -lpsapi -lws2_32 -lssp
-  FIO_CFLAGS += -DPSAPI_VERSION=1 -Ios/windows/posix/include -Wno-format
+  FIO_CFLAGS += -DPSAPI_VERSION=1 -I$(SRCDIR)/os/windows/posix/include -Wno-format
 endif
 
 ifdef cmdprio_SRCS
