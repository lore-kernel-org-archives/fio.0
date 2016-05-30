Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33675 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933411AbcE3Peu convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 30 May 2016 11:34:50 -0400
Received: by mail-io0-f196.google.com with SMTP id p194so9467131iod.0
        for <fio@vger.kernel.org>; Mon, 30 May 2016 08:34:50 -0700 (PDT)
MIME-Version: 1.0
From: Nitin Mathur <nitinmathur@gmail.com>
Date: Mon, 30 May 2016 23:34:10 +0800
Message-ID: <CAMy1HkEAccd5FwvUKpJMuaKtcGa_T18GXdivR06S8Ne7m0Qq=w@mail.gmail.com>
Subject: fio error when using direct=1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I am getting the following error and need help from someone

Test environment
CentOS 6.5
Linux kernel: 3.8.8, 64 bit
FIO version: fio-2.11

I run the following command

> ./fio --name=test_workld --ioengine=libaio --direct=1 --rw=randrw --norandommap --randrepeat=0 --rwmixread=40 --rwmixwrite=60 --iodepth=256 --size=100% --numjobs=4 --bssplit=512/4:64k/96 --random_distribution=zoned:50/5:50/95 --overwrite=1 --output=test_op --filename=/dev/nvme0n1 --group_reporting --runtime=1m --time_based


This means, I'm using libaio, with a queue depth of 256, and fio is
utilizing asynchronous IO engines. But when i run this command, it
results into an error "Invalid argument". If i change the parameter
--direct=0, I'm able to issue the command successfully.

Can you help me to understand, why with direct=1, the fio command
results in an error  ?

Thanks
Nitin
