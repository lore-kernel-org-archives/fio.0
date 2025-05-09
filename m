Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC8422129F
	for <fio@vger.kernel.org>; Fri,  9 May 2025 12:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746792015; cv=none; b=Hdv3X6nyzd1QigErGjkLE5D6mnI9aORAmWrW89STmBS0Zv+xh0lYKpyWe92MXqwNZogwkHNnIWqCIuItaUCQfsWRsdiQQoYVxplsRt58jXYEU1lqwI34Elxw2ARCH/7uByGBqOIR+xygT++5gmZEgoHnCKn8ORlMZo1WSD0h6oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746792015; c=relaxed/simple;
	bh=ZBPnI5Kk1ow93bTATzInIp3n65ZIr82AGfTpMTG1URk=;
	h=Subject:From:To:Message-Id:Date; b=VtTPFb0Sgy4+Hs8srdLr0eLFAO/3JD22Uw7MV9OjYPYJT68TQhfz3VD1bVNyaMJhmMFgOehvZmQOPCtxjLXhL3He4A++qFYuNgbGmgRo/qoy77vT20NhjMYVwj6ch9TO0nF8WH9sX8KZWhezdzU4x49VLfOvqGFG5BiBlYJzekg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UiwxPSi4; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UiwxPSi4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=CjNcYGo51dt2EtL7imlISFQvk2FpWn+9egVmfAOqYNk=; b=UiwxPSi4k0IhjJP12wQEzRsDgJ
	1VbzMoZLPU9egft1+eM6VRYlPmWtCls2o4CtVg0/ZNdZk82ILKyk1gtG69tUloFWXynm42KUSiTOU
	DsgWUmeSsEt/1VdJ8RiLl0bEl9iEJ7GNP7c1t84V+6ECfCw/nISkMZ7WcHJWf1FuhSsyjYQJUAeXb
	WpynZMxrCC6C3GF+u3Q4dQkElmt901KncoE+sjbTscPttNfCh3vTtK6um46na0e/v5UTVlkgHMMAP
	B9NwjYuJeCh2t2ye1Y4c4Yy878/Hp06FViZWqfEo4tLxJJe7sOsI+DTq6Mqoxy/6PAidyLmnXJqW5
	ETE7SaOg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.1 #2 (Red Hat Linux))
	id 1uDMOe-0000000GGOl-0TC8
	for fio@vger.kernel.org;
	Fri, 09 May 2025 12:00:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 0C4431BC016B; Fri,  9 May 2025 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250509120002.0C4431BC016B@kernel.dk>
Date: Fri,  9 May 2025 06:00:02 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 1276068fa9ecfede2fcfb2068f4670a553a6dfa4:

  Merge branch 'continue_on_error_fix_up' of https://github.com/kawasaki/fio (2025-05-07 19:18:57 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3a2b42b355fa206c794b2e3640a128ff9b59f118:

  windows: fix pread/pwrite (2025-05-08 14:03:21 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      windows: fix pread/pwrite

 os/windows/posix.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/os/windows/posix.c b/os/windows/posix.c
index e3abf383..3e48c3ff 100644
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -830,18 +830,24 @@ ssize_t pwrite(int fildes, const void *buf, size_t nbyte,
 		off_t offset)
 {
 	int64_t pos = _telli64(fildes);
-	ssize_t len = _write(fildes, buf, nbyte);
+	ssize_t len;
 
+	_lseeki64(fildes, offset, SEEK_SET);
+	len = _write(fildes, buf, nbyte);
 	_lseeki64(fildes, pos, SEEK_SET);
+
 	return len;
 }
 
 ssize_t pread(int fildes, void *buf, size_t nbyte, off_t offset)
 {
 	int64_t pos = _telli64(fildes);
-	ssize_t len = read(fildes, buf, nbyte);
+	ssize_t len;
 
+	_lseeki64(fildes, offset, SEEK_SET);
+	len = read(fildes, buf, nbyte);
 	_lseeki64(fildes, pos, SEEK_SET);
+
 	return len;
 }
 
