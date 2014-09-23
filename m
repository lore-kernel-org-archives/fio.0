Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:37104 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbaIWNrm (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 23 Sep 2014 09:47:42 -0400
Received: by mail-pd0-f182.google.com with SMTP id p10so6329872pdj.27
        for <fio@vger.kernel.org>; Tue, 23 Sep 2014 06:47:42 -0700 (PDT)
Received: from Akira-Hayakawas-MacBook-Pro.local (e0109-106-188-9-173.uqwimax.jp. [106.188.9.173])
        by mx.google.com with ESMTPSA id nz4sm12207678pdb.51.2014.09.23.06.47.40
        for <fio@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 23 Sep 2014 06:47:41 -0700 (PDT)
Message-ID: <542179FA.5040106@gmail.com>
Date: Tue, 23 Sep 2014 22:47:38 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
MIME-Version: 1.0
Subject: [Question] How to perform stride access?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I want to perform stride write access to a block device but
I don't have a clue how I can do that.

What I want to do is to perform a stride access that
each write size is 1 sector and 7 sectors are apart between each writes.
(i.e. Only the first sector of each 4KB block)

For example,
0, 8, 16, 24, 32, ...

And, it repeat over the device until certain amount of writes are accomplished.
In my case, amount of 32MB to 508KB device.

I consider the command below works like as I want but it doesn't actually.
Instead, it looks performing ordinary 512KB seq write.
fio --name=test --filename=#{dev.path} --rw=write --ioengine=libaio --direct=1 --io_limit=32M --size=100% --ba=4k --bs=512

My questions are:
1) How to perform stride write access in fio?
2) If fio is not a appropriate tool for this purpose, easy to fix?
   Or do you recommend other tool?

- Akira
