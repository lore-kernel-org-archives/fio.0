Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:36754 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750820AbdCaCZ5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 30 Mar 2017 22:25:57 -0400
Received: by mail-qt0-f178.google.com with SMTP id r45so55006087qte.3
        for <fio@vger.kernel.org>; Thu, 30 Mar 2017 19:25:56 -0700 (PDT)
MIME-Version: 1.0
From: Guruganesh Hegde <guruhegde4u@gmail.com>
Date: Fri, 31 Mar 2017 07:55:55 +0530
Message-ID: <CACqzM2CTN9w45owkjvoTR+Ca4QJFvM_MnOZE9+BU+dCxo2nuEQ@mail.gmail.com>
Subject: numberio failure with numjobs=1
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I am using fio version 2.12 and using following configuration to
perform data integrity check
--------------------------------------------------------------------
[write-phase]
group_reporting
rw=randwrite
bs=4k
direct=1
ioengine=libaio

iodepth=32
numjobs=1

size=32G
randseed=40964096
verify=crc32c

verify_dump=1
refill_buffers

filename=/dev/nvme0n1

loops=10
----------------------------------------------------------------------------------

What I am seeing is fio fails for numberio with mismatch.
"verify: bad header numberio x wanted y"

I have modified fio 'verify.c' to continue on numberio mismatch error.
All other header checks like header crc & data crcs are verified.

After the above changes fio reports only few numberio errors and there
seem to no other data integrity error.

Is there anything I am missing in fio configuration?

Best Regards,
Gruu
