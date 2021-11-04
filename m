Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54897C433F5
	for <fio@archiver.kernel.org>; Thu,  4 Nov 2021 07:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3503361168
	for <fio@archiver.kernel.org>; Thu,  4 Nov 2021 07:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhKDHfe (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 4 Nov 2021 03:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbhKDHfe (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 4 Nov 2021 03:35:34 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A244FC061714
        for <fio@vger.kernel.org>; Thu,  4 Nov 2021 00:32:56 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id y26so10135513lfa.11
        for <fio@vger.kernel.org>; Thu, 04 Nov 2021 00:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+jtjJbwN0CxKQkm/zF0Unl1qqWjtj+DPks7eFlgEgl8=;
        b=EXofnU9s21y5B5zGQNN1HjdHyBUSTfkYD6ArE+0mI4MA39qzrih60ts7tNY34PmPBV
         Up1hNFdT7tbz70eaX6hTQWyYJhZRUQzw78rpKLC3unGz17cSiM8wAHeolWkZbikMIZqR
         IGGLa/UAeW7DG7uvr/EG4nxaHsaJpb1y1RuecB1tUe5tY7l0F+9wWnj/Vc7fse1Q6GUt
         kzl55Lb7MwbtSwtloJkFo9cATi4pHHOtiPAHNOrEmrSqDZ06MYPLL70aJiCEr9P/D7M5
         dN6Jrt38/iDyCl0oxp1iCpI8jdtqAxvHGRPdzK1MmFAFBkUE6UVIqvoTo/yOh9PG3634
         Gz5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=+jtjJbwN0CxKQkm/zF0Unl1qqWjtj+DPks7eFlgEgl8=;
        b=Dg+rVT5RCyNZnAzcfSLX5wR8aBnviVXNKskt1lGse8rSlGtlrvno3K1nf5t1cqr+iP
         +atiMqEgByeQXYW1NaH1QFLWWH37P7bOvpemWOF/hKSHCoTavUscRX9KEkD/27DtQl1V
         M+Lh/CyjI/n9PU8QrDNmFQRnrhpDSwbNikWvOD3WLQ2NSPGaSHfweertH2/8+Bo+KA8i
         uYNb5Hmdr11Mn86o/GotgxM/JVaCtGEUeSgSoa3qdG65ZWs7T0x+kR8ifgujDGXBvyaE
         1nRSm21UlxmT9BsEiMLvh+k7kJ7cf4+fwrayrEA/TD500CREaDbSIvrZAU0Hmi1akktD
         b4zQ==
X-Gm-Message-State: AOAM533g8Ne+sO1UNTSRoi45cF2oRiABJ91lEeY62PEajGan+vwGXjZo
        L1TzC/LPouaxBiqf+FkiNxXiBZaOc2/OtQ==
X-Google-Smtp-Source: ABdhPJzEJpC6CHkbmmrQ5hmKBXRM5y8cOo7TXQn759PXB6wMkbFQMVctL4PvbUPY5LMHuphiD/N1vQ==
X-Received: by 2002:a19:c34a:: with SMTP id t71mr702456lff.146.1636011174706;
        Thu, 04 Nov 2021 00:32:54 -0700 (PDT)
Received: from localhost.localdomain (dyh1cxc773fwnls7mh3kt-4.rev.dnainternet.fi. [2001:14bb:1aa:298b:7bb9:24b4:bf6a:35d1])
        by smtp.gmail.com with ESMTPSA id o14sm384148lfu.253.2021.11.04.00.32.54
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 00:32:54 -0700 (PDT)
Sender: =?UTF-8?Q?Ville_Skytt=C3=A4?= <vskytta@gmail.com>
From:   "=?UTF-8?q?Ville=20Skytt=C3=A4?=" <ville.skytta@iki.fi>
X-Google-Original-From: =?UTF-8?q?Ville=20Skytt=C3=A4?= <ville.skytta@upcloud.com>
To:     fio@vger.kernel.org
Subject: [PATCH] ci, t, tools: use `command -v` instead of `which`
Date:   Thu,  4 Nov 2021 09:32:53 +0200
Message-Id: <20211104073253.720254-1-ville.skytta@upcloud.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

`which` has been deprecated in Debian's debianutils 5.0+ (currently only
Debian unstable), with no drop-in replacement:
https://salsa.debian.org/debian/debianutils/-/commit/3a8dd10b4502f7bae8fc6973c13ce23fc9da7efb

`command -v` is available in POSIX and its predecessors at least since
1994. `which` is not there in any version I'm aware of.
https://pubs.opengroup.org/onlinepubs/7908799/

Signed-off-by: Ville Skyttä <ville.skytta@upcloud.com>
---
 ci/travis-install-pmdk.sh | 2 +-
 t/one-core-peak.sh        | 4 ++--
 tools/fio_generate_plots  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/ci/travis-install-pmdk.sh b/ci/travis-install-pmdk.sh
index 803438f8..9163ec79 100755
--- a/ci/travis-install-pmdk.sh
+++ b/ci/travis-install-pmdk.sh
@@ -12,7 +12,7 @@ WORKDIR=$(pwd)
 #    /bin/sh: 1: clang: not found
 # if CC is not set to the full path of clang.
 #
-export CC=$(which $CC)
+export CC=$(command -v $CC)
 
 # Install PMDK libraries, because PMDK's libpmem
 # is a dependency of the librpma fio engine.
diff --git a/t/one-core-peak.sh b/t/one-core-peak.sh
index 9da8304e..466dbdd4 100755
--- a/t/one-core-peak.sh
+++ b/t/one-core-peak.sh
@@ -33,7 +33,7 @@ check_binary() {
   # Ensure the binaries are present and executable
   for bin in "$@"; do
     if [ ! -x ${bin} ]; then
-      which ${bin} >/dev/null
+      command -v ${bin} >/dev/null
       [ $? -eq 0 ] || fatal "${bin} doesn't exists or is not executable"
     fi
   done
@@ -197,7 +197,7 @@ show_nvme() {
   fw=$(cat ${device_dir}/firmware_rev | xargs) #xargs for trimming spaces
   serial=$(cat ${device_dir}/serial | xargs) #xargs for trimming spaces
   info ${device_name} "MODEL=${model} FW=${fw} serial=${serial} PCI=${pci_addr}@${link_speed} IRQ=${irq} NUMA=${numa} CPUS=${cpus} "
-  which nvme &> /dev/null
+  command -v nvme > /dev/null
   if [ $? -eq 0 ]; then
     status=""
     NCQA=$(nvme get-feature -H -f 0x7 ${device} 2>&1 |grep NCQA |cut -d ':' -f 2 | xargs)
diff --git a/tools/fio_generate_plots b/tools/fio_generate_plots
index e4558788..468cf27a 100755
--- a/tools/fio_generate_plots
+++ b/tools/fio_generate_plots
@@ -21,7 +21,7 @@ if [ -z "$1" ]; then
 	exit 1
 fi
 
-GNUPLOT=$(which gnuplot)
+GNUPLOT=$(command -v gnuplot)
 if [ ! -x "$GNUPLOT" ]
 then
 	echo You need gnuplot installed to generate graphs
-- 
2.25.1

