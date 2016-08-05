Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:35020 "EHLO
	mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940252AbcHETaM (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 5 Aug 2016 15:30:12 -0400
Received: by mail-qk0-f175.google.com with SMTP id x185so79634099qkc.2
        for <fio@vger.kernel.org>; Fri, 05 Aug 2016 12:30:11 -0700 (PDT)
MIME-Version: 1.0
From: Karl Cronburg <kcronbur@redhat.com>
Date: Fri, 5 Aug 2016 15:30:10 -0400
Message-ID: <CAJ9yE1D81xgUNVgpxOnYpX8zJ7jyg6j8tVMEKTAkYkPE=feo2g@mail.gmail.com>
Subject: PR for histogram logging from fio
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I've made a pull request (# 221) to the fio github, for logging and
post-processing latency histograms.

I've been working on this from the angle of making a scalable yet
accurate alternative to the averaged interval logging (log_avg_msec)
already supported.

Let me know what you think / try it out!

-Karl Cronburg-
