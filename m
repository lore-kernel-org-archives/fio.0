Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ot1-f53.google.com ([209.85.210.53]:35746 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfLKV4s (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 11 Dec 2019 16:56:48 -0500
Received: by mail-ot1-f53.google.com with SMTP id o9so199786ote.2
        for <fio@vger.kernel.org>; Wed, 11 Dec 2019 13:56:47 -0800 (PST)
MIME-Version: 1.0
From: Mauricio Tavares <raubvogel@gmail.com>
Date: Wed, 11 Dec 2019 16:56:36 -0500
Message-ID: <CAHEKYV5JBE_3rhk1o-x95gSxp3jTc7XrXridimgimAWgA6CdJA@mail.gmail.com>
Subject: Reading tech specs for a drive
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

So I am trying to figure out why a hard drive I am testing using fio
is not getting the same specs as the official ones. Hard drive in
question is https://www.intel.com/content/www/us/en/products/memory-storage/solid-state-drives/data-center-ssds/dc-p4500-series/dc-p4500-4tb-aic-3d1.html

1. When it says "Random Read (100% Span)", does that mean
rwmixread=100 reads while "Random Write (100% Span)" gives
rwmixread=0?

2. Is there a way to find out the other settings they used? Looking at
https://software.intel.com/en-us/articles/evaluate-performance-for-storage-performance-development-kit-spdk-based-nvme-ssd#inpage-nav-3
they recommend for this hard drive

  Intel SSD DC P4500 series: numjob=2, iodepth=256

I do not know if that is for their spdk perf program or also fio. But
further down on the same page they are talking about different
blocksizes and iodepths for testing for IPS, bandwidth, and latency
than the ones they recommended for the P4500 drive.

And that confuses the hell out of me. =)

They also mentioned preconditioning the hard drive. How is that done?

