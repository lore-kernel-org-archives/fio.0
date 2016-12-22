Return-Path: <fio-owner@vger.kernel.org>
Received: from g2t1383g.austin.hpe.com ([15.233.16.89]:8410 "EHLO
        g2t1383g.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756694AbcLVGH3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Dec 2016 01:07:29 -0500
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by g2t1383g.austin.hpe.com (Postfix) with ESMTPS id E588EB80
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 06:07:15 +0000 (UTC)
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g9t5009.houston.hpe.com (Postfix) with ESMTP id DCBFF62
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 06:06:14 +0000 (UTC)
Received: from s17.americas.hpqcorp.net (s17.americas.hpqcorp.net [16.84.27.163])
        by g9t2301.houston.hpecorp.net (Postfix) with ESMTP id CC7824C
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 06:06:14 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: Improve IEC binary and SI decimal prefix handling
Date: Thu, 22 Dec 2016 00:08:41 -0600
Message-Id: <20161222060853.64104-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Use kb_base=1000 to follow international standards for unit prefixes.

