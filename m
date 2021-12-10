Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFE1C433F5
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 01:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhLJBYW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Dec 2021 20:24:22 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:58600 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbhLJBYV (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Dec 2021 20:24:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639099247; x=1670635247;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pn/svz0wOw+HRppLaIEUK8uj61MxGzxVEPW32nSrhkI=;
  b=DRuUfAFOccMkDf/U/21z1KqeiDzhB44aFns1gHqekJYb4VAkC/FI0Ez7
   dSC08qK0619Aizsr40+gkp8ZLAfkL8zf6d1G4Ra9M1/kxGY5k+TBuJJfK
   4orqMp7Y1ODv0i+XtocW3GReF00DridqBxGgsnX8fN5dOuRqqy0pxCmzP
   9OvLCrwo54HmIMfMuxLWMLlGj7Nf7ukuZzhQhWbBrpRIyB3lJGQwkiqZv
   Eqcd2cUW35zSAyo1ITn5gUZf27fZkrR1sM7dAiUkU+Mmaz30awFxHuRo6
   NAPfmlNrVHSqlWWEgaYSf/B+PjWM8M5giN4U9kl1oBReMrDqN17kgEYeh
   w==;
X-IronPort-AV: E=Sophos;i="5.88,194,1635177600"; 
   d="scan'208";a="291878852"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 09:20:46 +0800
IronPort-SDR: S7C5a3xZEt0rSnmWxTx5zzjvuKfk1C0pTkONfUxifx6ZmzKD/srfnCy9DmPZNlwbRGLCbxS9qi
 TictbSUeniE4Dgc2m3R7HP/FzhNNQvTrag8lpT3SH3NrPcGRJFOD77JErL9b6cw1/EKSZY7874
 N7cQftBUg5MIa3x7q6ycTJ5x72NvFbQ0mNASMoVdC4QeXKVnZ3elqxMF4WnveGJyBb7BBbKoNV
 e2YhIgmKR/T2I8ZMsjsbcjYb+T+tNz0VJFtIw45uTsQMttPBOMt21LLe2U0gymmVjxfijS6Xcn
 9MjJOr5WOu/xGuuAJkHUlB9e
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 16:55:18 -0800
IronPort-SDR: 4ThVpq3Plg2ANOwhm54qtXeTRHMtjHPnE2ypDl9jzUPeOCzV5fGwEJ0ITGI+dDdvENZV70jQVT
 N+Y+iwsGAJj7U9J9maioL3kgI8AE9yMNilD+Y5mshwbiJkdqY9XPqB3aRk/dX7x971lCdqaSzM
 NBUyZIbniwRz+pqZtbfC1Hx6b5KlBAOaWJrkwOVNPtojiCGYeDEoOctQRqfaHyqwzrV//Nlilo
 C0Csld/ExhtB5kE3Yw+LliS3y6ufEWDuKlT5TI5PYdAOQRbPpXTpl87PeC54jn3RNJdVuqNqr1
 /5c=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 17:20:46 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J9ClL1sq0z1Rvlf
        for <fio@vger.kernel.org>; Thu,  9 Dec 2021 17:20:46 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1639099245;
         x=1641691246; bh=pn/svz0wOw+HRppLaIEUK8uj61MxGzxVEPW32nSrhkI=; b=
        tQlUUMw9pkpv7pgiqiiKJmeVLCuZL8pNwKmFRqJSmknvoRa5EcA8U/iUiyX9HeFU
        xY3iW2e3alu6ae38V7gbgqg4lsMzmMTZRYTQM7WOidsiN9kPn45Pnjyf/whx2aNa
        VpOMlUW8QfUPM0NqXLfrqpupp/uKVWWYwXNhsOvG+6bymGUutAn/NdNTk9TPq2Cn
        2n5b88/zYyaHUO0TMvjLCO2vsfqCnD696NGnUvkawRxK80fyIQ2bsdNT+76ARdKq
        4XUN/yPyOmN9C/T1VMUnuHRzRVVn0MJm/4GeoW16lX8d7cad8oxAfHDwPKKqzf0I
        hyNKxeAIwDXw7h7tuBKJQg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id SXEGIncOCnby for <fio@vger.kernel.org>;
        Thu,  9 Dec 2021 17:20:45 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J9ClJ6nJXz1RtVG;
        Thu,  9 Dec 2021 17:20:44 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] ioengines: libzbc: disable libzbc block backend driver
Date:   Fri, 10 Dec 2021 10:20:41 +0900
Message-Id: <20211210012041.310670-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

libzbc includes 3 different internal backend drivers:
1) The block backend: this backend relies on the kernel SMR support and
   uses regular system calls.
2) The SCSI backend: this is a SG passthrough driver for SAS drives and
   for SATA drives accessible through an SMR compliant SAT (SCSI-to-ATA
   translation layer).
3) The ATA backend: this is a SG passthrough driver for SATA drives not
   handled by the system SAT (either kernel or HBA SAT)

libzbc automatically selects the internal backend driver, using the
first one that is detected as functional (tested in the same order shown
above).

When running on an SMR enabled system (SMR compliant HBA and kernel with
zoned block device support enabled), any fio job using the libzbc IO
engine will thus end up using the regular kernel IO path. This is silly:
for this IO path, the libaio or psync IO engines are far better (less
overhead and more functionalities). The libzbc IO engine should be
restricted to be a passthrough engine only, similarly to the sg engine.

Fix the libzbc engine to not allow the use of libzbc block backend
driver by removing the ZBC_O_DRV_BLOCK flag when opening the device.

Also adjust the test script t/zbd/run-tests-against-nullb to remove the
-l option to force the use of the libzbc IO engine as it will not work
anymore (since the nullb device is neither a SCSI nor an ATA device).

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 engines/libzbc.c              |  2 +-
 t/zbd/run-tests-against-nullb | 14 --------------
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/engines/libzbc.c b/engines/libzbc.c
index abee2043..2bc2c7e0 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -85,7 +85,7 @@ static int libzbc_open_dev(struct thread_data *td, stru=
ct fio_file *f,
 		return -ENOMEM;
=20
 	ret =3D zbc_open(f->file_name,
-		       flags | ZBC_O_DRV_BLOCK | ZBC_O_DRV_SCSI | ZBC_O_DRV_ATA,
+		       flags | ZBC_O_DRV_SCSI | ZBC_O_DRV_ATA,
 		       &ld->zdev);
 	if (ret) {
 		log_err("%s: zbc_open() failed, err=3D%d\n",
diff --git a/t/zbd/run-tests-against-nullb b/t/zbd/run-tests-against-null=
b
index db901179..7d2c7fa8 100755
--- a/t/zbd/run-tests-against-nullb
+++ b/t/zbd/run-tests-against-nullb
@@ -19,7 +19,6 @@ usage()
 	echo -e "\t-L List the device layouts for every section without running=
"
 	echo -e "\t   tests."
 	echo -e "\t-s <#section> Only run the section with the given number."
-	echo -e "\t-l Use libzbc ioengine to run the tests."
 	echo -e "\t-t <#test> Only run the test with the given number in every =
section."
 	echo -e "\t-o <max_open_zones> Specify MaxOpen value, (${set_max_open} =
by default)."
 	echo -e "\t-n <#number of runs> Set the number of times to run the enti=
re suite "
@@ -239,7 +238,6 @@ dev_size=3D1024
 dev_blocksize=3D4096
 set_max_open=3D8
 zbd_test_opts=3D()
-libzbc=3D0
 num_of_runs=3D1
 test_case=3D0
 quit_on_err=3D0
@@ -250,7 +248,6 @@ while (($#)); do
 		-o) set_max_open=3D"${2}"; shift; shift;;
 		-L) list_only=3D1; shift;;
 		-r) cleanup_nullb; exit 0;;
-		-l) libzbc=3D1; shift;;
 		-n) num_of_runs=3D"${2}"; shift; shift;;
 		-t) test_case=3D"${2}"; shift; shift;;
 		-q) quit_on_err=3D1; shift;;
@@ -311,17 +308,6 @@ while ((run_nr <=3D $num_of_runs)); do
 			exit 1
 		fi
 		show_nullb_config
-		if ((libzbc)); then
-			if ((zone_capacity < zone_size)); then
-				echo "libzbc doesn't support zone capacity, skipping section $(print=
f "%02d" $section_number)"
-				continue
-			fi
-			if ((conv_pcnt =3D=3D 100)); then
-				echo "libzbc only supports zoned devices, skipping section $(printf =
"%02d" $section_number)"
-				continue
-			fi
-			zbd_test_opts+=3D("-l")
-		fi
 		cd "${scriptdir}"
 		((intr)) && exit 1
 		((list_only)) && continue
--=20
2.31.1

