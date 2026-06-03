Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9B8477E3B
	for <fio@vger.kernel.org>; Wed,  3 Jun 2026 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780488011; cv=none; b=q2vjFir2no3cTLzaTKMURlxlGyq+P68MGNwvQR0AVvs7D2KPgbSqI51LB/yrNV9THkLED/cgpW4khwsszZoLbKKu87BFmJTMZbmX7knapGYlgt+ge1XMPHgF+0lPROuY/ncAl1f2C2INCJlyJKsqzlYs9twrsnI3Sdan9w6tJqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780488011; c=relaxed/simple;
	bh=A2vRX8PcWj/D+6aMYZaiZaVBmVljcVi7LRyQRr8WYm4=;
	h=Subject:From:To:Date:Message-Id; b=RCGNqP30UqFvi/VYo59PQrikdbjfHj66tAtSF0Ebrfwajo+dnbRpkU85VqMjNucpM8LTGDyAkvMafkbvX7iHfN/y98dO+U+2mvGujI0toDd7OSPSrHhSKkZx9B3r0cJSXSovG+EtDi6RX2doXs1psmj3fkTEHUoWQQn8Kf4T4gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e17dgXwe; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e17dgXwe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ve9CbpwZmKMSMcrUPhAJLJinlkkwBqrSBlEHKxeln8o=; b=e17dgXweBH23wc0U/RvYFO2zQb
	aqcWrSCgUt7EBhSwGPw8Owh5z4/lQeR0/nEppFPo5qcpYjcDe0cWH4bCVha+tPiwFKH3WAIV9do0y
	Rn9xRAJu042cM6kBdaBwZ9UIVRWJkpKoYOUP7dodEO7wmJr+/PgrAVJin9Zo7zEvV/7DF03zdLYHe
	kDBa8XSdn/41CEJkGItFmPkkF2cUhIEvjt8Z7dNzGeh7Ag0RFofY8q4qZp8Nu2y5JWK839/SSL6wn
	a0CBrhecRRtrLkvOEQIE4/Jkabldu+O5ZPaE0/jllR5EfUt4P7S6pz+uI5O2u/y9JZwVYe/VkNjT5
	ROsG6+pg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wUkGT-0000000C3lH-0ijV
	for fio@vger.kernel.org;
	Wed, 03 Jun 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 5BE3D1BC01B2; Wed,  3 Jun 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed,  3 Jun 2026 06:00:01 -0600
Message-Id: <20260603120001.5BE3D1BC01B2@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit e682f9b3406e35a28a87f39789e3a0c6138b30b4:

  ci: add nvmept_write_mode.py to test harness (2026-06-01 14:38:22 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5b476c918091ff15705f3cd26a6a30a2084cd880:

  Merge branch 'master' of https://github.com/wangxp006/fio (2026-06-02 12:27:16 -0400)

----------------------------------------------------------------
Vincent Fu (1):
      Merge branch 'master' of https://github.com/wangxp006/fio

xiaopeng.wang (1):
      blktrace: fix three bugs in merge_blktrace_iologs path

 blktrace.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/blktrace.c b/blktrace.c
index ef9ce6bf..045c4eb6 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -664,7 +664,7 @@ static int read_trace(struct thread_data *td, struct blktrace_cursor *bc)
 
 read_skip:
 	/* read an io trace */
-	ret = fread(&t, 1, sizeof(t), bc->f);
+	ret = fread(t, 1, sizeof(*t), bc->f);
 	if (ferror(bc->f)) {
 		td_verror(td, errno, "read blktrace file");
 		return ret;
@@ -790,7 +790,9 @@ int merge_blktrace_iologs(struct thread_data *td)
 	}
 
 	/* set iolog file to read from the newly merged file */
+	free(td->o.read_iolog_file);
 	td->o.read_iolog_file = td->o.merge_blktrace_file;
+	td->o.merge_blktrace_file = NULL;
 	ret = 0;
 
 err_file:
@@ -799,10 +801,10 @@ err_file:
 		fclose(bcs[i].f);
 	}
 err_merge_buf:
-	free(merge_buf);
-err_out_file:
 	fflush(merge_fp);
 	fclose(merge_fp);
+err_out_file:
+	free(merge_buf);
 err_param:
 	free(bcs);
 
