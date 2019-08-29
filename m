Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:28106 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfH2HVl (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 29 Aug 2019 03:21:41 -0400
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 5/6] man: Improve zonemode=zbd information
Date: Thu, 29 Aug 2019 16:21:34 +0900
Message-Id: <20190829072135.2872-6-damien.lemoal@wdc.com>
In-Reply-To: <20190829072135.2872-1-damien.lemoal@wdc.com>
References: <20190829072135.2872-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

Clarify the use of the zonerange and zonesize options for zonemode=zbd.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 fio.1 | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fio.1 b/fio.1
index d7421eee..c00579bc 100644
--- a/fio.1
+++ b/fio.1
@@ -753,7 +753,10 @@ restricted to a single zone.
 .RE
 .TP
 .BI zonerange \fR=\fPint
-Size of a single zone. See also \fBzonesize\fR and \fBzoneskip\fR.
+For \fBzonemode\fR=strided, this is the size of a single zone. See also
+\fBzonesize\fR and \fBzoneskip\fR.
+
+For \fBzonemode\fR=zbd, this parameter is ignored.
 .TP
 .BI zonesize \fR=\fPint
 For \fBzonemode\fR=strided, this is the number of bytes to transfer before
@@ -762,8 +765,11 @@ skipping \fBzoneskip\fR bytes. If this parameter is smaller than
 will be accessed.  If this parameter is larger than \fBzonerange\fR then each
 zone will be accessed multiple times before skipping to the next zone.
 
-For \fBzonemode\fR=zbd, this is the size of a single zone. The \fBzonerange\fR
-parameter is ignored in this mode.
+For \fBzonemode\fR=zbd, this is the size of a single zone. The
+\fBzonerange\fR parameter is ignored in this mode. For a job accessing a
+zoned block device, the specified \fBzonesize\fR must be 0 or equal to the
+device zone size. For a regular block device or file, the specified
+\fBzonesize\fR must be at least 512B.
 .TP
 .BI zoneskip \fR=\fPint
 For \fBzonemode\fR=strided, the number of bytes to skip after \fBzonesize\fR
-- 
2.21.0


