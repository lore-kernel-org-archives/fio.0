Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40280 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727046AbfH2QiO (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 29 Aug 2019 12:38:14 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 58B1CC0546FC
        for <fio@vger.kernel.org>; Thu, 29 Aug 2019 16:38:14 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 178221001B05
        for <fio@vger.kernel.org>; Thu, 29 Aug 2019 16:38:14 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: io_uring engine -- sqthread_poll option can't work as implemented
Date: Thu, 29 Aug 2019 12:38:12 -0400
Message-ID: <x49r254apvv.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

sqthread_poll requires registered files in order to work.  That's not
implemented in fio, and I don't see how one would go about it (but I'm
not all that familiar with fio's architecture).  We basically need all
files to be opened before we can register them.  It looks to me as
though the files are opened on demand, after the io engine is
initialized.

Any suggestions?

Cheers,
Jeff

