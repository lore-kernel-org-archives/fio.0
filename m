Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD52319ABDE
	for <fio@vger.kernel.org>; Sat,  9 Aug 2025 01:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.153.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754702234; cv=none; b=BnU4NicgHDv5n748ZEamIflzefoixpi1LZPzRVnu5WAcD/ixhjvD3ounUcJCllxWDR15vTVwcAr6Q/gXNi4+UAUFqRb+WxiygKWqaD6Nit3GaGRMHwiuhIy/rrB+bkZSB3I9keSd7FSUrpEsbBYOvBKhkAqDubt+sAlsWW31xj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754702234; c=relaxed/simple;
	bh=olEf3IcBvJXx24G+GIRX8lBIN8hR8jwXlf59y7PEWHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZ2pKJuhhQzqY2/FpfpsMhot4hdXoKVY8bdhB4mSwd0abKj/bg2JXXaso/vtNn5pQCKTPdvtPNV7+0fKOQrBxGmGZistWESBs59e5KhxANsVRVARVCsgoQiIvoaSzXfAkN+dNAVwpzJ8J3uWmFSBQLth26gZ1jIrLPuZrFjtRv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kroyJN37; arc=none smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kroyJN37"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1754702232; x=1786238232;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=olEf3IcBvJXx24G+GIRX8lBIN8hR8jwXlf59y7PEWHQ=;
  b=kroyJN37JRNdbevkA8/g9aXiJDff9VsjgUT9xC6VAMZXv+VxgyMmT97B
   m1ulMyMLnwDjcE/Lw8rClEwv5syaNjrsEbiZYOEsIeOVTqB9tudDtXmhx
   GvVJMI34xZrwp+LVNesGn6GEJICNtgBmerrgyaTy5hSunr1jbhI2+kges
   E7zJC4vrQmZCZFWmKLdI1GzUA9zyWDGlaX6Z9IUu6zRUw8liFnPGTd+4m
   KEbLn3a/gyVXyeDsJTkKg41gqe+GYRky/cw8i+nz1YCGhsDI9JbcNMMdU
   KRhCIFWHWlnkYBW3qW5s8dSNeohn2N14VBqKmoJo+SSM5lhfxr4L/ijyu
   Q==;
X-CSE-ConnectionGUID: NnSPp4j/SaiCdrnaiJDeMw==
X-CSE-MsgGUID: xUsLarTKRD+xPBFg6Ob/QA==
X-IronPort-AV: E=Sophos;i="6.17,278,1747670400"; 
   d="scan'208";a="104622434"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Aug 2025 09:16:04 +0800
IronPort-SDR: 1iUENq1h+eZRbf73BtLfXjvCVmcW8Cxpa70YdPoxuxs/rgvhJNW2MAx4XSJNNbFvOkGepne5qM
 LJnCCevY90TpXBY+4YieVg+QfdfwEIqtDM07p+ZQPmnZb2pBxyu2a0ajtT+lC3Kq+W+uBY2wV0
 SDe8tC8L4JNX9JvgtaYb9PJmiKnDphXnliWfNzrAnp+sonswiSQHlpaZbGjqqMsMHI5Xd9Fxl/
 giLWX1q3wuC3znkiTcklI50Xnnbo190Qr62lc8fG3ds1Vreo4eDC0Jj3t2KR9piuUoJht0xpvt
 /Uw=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Aug 2025 17:12:02 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.67.30])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Aug 2025 18:15:57 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: fio@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>,
	Riley Thomasson <riley.thomasson@gmail.com>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/2] verify: fix write tracking in error cases
Date: Sat,  9 Aug 2025 10:15:54 +0900
Message-ID: <20250809011555.948564-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250809011555.948564-1-shinichiro.kawasaki@wdc.com>
References: <20250809011555.948564-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit a9ba7cef70a7 ("verify: rework write tracking for use with
verify_save_state()") reworked write tracking for verify workloads.
As part of the rework, two new functions were added: log_inflight() and
invalidate_inflight(). log_inflight() is called when a write io_u is
prepared for the verify workload. The call is ensured to occur only once
per write io_u by using the IO_U_F_PATTERN_DONE flag.
invalidate_inflight() is called when the write io_u completes. Under
non-failure conditions, the number of calls to these two functions
is expected to be equal upon the completions of all writes.

However, when a write io_u fails with an error, the balance between the
calls to log_inflight() and invalidate_inflight() breaks for two
reasons. Firstly, invalidate_inflight() is not called when the failed
sync writes. Secondly, the IO_U_F_PATTERN_DONE flag is not cleared when
the failed write io_u is reused. As a result the subsequent attempt to
prepare the io_u does not trigger the call to log_inflight(). The
unbalanced function calls causes mismatch between io_u->numberio and
td->inflight_issued, then results in abort in log_inflight(). This
failure symptom is observed by running t/zbd/run-tests-against-nullb for
the test case 72 in t/zbd/test-zbd-support.

To fix the unbalanced function calls, add calls to log_inflight() in
the sync write failure path in io_queue_event(). This ensures that
failed sync writes are appropriately logged. To fix the left
IO_U_F_PATTERN_DONE flag, clear the flag in io_queue_event() failure
path. Additional, clear the IO_U_F_BUSY_OK flag which is to be cleared
when inflight I/Os complete. For the code simplicity, introduce a new
helper function io_u_clear_inflight_flags() to avoid duplication of
the code to clear the flags.

Fixes: a9ba7cef70a7 ("verify: rework write tracking for use with verify_save_state()")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 backend.c |  2 ++
 io_u.c    | 11 +++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/backend.c b/backend.c
index 922309a0..858506c4 100644
--- a/backend.c
+++ b/backend.c
@@ -449,6 +449,7 @@ int io_queue_event(struct thread_data *td, struct io_u *io_u, int *ret,
 	case FIO_Q_COMPLETED:
 		if (io_u->error) {
 			*ret = -io_u->error;
+			invalidate_inflight(td, io_u);
 			clear_io_u(td, io_u);
 		} else if (io_u->resid) {
 			long long bytes = io_u->xfer_buflen - io_u->resid;
@@ -467,6 +468,7 @@ int io_queue_event(struct thread_data *td, struct io_u *io_u, int *ret,
 				if (!from_verify)
 					unlog_io_piece(td, io_u);
 				td_verror(td, EIO, "full resid");
+				invalidate_inflight(td, io_u);
 				clear_io_u(td, io_u);
 				break;
 			}
diff --git a/io_u.c b/io_u.c
index 6d0f32a8..78dbac9c 100644
--- a/io_u.c
+++ b/io_u.c
@@ -869,9 +869,16 @@ void put_io_u(struct thread_data *td, struct io_u *io_u)
 		__td_io_u_unlock(td);
 }
 
+static inline void io_u_clear_inflight_flags(struct thread_data *td,
+					      struct io_u *io_u)
+{
+	io_u_clear(td, io_u, IO_U_F_FLIGHT | IO_U_F_BUSY_OK |
+		   IO_U_F_PATTERN_DONE);
+}
+
 void clear_io_u(struct thread_data *td, struct io_u *io_u)
 {
-	io_u_clear(td, io_u, IO_U_F_FLIGHT);
+	io_u_clear_inflight_flags(td, io_u);
 	put_io_u(td, io_u);
 }
 
@@ -2090,7 +2097,7 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 	dprint_io_u(io_u, "complete");
 
 	assert(io_u->flags & IO_U_F_FLIGHT);
-	io_u_clear(td, io_u, IO_U_F_FLIGHT | IO_U_F_BUSY_OK | IO_U_F_PATTERN_DONE);
+	io_u_clear_inflight_flags(td, io_u);
 	invalidate_inflight(td, io_u);
 
 	if (td->o.zone_mode == ZONE_MODE_ZBD && td->o.recover_zbd_write_error &&
-- 
2.49.0

