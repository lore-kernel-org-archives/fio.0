Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:61112 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3GESnb (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 5 Jul 2013 14:43:31 -0400
Received: by mail-vc0-f177.google.com with SMTP id hv10so1869982vcb.36
        for <fio@vger.kernel.org>; Fri, 05 Jul 2013 11:43:31 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 5 Jul 2013 11:43:30 -0700
Message-ID: <CAF+0mvkAjqDsNBeayQ0TnYCao===-iomUMPepxEavYRk3XKPAw@mail.gmail.com>
Subject: Question about default random I/O distribution
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello all,

I have a question regarding the default random I/O distribution.

I am calling fio multiple times using the same parameters in a shell
script loop.  I want to make sure that each time fio is called it will
generate new random offsets (not continue to use the same random
offsets).  Or, must I specify norandommap or specify a different
random generator?

Here is an example of the parameters I am using when calling fio:

fio --name=test --filename=/dev/sdb --size=100% --runtime=60
--time_based --rw=randrw --rwmixread=50 --bs=4k --iodepth=64
--numjobs=16 --ioengine=libaio --direct=1 --refill_buffers --thread
--eta=never --group_reporting=1 --unified_rw_reporting=1 --minimal
--terse-version=3

Thank you in advance!
