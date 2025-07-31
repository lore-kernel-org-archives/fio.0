Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.154.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73847D3F4
	for <fio@vger.kernel.org>; Thu, 31 Jul 2025 12:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753964487; cv=none; b=nuKAvnnJMKyTlCDg4rjYPtw6FaMYxr/r+qUwmiT4vcYvKe98h1uSE9rww2LXR85TtHoe3bLHTWRCSHoQOPPpfhQZ2/zf9yEq3s6y2QYwXIB/XL8e5XGT7vDMbkYhikyfNnANKcRLOdYh16hvl7xyIKqHC1o1BxhVFK6M/oiMW/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753964487; c=relaxed/simple;
	bh=h1mvFwW6yrL5ucK6i3Nkhsa9z7X1hgD7DWzrMiQaNX8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xy3JDkq+o8KVlutbqurvVp8S9MOTfa0pnMiyzcbflruh2pcIf9F4Uyt+WDf9Zbklw09lVahh0tu1hJQThT0NUsIvdAynh+ozM2mCrQMYUrsnubKisncw4s5UKWyxCbVsiydvaXUplkk7YG1p+7JookFtI4g2vE0Mbs76WoxtMys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=YVnpUbrX; arc=none smtp.client-ip=216.71.154.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="YVnpUbrX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1753964486; x=1785500486;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=h1mvFwW6yrL5ucK6i3Nkhsa9z7X1hgD7DWzrMiQaNX8=;
  b=YVnpUbrX5CB3sk8DGhbuFqjwr/P507q5FsLIFa78xhVG1SWFqQJ+/3eO
   9l5E7vaCmG5WIVPqLKjvPyiNcJk94IHLow2vrlj2rl9Ki4JXXZMjVYcCH
   ZWt8yODytQOb8VI7mKc6NaTlWL3bj5jWwUmsFYkGTcPy5rIih3IF3wgQH
   czZkQT0grPneFIrApMrlJ75fg8/MkjoZCc2L88UlOJF3Hgq7gYAOCXRua
   Rdb2iJb18Z8imKaiDwDA3vIpgWfxjdQnGi50Nuyw96JZFOFYCtTpvRRFo
   OiZA7q//v9WqtBj71U6TwYsqreoKIX/78A66W7O/FCDS1XY14wnNsuLHH
   Q==;
X-CSE-ConnectionGUID: QsIjPPRuSoypx1l5jp77cw==
X-CSE-MsgGUID: HM9U7IQVQQ6DqW+vzTpa2A==
Received: from unknown (HELO uls-op-esaep02.corp.sandisk.com) ([129.253.192.43])
  by ob1.hc6817-7.iphmx.com with ESMTP; 31 Jul 2025 05:20:17 -0700
IronPort-SDR: 688b5f80_piMME44ItR04so/mtd2y0SN49cNrFsFQCTLiWsTZZwtO+m3
 OC0S6pzQsjXafAAlIFb2L/ZSp6v0V4W42jQNblg==
Received: from unknown (HELO uls-op-esaip02.corp.sandisk.com) ([10.15.0.10])
  by uls-op-esaep02.corp.sandisk.com with ESMTP; 31 Jul 2025 05:20:17 -0700
SanDiskIronportException: Internal
Received: from ulssdxvpxsnip.corp.sandisk.com (HELO sandisk-inand-1.sdcorp.global.sandisk.com) ([10.9.34.160])
  by uls-op-esaip02.corp.sandisk.com with ESMTP; 31 Jul 2025 05:20:16 -0700
From: Tomas Winkler <tomas.winkler@sandisk.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Tomas Winkler <tomas.winkler@sandisk.com>
Subject: [PATCH 1/2] filesetup: make longest_existing_path() static and const-correct
Date: Thu, 31 Jul 2025 15:20:10 +0300
Message-ID: <20250731122011.539660-1-tomas.winkler@sandisk.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mark longest_existing_path() as static since it is only used within
filesetup.c. Also, declare the 'path' parameter as const char *
because it is not modified within the function.

Signed-off-by: Tomas Winkler tomas.winkler@sandisk.com
---
 filesetup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/filesetup.c b/filesetup.c
index a94d3b38..bcbd871e 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1002,7 +1002,8 @@ uint64_t get_start_offset(struct thread_data *td, struct fio_file *f)
 /*
  * Find longest path component that exists and return its length
  */
-int longest_existing_path(char *path) {
+static int longest_existing_path(const char *path)
+{
 	char buf[PATH_MAX];
 	bool done;
 	char *buf_pos;
-- 
2.45.2

