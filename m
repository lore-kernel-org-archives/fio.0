Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401E93164D9
	for <fio@vger.kernel.org>; Fri,  9 Jan 2026 02:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767926237; cv=none; b=aj/6g+/yAOUVHpzH6lFA5HleX+UdJsaEkBj9keNgJdqQLKlcTH0ox2OteJaFnn3+W1b7PgrtptCSs5xgA+7S0TPDW6m+PqfI9efWKLE7Aehefw2I+InxLIF0ZBUVot1mKApxkGUGC7xigHVmN1ZoWQfKeFU5m2pmq0Qv37x75lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767926237; c=relaxed/simple;
	bh=LqgiKMvcMuf0sgeQLocPiKoRXbd1LatSXeKTPx9qCBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IUe4UYZESVLronnv/NaGwMl+SKhb9XFCz+7/uli64UcSUkwQdKKQSHlcSV55ZXTgdLjmEh5n7/KfegvVaanKirIZH1irA/fX75HZwdY5PQaJMUjjxcsjxonJbo19t4BwlexAjo+dd41TMhXZIouOCegKXY9sw7Eb1JEeqruDnng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=XwUenauT; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="XwUenauT"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1767926234; x=1799462234;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LqgiKMvcMuf0sgeQLocPiKoRXbd1LatSXeKTPx9qCBI=;
  b=XwUenauTeyGS3jTHQGaUf/r8xk4gmv8Ogy751y8plB6jF6eYU2hOMivH
   WEwJFz3R/S+yWTP23PdAFmA1oFLbDHxvYdRs7S3NnNtvtoEn6AY3V8jIT
   Cr6TUB0iB9HbqJfbQvXXCmwO/Xb2TPT8WlRJZXD0ab3zvx0B4Nai02o/d
   se6M327Wbhui5zscKQ2mo73IwwbidhAq7e1RADdq+uS+3PapqofgZe7wY
   oVCeHjB7aSu+6kPYCeHpGhPnRzKpZ1PKqwx5do7EDHFHEYq3xQU4cGoRH
   cp+UTzTdZW7ZIFhCInLvcqJqVUjj3ajFUlFlQVdH7MeNNqMMKkLmYg06m
   A==;
X-CSE-ConnectionGUID: NwrbLrH1Sd67xzBHED9waA==
X-CSE-MsgGUID: 6gZA2wu2Q0G0noznMtCpcQ==
X-IronPort-AV: E=Sophos;i="6.21,211,1763395200"; 
   d="scan'208";a="137774574"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jan 2026 10:36:05 +0800
IronPort-SDR: 69606997_j4rac/RKFkV6DM29tGHfi/VQu2pOQFiZEQOcuzjNtut88zs
 6ZYz8jQlSKogvKUU+F81U+WpfKg+LjdPThHra5g==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jan 2026 18:36:08 -0800
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Jan 2026 18:36:07 -0800
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 02/12] zbd: set norandommap=1 when zonemode=zbd is specified
Date: Fri,  9 Jan 2026 11:35:53 +0900
Message-ID: <20260109023603.2848421-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com>
References: <20260109023603.2848421-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The random map functionality relies on the minimum block size to manage
the map of written blocks, in order to ensure that all blocks are
written with a random workload. This is normally fine, but in the case
of a zoned block devices being written with a minimum block size that is
not aligned with the zone size or the write pointer position at workload
start, the last blocks of a zone can only be written using a write
operation with a size smaller than the minimum block size. This
conflicts with the random map operation.

In preparation for supporting writing a zone remainder smaller than the
minimum block size without using a zone finish operation, disable the
random map feature by setting norandommap=1 when zonemode=zbd is
specified.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 init.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/init.c b/init.c
index 76e1a86d..9320bca8 100644
--- a/init.c
+++ b/init.c
@@ -665,6 +665,19 @@ static int fixup_options(struct thread_data *td)
 		ret |= 1;
 	}
 
+	if (o->zone_mode == ZONE_MODE_ZBD) {
+		if (fio_option_is_set(o, norandommap)) {
+			if (o->norandommap == 0) {
+				log_err("fio: zonemode=zbd requires norandommap=1\n");
+				ret |= 1;
+			}
+			/* if == 1, OK */
+		} else {
+			dprint(FD_ZBD, "fio: zonemode=zbd sets norandommap=1\n");
+			o->norandommap = 1;
+		}
+	}
+
 	if (o->zone_mode == ZONE_MODE_STRIDED && !o->zone_size) {
 		log_err("fio: --zonesize must be specified when using --zonemode=strided.\n");
 		ret |= 1;
-- 
2.49.0

