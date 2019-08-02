Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59058 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729311AbfHBLJ2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 2 Aug 2019 07:09:28 -0400
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH v3] engines: Add Network Block Device (NBD) support using libnbd.
Date: Fri,  2 Aug 2019 12:09:24 +0100
Message-Id: <20190802110925.1724-1-rjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: eblake@redhat.com, axboe@kernel.dk

v2 was posted here:
https://www.spinics.net/lists/fio/msg07831.html

For v3 I changed from creating NBD messages "by hand" to using libnbd
which is a C library that we wrote for accessing NBD servers.

In this implementation I'm using the library synchronously, which is
quite slow because it prevents us from having multiple commands in
flight on the same TCP connection.

libnbd also supports full asynchronous access.  However I couldn't
work out how the ->getevents and ->event callbacks are supposed to
work in fio engines.  If someone could take some time to explain to me
how those are supposed to be used then I could get a much higher
performance asynch engine working here.

Rich.



