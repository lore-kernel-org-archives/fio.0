Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:36629 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964971AbcCOLU3 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 15 Mar 2016 07:20:29 -0400
Received: by mail-lb0-f170.google.com with SMTP id x1so17967302lbj.3
        for <fio@vger.kernel.org>; Tue, 15 Mar 2016 04:20:28 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 15 Mar 2016 19:20:27 +0800
Message-ID: <CAFiDJ59S0zhHDNbbron+Q1X06kBZ2i24VXYzHrSbrr0ujAR74w@mail.gmail.com>
Subject: fio with polling mode
From: Ley Foon Tan <lftan.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi

In the kernel v4.4 above, we can use polling mode for the NVMe data
transfer with command below:

echo 1 > /sys/block/nvme0n1/queue/io_poll

We can see NVMe throughput increase with polling mode with dd command.
Can we run fio with polling mode as well? If yes, what are the correct
fio parameters/arguments should we use?

Thanks.
