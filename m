Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52666 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728011AbfDYUch (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Apr 2019 16:32:37 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B792D3088297
        for <fio@vger.kernel.org>; Thu, 25 Apr 2019 20:32:37 +0000 (UTC)
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH v2] engines: Add Network Block Device (NBD) support.
Date: Thu, 25 Apr 2019 21:32:32 +0100
Message-Id: <20190425203233.17033-1-rjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: eblake@redhat.com

v1 was posted here:
https://www.spinics.net/lists/fio/index.html#07806

v2 isn't a particularly large change vs v1, but I have fixed
whitespace and other formatting issues.  The main thing is that I've
fixed the example nbd.fio file so it runs multiple jobs, and tested it
a lot more.

Rich.



