Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DC412E1E3
	for <fio@vger.kernel.org>; Tue,  6 Feb 2024 10:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707217154; cv=none; b=lL7jCnEkA6uDuw6f7ZEQhEwnNWJ60P8NqiuLGN63Ldno/42YGZRVhOP29MWYu/TInLCvqPN84uJdAOn/HAjMWUOShMRnrruX5MF06QxQoguW+lzAG3vvDdOVxt1IyKIp9/zt7nF11ACY8PazI7p1nwQlspTrTNatEv4UUvgd9Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707217154; c=relaxed/simple;
	bh=SjuInYqIacOKFt/CrBY5t+FnOGAmqLgPXywQLRBOC+g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QVRWezBjAsIhz0ciIljtGLwok0k3wVs+9lDufklWzOtSvy/gGGsaM+T0piXKYg+N4ldWiQF/WyHYl/0ubNjZ5F2qLEG33H1PmOijnWKJd0pjlYu6vgtoJSO0eUlF2Dc4txgwPn9MwLd7hqtA7CFpopU1XyGODL2SIE+M+s+VsVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=heOI5sMb; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="heOI5sMb"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1707217152; x=1738753152;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SjuInYqIacOKFt/CrBY5t+FnOGAmqLgPXywQLRBOC+g=;
  b=heOI5sMbY01fZ7BbSC0TWjB1qqqoxVi7DElPXKuEHEBDIR1rnnp31BcY
   kEGJL6lk5QTzukHcWFp1wMvirkpmXHWGHqbeTooEDLxpCTRE+3yTmejED
   e+IevcJb8qYxz6VpU3As7m60XxD5+RIJ1Sl1GIXbpe3xCeTDET2WnLcsv
   wScz3GC8xeVPlx+4HDDIc4Rkmd9MiK2RLUZrnK5O6rB1gx9/Vvt/lj5Sm
   CGKaOCbKQFfb2Ju7uGM9JmvU9CxuMJ/jJY7P4ZdVPp03JFKFT3XAOsuy2
   u7s/Ms7t/XHYMEo2C1/ySvrqQXadWJqAmzKW9QZWnPcEOyTVbcXmx4uQ2
   A==;
X-CSE-ConnectionGUID: o/6ALJ37TOSLoKfu3h+MAg==
X-CSE-MsgGUID: k6ES8yC+Sbe1rAD/icpGKw==
X-IronPort-AV: E=Sophos;i="6.05,247,1701100800"; 
   d="scan'208";a="8663346"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Feb 2024 18:58:00 +0800
IronPort-SDR: oUSWoKQCvNblAnQL0lKF3MZ5Itc2+LtwWAoDfojfxABBep5St6vrsC9tQwZXRaIZN02+mgb/nj
 hovdkXSSbxSg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Feb 2024 02:02:05 -0800
IronPort-SDR: Ede5v6iSQvUhjtI0YAnrPNeyjQ4mXDGaHI3jSsa1nM53BwiywvThAoTQzrSth/e5oofVdXIq2X
 Pf8Df/OY0SKw==
WDCIronportException: Internal
Received: from unknown (HELO redsun50.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Feb 2024 02:57:59 -0800
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>,
	fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 2/5] oslib: log BLKREPORTZONE error code
Date: Tue,  6 Feb 2024 19:57:52 +0900
Message-Id: <20240206105755.214891-3-dmitry.fomichev@wdc.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20240206105755.214891-1-dmitry.fomichev@wdc.com>
References: <20240206105755.214891-1-dmitry.fomichev@wdc.com>
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

