Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A44A2556E
	for <fio@vger.kernel.org>; Sun,  4 Feb 2024 21:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707081409; cv=none; b=Rv/CeSLQF1QiiqSb6vw6CZ9zvMaX9FitaECrGUeLFk8UShQsglYsyZmcbUsycs0Z9NOaxvj9yfsP8+gyHZWr6WypxgxwbbjC6I+6jTRp6DYdFUGEGAeEemmvC2NR4hHs1iWtA0XYWzdiV7CIC4i499fTvyK1qHQdtP83KfDpwNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707081409; c=relaxed/simple;
	bh=SjuInYqIacOKFt/CrBY5t+FnOGAmqLgPXywQLRBOC+g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZFIJstOYnriO+GNeMuGhwduZcd3NDqlGqyH23LBhhrUGfImuwefDlQHpdHlI2oxHO59Ml2JJ6pmoDRyxIc52/oXCmLpgvJ70B8Rr+B1KmPGdGBfHP+lOi/PyxhAlBYFEQZqrzCdHrwPdhdlFLgr/Z68z5eYCilbPnExmkoeiGco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GmjIbNah; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GmjIbNah"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1707081408; x=1738617408;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SjuInYqIacOKFt/CrBY5t+FnOGAmqLgPXywQLRBOC+g=;
  b=GmjIbNahPx3PVbFcGHj0dpS47U/0kOIYwgEc76+f9h9NSjJOK11mPrwX
   kv5TgLxNY1gLGE4hGXQbSOH5qn21K6IyyCo8YZUoJug/O4ZY/8N5i1lOe
   zVHWp0i+e1c6ak4h7QonkziiFLeXLDJjXjncSXhTk+DMT/LdrQZA0jDxW
   FiIlvwjyuLcWMfYB/cM3Vmlfga3Y8lsLGgDKdlB4bHl0XfssHMJ+ZByR0
   06iBeMkil9YCs8Ws0p6/uvGJXHxYqUMgIDm3HFwGHmz4/mWfQLCe2GsxB
   8vyRwDxcZ7wuha+arO9p5an5MIHBL77t+OciL7szF1iTcZ6yttFdMzdgM
   g==;
X-CSE-ConnectionGUID: fZ8OKJsAS3G3aaLZkfuO2g==
X-CSE-MsgGUID: pvgSQgttROuOAduivENs0A==
X-IronPort-AV: E=Sophos;i="6.05,242,1701100800"; 
   d="scan'208";a="8472762"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Feb 2024 05:16:42 +0800
IronPort-SDR: gkklwyQZWkjDlL7BAYeDhA+4GlqioWoK4Y5owdDIuaPJglvvYkZhvo8m+qtb90sn0u8CMxUkjK
 RT5Heh+8INnQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Feb 2024 12:20:48 -0800
IronPort-SDR: qQKIYwi4tBlW7qQmHwiFXGjfy8C1lGgyoS47p5Ex4GVeR7G3MyHZi0KuoZ4AbABMZcWejjt8QN
 brNfM1c/jHAA==
WDCIronportException: Internal
Received: from unknown (HELO redsun50.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Feb 2024 13:16:41 -0800
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>,
	fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 2/5] oslib: log BLKREPORTZONE error code
Date: Mon,  5 Feb 2024 06:16:34 +0900
Message-Id: <20240204211637.210199-3-dmitry.fomichev@wdc.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20240204211637.210199-1-dmitry.fomichev@wdc.com>
References: <20240204211637.210199-1-dmitry.fomichev@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

BLKREPORTZONE may fail because of a variety of reasons.
Log both the return code and errno when this ioctl fails.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 oslib/linux-blkzoned.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 2c3ecf33..1cc8d288 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -242,6 +242,8 @@ int blkzoned_report_zones(struct thread_data *td, struct fio_file *f,
 	hdr->sector = offset >> 9;
 	ret = ioctl(fd, BLKREPORTZONE, hdr);
 	if (ret) {
+		log_err("%s: BLKREPORTZONE ioctl failed, ret=%d, err=%d.\n",
+			f->file_name, ret, -errno);
 		ret = -errno;
 		goto out;
 	}
-- 
2.37.3

