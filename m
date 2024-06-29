Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF8A21364
	for <fio@vger.kernel.org>; Sat, 29 Jun 2024 12:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719662424; cv=none; b=TCB3VFK8gwgfdGEookFfL37taoYl3hQM5uUxQ//f2FCbTxmIjhaH9gc0r+tvbixaTzJJaFt9mOuzR2eREH8jBmYcSWtdKb4X7f1NdCl5i2dYNXoifBmfOjBjcR5FV8n6p8NYLthtEZ1qBVe5JSGVppXF60LLXjMz9AF3tr4280E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719662424; c=relaxed/simple;
	bh=5nMaCjDWzKJYm7cvXumwh3mQsgDGew8UbBWLY6N6Xn0=;
	h=Subject:From:To:Message-Id:Date; b=CFYBKhDfFQkSGdfKPH3rpkv5Zv2+wd2RUaSTZ+gEN1yI43oWA7zMrC1+IQF7iBX8wMhuGzBGqYS59XJVNlnb7Z3Yx6DT7T4xmSGZ4XuXLY36ZRBZltUnhe0GA2YyH3DjzSAN4iursUPhkGHspzBCDCPXvunSUojLxOAcP81BNGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W/Qa01C4; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W/Qa01C4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=zp2wmyqrPjfhV/go+GmJ+QalSfYVXieiLSQc5gHcVr8=; b=W/Qa01C4nDn+r8Avx1vGPBbiNk
	jGbnWOp5e87XBTaXywjIvAS58rc7bFA5DBf6fcmKFZjVKtyj66nAhHqu4J7KKxkbVR0vkXb+8e1Bj
	obu7y7OSqHDIgLWduu/YNDWXuDwtRPAvVsGx6mmnVBm34xlRNnoMF0vn5u7Vw7aXN2Z5dRATATRnb
	YgXQbyCWbz3iv7b/1E1O+mdSL9zE37vPYyic4KRyLyCipCpR/w8YRuthecxsztKfN9/f/XGb6v7S9
	IMFxoY7AN3RqAZ9Uo0c4Zy73SlOhl62PRryyOQR1idqZvskrSTZ8SjKsxipQV02mSONUcpnqo+1R9
	Z0Cn9efw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sNWkO-00000009B67-3zD7
	for fio@vger.kernel.org;
	Sat, 29 Jun 2024 12:00:10 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 14B8E1BC014C; Sat, 29 Jun 2024 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240629120002.14B8E1BC014C@kernel.dk>
Date: Sat, 29 Jun 2024 06:00:02 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 05a52be478dbbaa73d7ef563133125b24c001f1c:

  Merge branch 'nfs' of https://github.com/panxiao2014/fio (2024-06-14 06:19:28 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6eaa6422fccf857e6b1a88492db805dafca8ee85:

  windows: don't define strtoll for 32-bit builds (2024-06-28 18:48:43 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      windows: don't define strtoll for 32-bit builds

 os/windows/posix.c | 2 ++
 1 file changed, 2 insertions(+)

---

Diff of recent changes:

diff --git a/os/windows/posix.c b/os/windows/posix.c
index a47223da..2ce18b8b 100644
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -873,10 +873,12 @@ ssize_t writev(int fildes, const struct iovec *iov, int iovcnt)
 	return bytes_written;
 }
 
+#ifndef _WIN32
 long long strtoll(const char *restrict str, char **restrict endptr, int base)
 {
 	return _strtoi64(str, endptr, base);
 }
+#endif
 
 int poll(struct pollfd fds[], nfds_t nfds, int timeout)
 {
