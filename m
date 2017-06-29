Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:36242 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751669AbdF2RLo (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 29 Jun 2017 13:11:44 -0400
Received: by mail-pf0-f175.google.com with SMTP id q86so53533274pfl.3
        for <fio@vger.kernel.org>; Thu, 29 Jun 2017 10:11:44 -0700 (PDT)
Received: from [10.125.26.39] ([8.39.141.5])
        by smtp.gmail.com with ESMTPSA id a4sm14487251pfc.22.2017.06.29.10.11.43
        for <fio@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Jun 2017 10:11:43 -0700 (PDT)
From: "Forrest, Jon" <nobozo@gmail.com>
Reply-To: Jon.Forrest@dolby.com
Subject: Strange Uncorrectable Section Count Produced By Fio
Message-ID: <ece2c605-f015-6479-2b3b-ad30f07b447c@dolby.com>
Date: Thu, 29 Jun 2017 10:11:42 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

(Oracle X4-2L running CentOS 7.3 with 512GB of RAM and 3 Oracle F80
800GB PCIe Flash Accelerators)

Running the fio job shown below seems to generate the expected
i/o load, but it also caused the following output on the console:

WARNING: Your hard drive is failing
Device: /dev/sdb [SAT], 37009733189632 Offline uncorrectable sectors
WARNING: Your hard drive is failing
Device: /dev/sdc [SAT], 54275501719552 Offline uncorrectable sectors
WARNING: Your hard drive is failing
Device: /dev/sdd [SAT], 71987946848256 Offline uncorrectable sectors
WARNING: Your hard drive is failing
Device: /dev/sde [SAT], 93179315486720 Offline uncorrectable sectors
WARNING: Your hard drive is failing
Device: /dev/sdf [SAT], 101245264068608 Offline uncorrectable sectors
WARNING: Your hard drive is failing
Device: /dev/sdg [SAT], 113082193936384 Offline uncorrectable sectors
WARNING: Your hard drive is failing
Device: /dev/sdh [SAT], 127135326928896 Offline uncorrectable sectors
WARNING: Your hard drive is failing
Device: /dev/sdi [SAT], 141721035866112 Offline uncorrectable sectors
WARNING: Your hard drive is failing
Device: /dev/sdaj [SAT], 162611756793856 Offline uncorrectable sectors
WARNING: Your hard drive is failing
Device: /dev/sdak [SAT], 178245437751296 Offline uncorrectable sectors
WARNING: Your hard drive is failing
Device: /dev/sdal [SAT], 189824669581312 Offline uncorrectable sectors
WARNING: Your hard drive is failing
Device: /dev/sdam [SAT], 203104708460544 Offline uncorrectable sectors

These are the 12 drives the fio job is accessing. The system seems
to be running fine with no crashes or hangs.

The number of uncorrectable sectors seems bogus. Also, these message 
showed up soon after starting the job started. It seems unlikely that
e.g. 203104708460544 sectors would have been access during this time.
Also, according to an 'iostat' command, the job is still running so the
drives are presumably still not offline. Finally, the 'ddcli' program
that lets me talk to the flash card says:

Bytes Read                            89961186304
Soft Read Error Rate                  3.657696e-03
Wear Range Delta                      0          (%)
Uncorrectable RAISE Errors            0
Current Temperature                   46         (degree C)
Uncorrectable ECC Errors              0
SATA R-Errors (CRC) Error Count       0

which looks normal.

Are the uncorrectable sector reports something I should worry about?
Is this something that 'fio' can tickle?

The 'fio' job is:
[global]
bs=8k
iodepth=128
direct=1
ioengine=libaio
randrepeat=0
group_reporting
time_based
runtime=24h
filesize=6G

[job1]
rw=randread
filename=/dev/sdaj:/dev/sdak:/dev/sdal:/dev/sdam:/dev/sdb:/dev/sdc:/dev/sdd:/dev/sde:/dev/sdf:/dev/sdg:/dev/sdh:/dev/sdi
name=random-read

Cordially,

-- 
Jon Forrest
Dolby Laboratories, Inc.
