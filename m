Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t5009.houston.hpe.com ([15.241.48.73]:38008 "EHLO
        g9t5009.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933196AbdADGvT (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 4 Jan 2017 01:51:19 -0500
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g9t5009.houston.hpe.com (Postfix) with ESMTP id 9855159
        for <fio@vger.kernel.org>; Wed,  4 Jan 2017 06:51:18 +0000 (UTC)
Received: from s17.americas.hpqcorp.net (s17.americas.hpqcorp.net [16.84.27.163])
        by g9t2301.houston.hpecorp.net (Postfix) with ESMTP id 87F5757
        for <fio@vger.kernel.org>; Wed,  4 Jan 2017 06:51:18 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: pmemblk and dev-dax cleanups
Date: Wed,  4 Jan 2017 00:54:49 -0600
Message-Id: <20170104065453.15106-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This series changes library loading to startup time, and resubmits
pmemblk and dev-dax patches that were not posted earlier but not
included in the previous 12-part series of binary/decimal prefix
cleanups.

 [PATCH 1/4] pmemblk, dev-dax: load libpmem and libpmemblk at startup
 [PATCH 2/4] pmemblk, dev-dax: Update descriptions
 [PATCH 3/4] pmemblk,dev-dax: clean up error logs
 [PATCH 4/4] pmemblk: Clarify fsize is in MiB not MB

 HOWTO             |  10 +++++---
 configure         |   4 ++-
 engines/dev-dax.c |  44 +++++++++-----------------------
 engines/pmemblk.c | 117 ++++++++++++++++++++++--------------------------------------------------------------
 fio.1             |   6 +++--
 5 files changed, 56 insertions(+), 125 deletions(-)

