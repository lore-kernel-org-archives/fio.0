Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.phas.ubc.ca ([142.103.236.13]:34666 "EHLO mail.phas.ubc.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726939AbgLOXMC (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 Dec 2020 18:12:02 -0500
Received: from [192.168.1.70] (d108-172-7-229.bchsia.telus.net [108.172.7.229])
        (authenticated bits=0)
        by mail.phas.ubc.ca (8.14.7/8.14.7) with ESMTP id 0BFMAogL001728
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <fio@vger.kernel.org>; Tue, 15 Dec 2020 14:10:51 -0800
From: Davor Cubranic <davor@phas.ubc.ca>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Using `direct=1` parameter in disk vs filesystem tests
Message-Id: <492E6063-8BAE-413B-9BD4-087E37525135@phas.ubc.ca>
Date: Tue, 15 Dec 2020 14:10:50 -0800
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I have a usage question: in testing the write speed of a raw disk drive, I saw “randwrite” achieve bandwidth identical to “write” even with small block sizes, at least until I added `--direct=1` option (`--fsync_on_close=1` did not make any difference). Does that mean that this option is pretty much required for testing raw disks? (Specific command line I used: "fio --filename=/dev/sdb --name=rawdisk --rw=randwrite --bs=4k --size=256g --runtime=60 --direct=1”.)

For realistic testing of writes to a *filesystem* where our applications won’t go beyond regular POSIX open/write/close API, I assume I don’t need to set the `direct` parameter?

Thank you,

Davor

