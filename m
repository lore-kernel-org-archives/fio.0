Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7E722094
	for <fio@vger.kernel.org>; Sat, 17 Feb 2024 13:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708174817; cv=none; b=f6juXaX2ZOAz4oe9FZ2QxC6sASGFM+OvVXP0I/f0otmD/pGhnXq+VFoiGIyXXhuklsZJr9mkWbroErKp7kYK+gv9zYVysIgfGR9lgzVHOAYSZ0bmNV2yPqPbMiMl+Q/B9Vd14EXyi7Q0nfPlBOb8yW1aFEIc6MVFeeJDtHnpgGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708174817; c=relaxed/simple;
	bh=RUkJKMecJ4TtcYDumc/kLXRjTkzVFo3HXUe1mn+jkZY=;
	h=Subject:From:To:Message-Id:Date; b=GXPTiJeCWVXF1mXU5h4h7zUjs+BreS7WrT4zhnVAKTxI9kHeiBgs62UrOeeQ0UvgZZlGzFEazUT0CSQ23V5sgogZQU40pACBbh6exuhI2iims/xHbEqxTF5xcziikT8rj7XVgnt9ALvpjeGdhpP9Ea95/BvYhBIm+tlc3enrIk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qFpkgXID; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qFpkgXID"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=0MovRME+lE95+UoTlU4mRnG1EUSnYNlb1zbbyXCAeDU=; b=qFpkgXIDzNuYgqiwmY4iote8a+
	GchoLDq0EId9hyy2WEMz4iVOwzo7YBsqNbBxK0yuhUcISaPUjPyEw+e+HgPKKGfs3Z4Bi6ypYSHDM
	t0DujbN5m+gLGr/Lszm7ixz3aXb5e7DmSSNZHximIo0k7dqVO/FIWqa6do/sc8dZ8+Bd+0NaIDAjt
	44eYoxgG3d5pIR6/Y7TDEsQZRG4/D/bLa2IpTh6vyVN2qAL0UPNI/rtow8MUtYo/DeU7mryoG9YRF
	pzxvMXSOlQwEk/d+9lLdSxVaApJ/jU8YUcOHPw3KkYNsKYmHSdEAOaO96h61U4DVHNeo9lDXffve4
	ttGJJeKQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rbKIW-00000000Mbb-1YSm
	for fio@vger.kernel.org;
	Sat, 17 Feb 2024 13:00:08 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id B80281BC0143; Sat, 17 Feb 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240217130001.B80281BC0143@kernel.dk>
Date: Sat, 17 Feb 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 2d0debb3fca7ddc4374624acb8c70fc8292d860d:

  t/run-fio-tests: add t/nvmept_trim.py (2024-02-15 14:05:12 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 38d01cc56366aa2fd3af42dbab522888b6359dec:

  verify: fix integer sizes in verify state file (2024-02-16 09:25:35 -0500)

----------------------------------------------------------------
Vincent Fu (1):
      verify: fix integer sizes in verify state file

 verify.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/verify.c b/verify.c
index b438eed6..b2fede24 100644
--- a/verify.c
+++ b/verify.c
@@ -1619,8 +1619,8 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 		comps = fill_file_completions(td, s, &index);
 
 		s->no_comps = cpu_to_le64((uint64_t) comps);
-		s->depth = cpu_to_le64((uint64_t) td->o.iodepth);
-		s->nofiles = cpu_to_le64((uint64_t) td->o.nr_files);
+		s->depth = cpu_to_le32((uint32_t) td->o.iodepth);
+		s->nofiles = cpu_to_le32((uint32_t) td->o.nr_files);
 		s->numberio = cpu_to_le64((uint64_t) td->io_issues[DDIR_WRITE]);
 		s->index = cpu_to_le64((uint64_t) __td_index);
 		if (td->random_state.use64) {
