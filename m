Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44109C433EF
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 13:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237913AbhLJNDm (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Dec 2021 08:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236018AbhLJNDl (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Dec 2021 08:03:41 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E0AC061746
        for <fio@vger.kernel.org>; Fri, 10 Dec 2021 05:00:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=tx2rP1PkTl+ODlgl6aWWuAXAuBExMuCA2L4jkzjm5+g=; b=U5JoSeCQoxMp08vvozUJicJKcG
        npwvEQUvY70jO2t+ohdhoLaagYgDcvuerOzp2BBpEjhzzpBuLMMD4xnv7z5M2ZtnnNCSgj+Z6aeAp
        okWaUv4YFhVdrVuiQEtHxC14qDOwhuA6PwuTj0gvolExEpJa0ThHmsf4uy6HrjdD3XMo0UdGdIt3E
        jRoWMI8dO8Y/erDx9IAXEOeh1xSiIuKI+LgglSuY32hQT+wqfyaSAuUed36hLYhJPSLj8FX6wXhUV
        r+fECJ/mcNmakH6eL/3Hus24l1tdzXz8MWMxKBWDDZPHujDgUvLaDe60R55/o8QjwdSXSnlPvxKPS
        0qvAtztQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvfVM-000Z4C-Os
        for fio@vger.kernel.org; Fri, 10 Dec 2021 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 8442A1BC012C; Fri, 10 Dec 2021 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211210130001.8442A1BC012C@kernel.dk>
Date:   Fri, 10 Dec 2021 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit fab60fa78a1832c17f8bb200292ded4a8b3eb2a5:

  Merge branch 'arm-detect-pmull' of https://github.com/sitsofe/fio (2021-12-06 13:26:52 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 79eb6c9a17de959d72ee51c601b2764225101282:

  ioengines: libzbc: disable libzbc block backend driver (2021-12-09 21:34:21 -0700)

----------------------------------------------------------------
Damien Le Moal (1):
      ioengines: libzbc: disable libzbc block backend driver

 engines/libzbc.c              |  2 +-
 t/zbd/run-tests-against-nullb | 14 --------------
 2 files changed, 1 insertion(+), 15 deletions(-)

---

Diff of recent changes:

diff --git a/engines/libzbc.c b/engines/libzbc.c
index abee2043..2bc2c7e0 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -85,7 +85,7 @@ static int libzbc_open_dev(struct thread_data *td, struct fio_file *f,
 		return -ENOMEM;
 
 	ret = zbc_open(f->file_name,
-		       flags | ZBC_O_DRV_BLOCK | ZBC_O_DRV_SCSI | ZBC_O_DRV_ATA,
+		       flags | ZBC_O_DRV_SCSI | ZBC_O_DRV_ATA,
 		       &ld->zdev);
 	if (ret) {
 		log_err("%s: zbc_open() failed, err=%d\n",
diff --git a/t/zbd/run-tests-against-nullb b/t/zbd/run-tests-against-nullb
index db901179..7d2c7fa8 100755
--- a/t/zbd/run-tests-against-nullb
+++ b/t/zbd/run-tests-against-nullb
@@ -19,7 +19,6 @@ usage()
 	echo -e "\t-L List the device layouts for every section without running"
 	echo -e "\t   tests."
 	echo -e "\t-s <#section> Only run the section with the given number."
-	echo -e "\t-l Use libzbc ioengine to run the tests."
 	echo -e "\t-t <#test> Only run the test with the given number in every section."
 	echo -e "\t-o <max_open_zones> Specify MaxOpen value, (${set_max_open} by default)."
 	echo -e "\t-n <#number of runs> Set the number of times to run the entire suite "
@@ -239,7 +238,6 @@ dev_size=1024
 dev_blocksize=4096
 set_max_open=8
 zbd_test_opts=()
-libzbc=0
 num_of_runs=1
 test_case=0
 quit_on_err=0
@@ -250,7 +248,6 @@ while (($#)); do
 		-o) set_max_open="${2}"; shift; shift;;
 		-L) list_only=1; shift;;
 		-r) cleanup_nullb; exit 0;;
-		-l) libzbc=1; shift;;
 		-n) num_of_runs="${2}"; shift; shift;;
 		-t) test_case="${2}"; shift; shift;;
 		-q) quit_on_err=1; shift;;
@@ -311,17 +308,6 @@ while ((run_nr <= $num_of_runs)); do
 			exit 1
 		fi
 		show_nullb_config
-		if ((libzbc)); then
-			if ((zone_capacity < zone_size)); then
-				echo "libzbc doesn't support zone capacity, skipping section $(printf "%02d" $section_number)"
-				continue
-			fi
-			if ((conv_pcnt == 100)); then
-				echo "libzbc only supports zoned devices, skipping section $(printf "%02d" $section_number)"
-				continue
-			fi
-			zbd_test_opts+=("-l")
-		fi
 		cd "${scriptdir}"
 		((intr)) && exit 1
 		((list_only)) && continue
