Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:54400 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab3AaDNF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 30 Jan 2013 22:13:05 -0500
Received: by mail-vc0-f169.google.com with SMTP id n10so1507270vcn.0
        for <fio@vger.kernel.org>; Wed, 30 Jan 2013 19:13:04 -0800 (PST)
MIME-Version: 1.0
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Wed, 30 Jan 2013 21:04:39 -0600
Message-ID: <CAB-428m_-uqpVaeg7yLO=0SosHtVh-QhWMFsrp0KDc4msKjWtQ@mail.gmail.com>
Subject: Tune IO stack to get max IOPS out of AIO
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: linux-aio@kvack.org, fio@vger.kernel.org

Hello

I am trying to tune Linux IO stack to maximize application IOPS. I was
wondering if there is any other parameter that I am missing to tune up
?

Right now I am using a raw block device to write sequential AIO
requests with FIO and set :
1. max possible value for libaio completion queue,
2. max possible value for IO scheduler queue size
(/sys/block/sda/queue/nr_requests)
3. max possible value for generic device driver queue depth
(/sys/block/sda/device/queue_depth)
4. noop IO scheduler
6. disable IO merge ( echo 2 > /sys/block/sda/queueu/nomerge )

Note that the device (/dev/sda) is attached to the server over the
network. Therefore, generic device driver will send IOs to Fiber
Channel network driver (Qlogic qla2xxx).

Please kindly advise how can I push more IO per second ?


Thanks
Alireza
