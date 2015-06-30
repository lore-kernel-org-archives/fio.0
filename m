Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.32.201]:59140 "EHLO mail.cs.umn.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbbF3BxZ (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 29 Jun 2015 21:53:25 -0400
Received: from mail-qk0-f170.google.com (mail-qk0-f170.google.com [209.85.220.170])
	by mail.cs.umn.edu (Postfix) with ESMTPSA id C98CD3DDEC6
	for <fio@vger.kernel.org>; Mon, 29 Jun 2015 20:18:05 -0500 (CDT)
Received: by qkei195 with SMTP id i195so65061788qke.3
        for <fio@vger.kernel.org>; Mon, 29 Jun 2015 18:18:05 -0700 (PDT)
MIME-Version: 1.0
From: Alireza Haghdoost <alireza@cs.umn.edu>
Date: Mon, 29 Jun 2015 20:17:25 -0500
Message-ID: <CAB-428kbc6uE0fViU9ahW15BtPZi1txKcKnBdgzyb+083SfRZg@mail.gmail.com>
Subject: Question about data integrity check
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Grant Grundler <grundler@chromium.org>, Gwendal Grignou <gwendal@chromium.org>, Puthikorn Voravootivat <puthik@chromium.org>
Cc: FIO List <fio@vger.kernel.org>

Dear Chrome OS developers,

Thanks a lot for your contribution on this mailing list to develop
data integrity test for fio. I am in need to extend this tool for
almost similar purpose. Therefore, I did some research to understand
what you and your intern (Juan) has been done so far and have some
comments on your approach:

Based on my understanding the integrity test framework works like this:
    - First, run the write intensive job with verify_only=0 option to
write initial contents and headers on the media
    - Second, run the same job with verify_only=1 option to read what
has been written in the previous run and checks a) header rand_seed b)
in case of verify=meta check numberio


Refering to sample job file posted in here :
https://chromium.googlesource.com/chromiumos/third_party/autotest/+/master/client/site_tests/hardware_StorageFio/8k_async_randwrite

This kind of integrity checking failed to detect stale writes in
following cases. Please correct me if I am wrong but here is why I
think this is not a good method to do integrity checking:

   1. The logic does not work for multiple integrity check on the same
target (file,raw device) since it write exactly the same contents and
headers every time we run the test on the target media. Therefore, if
the test pass for the 1st time, it will pass forever regardless of
future stale writes. You are using randrepeat=1 which essentially
force FIO to use 0 for rand_seed and follow exact the same random IO
blocks every time/run.

   2. The logic does not work for 0 initialized target media with
verify != meta. This is exactly similar to the 8K_async_randwrite job
file that sounds like you are using. In this case, since verify !=
meta then the verify_only phase just check the rand_seed value of
written data with default rand_seed value of FIO. It turns out the
default rand_seed value of FIO is 0 if you have randrepeat=1.
Therefore, assuming the target media is already initialized to 0
(which is a valid case for most of new drives) regardless of what has
been written in first phase, the header rand_write check will pass.


--Alireza
PhD Candidate,
Center for Research in Intelligent Storage,
University of Minnesota - Twin Cities
