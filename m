Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F23129A67
	for <fio@vger.kernel.org>; Tue, 16 Apr 2024 12:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713268819; cv=none; b=WQtdeCFCS2wEqYoNueSTCKFG6GOQudrSw20y9uXzotEJlM5xq5AVb8eTx0myW4MGkxB2OuA6K1Fas37XKW2v9sr96Xi0nwnSNBMXyPL9iIbxiPahdH15Q/q6LQ+SocaewxNJ2aF8AnOI5rMg37m1GMSSdI9WYFV3RNPrmYZevY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713268819; c=relaxed/simple;
	bh=GSUSwCMKVkrGzdUjYkgXYikHYkOKpnZKZewaCFc+Sr0=;
	h=Subject:From:To:Message-Id:Date; b=ji+7gXp+WveM7qnNKsX9R8D7A2LDmJoJBG/OYPh7oEElp7T+dh+ePyCEYYZ9hIzM3bLJvAbu8Trt7NWNQEPMjztpqHABJrLinK+8nlz1h8/s8Y8eZOzQuqwHijKfwk8wZ2W4/7IJcrqinKOPq9QTgO6sFVlIC8WFw1bfQ0bsScY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IReqG2YO; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IReqG2YO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=4WOUzzHUh5sbJcXh0cV+5zqPg9FsQ7BNmTT7DQgPjSg=; b=IReqG2YOoEBKPQ0DkF+m1C3i6l
	H0AAjNvxsAfNNYziN+8L9gVZYNxSlxZCgvn4I9lBSVfHC5S5khcOIiEHRVS0Oqj0dGt2pyhHNi/CV
	DpyqzoNb6eEpdHXqi6HDkA7cwF03LwLXd+KhotduHCmVYdYF7G5bR0mYN+8N34jrPC9BC7VteU/ou
	a7YjVxXZ0Bi97FKcwrtZi+svfPuSeC/ZYjvDZUYWTKTHmSnoYswx2AdUbDH/U8wLuQd4SoYIT8Yie
	6Dii3zZf3zpnR67qPdc/cEv/KG57nP19DSoQ5qQ/78nxrdKCWxMMr6e9chqA15l0f3nh5rEQbi5tv
	AtnSIzZw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwhTp-0000000B3AM-27On
	for fio@vger.kernel.org;
	Tue, 16 Apr 2024 12:00:10 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 225841BC0151; Tue, 16 Apr 2024 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240416120002.225841BC0151@kernel.dk>
Date: Tue, 16 Apr 2024 06:00:02 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 4eef23f627d103d7092b4141bd6b0c8f95309ee9:

  howto: fix zonemode formatting (2024-04-02 11:10:58 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8bcd4cb42931996575cb4430f3d630810f213434:

  Revert "ioengines: Make td_io_queue print log_err when got error " (2024-04-15 12:26:56 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Revert "ioengines: Make td_io_queue print log_err when got error "

 ioengines.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/ioengines.c b/ioengines.c
index 5dd4355d..87cc2286 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -413,7 +413,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	if (io_u->error == EINVAL && td->io_issues[io_u->ddir & 1] == 1 &&
 	    td->o.odirect) {
 
-		log_err("fio: first direct IO errored. File system may not "
+		log_info("fio: first direct IO errored. File system may not "
 			 "support direct IO, or iomem_align= is bad, or "
 			 "invalid block size. Try setting direct=0.\n");
 	}
@@ -421,7 +421,7 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	if (zbd_unaligned_write(io_u->error) &&
 	    td->io_issues[io_u->ddir & 1] == 1 &&
 	    td->o.zone_mode != ZONE_MODE_ZBD) {
-		log_err("fio: first I/O failed. If %s is a zoned block device, consider --zonemode=zbd\n",
+		log_info("fio: first I/O failed. If %s is a zoned block device, consider --zonemode=zbd\n",
 			 io_u->file->file_name);
 	}
 
