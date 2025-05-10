Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21041DF25A
	for <fio@vger.kernel.org>; Sat, 10 May 2025 12:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746878425; cv=none; b=WiyjJXAgMFXEc4swOaNnAW9oWk29qu7Ityd+SByZWiiXbmNugyu1HeAG0N6ZR7cr/AYpGOMHB66B/bLIiiohiPsmUVPCDs/I+/cJHRD5gXP9OOP+dTcekBzipDUYNkMN4C/1T53WAviJhpornMyHgE8NUVWizM2MwL5Kj41qtVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746878425; c=relaxed/simple;
	bh=gPOQUrmdLy4GeLtpZBqJkrWIEw5ALD7pYdTCtoKpyYw=;
	h=Subject:From:To:Message-Id:Date; b=Y/DYiUuhisz1j81kTOKbcCDfOso3NigyA6EM4bBSgZ0FM6SQssg1rswaF57BBop4Vap5+2uR69A+xEhBLjJhvj9YcA/zyVd7CDrflLfibD5qax6NZIt3w+/yEz2aKm6IVnwHz1hKhzUGZh8kTdJNwZbyheEyBU6E8ngnKh3P50c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a3fp9/VV; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a3fp9/VV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=bUHsAXOisekyiBE32tqZwVJITjD4MaAQ0X8DEBSQ39k=; b=a3fp9/VVLMEpWgp5JtZR0w1wEZ
	ql1T8vBLIs48ZWTsdPZdFArNshkm7CgSgfIlVj5NYO7TK0QosDnfeXfHFhBr/dNQ6RRTfppj0nKBi
	CxVwIieZ02GTEIgjBvdXSoFn9g7gRvkTZVB4EcOidmBDqFlDq77iakTQJH4QFZfz6tHN5rQ15V+K3
	adeYmR9dLL/m34KlVIG0WRvVUPv4Bf/H2EXXxyg3RWDD3dW+ZyN2wFgY/KQChRrl/dtAPTUNtMZEL
	xZFy3Zha5E/Zi0FXYztVWNCg3q9uIr8GArIIcqBqsYiNdHcuvfS2i5hJUDPQg1qapL6bJhiaUrJuG
	NPc5ZyaA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uDisI-0000000DQKw-2LMj
	for fio@vger.kernel.org;
	Sat, 10 May 2025 12:00:16 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id B1A891BC0144; Sat, 10 May 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250510120001.B1A891BC0144@kernel.dk>
Date: Sat, 10 May 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 3a2b42b355fa206c794b2e3640a128ff9b59f118:

  windows: fix pread/pwrite (2025-05-08 14:03:21 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f4e54d3fa7bf94a17648a4439f06ca7dab4291c0:

  man: Fix recover_zbd_write_error option description (2025-05-09 08:40:30 -0400)

----------------------------------------------------------------
Damien Le Moal (1):
      man: Fix recover_zbd_write_error option description

 fio.1 | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/fio.1 b/fio.1
index 8476b681..69dd892f 100644
--- a/fio.1
+++ b/fio.1
@@ -890,6 +890,7 @@ A number between zero and one that indicates how often a zone reset should be
 issued if the zone reset threshold has been exceeded. A zone reset is
 submitted after each (1 / zone_reset_frequency) write requests. This and the
 previous parameter can be used to simulate garbage collection activity.
+.TP
 .BI recover_zbd_write_error \fR=\fPbool
 If this option is specified together with the option \fBcontinue_on_error\fR,
 check the write pointer positions after the failed writes to sequential write
