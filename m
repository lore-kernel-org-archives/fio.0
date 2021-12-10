Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB1DC433EF
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 02:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235770AbhLJCTU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Dec 2021 21:19:20 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:33935 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235829AbhLJCTT (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Dec 2021 21:19:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639102546; x=1670638546;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=4V+xiDUfQ9HIQkBNSFGSz4wB1RDXIdh1CHKhh9XwWHQ=;
  b=GRkkL5vaPTer5ldFkjRnehHHwNLcDh62ooMKABNibVixJ+rxD02ePqBM
   XanQwc158GD9VsJqD+DZ7anFU9T56w8hGdJo4bfiiclJCJHi3fxcSAf1L
   ZwvEp50vU9+kT37VQni940aC85J4ncbwsU3SGnLXdfRuGbVbBZRoldOaa
   YKr/gfCKP8sZRsETjyMbYubNV27kKqC1kYJwZ6EQbx0ffy+8BLROEjmTd
   eztx5yorlomvxTQNFcjqbpLXuMsJgQOvH8pdeJJcBRtX/vmJ3JFRqPoKI
   uUsZeOSmLevDWbuC9w8M0tRQgdO4yZ9cUtDBE3lZw/+fzOC8WKOGvu4a0
   w==;
X-IronPort-AV: E=Sophos;i="5.88,194,1635177600"; 
   d="scan'208";a="188907574"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 10:15:45 +0800
IronPort-SDR: +fyZEEWgKDaHQWNYSI9WFB0TI97gAoHHKhdje+5I3cQ5XB2khqKhB9MpZ9F7uJc/PsHNA+Ybfo
 b/cnrj/bqqUv1Mp+ZLnATeJzQWX0BQvb+JvddKcn++Td4YW683J6deqwBPPqUI1f45HyAoIA3G
 6b+J+b0WgVplzllJP317JgcWTXjulHUijCPjHCNYBEuBhI9n7svEKANxu/lpgq3a+ijcLNz8MS
 nj+c7kwNdbmAcTrFJlrqF0w+VvC3eIN5NFSVOMJtWyIhOjEe/HonAQRI9TOz0oDG/P8NiMsRZw
 Z8UVKWGZtFOMy15BW3XOsSZD
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 17:50:17 -0800
IronPort-SDR: WHVjkaKGSo48nirVuRe6/yEOCHx7ac55w/9/tyLHn9n8gV3EBAprk0SwPCVU9PHbJNYYS2lM2d
 hoXN/tuSv4w31lM8CIxatgnWsHQ2ipNnamlPkvAslJY5ggIJVkQrT6sft2CBobMWcIPcP9LLZP
 gZRsdRX4SC+/qfjOH0aBWngvxuJJOirlc2xFGW0KcXMKRh3r6KLLfJFIGSKOfGqWEow+3X+ehg
 wq4uyYFsUDCOI5jjLZevby2Im/wzZYQ7a8moDSGLvZ9YxaPJ1xamRe1SX4hw16rJ0LSOGAgt+Z
 jy0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 18:15:45 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J9Dyn0smMz1Rvlf
        for <fio@vger.kernel.org>; Thu,  9 Dec 2021 18:15:45 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639102544; x=1641694545; bh=4V+xiDUfQ9HIQkBNSF
        GSz4wB1RDXIdh1CHKhh9XwWHQ=; b=VFmE4+kGyrxZx0LUdQOCE2eXkC6AMwnW/i
        qTDtyu76xUdn+Jr8duwCTax6J9PHB6A8Zth6x9qiViR0hc2mMFN9Ta82cQiw2Wux
        vkXqBZ7CQSz78DwEeShJgj5dOHWBiLhSlwZuuNeFVRXzaAg+zN8fvMm2xql3HNlw
        QrwSGItCuZGOBjGiL20EmDBhBQThyyp4Ik10HrwFcTQNE71Bj3MDB2nZHiNgPsrU
        +8wkRoKngSXRry4X+QGcSdG9SayOiZftkO11VmIP8AFjMQ8uKzOvZ7G978ZeGjcq
        RRub7zJXqR8SXU0d6mZsb7ZIS2/HYNFYogysvPQnGXxJQMIwe5MQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id f9b5aus8KdN0 for <fio@vger.kernel.org>;
        Thu,  9 Dec 2021 18:15:44 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J9Dym2mypz1RtVG;
        Thu,  9 Dec 2021 18:15:44 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/11] zbd: define local functions as static
Date:   Fri, 10 Dec 2021 11:15:32 +0900
Message-Id: <20211210021541.317315-3-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Define zbd_get_zoned_model(), zbd_report_zones(), zbd_reset_wp() and
zbd_get_max_open_zones() as static since these functions are used
locally only.

No functional changes.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 zbd.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/zbd.c b/zbd.c
index c18998c4..44e77227 100644
--- a/zbd.c
+++ b/zbd.c
@@ -27,8 +27,8 @@
  * @td: FIO thread data
  * @f: FIO file for which to get model information
  */
-int zbd_get_zoned_model(struct thread_data *td, struct fio_file *f,
-			enum zbd_zoned_model *model)
+static int zbd_get_zoned_model(struct thread_data *td, struct fio_file *=
f,
+			       enum zbd_zoned_model *model)
 {
 	int ret;
=20
@@ -71,9 +71,9 @@ int zbd_get_zoned_model(struct thread_data *td, struct =
fio_file *f,
  * upon failure. If the zone report is empty, always assume an error (de=
vice
  * problem) and return -EIO.
  */
-int zbd_report_zones(struct thread_data *td, struct fio_file *f,
-		     uint64_t offset, struct zbd_zone *zones,
-		     unsigned int nr_zones)
+static int zbd_report_zones(struct thread_data *td, struct fio_file *f,
+			    uint64_t offset, struct zbd_zone *zones,
+			    unsigned int nr_zones)
 {
 	int ret;
=20
@@ -105,8 +105,8 @@ int zbd_report_zones(struct thread_data *td, struct f=
io_file *f,
  * Reset the write pointer of all zones in the range @offset...@offset+@=
length.
  * Returns 0 upon success and a negative error code upon failure.
  */
-int zbd_reset_wp(struct thread_data *td, struct fio_file *f,
-		 uint64_t offset, uint64_t length)
+static int zbd_reset_wp(struct thread_data *td, struct fio_file *f,
+			uint64_t offset, uint64_t length)
 {
 	int ret;
=20
@@ -133,8 +133,8 @@ int zbd_reset_wp(struct thread_data *td, struct fio_f=
ile *f,
  *
  * Returns 0 upon success and a negative error code upon failure.
  */
-int zbd_get_max_open_zones(struct thread_data *td, struct fio_file *f,
-			   unsigned int *max_open_zones)
+static int zbd_get_max_open_zones(struct thread_data *td, struct fio_fil=
e *f,
+				  unsigned int *max_open_zones)
 {
 	int ret;
=20
--=20
2.31.1

