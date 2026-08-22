Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E643BB9FD
	for <fio@vger.kernel.org>; Sat, 22 Aug 2026 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787400012; cv=none; b=IW7czN+gpZ4UVaNIrvaIf6/37qaNWvPFAmgBlKhwAea8koMuz8emZkYYDfxqnfbDpoZXU1nNF6hPa24nw5CjQcxMM4EPYlbwJfrgfJiwatAtBEMOldVMhRx22ge+WNu+CqycyVFo9w4sOpkr8m6DNFLYQ3o88xhA63UHEugChuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787400012; c=relaxed/simple;
	bh=eO6z03+tQTmezg/RGd9En7PlsBh0VdRXqPsoz0gvE20=;
	h=Subject:From:To:Date:Message-Id; b=Tqq8hWqF1FFF+daNNJqH29XCMW9iVF4L7aunrHdeUUcNU4fDapr0e+zY1itmCnxo3/hoCa2NcajkgAvAuY2xQAy2YJyVlJ6Mubt2lFuNvY936IjfQlKYR0cvUhv3nZtFc9XgYAPV/zXlt7ehf5HRFiOiSrhdEhKOfzB979atajg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ajc4bCG1; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ajc4bCG1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=S64fVs2fILKXwhbH/OkNC+jnmUcbBaLWsOn9pjNvohc=; b=Ajc4bCG1ATSNTGMmDL23Yk8/Eh
	N/fyx2cUxGzC9ZsO0Lp8UuLDqzpLC+/qruiMBve8+eIHamSiinbomUf4vyq+FmN5+4xL7y6to8k52
	UdXQ1mV9SCJm6FS97zPkNKbix66Ax70vMnaGNHk+QYeJb41Srgii94iueMQrOs37wR4KJ6wc7J0za
	NMzrLg1dl9XrRj5eqKlO968GEZ2SIuRMi3h5xLgznQoz4P9C6iVYIE/ALqEoRA0OaiAW1PNk2Zdxm
	xSiAJu3xFmAfXahyFGYk6VH7+2CwfjLTHPB2dsiQ7HM2uWGx4hFkK40pIfPniFHaRT32J+DuiyX/7
	vUrPWk0w==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxkOL-00000001OrL-3diM
	for fio@vger.kernel.org;
	Sat, 22 Aug 2026 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id E5CC31BC0178; Sat, 22 Aug 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Sat, 22 Aug 2026 06:00:01 -0600
Message-Id: <20260822120001.E5CC31BC0178@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit a9f011b10a4b1795c6c340cef24b0b4a441570b5:

  t/io_uring_cmd.py: test new bsg features (2026-08-20 18:25:48 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f5344384f7c7b6e9e6aa9336e476e8f6eb54dd3a:

  Merge branch 'doc-fix' of https://github.com/Panky-codes/fio (2026-08-21 12:31:33 -0400)

----------------------------------------------------------------
Pankaj Raghav (1):
      doc: change RWF_UNCACHED to RWF_DONTCACHE

Vincent Fu (1):
      Merge branch 'doc-fix' of https://github.com/Panky-codes/fio

 HOWTO.rst | 2 +-
 fio.1     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 410be6d3..e6a08800 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2684,7 +2684,7 @@ with the caveat that when used on the command line, they must come after the
 	a writeback is initiated before the syscall returns. Pages are evicted
 	once the writeback completes.
 
-	This option sets the RWF_UNCACHED flag (supported from the 6.14 Linux kernel) on
+	This option sets the RWF_DONTCACHE flag (supported from the 6.14 Linux kernel) on
 	a per-IO basis.
 
 .. option:: atomic=bool : [pvsync2] [libaio] [io_uring]
diff --git a/fio.1 b/fio.1
index 915c8407..3988e8a9 100644
--- a/fio.1
+++ b/fio.1
@@ -2430,7 +2430,7 @@ after data is copied to userspace. Writes work like buffered writes but
 a writeback is initiated before the syscall returns. Pages are evicted
 once the writeback completes.
 
-This option sets the RWF_UNCACHED flag (supported from the 6.14 Linux kernel) on
+This option sets the RWF_DONTCACHE flag (supported from the 6.14 Linux kernel) on
 a per-IO basis.
 .TP
 .BI (pvsync2,libaio,io_uring)atomic \fR=\fPbool
