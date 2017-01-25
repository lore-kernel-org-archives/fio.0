Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:37638 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751383AbdAYL7l (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 25 Jan 2017 06:59:41 -0500
Received: by mail-wm0-f44.google.com with SMTP id c206so26772681wme.0
        for <fio@vger.kernel.org>; Wed, 25 Jan 2017 03:59:40 -0800 (PST)
Received: from [192.168.1.211] (ppp-93-104-163-1.dynamic.mnet-online.de. [93.104.163.1])
        by smtp.googlemail.com with ESMTPSA id l140sm31186892wmg.12.2017.01.25.03.59.38
        for <fio@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Jan 2017 03:59:39 -0800 (PST)
From: Tobias Oberstein <tobias.oberstein@gmail.com>
Subject: comparing ioengines IOPS normalized for CPU load
Message-ID: <46824bb4-03ce-5820-53e1-16c8b994d76f@gmail.com>
Date: Wed, 25 Jan 2017 12:59:38 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

FWIW, I have compared IOPS over different ioengines when normalized for 
the resulting CPU load:

https://github.com/oberstet/scratchbox/raw/master/cruncher/engines-compared/normalized-iops.pdf

Takeaway for me was:

- libaio achieves 9.5 mio 4k randread at lowest load
- all sync engines are much more costly (rgd CPU load)
- psync is better than sync

More conclusions:

- Linux MD (RAID-0!) comes at a massive collapse of performance
- it's sad that PostgreSQL doesn't use pread/pwrite

Cheers,
/Tobias

PS:

1. I still want to try sdpk.io/fio plugin (thx Andrey!)
2. I had troubles with the mmap engine (bogs down the machine, behaves 
strangely)
