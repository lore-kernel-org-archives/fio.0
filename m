Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6939CC433EF
	for <fio@archiver.kernel.org>; Thu, 30 Sep 2021 00:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DAE461439
	for <fio@archiver.kernel.org>; Thu, 30 Sep 2021 00:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345134AbhI3AEV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 29 Sep 2021 20:04:21 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:19148 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344935AbhI3AEU (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 29 Sep 2021 20:04:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632960159; x=1664496159;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CCvEiam7PvZciXo3bZAnTC6IyIthXA96dlObE7tNNQ0=;
  b=B9enbRnlaj8240qURhhHhBgMd1AeqMdOLIbuBBndjAxGg9GcVpSmbmiN
   Iw1xTpvq77DqVsXg+bOLQ/fhLJ3X++CwxS05hTG3sQoXMQit3MXGdx0zK
   MP/7JUTHisusKcUqBFf8eycz1r6cSpWksCwSny6/1FVOg8RtaqTpEUVai
   D2nYNjrcWPoevI4AUKjuCAl1cBw0iu3r2V0tYD26rG9HE/z0h41R2yP3Q
   Gj1uogp4nWgZGrBz7yI28lFPtRBYBUwUuJM+nteYKkdKbuviysPlxOl0c
   np/GpDLE3J52QqQKPtCqZ9wluOb2dun/H56hMJ3gqQC8Kwy3g/9dZ1ypA
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,334,1624291200"; 
   d="scan'208";a="180424528"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 30 Sep 2021 08:02:38 +0800
IronPort-SDR: HA2FysaQ8+FeadxM2s6ov+veAyegAZvo9lFVMV6FV7fce8H4g/zWpYtVufolof79okLuRQDj38
 q7EZ0hnF/FKUXp3LW7l28hEFUlQm2oBgiQgc66fWvZb6keHOFvNQQVeZwusz9uEanFTbUBWd1h
 Q9EJdry2cK7JJTVjVIjc3vmlEPi+B2SUfxqzCr3I/6jAxybP4w06xK3IwWqtTCTur2H+HJTBMV
 wJNHZIywRa2Z+7g3bSg1bBJoD4bqxn2fixmrhGEnqJc/iXU5yw0MV/oUKWnOrRx4sovcx+rjj2
 ekzzM6hHSux9oPaXggkOyYto
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 16:37:09 -0700
IronPort-SDR: BJWVDCI7Mj+3hk9ZkwPcuiloEnk9SiPH+d3saq0cjdj04e7CFaqvw6w62hWp4sABNC0sg2XBu4
 C72sMWoGVC+phueaCsTCv4nBUTBKcwGmmLPSOGEILQ/xyePaK8isjS5yF/0Zd79iscGRXDtNiD
 k5QDfBPHdoVw9aOhWfEtFJt/qiiGr5QW0LnB1HFJa9CgISpB8Xjqnm+f6LLMDYL8C64hUxyrkC
 MaT30e5jEeP4OeXZNk5tvBDlGLqxmGHyvmOu7hBt1YlsPMO3ZstPtI59c68EtLhIxoXbxVirwJ
 LjI=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.173])
  by uls-op-cesaip01.wdc.com with ESMTP; 29 Sep 2021 17:02:37 -0700
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] zbd: Fix unexpected job termination by open zone search failure
Date:   Thu, 30 Sep 2021 09:02:36 +0900
Message-Id: <20210930000236.4116945-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Test case #46 in t/zbd/test-zbd-support fails when it is repeated
hundreds of times on null_blk zoned devices. The test case uses libaio
IO engine to run 8 random write jobs on 4 sequential write required
zones. When all of the 4 zones get almost full but still open for
in-flight writes, the helper function zbd_convert_to_open_zone() fails
to get an opened zone for next write. This results in unexpected job
termination.

To avoid the unexpected job termination, retry the steps in
zbd_convert_to_open_zone(). Before retry, call io_u_quiesce() to ensure
that the in-flight writes get completed.

To prevent infinite loop by the retry, retry only when any IOs are
in-flight or in-flight IOs get completed. To check in-flight IO count of
all jobs, add a new helper function any_io_in_flight().

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/zbd.c b/zbd.c
index 64415d2b..c0b0b81c 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1204,6 +1204,19 @@ static uint32_t pick_random_zone_idx(const struct fio_file *f,
 		f->io_size;
 }
 
+static bool any_io_in_flight(void)
+{
+	struct thread_data *td;
+	int i;
+
+	for_each_td(td, i) {
+		if (td->io_u_in_flight)
+			return true;
+	}
+
+	return false;
+}
+
 /*
  * Modify the offset of an I/O unit that does not refer to an open zone such
  * that it refers to an open zone. Close an open zone and open a new zone if
@@ -1223,6 +1236,8 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 	uint32_t zone_idx, new_zone_idx;
 	int i;
 	bool wait_zone_close;
+	bool in_flight;
+	bool should_retry = true;
 
 	assert(is_valid_offset(f, io_u->offset));
 
@@ -1337,6 +1352,7 @@ open_other_zone:
 		io_u_quiesce(td);
 	}
 
+retry:
 	/* Zone 'z' is full, so try to open a new zone. */
 	for (i = f->io_size / zbdi->zone_size; i > 0; i--) {
 		zone_idx++;
@@ -1376,6 +1392,24 @@ open_other_zone:
 			goto out;
 		pthread_mutex_lock(&zbdi->mutex);
 	}
+
+	/*
+	 * When any I/O is in-flight or when all I/Os in-flight get completed,
+	 * the I/Os might have closed zones then retry the steps to open a zone.
+	 * Before retry, call io_u_quiesce() to complete in-flight writes.
+	 */
+	in_flight = any_io_in_flight();
+	if (in_flight || should_retry) {
+		dprint(FD_ZBD, "%s(%s): wait zone close and retry open zones\n",
+		       __func__, f->file_name);
+		pthread_mutex_unlock(&zbdi->mutex);
+		zone_unlock(z);
+		io_u_quiesce(td);
+		zone_lock(td, f, z);
+		should_retry = in_flight;
+		goto retry;
+	}
+
 	pthread_mutex_unlock(&zbdi->mutex);
 	zone_unlock(z);
 	dprint(FD_ZBD, "%s(%s): did not open another zone\n", __func__,
-- 
2.31.1

