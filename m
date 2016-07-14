Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:35473 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbcGNPfw (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 14 Jul 2016 11:35:52 -0400
Received: by mail-qk0-f170.google.com with SMTP id s63so75799435qkb.2
        for <fio@vger.kernel.org>; Thu, 14 Jul 2016 08:35:51 -0700 (PDT)
MIME-Version: 1.0
From: Karl Cronburg <kcronbur@redhat.com>
Date: Thu, 14 Jul 2016 11:35:50 -0400
Message-ID: <CAJ9yE1D_J5hvq_=vJ_DbgYy5nrQM0bC_nMhRKziDWjnbw23i-w@mail.gmail.com>
Subject: fiologparser
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello all,

I have written a new version of fiologparser and could use some feedback
from anyone who uses the tool regularly. It is on branch fiologparser of my fork
of fio:

https://github.com/cronburg/fio/blob/fiologparser/tools/fiologparser.py

It uses numpy and cython to speed up the data parsing and percentile
calculations,
while decreasing the memory footprint and making it scalable.

-Karl Cronburg-
