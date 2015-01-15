Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:51482 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbbAOLBg (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 15 Jan 2015 06:01:36 -0500
Received: by mail-lb0-f170.google.com with SMTP id 10so12637348lbg.1
        for <fio@vger.kernel.org>; Thu, 15 Jan 2015 03:01:34 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 15 Jan 2015 11:01:34 +0000
Message-ID: <CALjAwxgmpWDviJiUyoXSZPy_-JP0va+QdXmhP-r6g6JTTRv7Fg@mail.gmail.com>
Subject: Should io_limits/queue depth flushed persist while using verify_state?
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

While using fio-2.2.4 the following snippet produces a verification
error for me on the second fio invocation:

fio --bs=4k --ioengine=libaio --direct=1 --verify=meta --iodepth=128
--io_limit=300k --verify_state_save=1 --rw=randwrite --name=write3
--filename=/dev/dm-7 && fio --bs=4k --ioengine=libaio --direct=1
--verify=meta --iodepth=128 --verify_state_load=1 --rw=randread
--name=write3 --filename=/dev/dm-7

However if I put the iodepth of the second fio command down to 64 or
set io_limit the error goes away. I have also sometimes seen an error
that looks similar if the first fio is killed via ctrl-C. Is this to
be expected?

-- 
Sitsofe | http://sucs.org/~sits/
