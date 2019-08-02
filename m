Return-Path: <rjones@redhat.com>
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH v4] engines: Add Network Block Device (NBD) support using libnbd.
Date: Fri,  2 Aug 2019 16:32:24 +0100
Message-Id: <20190802153225.11480-1-rjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org
Cc: eblake@redhat.com, axboe@kernel.dk
List-ID: <fio@vger.kernel.org>

v3 (the synchronous version) was posted earlier today.  It looks like
it's not available in the online archives yet.

This is v4 which implements full asynchronous support and in my
testing is about 4-5 times faster.

Rich.



