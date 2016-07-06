Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:33561 "EHLO
	mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbcGFP4d (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 6 Jul 2016 11:56:33 -0400
Received: by mail-qk0-f175.google.com with SMTP id e3so116998370qkd.0
        for <fio@vger.kernel.org>; Wed, 06 Jul 2016 08:56:32 -0700 (PDT)
MIME-Version: 1.0
From: Karl Cronburg <kcronbur@redhat.com>
Date: Wed, 6 Jul 2016 11:56:31 -0400
Message-ID: <CAJ9yE1DPWmV0Hx_AAS5cKZR5qSFeqmqJVg7dgikQK=ZBje-e3A@mail.gmail.com>
Subject: what is the sample logger doing when the buffer fills up?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello all,

When I change add_clat_sample() in stat.c to call add_log_sample() seven times
instead of once, and I set DEF_LOG_ENTRIES=4096, I get the following in the clat
log file (note first column is line number in the file):

  4089 143, 9832, 0, 131072
  4090 143, 9832, 0, 131072
  4091 143, 9832, 0, 131072
  4092 143, 9832, 0, 131072
  4093 143, 9832, 0, 131072
  4094 143, 9832, 0, 131072
  4095 143, 9832, 0, 131072
  4096 143, 9834, 0, 131072
  4097 170, 15982, 0, 131072
  4098 170, 15982, 0, 131072
  4099 170, 15982, 0, 131072
  4100 170, 15982, 0, 131072
  4101 170, 15982, 0, 131072
  4102 170, 15982, 0, 131072
  4103 170, 15982, 0, 131072
  4104 170, 15985, 0, 131072
  4105 170, 15985, 0, 131072

Notice the lonely '9834' value in the center, which should have 7
exact copies of itself
but gets cut off right at the buffer size of 4096 entries.

So if I'm interpreting this correctly, samples get silently dropped
(or not properly printed?)
when the buffer fills up. Is this a bug? Am I misinterpreting what the
doubly linked list is
for? I was under the impression that a new sample buffer should be
added to the linked
list when the current one fills up.

Thanks,
-Karl Cronburg-
