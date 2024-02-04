Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E8D286BF
	for <fio@vger.kernel.org>; Sun,  4 Feb 2024 21:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707081409; cv=none; b=gcDlQkSaRnyuel6UY8TVhMlF5XZjLsgmfUDBgU3vnFlewHbXR4piq5OC1WEhZhCQsF4VEmZ0esAq9tjxLvQ8WMfwKO6q9+//4yiz+UNQ/Csj4VVhLWbInBWJ7FXi37Mhet5zCJxaJ6Wk1kZm2VGiJ29KTEQ8e0WMTzRJDDa7Lpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707081409; c=relaxed/simple;
	bh=uS6YT0OiSAkcTNxiTyWeffINlvoJuYax+B56ID9Is4M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LjRa9O3hv4636btVVY7fEFQj9Bq5AqOLKuItGDyJcdy968XPHC2UigFUfJTKDi+oUCobkc8albaQJwYi3+6RBwTPPex3Jn/Pwkf3lqRMLt9T7izxvGykEyUwhfRXGPFSeWBKk3cSRU+KVErwx+z9QurgWfw3SwXXYfYcn/6a+AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=AhSCwI5m; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="AhSCwI5m"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1707081406; x=1738617406;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uS6YT0OiSAkcTNxiTyWeffINlvoJuYax+B56ID9Is4M=;
  b=AhSCwI5m6m7746Am313bhn1MFyZWZUQSjRN1esq7/xVLjyRsX2aUpFXK
   K4MEBA6I83G29MDUZJG/mDSwGp5TT6PomN4D8T7La/AxCc6n02tChfeoY
   OiV691L9yradSwe90cvWe5CO0nNN2nx5wLq0YvHIs6KSq8V5LXyRs5236
   ZN2I3wGEXBiYvYaA3PXkaIRlWhcQt1sNfqeThUp+1CBwBjRNbPzHwCfZU
   h13x7U8Eov7sraCc5rG8Jjjem6k6/HBa2ckXi4W69Nu1gulO6tWU9kjZy
   8gagXvAIeQ8ZwQjpsOhpott1NsrdABS/nsnLgHIyKkEZ4yypWAapIjlsv
   w==;
X-CSE-ConnectionGUID: K9AzlfZKSD2FIZT5UFX+MA==
X-CSE-MsgGUID: +bw4NcFiSCeNFC1xHxW+Ew==
X-IronPort-AV: E=Sophos;i="6.05,242,1701100800"; 
   d="scan'208";a="8472760"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Feb 2024 05:16:40 +0800
IronPort-SDR: P6/ptPK2f+M2+dXc95jBh7suxtvEXvClNvWk0BGi1ZQo0Pzgw17PL2Fkd2pWa7CUOBNFpTiXSv
 T7OIN3YdFfnA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 04 Feb 2024 12:20:47 -0800
IronPort-SDR: SsKaEK0wBKxqpkYssGXIIx/eiqYuMVoWARrIQMOJnGlQ6ky4ul6ONVo49uredmsSPY7xKUylhc
 GLuUFksJarIQ==
WDCIronportException: Internal
Received: from unknown (HELO redsun50.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Feb 2024 13:16:40 -0800
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>,
	fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Niklas Cassel <niklas.cassel@wdc.com>,
	Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 1/5] zbd: avoid assertions during sequential read I/O
Date: Mon,  5 Feb 2024 06:16:33 +0900
Message-Id: <20240204211637.210199-2-dmitry.fomichev@wdc.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20240204211637.210199-1-dmitry.fomichev@wdc.com>
References: <20240204211637.210199-1-dmitry.fomichev@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

“zbd.c:110: zone_lock: Assertion `f->min_zone <= nz && nz < f->max_zone' failed.”

The code in zbd_zone_align_file_sizes() rounds down the I/O size to
avoid these situations, but it is bypassed
if td->o.td_ddir == TD_DDIR_READ.

Avoid this issue by modifying zbd_zone_align_file_sizes() to round down
the I/O size for read I/Os and leave the I/O offset untouched.

Fixes: 0bf93a1a7ed7 ("zbd: introduce zbd_zone_align_file_sizes() helper")
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/zbd.c b/zbd.c
index 61b5b688..7577472e 100644
--- a/zbd.c
+++ b/zbd.c
@@ -674,9 +674,20 @@ static bool zbd_zone_align_file_sizes(struct thread_data *td,
 		return false;
 	}
 
+	if (td->o.td_ddir == TD_DDIR_READ) {
+		z = zbd_offset_to_zone(f, f->file_offset + f->io_size);
+		new_end = z->start;
+		if (f->file_offset + f->io_size > new_end) {
+			log_info("%s: rounded io_size from %"PRIu64" to %"PRIu64"\n",
+				 f->file_name, f->io_size,
+				 new_end - f->file_offset);
+			f->io_size = new_end - f->file_offset;
+		}
+		return true;
+	}
+
 	z = zbd_offset_to_zone(f, f->file_offset);
-	if ((f->file_offset != z->start) &&
-	    (td->o.td_ddir != TD_DDIR_READ)) {
+	if (f->file_offset != z->start) {
 		new_offset = zbd_zone_end(z);
 		if (new_offset >= f->file_offset + f->io_size) {
 			log_info("%s: io_size must be at least one zone\n",
@@ -692,8 +703,7 @@ static bool zbd_zone_align_file_sizes(struct thread_data *td,
 
 	z = zbd_offset_to_zone(f, f->file_offset + f->io_size);
 	new_end = z->start;
-	if ((td->o.td_ddir != TD_DDIR_READ) &&
-	    (f->file_offset + f->io_size != new_end)) {
+	if (f->file_offset + f->io_size != new_end) {
 		if (new_end <= f->file_offset) {
 			log_info("%s: io_size must be at least one zone\n",
 				 f->file_name);
-- 
2.37.3

