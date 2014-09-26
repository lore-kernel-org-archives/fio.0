Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:35660 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbaIZSan (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 26 Sep 2014 14:30:43 -0400
Received: by mail-qc0-f173.google.com with SMTP id r5so5093382qcx.4
        for <fio@vger.kernel.org>; Fri, 26 Sep 2014 11:30:42 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 26 Sep 2014 19:30:42 +0100
Message-ID: <CA+BkS8NvVNyj3KDy3UjtD2G0q-B3Ai7sdbqwRu_DafLQmKk37Q@mail.gmail.com>
Subject: dedupe and replay
From: Alket Memushaj <amemushaj@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I am playing with the dedupe option and while it works well under
synthetic tests, it doesn't seem to work when replaying a trace.

My test jobs are simple:

fio --name=replay --ioengine=libaio --direct=1 --iodepth=32
--read_iolog=/path/to/trace --dedupe_percentage=80

or

fio --name=synth --ioengine=libaio --direct=1 --iodepth=32
--dedupe_percentage=80 --rw=write


I understand that block sizes would be variable during a trace replay,
but is it possible to specify a base block size and calculate dedupe
based on that for blocks that are multiples of the base size?

Thanks,
Alket
