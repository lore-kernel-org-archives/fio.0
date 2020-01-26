Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io1-f54.google.com ([209.85.166.54]:38782 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbgAZBdj (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 25 Jan 2020 20:33:39 -0500
Received: by mail-io1-f54.google.com with SMTP id s24so4616104iog.5
        for <fio@vger.kernel.org>; Sat, 25 Jan 2020 17:33:39 -0800 (PST)
MIME-Version: 1.0
From: Sarvani Reddy Kolli <sarvanireddykolli@gmail.com>
Date: Sat, 25 Jan 2020 18:33:28 -0700
Message-ID: <CANiA0Zq4ZtgYnBkfyq2yfhCc5mNZJ+R7_kYh8By+hAqWhmwhPw@mail.gmail.com>
Subject: How to cross compile fio
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
I am trying to compile and build fio 3.15 binary on a development
machine with Centos and Intel CPU E5-1620 v3 and use it across
different machines of which few are running with OS's like CentOs ,
Arch and different CPU architecture like sandybridge, broadwell,
haswell, skylake but the fio binary fails either

1. with " illegal hardware instruction (core dumped)"  - on
sandybridge and Ivybridge CPUs or
2.  "--write_hist_log=" requires zlib to run in client/server mode.

Can you  provide steps to compile and build the binary that runs
across different CPU architectures and different OS.

Thanks

