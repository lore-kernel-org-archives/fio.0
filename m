Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A18A233939
	for <fio@vger.kernel.org>; Wed, 24 Jun 2026 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782302409; cv=none; b=qWUpx1Sk1ScO3NvXum481eZAiLV9XzNX/Hrlymk/kt9I2+fCdm/nJGr+byLj1Mqhj4Lo83GBivCTQrPRIaALjSRz91OFBLwKml1I7I6YLIWy2GxOugkN10iCD2d0cEo6f9/D7qtRrxZ92mdgqb1ufCrcVTmhXnim5+Fvj0qv0Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782302409; c=relaxed/simple;
	bh=MnOi9nLjRVeyd6a+HRZe0gk3Mjmb3J4IQQ8L7V/9fdg=;
	h=Subject:From:To:Date:Message-Id; b=kv8g5BZBPz2ppiTbS8/trIe8AI+DFIcNd1AnWT+MqMeBRfuRVkfXttjUsVCy5qwcsdbMo4oUVzh5OgpkZbwintlX3WIqZZL3T3lqwQs5eIrX1YBbpxaXikvu/v5SLkRqK0VbDEMxs/amLpzdBvEeHxxE72XIjnJCP74S4GW5PMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lIxeAGbc; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lIxeAGbc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=QESqJJ/QPwoI07ANvVaSm9xgtUSZa9I4idZsyb3olXQ=; b=lIxeAGbcf9Aosfa84FqJQJoQGf
	RAio+6pjKK3a8g4pbEX+hYlHB7wjXVTmylFg8zT0L4eLJUTCkiwweYyarHs8qYF20AKhg3gF9XJof
	wFY2W5ql9wxsX/RpluTC7FK5xQY4Zreo1SVUUgpdBIIbKc+2JzguUnMaqt+e3G6rXaZxTCrOF0tE9
	u4VPo3/g4LaMRVrxyMVSUIk2DvRhO/XId4Tgt7YNK5crzWozgClR+UL2TtzhX7BUcumdtxY+7R7XL
	uuDwhp6gNHHnpnytQRpxXzF2XkWV5uz5tlHB4PSWjOqGd2h4MfY94f0+Ue+noGPDnVwPTC/jAbnnm
	6hzuGvDw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wcMGz-00000002J4v-0n5X
	for fio@vger.kernel.org;
	Wed, 24 Jun 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id A3C321BC0165; Wed, 24 Jun 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed, 24 Jun 2026 06:00:01 -0600
Message-Id: <20260624120001.A3C321BC0165@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit fb5b6ae8913be8032beb6cbfe0a4772c74d78cb2:

  Merge branch 'pr-speed-up-norandommap-read-bw' of https://github.com/malikoyv/fio (2026-06-15 11:29:22 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2c69e8e9b67c0e8967cb1b9e67a74ef55ef9d027:

  test: run QEMU tests on push and pull request (2026-06-23 16:36:52 -0400)

----------------------------------------------------------------
Vincent Fu (2):
      t/nvmept_pi: improve default fio executable
      test: run QEMU tests on push and pull request

 .github/workflows/qemu.yml | 4 ++--
 t/nvmept_pi.py             | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/.github/workflows/qemu.yml b/.github/workflows/qemu.yml
index 451ecd42..db90b03d 100644
--- a/.github/workflows/qemu.yml
+++ b/.github/workflows/qemu.yml
@@ -2,8 +2,8 @@ name: QEMU
 
 on:
   workflow_dispatch:
-  schedule:
-    - cron: "50 3 * * *"  # daily at 4:50 UTC (00:50 EST)
+  push:
+  pull_request:
 
 jobs:
   qemu-guest:
diff --git a/t/nvmept_pi.py b/t/nvmept_pi.py
index df7c0b9f..520dc560 100755
--- a/t/nvmept_pi.py
+++ b/t/nvmept_pi.py
@@ -902,7 +902,7 @@ def main():
     if args.fio:
         fio_path = str(Path(args.fio).absolute())
     else:
-        fio_path = 'fio'
+        fio_path = os.path.join(str(Path(__file__).absolute().parent.parent), "fio")
     print(f"fio path is {fio_path}")
 
     lbaf_list = get_lbafs(args)
