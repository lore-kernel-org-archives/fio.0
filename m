Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEB149B470
	for <fio@vger.kernel.org>; Fri, 18 Sep 2026 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789732810; cv=none; b=YuodfkDXT3r3mWfLB5K9XsuXE4slzI8yxTuSCiKPC8b0kRPKGXhywH/1dy+UerIjMTDC+mRrnvpMVcCsYckC4nYjOSbzX8oIHekvcKiKk5uKi6vQBAhXxap6Bunln7jHf5bSb2mWpn0pb34Yoij6R9iztKFy78p3wApSeNokcr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789732810; c=relaxed/simple;
	bh=AN7sFfusw8izNuTLzJ/EJTTd55NorJlQxaqP84rdFzg=;
	h=Subject:From:To:Date:Message-Id; b=YNw6Z4+Y1bJsDJGkM6ARR8EY4TW+LY9WOIb65gef1Zew2iVZwTs6rn6fTJDxmXX9oESq2c/WwUEgywF4TRkrBHvSVDo++803XOnCst2I0zFNJED7OZMAF/46/iLr8AUTYvosOHxma6i7CEc9xJ74e80OUD9KKzgpIgPr+90JNxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oITZKss+; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oITZKss+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=hCqz74nxFgQjsQAcUS+iGl9gSIVt8S9lxi6oHhzwSyY=; b=oITZKss+1eD9CSd1imRmeXtlIF
	7xKKD8X9KU+nloD+mlkPpnG/6QfefhFD9RPWI1GSv/YSUSYLYOZKN85XFrQaMxN/zPWvzr+0STYYl
	YVLlyh50rd4VQx2VpGIdL2p7G7fvhMStNm2k/P03DzzKgehTl3BFrPu07MBAYMUl0LYahoWpXV0wD
	1ZvKIh+oNF3zTkhd2E4DOj2v2+6F52Lo3aWWAIQri65uug5DNZJR2Idg9gXR+nClbRfJ4rMA8JEE+
	kBfg+wecyO8kmpBs1Fcgzv5AMQtz1YqIVov3qPY58VVtwwSKgiH15+7bpULcZD1/NnJcyhFbtegoq
	IC5vg97w==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x7XG9-0000000HDuD-1V5r
	for fio@vger.kernel.org;
	Fri, 18 Sep 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 90FD31BC0161; Fri, 18 Sep 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Fri, 18 Sep 2026 06:00:01 -0600
Message-Id: <20260918120001.90FD31BC0161@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 6bc57a931f04fa3f50348d8c8f087187f050c6e1:

  eta: remove now unused done_secs (2026-09-11 14:41:56 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 162e8fb3d059c090caa56255e4a6a92bfa6e47b3:

  client: don't send uninitialized data in fio_send_file error replies (2026-09-17 14:57:34 -0600)

----------------------------------------------------------------
Eric Sandeen (1):
      client: don't send uninitialized data in fio_send_file error replies

 client.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index 374a744a..c1d80783 100644
--- a/client.c
+++ b/client.c
@@ -1807,7 +1807,7 @@ static int fio_send_file(struct fio_client *client, struct cmd_sendfile *pdu,
 	int fd;
 
 	size = sizeof(*rep);
-	rep = malloc(size);
+	rep = calloc(1, size);
 
 	if (stat((char *)pdu->path, &sb) < 0) {
 fail:
@@ -1817,14 +1817,14 @@ fail:
 		return 1;
 	}
 
-	size += sb.st_size;
-	rep = realloc(rep, size);
-	rep->size = cpu_to_le32((uint32_t) sb.st_size);
-
 	fd = open((char *)pdu->path, O_RDONLY);
 	if (fd == -1 )
 		goto fail;
 
+	size += sb.st_size;
+	rep = realloc(rep, size);
+	rep->size = cpu_to_le32((uint32_t) sb.st_size);
+
 	rep->error = read_data(fd, &rep->data, sb.st_size);
 	sendfile_reply(client->fd, rep, size, tag);
 	free(rep);
