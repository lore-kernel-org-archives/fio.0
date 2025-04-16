Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C502459FC
	for <fio@vger.kernel.org>; Wed, 16 Apr 2025 12:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744804810; cv=none; b=KhISnvSC+laDWzHcByxDTwxxc7NVxq7ISYgo/hgpn7Ieqr6Y+X7MdEV3d5rzZ9FtzcIVHU1JDj3xuBp/Wg0x+2QuPHFgmDGrfHlGrhR4U1KUO2b6rf9AVkHYQui9ZCeJJgfGaIhjx5hUxlgSmmYqNR6xWmsCM9TPleKvvUE/RRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744804810; c=relaxed/simple;
	bh=8+q0HMIXbFTzd72Lemp87MHf7yUiIk9v3kVqGvG5DfU=;
	h=Subject:From:To:Message-Id:Date; b=GAmWMFdgDWyes2Bsd7FRAObw/xPVjpTPrHENj/Iglju/+DaKuffH/UhISakO5jjiQTcNGFWBOFGSQRFQB7LxSlfazVc1Vnx+D4dWHj4Fec+Q5PmqlJt5u14huy7lY6gfLl6NCdN1x72wd8Sg/CcijRE7JIOGdpQyW94XxrHxpVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mRecd+SK; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mRecd+SK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=IkPC5wvKgc1vr3ArZNAYrCadHsSAEHL+vMXMQRCXIn8=; b=mRecd+SK8KQ2tnjHDCOd2Dupuk
	6/Be0IY+gT0aFPHhuN0eszisiWhPioDeGg7DNdyr4T8QqGwjzub7x2qx8SaipCF2W1NLVyZM5cyQ3
	gsQ+N2DPmnqkSWyTKjAuKBmetJTFHW25ree/h8EV0J6tb9NwMFnnm3YYxpm4pNgI0yS5c2qN1rfnJ
	A+7NpCKn/h9r9rpRXGcJkrQD2WavZa3LK0aj83ZeTxiQVl34MSIq1qybRNu9iNkihGW5c2ETgHBBG
	tdzt8xlo9sJzjV/l3V6jhILKVGVROxc8vvPUyYk38Mut4bhjFzyVEDSTHaCQsj4krXH08tlspitJW
	j1jORcYQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1u51Qy-0000000A6Fj-073A
	for fio@vger.kernel.org;
	Wed, 16 Apr 2025 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 86A4F1BC0166; Wed, 16 Apr 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250416120001.86A4F1BC0166@kernel.dk>
Date: Wed, 16 Apr 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 96afc2337db197a59fae916b5ff4226af8b0108f:

  t/zbd: add test for the case all write zones have small remainder (2025-04-14 08:27:31 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 19d9ef1e091a78ad651703d19c07886cb5dfd302:

  Merge branch 'master' of https://github.com/blah325/fio (2025-04-15 19:02:20 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'master' of https://github.com/blah325/fio

jrizzo (1):
      Fix hang on Windows when multiple --client args are present

 os/windows/posix.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/os/windows/posix.c b/os/windows/posix.c
index 2ce18b8b..e3abf383 100644
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -899,10 +899,9 @@ int poll(struct pollfd fds[], nfds_t nfds, int timeout)
 	FD_ZERO(&exceptfds);
 
 	for (i = 0; i < nfds; i++) {
-		if (fds[i].fd == INVALID_SOCKET) {
-			fds[i].revents = 0;
+		fds[i].revents = 0;
+		if (fds[i].fd == INVALID_SOCKET) 
 			continue;
-		}
 
 		if (fds[i].events & POLLIN)
 			FD_SET(fds[i].fd, &readfds);
