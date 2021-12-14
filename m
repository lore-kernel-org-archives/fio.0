Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DABEC433FE
	for <fio@archiver.kernel.org>; Tue, 14 Dec 2021 01:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237215AbhLNBYT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 13 Dec 2021 20:24:19 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:51731 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243119AbhLNBYS (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 13 Dec 2021 20:24:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639445058; x=1670981058;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XTlBfBAHVdGzCvpBU5i7s/TtgYIXDQg1Ri5z+8HdmKA=;
  b=DVBHYN3rFeFOt2O66dqz4qw7jIBNNUH1OkH3DPe+wd9rY1m9BvI316pA
   gH78S+f9NjAMrvYxCOm2RA++tXWA94ZZRn/H9IXIAzXTXLO2iEtN1/luB
   g5Y05zVOr5cH+8zDsHLtUdEUVWmseH6GrZMmTlLV/QTjWYgyyg8aU8cNa
   Q5G7aANEc/j9ku6aAZDSYoHhQ/DdnPbDledXw9NcxsRF4qTmyysuUNEK/
   ppGqjou0QkSuiOAkL3z+OtkIm5xUfjU9a7aM47dfDiJrGtAWSDQgYA2jC
   KeAS8QhlROPimy6kKZFMPJPngSdVW5KtsaEe3ohxA/nu1XGofnqo3xcNh
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,204,1635177600"; 
   d="scan'208";a="188163305"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Dec 2021 09:24:18 +0800
IronPort-SDR: h9cERqOoB4hreYamaqc/53AgR91am0R1uI9xeC+oA3KELTknZXf1sPhjwJZ3hDgo+2OikesTca
 cjGz+bKVLQ5ZS6GiLbNqQb88+fG7imCmnnE0ZYALxzI48AWFgVSQUtFWNZQ9t3YMISipOR/h8a
 e7P8AbAbsWo4gY2h82+LmmiNKDlR+xop7WY1aL3RtBIcCGGdBU1JZT3ZelyxPU8Q4zOiNVsPu8
 7l88MLqshj4Ikm66x+7f2endqNqosP+iA9Kr1LGcBCIL2mruI5IOX19cBbDfBNUJ+yKyerMczi
 NtZhKjy1CLyWqXblC6rdLSG4
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 16:58:44 -0800
IronPort-SDR: D9yAp5zvcM7NhNuO/W+hPuAFY8BwmCpYaFJiInxCHlF391wHFUHZ19Ad/iQpotOy5fZlwGFfgQ
 DBzuGPke1lXK7WmiE2n3vCtmA1Y9lWJYJfcj8jyiZOvao1/vFzWSiqG+LkpyZ/Ev47ugaF8kpB
 VjL9m4yo994M8Uvngr0EqRYiJuoXK9+VSsN0adKcfG81gSnLOuf3spJALoDvcdceOVOLiP9jmI
 +OyAXrTCjUbwKnMLsqTGewhMpN1TmfKC41RELGFN6O1Gf+IGidVpLXXAmS8yY/r0ctHCi3BT5f
 z04=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 17:24:19 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JCgdZ1KfXz1RwFN
        for <fio@vger.kernel.org>; Mon, 13 Dec 2021 17:24:18 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1639445057; x=1642037058; bh=XTlBfBAHVdGzCvpBU5
        i7s/TtgYIXDQg1Ri5z+8HdmKA=; b=kLzQ01geWNvfnyP57GFu4yTpXh6jxMpcyQ
        go35+VUhFAykNO3Wo0D2j6p9AzdsPd7mFcrpteUeZkxSwp+3TSfCalrfT7zjs+hM
        JiSmlJbzUoB96jlb9vPwQN5U6+NWgd26EN8hdpg9To5HxFXHssRNHli487VkN/Nt
        Uid3BfHBfpWNI1y6TBjhe1JeNRgsfdwqUqIL58H53aVT57aYbyCzK1N9DEglVOlY
        Ilz77Zx7Isgksf0Cqdsjr9tGaEWsVdNsbXLI1rwOP5wQl+WD1AnpQXpNO1pilu0P
        S/9rr2epOghzTf+Uq50ri6atSeEUkTpp84gmaTGdRfFXm27ER7bQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id u_ZahP2GPueT for <fio@vger.kernel.org>;
        Mon, 13 Dec 2021 17:24:17 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JCgdY0mBWz1RtVG;
        Mon, 13 Dec 2021 17:24:16 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 02/12] zbd: define local functions as static
Date:   Tue, 14 Dec 2021 10:24:03 +0900
Message-Id: <20211214012413.464798-3-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
References: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
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
Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
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

