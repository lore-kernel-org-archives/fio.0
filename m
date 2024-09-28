Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37488185B7B
	for <fio@vger.kernel.org>; Sat, 28 Sep 2024 12:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727524818; cv=none; b=Rakpo2j1uXWEL6KZ9/as1WMoELD6zLk2PLevwfldbqBXgJxCKEpm5sGWtJU1jovMvowsTdztQ9WDS9mMPtobn2+I1cmFy0GD8fmXK4cMoSPt57MDool2EkaTupUeXGbOitP+Em89FsXjGN7CnDT7dfqiUqtiBGaEGbEYjaAJT8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727524818; c=relaxed/simple;
	bh=kDgvRfWSH6iCwdV/A7jh7rusq9Zf5vF/kxCT2NKaGM8=;
	h=Subject:From:To:Message-Id:Date; b=o2FTonSZvWHais7S/OpEzY7PeG0QON09TStbYajA57uRDSNPIQJLj+uyH51/6Wx6gLAVrTcaryskWz3zMt7TVTQJxgYrLcIS5d4XzBrf7c26NIet3pBWAN3SxVJjyS2J4B66hw/Ei5qctqmmTtoEgBeV/71Mzzm6/Peq2OBLKOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=G2KKPPrQ; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="G2KKPPrQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=085iumLua2rvzhKzWRG8HYED4VirisYAn6BYChMgc8Q=; b=G2KKPPrQMDDZ8FrS5fGESLKMFM
	wUFZLHo0JkLhyJGWlQ6Dsrqn41SeQSSRgfuM5v3CschtQmqE0gfOvxTNs/yw7ydjsUbzefmaYSrdj
	nDuf+X7VEQIYBzJvnDAfeM0inu8mQYVdUaA2bBQuJHXcXQXE2FTzT3RlgsIH0xCo6yM6tkxqAfqIy
	yZpQRgZ/wralAZVRNslNCc5b7J7p2t5H0Euvm22zmq1k/l8S26uv8hyKKOa1DXwScMepKn+FaU1CA
	FJXU2fR+bOIbfpfmkgJVuz0UmQnNjaDrfXiv7BSlDDWotZmNBAyTCWWDZ2hMyeuQNGuB5bP6GHucb
	RnJvNRnw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1suW7M-0000000CBxD-08ad
	for fio@vger.kernel.org;
	Sat, 28 Sep 2024 12:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 7AA591BC0172; Sat, 28 Sep 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240928120001.7AA591BC0172@kernel.dk>
Date: Sat, 28 Sep 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit e4e8520b374e7e021d289d400ade70c41681d635:

  engines/io_uring: Fix negative errno in io_u->error (2024-09-27 04:18:26 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fef1936ee2be62bdfedffef472a124fded94633e:

  ci/qemu: change the name of this workflow (2024-09-27 19:33:57 +0000)

----------------------------------------------------------------
Vincent Fu (2):
      ci: allow GitHub Actions workflows to be manually triggered
      ci/qemu: change the name of this workflow

 .github/workflows/ci.yml     | 1 +
 .github/workflows/cifuzz.yml | 2 +-
 .github/workflows/qemu.yml   | 3 ++-
 3 files changed, 4 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index 6fbba591..d20a2d01 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -3,6 +3,7 @@ name: CI
 on:
   push:
   pull_request:
+  workflow_dispatch:
 
 jobs:
   build-containers:
diff --git a/.github/workflows/cifuzz.yml b/.github/workflows/cifuzz.yml
index 9227735e..d12388f1 100644
--- a/.github/workflows/cifuzz.yml
+++ b/.github/workflows/cifuzz.yml
@@ -1,5 +1,5 @@
 name: CIFuzz
-on: [pull_request]
+on: [pull_request, workflow_dispatch]
 jobs:
   Fuzzing:
     runs-on: ubuntu-latest
diff --git a/.github/workflows/qemu.yml b/.github/workflows/qemu.yml
index 4ba8bfae..f987b33c 100644
--- a/.github/workflows/qemu.yml
+++ b/.github/workflows/qemu.yml
@@ -1,6 +1,7 @@
-name: CI
+name: QEMU
 
 on:
+  workflow_dispatch:
   schedule:
     - cron: "50 3 * * *"  # daily at 4:50 UTC (00:50 EST)
 
