Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30F03CC315
	for <fio@vger.kernel.org>; Fri,  3 Jul 2026 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783080011; cv=none; b=YYYG+9A7vu2m5aNQUwemW7jyDy3VGm1u6uxu6GA8ybyp6sm3eYt0epAGgWggOdGrlE+uu+LBRhO5K2WdlgCzpKiFLHEqUHhHNGcbYEdAXhZ+pP0Bblux+iEnW7GimtTYcQAtIpkNJgNXm4JdC2OeKk9P+QLcS0NGe143fKY+N1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783080011; c=relaxed/simple;
	bh=WhPol2U++IZlt0Tt7xSwrNIMPhFr3jgOYJR9Q7ODlyg=;
	h=Subject:From:To:Date:Message-Id; b=UjwlM5uMoJE7rkC6+VQKrRrIAIiE2TlQIWFeyNuSolCexy43bHGhsOGc2bWVtkTADmrpT1PLCQTqAKw5lNh1nbzwrlT4+uqdtmu3Ojaghwvmovb8xDpG1KHNAWx0OsF2XJdF0BxJIsrXUti4E/Tz/jy4acrf+H04Rqac69P9qwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q5aMIYjJ; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q5aMIYjJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=MOzkt8eSHUc5B2rIpqeDubk1wHOlFCQ46/i4JkkQsWU=; b=q5aMIYjJuQvAvv0gB2LS81hktD
	4duikXZ1Jpwn54hQn0XK1OlOumw2PKx/45OVauKbFdIMMqnu80I9M9tOm5JmIJmFeeY/IlrxlDoB3
	ygQUls5gD9ceLo5lkdiFvM+WUIH9bvdGREoUEn+/tap59dchCYPZF0lb3t2v5LK6cpnue8xjdAHVq
	UWMHtSV04/gbPivw0xCIi8wApDzjpwQmvQfdfLmeJGGtI65CYdHjacMDeZcIGQzAZJZokPEDHg0Zy
	27bClh8LlUpiEqgiol2MlN45XDkZg/rfvjx5xDQ7jAqb0UQdIdwAgKvJfVqlH9GEuZWlxSloJBp/j
	LHlsaydg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wfcYv-00000004mPy-0dPm
	for fio@vger.kernel.org;
	Fri, 03 Jul 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 8387A1BC0171; Fri,  3 Jul 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Fri,  3 Jul 2026 06:00:01 -0600
Message-Id: <20260703120001.8387A1BC0171@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit f80c50d9ff50a746cd1a111f1986648963bbf7dd:

  Merge branch 'fix-issue-1542' of https://github.com/cenhuil/fio (2026-06-30 12:23:27 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ed3e687f27802ae0daa60ae96ae9b798ee1b6511:

  Merge branch 'fix-pending-log-iodepth-assert' of https://github.com/SAY-5/fio (2026-07-02 08:46:38 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fix-pending-log-iodepth-assert' of https://github.com/SAY-5/fio

Sai Asish Y (1):
      iolog: size pending log larger than iodepth to avoid log assertion

 iolog.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/iolog.c b/iolog.c
index 36fcad37..cc13ecbb 100644
--- a/iolog.c
+++ b/iolog.c
@@ -876,8 +876,16 @@ void setup_log(struct io_log **log, struct log_params *p,
 		struct io_logs *__p;
 
 		__p = calloc(1, sizeof(*l->pending));
-		if (l->td->o.iodepth > DEF_LOG_ENTRIES)
-			def_samples = roundup_pow2(l->td->o.iodepth);
+		/*
+		 * Up to iodepth in-flight IOs can log a sample into the pending
+		 * log before regrow_logs() runs, and get_cur_log() asserts there
+		 * is always room for one more (nr_samples < max_samples), so the
+		 * buffer must be strictly larger than iodepth. roundup_pow2() of
+		 * a power-of-2 iodepth (1024, 2048, ...) returns iodepth itself,
+		 * which overflows and trips the assertion; round up iodepth + 1.
+		 */
+		if (l->td->o.iodepth >= DEF_LOG_ENTRIES)
+			def_samples = roundup_pow2(l->td->o.iodepth + 1);
 		__p->max_samples = def_samples;
 		__p->log = calloc(__p->max_samples, log_entry_sz(l));
 		l->pending = __p;
