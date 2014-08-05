Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:51361 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaHEPWX (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 5 Aug 2014 11:22:23 -0400
Received: by mail-la0-f44.google.com with SMTP id e16so854026lan.31
        for <fio@vger.kernel.org>; Tue, 05 Aug 2014 08:22:20 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 5 Aug 2014 16:22:20 +0100
Message-ID: <CALjAwxgC_7JRais+2ahfotYbJQ2ENwgE8KvnBF+2htPfVYEtvA@mail.gmail.com>
Subject: Spurious verification mismatch?
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

When trying to use fio from git
ae7e055f755e77dfa71ae9040250ce8eec238721 (commit dated July 25th) the
following line always fails at the same point:

./fio --randseed=1 --ioengine=libaio --iodepth=1 --bs=64k
--rw=randwrite --verify=meta --verify_backlog=50 --filename
/dev/shm/foo --size=8M --time_based --runtime=1m --name=go

go: (g=0): rw=randwrite, bs=64K-64K/64K-64K/64K-64K, ioengine=libaio, iodepth=1
fio-2.1.11-10-gae7e
Starting 1 process
meta: verify failed at file /dev/shm/foo offset 6291456, length 65536
fio: pid=55393, err=84/file:io_u.c:1806, func=io_u_queued_complete,
error=Invalid or incomplete multibyte or wide character
go: (groupid=0, jobs=1): err=84 (file:io_u.c:1806,
func=io_u_queued_complete, error=Invalid or incomplete multibyte or
wide character): pid=55393: Tue Aug  5 15:56:56 2014

Switching --loops=4 for --time_based --runtime=1m doesn't resulted in
the same error.

Is this fio job malformed?

-- 
Sitsofe | http://sucs.org/~sits/
