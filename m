Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3E3161331
	for <fio@vger.kernel.org>; Thu, 18 Apr 2024 09:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713432272; cv=none; b=XlmFvpy0U3RscyOBUyJ5pBe5gTKijlSUy33fd78M64Bjaga0P9/HAC7MNfJpy0oCfb18CUwNTT3qpVVjpHKrNbbQmnm3v5p66LwTq0fTGQAf/6A/4VCPYQ3wschMdPbPT/Cs4FzhU7XIey+e8+0ntazRFTGR4Cy+sfRZIh4YLpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713432272; c=relaxed/simple;
	bh=9A36S5iDPRzhPQX64e6IYzTqmrH2hBLVtmldOd3SLHc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ByShebMBp+1UmM+hIM1n+xjtV8HwDEn1bput6WiOTnwiDWv7HiZgo7GgguWMvZ9Ai8pRNUXnI7DGZSpU+v9AuGxAWiUcOuUgHcaaIEkpN1Y7E2K1mmC7cy86Bje21Ud0dIwwuSEzLsMJDb+Yp01w29xChVXH5ggy3VvKOF3OIOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=b8sr1GoL; arc=none smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="b8sr1GoL"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1713432271; x=1744968271;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9A36S5iDPRzhPQX64e6IYzTqmrH2hBLVtmldOd3SLHc=;
  b=b8sr1GoLSgnGGd+5ZrkDVW9tgPnbA1XLpc61ZwcEM88EXYMCa1xvi6yM
   9KQHKiBiOg8g0+0JXHQMVCHoZ86UBEXJpnTefB8GPc96qZ667SJqYM3mD
   VxV8XKpRG+VTFH0Zmuu2/4OWeUf+q+BvPiL77+/pfy4Ym/pFYWr/o7KB2
   p92IdDmBtIjmIeXr/iu0dRvuMr65buRJpzRK1u/D76MB1x2537CtHqZcV
   RsBswzOy+U6qBzS4eVisVM/u3hYe70B18sgoh1XgisObOYAATrTMTRoc2
   tCaUCJQ2BEXc9ttqe3HVy9BEToncWAu9n2V8GFG+kBo78cVFPJc7Ck57o
   w==;
X-CSE-ConnectionGUID: mUukLmjSS0Sc0UBrJWmgmg==
X-CSE-MsgGUID: qPUdFnnvQReYLTy5YwIrGA==
X-IronPort-AV: E=Sophos;i="6.07,211,1708358400"; 
   d="scan'208";a="14091861"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Apr 2024 17:24:21 +0800
IronPort-SDR: jOHt12E158jNX4kwdsQuSKEcRwRglhCsN6HTAurFNXQza7NJ3NckJB/dLFuNxlThE1TF9jPpDX
 053wE+3XVG1CgBngtoSSy0fc46LtYA9SAWQb70N5DQq6yam52VuMZa0yAa2NJ09nUPRu1HuAr5
 GtGfT1OnQnlv8/OzVK/j7k697BnBFun5vTCfsJr1U6DuHUTam9SzZChqsJwgwZCqc3J0HuIY21
 KcIpnJNDhocqi+5x0yFzZeHuKDF9oVVpG2E8z53XWjWtZ3gnKKq3Qu0nLbqwoeVHMTSqW1XNzo
 4sI=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Apr 2024 01:32:38 -0700
IronPort-SDR: tMDSXVA/9Qkcl823pS0FaI0/iDF3xQIIPTKO2idAB4qowAbHwX4sxEyQuYEwtNknpRurYN1wTG
 M7NdW+yL5Gn7SInZYiVadRYVvLyzvK6dXX6XQiW7Ot0gEaBlwoHvqFqEAArd0n3CR+NS56iyUJ
 xoo2ekv2db/UKhldb1C45QBGYXi/MkoXKwhUiYTTM/VZRbawR26rfg+4xV+cawiBcIY//RfTvB
 akZSY4I/PH+IWgpLrPARd4NzNGndaLqE8yK5V4/vK6vTHvwV5ZHiAjjj4EOUe6CkI/DumWlKoc
 BuM=
WDCIronportException: Internal
Received: from 5cg1443s5d.ad.shared (HELO 5CG1421G2K.ad.shared) ([10.225.32.191])
  by uls-op-cesaip02.wdc.com with ESMTP; 18 Apr 2024 02:24:18 -0700
From: Chana Zaks <chana.zaks@wdc.com>
To: Jens,
	Axboe,
	axboe@kernel.dk,
	Vincent Fu <vincent.fu@samsung.com>
Cc: fio@vger.kernel.org,
	Chana-Zaks-wdc <chana.zaks@wdc.com>
Subject: [PATCH 1/2] Don break too early in readwrite mode
Date: Thu, 18 Apr 2024 12:22:22 +0300
Message-Id: <20240418092222.20543-2-chana.zaks@wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240418092222.20543-1-chana.zaks@wdc.com>
References: <20240418092222.20543-1-chana.zaks@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chana-Zaks-wdc <chana.zaks@wdc.com>

In readwrite mode, when io-size > size, we break too early and start
looping the addresses too soon. Instead of reset the address when
reaching size, we start looping after size/2, e.g. in a 50/50 rw. This
wrong behavior is demonstrated in the example below.

Before the fix:
size is 0x140000, io-size is 0x280000, max-address = 0xa0000 = size / 2.

./fio --debug=io --name=global --filename=/dev/mmcblk0p3 --size=1280K
--io_size=2560k --bs=128K --offset=0   --name=test1 --rw=rw| grep "complete: io_u"

io 5646 complete: io_u 0x560337a20840: off=0x60000, len=0x20000, ddir=0, file=/dev/mmcblk0p3
io 5646 complete: io_u 0x560337a20840: off=0x80000, len=0x20000, ddir=0, file=/dev/mmcblk0p3
io 5646 complete: io_u 0x560337a20840: off=0x20000, len=0x20000, ddir=1, file=/dev/mmcblk0p3
io 5646 complete: io_u 0x560337a20840: off=0x40000, len=0x20000, ddir=1, file=/dev/mmcblk0p3
io 5646 complete: io_u 0x560337a20840: off=0x60000, len=0x20000, ddir=1, file=/dev/mmcblk0p3
io 5646 complete: io_u 0x560337a20840: off=0xa0000, len=0x20000, ddir=0, file=/dev/mmcblk0p3
io 5646 complete: io_u 0x560337a20840: off=0x0,	    len=0x20000, ddir=0, file=/dev/mmcblk0p3
io 5646 complete: io_u 0x560337a20840: off=0x20000, len=0x20000, ddir=0, file=/dev/mmcblk0p3
io 5646 complete: io_u 0x560337a20840: off=0x40000, len=0x20000, ddir=0, file=/dev/mmcblk0p3
io 5646 complete: io_u 0x560337a20840: off=0x0,     len=0x20000, ddir=1, file=/dev/mmcblk0p3
Io 5646 complete: io_u 0x560337a20840: off=0x60000, len=0x20000, ddir=0, file=/dev/mmcblk0p3
io 5646 complete: io_u 0x560337a20840: off=0x80000, len=0x20000, ddir=0, file=/dev/mmcblk0p3
io 5646 complete: io_u 0x560337a20840: off=0x20000, len=0x20000, ddir=1, file=/dev/mmcblk0p3
io 5646 complete: io_u 0x560337a20840: off=0x40000, len=0x20000, ddir=1, file=/dev/mmcblk0p3
io 5646 complete: io_u 0x560337a20840: off=0x60000, len=0x20000, ddir=1, file=/dev/mmcblk0p3
io 5646 complete: io_u 0x560337a20840: off=0xa0000, len=0x20000, ddir=0, file=/dev/mmcblk0p3

After the fix max-address = 0x120000 = size – len:

io 32594 complete: io_u 0x70fc000980: off=0x0,     len=0x20000, ddir=0, file=/dev/mmcblk0p3
io 32594 complete: io_u 0x70fc000980: off=0x20000, len=0x20000, ddir=0, file=/dev/mmcblk0p3
io 32594 complete: io_u 0x70fc000980: off=0x40000, len=0x20000, ddir=0, file=/dev/mmcblk0p3
io 32594 complete: io_u 0x70fc000980: off=0x0,     len=0x20000, ddir=1, file=/dev/mmcblk0p3
io 32594 complete: io_u 0x70fc000980: off=0x60000, len=0x20000, ddir=0, file=/dev/mmcblk0p3
io 32594 complete: io_u 0x70fc000980: off=0x80000, len=0x20000, ddir=0, file=/dev/mmcblk0p3
io 32594 complete: io_u 0x70fc000980: off=0x20000, len=0x20000, ddir=1, file=/dev/mmcblk0p3
io 32594 complete: io_u 0x70fc000980: off=0x40000, len=0x20000, ddir=1, file=/dev/mmcblk0p3
io 32594 complete: io_u 0x70fc000980: off=0x60000, len=0x20000, ddir=1, file=/dev/mmcblk0p3
io 32594 complete: io_u 0x70fc000980: off=0xa0000, len=0x20000, ddir=0, file=/dev/mmcblk0p3
io 32594 complete: io_u 0x70fc000980: off=0x80000, len=0x20000, ddir=1, file=/dev/mmcblk0p3
io 32594 complete: io_u 0x70fc000980: off=0xc0000, len=0x20000, ddir=0, file=/dev/mmcblk0p3
io 32594 complete: io_u 0x70fc000980: off=0xa0000, len=0x20000, ddir=1, file=/dev/mmcblk0p3
io 32594 complete: io_u 0x70fc000980: off=0xe0000, len=0x20000, ddir=0, file=/dev/mmcblk0p3
io 32594 complete: io_u 0x70fc000980: off=0x100000,len=0x20000, ddir=0, file=/dev/mmcblk0p3
io 32594 complete: io_u 0x70fc000980: off=0x120000,len=0x20000, ddir=0, file=/dev/mmcblk0p3
io 32594 complete: io_u 0x70fc000980: off=0xc0000, len=0x20000, ddir=1, file=/dev/mmcblk0p3
io 32594 complete: io_u 0x70fc000980: off=0xe0000, len=0x20000, ddir=1, file=/dev/mmcblk0p3
io 32594 complete: io_u 0x70fc000980: off=0x0,     len=0x20000, ddir=0, file=/dev/mmcblk0p3
io 32594 complete: io_u 0x70fc000980: off=0x20000, len=0x20000, ddir=0, file=/dev/mmcblk0p3

Fixes: ac002339c382 (Fix bug with rw sequence offset and io_limit)
Signed-off-by: Chana-Zaks-wdc <chana.zaks@wdc.com>
---
 backend.c |  5 +++++
 io_u.c    | 11 +++++++++++
 2 files changed, 16 insertions(+)

diff --git a/backend.c b/backend.c
index fb7dc68a..fe03eab3 100644
--- a/backend.c
+++ b/backend.c
@@ -977,6 +977,11 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 	*/
 	if (td_write(td) && td_random(td) && td->o.norandommap)
 		total_bytes = max(total_bytes, (uint64_t) td->o.io_size);
+
+	/* Don't break too early if io_size > size */
+	if (td_rw(td) && !td_random(td))
+		total_bytes = max(total_bytes, (uint64_t)td->o.io_size);
+
 	/*
 	 * If verify_backlog is enabled, we'll run the verify in this
 	 * handler as well. For that case, we may need up to twice the
diff --git a/io_u.c b/io_u.c
index 09e5f15a..83895893 100644
--- a/io_u.c
+++ b/io_u.c
@@ -360,6 +360,17 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 		loop_cache_invalidate(td, f);
 	}
 
+	/*
+	 * If we reach the end for a rw-io-size based run, reset us back to 0
+	 * and invalidate the cache, if we need to.
+	 */
+	if (td_rw(td) && o->io_size > o->size) {
+		if (f->last_pos[ddir] >= f->io_size + get_start_offset(td, f)) {
+			f->last_pos[ddir] = f->file_offset;
+			loop_cache_invalidate(td, f);
+		}
+        }
+
 	if (f->last_pos[ddir] < f->real_file_size) {
 		uint64_t pos;
 
-- 
2.25.1

