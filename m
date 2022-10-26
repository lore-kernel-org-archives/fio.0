Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB79C38A2D
	for <fio@archiver.kernel.org>; Wed, 26 Oct 2022 19:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234782AbiJZTjZ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 26 Oct 2022 15:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234745AbiJZTjX (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Oct 2022 15:39:23 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47141A3AA7
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 12:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=33I13543xxl5IpRI3N6CO97FrUmYnw9CKJFJpgwPP2E=; b=VJ933/KMdC+wq5V1BhX9A3UP90
        A4njrHccmhlv/VcJ2lLlBjS1yG6cga9yBE0QXaBsdDIduPAnuj6Rs54RcKSRXt/kXmI77/Qz71LIj
        66NpljJkAQkg04688HYndAub2j0LUM7zanbgJzSuFgiXOF0MArgTrjc9+KfGYy4+SBYqTkix+rz4q
        QZ5SJP8HONG7HLoR9ZCTvVZi+RMW71dYPPEry0BSqBFylFfZ2GERPW6ifMZVQM/o5bzm59mWooRyI
        XB62Q3n0VyIxchxrJDTCfk3vW/HArugWTPhNdKsPEDonotSaf/gpWvvbHdQ1drxVhJ8Wy+ZYBetQT
        HG3uE9xg==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1onmFD-000HfQ-Ea; Wed, 26 Oct 2022 13:39:20 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1onmFB-0008Ui-8t; Wed, 26 Oct 2022 13:39:17 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Wed, 26 Oct 2022 13:39:02 -0600
Message-Id: <20221026193902.32571-10-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221026193902.32571-1-logang@deltatee.com>
References: <20221026193902.32571-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: fio@vger.kernel.org, axboe@kernel.dk, vincentfu@gmail.com, David.Sloan@eideticom.com, sbates@raithlin.com, logang@deltatee.com, jhubbard@nvidia.com, gregkh@linuxfoundation.org
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH v11 9/9] ABI: sysfs-bus-pci: add documentation for p2pmem allocate
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add documentation for the p2pmem/allocate binary file which allows
for allocating p2pmem buffers in userspace for passing to drivers
that support them. (Currently only O_DIRECT to NVMe devices.)

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-bus-pci | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 840727fc75dc..ecf47559f495 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -407,6 +407,16 @@ Description:
 	        file contains a '1' if the memory has been published for
 		use outside the driver that owns the device.
 
+What:		/sys/bus/pci/devices/.../p2pmem/allocate
+Date:		August 2022
+Contact:	Logan Gunthorpe <logang@deltatee.com>
+Description:
+		This file allows mapping p2pmem into userspace. For each
+		mmap() call on this file, the kernel will allocate a chunk
+		of Peer-to-Peer memory for use in Peer-to-Peer transactions.
+		This memory can be used in O_DIRECT calls to NVMe backed
+		files for Peer-to-Peer copies.
+
 What:		/sys/bus/pci/devices/.../link/clkpm
 		/sys/bus/pci/devices/.../link/l0s_aspm
 		/sys/bus/pci/devices/.../link/l1_aspm
-- 
2.30.2

