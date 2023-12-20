Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9256123DC
	for <fio@vger.kernel.org>; Wed, 20 Dec 2023 00:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="MlqVB+kV"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1703033941; x=1734569941;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Dn+m7mc8XeoZOvnSsaj+gU4IJpfbXA1yTheQp6P0WvA=;
  b=MlqVB+kVvO4c5lvba3SNRt3U2Ig/6Q3nYrlLqlPee/LKv/CMidNHGtFJ
   rA3FnTuO2fo7z6CnI6r3twTtNG7oqDzpHocOgwrjzWTehOI2L+piqdUsf
   FKw9zuPPTKpenSu+i/ScoM5upztESmiWZtA+EBeaHAcHwJJswkMnk+aNB
   FqCNEPYtqgR1AfIGHf1SkmZ3eQHbBbDatmlURyXlvlio9mNKIfB6IYppy
   kIvLrUA1l1nhbJEi0XymlV3PCS2vi09L15ja4At/+x4kgAV+JuKreML6r
   hWPP1xnh60rYcLKCTDWcNet8QIje4OGeWFXK88AnM/VTIN6Z2s07bVH1k
   w==;
X-CSE-ConnectionGUID: 3IWQbtLDSG6ae9MC/haGHg==
X-CSE-MsgGUID: 5wV8QQ9iTT+yqaXGST/17A==
X-IronPort-AV: E=Sophos;i="6.04,290,1695657600"; 
   d="scan'208";a="5448132"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Dec 2023 08:58:55 +0800
IronPort-SDR: 4yN89ARbxbk5G6Qmlxq6DnBCTGxQZ4P3NdxAxfAYLnHlVYpc3nvdjXcSuR8RKnCAugWTjm7NUj
 UZ7bhG2TsC7A==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Dec 2023 16:03:57 -0800
IronPort-SDR: t2mAbEvHF6IpVDr1/D1aB4fv6u+QggRGviRNfiJkimiAf7vD/hOJ7ADLQTL/lDPssZzbAZUXen
 F/lSD7ONGGhA==
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 19 Dec 2023 16:58:49 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/2] zbd: avoid write with rwmixwrite=0 option
Date: Wed, 20 Dec 2023 09:58:45 +0900
Message-ID: <20231220005846.1371456-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220005846.1371456-1-shinichiro.kawasaki@wdc.com>
References: <20231220005846.1371456-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the commit fb0259fb276a ("zbd: Ensure first I/O is write for
random read/write to sequential zones"), fio issues write as the first
I/O when zonemode=zbd and rw=randrw options are specified. However, fio
issues the first write even when rwmixwrite=0 option is specified. Users
do not expect such write and it confuses the users. To avoid the
confusion, suppress the write by referring td->o.rwmix[DDIR_WRITE].

Fixes: fb0259fb276a ("zbd: Ensure first I/O is write for random read/write to sequential zones")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index c4f7b12f..61b5b688 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1876,7 +1876,8 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
 	if (ddir != DDIR_READ || !td_rw(td))
 		return ddir;
 
-	if (io_u->file->last_start[DDIR_WRITE] != -1ULL || td->o.read_beyond_wp)
+	if (io_u->file->last_start[DDIR_WRITE] != -1ULL ||
+	    td->o.read_beyond_wp || td->o.rwmix[DDIR_WRITE] == 0)
 		return DDIR_READ;
 
 	return DDIR_WRITE;
-- 
2.43.0

