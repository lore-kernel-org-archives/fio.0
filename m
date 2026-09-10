Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EBF47CC91
	for <fio@vger.kernel.org>; Thu, 10 Sep 2026 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789041610; cv=none; b=UPsxd6iTQPD5moaeZyBTHWwhHnO991iSHxV91RWWX9cFlP1rxy/ToBc1cWucLbRBYxFnIfDOcNAMnUCjtXws6H3G0hqPYPG96q/F/N5Lmho8hBjQNnmSwauL7gzEdcI7TEtfaKo0nQkKYbr6idquolZTb/b9vmOKiZuu5mxavs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789041610; c=relaxed/simple;
	bh=Dtbap74O1KNAlT83hR8InbiBgEno4HoxZDHPUKrwOcs=;
	h=Subject:From:To:Date:Message-Id; b=k5s8DxN42AQMrqAYVRH9v2gml19jCkn5yk61H9oJkUsQBCqIgUE+nQvzMm/XVvDgV+L50b034ketDQZ9d1E599/ZTqd1qvSGKpas4rOmPg5zfRaMjxPjlLIYVbUXNn/eWh4tFDDn6DiKj7ToX4kPdQpRRjIYtWu4dDitqUQNBbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HytYs/u0; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HytYs/u0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=65wo6LuLUVm86tXkik8NQwwfw/YHk4c5GUEVX2dhGpE=; b=HytYs/u0InTIvaRviz/WJ5oj8m
	Kb9/DbvIUaU363rUXU+UVZiaejfJCEkVn+Veu+L2LjNSO8SNKFfgCFtGyfSMZzI/iVPqrnt2bfa0b
	WR6w9CYEO+vhAFRrIik/kllT9Z3A6+nzSslkoJyh41mLczNbM+5o3xFSOLzU/DsPaUlYXCAePwNia
	VQ8STTcs5fSNIRyh0XoCFDjXq4Fx74AMyUwrMFkczqRw4Yb8YhA0dlPj8sBGLFg43IGzv+ftp2oqU
	fX4AS2suKaMWBese6A83+19acb7NUoMCU+vSJ3navmGTCOVSTaJ60DkC5RO2hg2oyQA4C2Fxbj5i/
	9A+FspJQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x4dRk-00000002R3n-1zZM
	for fio@vger.kernel.org;
	Thu, 10 Sep 2026 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 99A651BC0157; Thu, 10 Sep 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu, 10 Sep 2026 06:00:01 -0600
Message-Id: <20260910120001.99A651BC0157@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit e333e45bd1e7503388d71932af047ecfd22c25da:

  ci: resize image for QEMU tests (2026-09-04 14:04:44 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ac6ae485e6003b2a9999540c4e3e65780f1e6660:

  Merge branch 'inconsistent_parameter_type_in_convert_agg_kbytes_percent' of https://github.com/dennischerchang/fio (2026-09-09 14:18:37 -0400)

----------------------------------------------------------------
Dennis Chang (1):
      Fix convert_agg_kbytes_percent() inconsistent type between caller and definition.

Vincent Fu (1):
      Merge branch 'inconsistent_parameter_type_in_convert_agg_kbytes_percent' of https://github.com/dennischerchang/fio

 stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index 305d1ae3..8bb383e5 100644
--- a/stat.c
+++ b/stat.c
@@ -515,7 +515,7 @@ static struct thread_stat *gen_mixed_ddir_stats_from_ts(const struct thread_stat
 }
 
 static double convert_agg_kbytes_percent(const struct group_run_stats *rs,
-					 enum fio_ddir ddir, int mean)
+					 enum fio_ddir ddir, double mean)
 {
 	double p_of_agg = 100.0;
 	if (rs && rs->agg[ddir] > 1024) {
