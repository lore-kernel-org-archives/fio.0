Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3829D1CBE89
	for <fio@vger.kernel.org>; Fri,  6 Sep 2024 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725624016; cv=none; b=qgsadEet4PzDu/pN7mn92fprO/Hpt5f/DlA4fmUo7RDmBHbE2LPrZFdhDCjBzo6A8rNIJ9GUSEFkPDTO/H6cbzGw6KjBawN9dpgkqXN7AGqUS4nPMet9loFX2dqzRZ7jnstV2adi/2rcISHOvgiBCZ4Qj/8ufk3T16zH1opyh9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725624016; c=relaxed/simple;
	bh=cIHxLFY7W8fPLz52RVo9ZS5lnM9QOL3RCGRa72SCPCk=;
	h=Subject:From:To:Message-Id:Date; b=uIlqZoGinOZPJQpJOlH1vDDdZSnjzOE3BQKVG3OaVMi/su2HiFnYrnUXzMU6VA3Zlf+tDrOnezZcfyfZ8POzSPaquIrojhV13AIzvNS3GSu8liKVCuL88e4pz5sDwFhbMrVqM45z+sm9jC542yCO+Fl2BAxwIouVa5nBL/ZbOxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iRuILXJd; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iRuILXJd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=3qk+XRPqPlpT5UKENjazZnlnNON3GOAEpfLgU12d2Tk=; b=iRuILXJd2aWVxrWMyCr3nzh5Pe
	kBlWXhN7shu1zp8/rDEP58Pow5fbqrdD98npwwMa08rRKkVgqnoxNQdMFJBLn56+uoIX86wSzhUEm
	Nlz5uOMAoI5erF6TkqvHHEcApQIj5ITrZptS8AKhMXXcaKfPmOHqscsmqwB2+N7eIBgbxl02mPlae
	7TUUakmmjFUzJQuo3Ix/+8ZvK7HmynghC7N5PZ1O+yvMX34Pa6lypW8lMw/WWTLhrAotjFXteG+En
	skO4fj5qiIKUPiksWDDLKySAJdWZb6ebdKmmQTECwX7nOJ6O6T7mz7WXIhS/hItMsMpPwSXR4rl9v
	Z8SEZH9Q==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1smXdH-00000003qbj-3cCR
	for fio@vger.kernel.org;
	Fri, 06 Sep 2024 12:00:09 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 656991BC0151; Fri,  6 Sep 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240906120001.656991BC0151@kernel.dk>
Date: Fri,  6 Sep 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 20d0ba84d3b7e7abd8a3318175b46f5e5363547d:

  t/jobs/t0034: add test for the log_issue_time option (2024-09-04 13:59:45 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 65098b11f8aa28e328c225dcd39e3338bb005fdc:

  iolog: add va_end on error (2024-09-05 14:35:30 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      iolog: add va_end on error

 iolog.c | 1 +
 1 file changed, 1 insertion(+)

---

Diff of recent changes:

diff --git a/iolog.c b/iolog.c
index aadb0d05..ef173b09 100644
--- a/iolog.c
+++ b/iolog.c
@@ -1022,6 +1022,7 @@ static int print_sample_fields(char **p, size_t *left, const char *fmt, ...) {
 	ret = vsnprintf(*p, *left, fmt, ap);
 	if (ret < 0 || ret >= *left) {
 		log_err("sample file write failed: %d\n", ret);
+		va_end(ap);
 		return -1;
 	}
 	va_end(ap);
