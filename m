Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93C8EC433FE
	for <fio@archiver.kernel.org>; Wed, 26 Oct 2022 19:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbiJZTj2 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 26 Oct 2022 15:39:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbiJZTjX (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Oct 2022 15:39:23 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC5B80BF7
        for <fio@vger.kernel.org>; Wed, 26 Oct 2022 12:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:Message-Id:Date:Cc:To:From
        :references:content-disposition:in-reply-to;
        bh=nF0SVUXmUm6/1jQhAiGtVkXjqXLugkxBCw1H6lsq9qw=; b=pseUDeHfrZEcxpMNUQpUhfYpJL
        R8QmdjJupQ4qWIiSACw9Si3/MSXrfSofkNtG2/FTXo+5AdbhfTpKtT+/2MP4rTZPRtksvzZNYq7G/
        OvuY/wCd3yD+r0ZpmnatuLaDn8BdEfInB6O2I6yOOCKDPkCSKuWIeyUKOBPVR/Lk3FVugk5uk8RlB
        OWIWmfVuF+girjCJt5nppZP9bLO+1a3pk/TgrpsPibzjPNFqtk1F7nQQw64V822uQ5PrNCPfn/ayM
        yDlQm2WmhLF4a3GV5gDU7GHtV6Zd/WYVHGc0qcPEAHeonrEpbpjkvBz094Xe9RMdbQgnDE3XAZnJ2
        6jmD2Taw==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1onmFC-000HfQ-2l; Wed, 26 Oct 2022 13:39:18 -0600
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1onmFA-0008UH-4u; Wed, 26 Oct 2022 13:39:16 -0600
From:   Logan Gunthorpe <logang@deltatee.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Wed, 26 Oct 2022 13:38:53 -0600
Message-Id: <20221026193902.32571-1-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: fio@vger.kernel.org, axboe@kernel.dk, vincentfu@gmail.com, David.Sloan@eideticom.com, sbates@raithlin.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH v11 0/9] Userspace P2PDMA with O_DIRECT NVMe devices
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi,

This is the latest P2PDMA userspace patch set. This version includes
some cleanup from feedback from the last posting[1].

This patch set enables userspace P2PDMA by allowing userspace to mmap()
allocated chunks of the CMB. The resulting VMA can be passed only
to O_DIRECT IO on NVMe backed files or block devices. A flag is added
to GUP() in Patch 1, then Patches 2 through 6 wire this flag up based
on whether the block queue indicates P2PDMA support. Patches 7
creates the sysfs resource that can hand out the VMAs and Patch 8
adds brief documentation for the new interface.

Feedback welcome.

This series is based on v6.1-rc1. A git branch is available here:

  https://github.com/sbates130272/linux-p2pmem/  p2pdma_user_cmb_v11

Thanks,

Logan

[1] https://lkml.kernel.org/r/20220922163926.7077-1-logang@deltatee.com

--

Changes in v11:
  - Rebased onto v6.1-rc1, fixed minor conflict in bio_map_user_iov
  - The GUP test was moved to try_grab_page() and try_grab_folio().
    This ought to be a bit more future proof. It required adding a new
    cleanup patch to return a proper error code from try_grab_page().
    (Per Jason)

Changes in v10:
  - Rebased onto v6.0-rc6
  - Reworked iov iter changes to reuse the code better and
    name them without the _flags() prefix (per Christoph)
  - Renamed a number of flags variables to gup_flags (per John)
  - Minor fixups to the last documentation patch (from Greg and John)

Changes in v9:
  - Rebased onto v6.0-rc2, included reworking the iov_iter patch
    due to changes there
  - Drop the char device mmap implementation in favour of a sysfs
    based interface. (per Christoph)

 (v8 only included the first half of the series and was merged for v6.0)

Changes in v8:
  - Rebase onto v5.19-rc1
  - Rework how the pages are stored in the VMA per Jason's suggestion

Changes in v7:
  - Rebased onto v5.18-rc1 which includes Christophs cleanup to
    free_zone_device_page() (similar to Ralph's patch).
  - Fix bug with concurrent first calls to pci_p2pdma_vma_fault()
    that caused a double allocation and lost p2p memory. Noticed
    by Andrew Maier.
  - Collected a Reviewed-by tag from Chaitanya.
  - Numerous minor fixes to commit messages

--

Logan Gunthorpe (9):
  mm: allow multiple error returns in try_grab_page()
  mm: introduce FOLL_PCI_P2PDMA to gate getting PCI P2PDMA pages
  iov_iter: introduce iov_iter_get_pages_[alloc_]flags()
  block: add check when merging zone device pages
  lib/scatterlist: add check when merging zone device pages
  block: set FOLL_PCI_P2PDMA in __bio_iov_iter_get_pages()
  block: set FOLL_PCI_P2PDMA in bio_map_user_iov()
  PCI/P2PDMA: Allow userspace VMA allocations through sysfs
  ABI: sysfs-bus-pci: add documentation for p2pmem allocate

 Documentation/ABI/testing/sysfs-bus-pci |  10 ++
 block/bio.c                             |  11 ++-
 block/blk-map.c                         |  12 ++-
 drivers/pci/p2pdma.c                    | 124 ++++++++++++++++++++++++
 include/linux/mm.h                      |   3 +-
 include/linux/mmzone.h                  |  24 +++++
 include/linux/uio.h                     |   6 ++
 lib/iov_iter.c                          |  32 ++++--
 lib/scatterlist.c                       |  25 +++--
 mm/gup.c                                |  45 ++++++---
 mm/huge_memory.c                        |  19 ++--
 mm/hugetlb.c                            |  23 +++--
 12 files changed, 280 insertions(+), 54 deletions(-)


base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
--
2.30.2
