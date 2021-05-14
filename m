Return-Path: <fio-owner@vger.kernel.org>
Received: from dish-sg.nttdocomo.co.jp ([202.19.227.74]:47919 "EHLO
        dish-sg.nttdocomo.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbhENGIm (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 May 2021 02:08:42 -0400
Received: from zssg-mailmd105.ddreams.local (zssg-mailmd900.ddreams.local [10.160.172.63])
        by zssg-mailou102.ddreams.local (Postfix) with ESMTP id 7BC5F120126
        for <fio@vger.kernel.org>; Fri, 14 May 2021 15:07:30 +0900 (JST)
Received: from t113sg-mailcc12.ddreams.local
 (t113sg-mailcc12.ddreams.local [100.66.13.87]) by zssg-mailmd105.ddreams.local
 (dDREAMS) with ESMTP id <0QT300TGB2CI0K30@dDREAMS> for fio@vger.kernel.org;
 Fri, 14 May 2021 15:07:30 +0900 (JST)
Received: from t113sg-mailcc11 (localhost [127.0.0.1])
 by t113sg-mailcc12.ddreams.local (unknown) with SMTP id 14E67UJh049355 for
 <fio@vger.kernel.org>; Fri, 14 May 2021 15:07:30 +0900
Received: from zssg-mailmf103.ddreams.local (unknown [127.0.0.1])
        by zssg-mailmf103.ddreams.local (Postfix) with ESMTP id E10687E6036     for
 <fio@vger.kernel.org>; Fri, 14 May 2021 15:06:57 +0900 (JST)
Received: from zssg-mailmf103.ddreams.local (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFFDB8E6061    for <fio@vger.kernel.org>; Fri,
 14 May 2021 15:06:57 +0900 (JST)
Received: from localhost (unknown [127.0.0.1])  by IMSVA (Postfix)
 with SMTP id DEBBD8E605A       for <fio@vger.kernel.org>; Fri,
 14 May 2021 15:06:57 +0900 (JST)
Received: from zssg-mailmf103.ddreams.local (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59B3D8E6054    for <fio@vger.kernel.org>; Fri,
 14 May 2021 15:06:57 +0900 (JST)
Received: from zssg-mailua105.ddreams.local (unknown [10.160.172.62])
        by zssg-mailmf103.ddreams.local (Postfix)
 with ESMTP     for <fio@vger.kernel.org>; Fri, 14 May 2021 15:06:57 +0900 (JST)
Received: from [10.132.72.183] (unknown [10.160.179.1])
 by zssg-mailua105.ddreams.local (dDREAMS)
 with ESMTPA id <0QT300T9L2BEBQ60@dDREAMS> for fio@vger.kernel.org; Fri,
 14 May 2021 15:06:51 +0900 (JST)
From: Nakajima Akira <nakajima.akira@nttcom.co.jp>
Subject: [Question]] How to get the expected results by writing to a single file
Message-id: <ac6ab347-f626-f859-d4fb-f302713dcf7c@nttcom.co.jp_1>
Date: Fri, 14 May 2021 15:06:50 +0900
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed
Content-language: en-US
Content-transfer-encoding: 7bit
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi.

I am measuring the speed of the cryptographic product LUKS.
In the case of CBC mode (used by LUKS ver1), due to the mechanism of 
CBC, when writing, it is expected that even if there are 2 threads, only 
the same writing speed as 1 thread.

However, in the following fio command, two files are created, and each 
thread writes to each file, so the speed is twice that of a single thread.
# fio -directory=/luks1 -direct=1 -ioengine=libaio -rw=write -numjobs=2

   This is related to https://www.spinics.net/lists/fio/msg09445.html


So I ran the following instead of -directory, but it was nearly twice as 
fast.
# fio -filename=/luks1/testfile -iodepth=1 -iodepth_batch_complete_min=0 
-direct=1 -ioengine=libaio -rw=write -runtime=60 -bs=1m -size=16G -numjobs=x

numjobs   Result
1         BW=255MiB/s
2         BW=455MiB/s


How can I get the expected result? (Result that numjobs=1 and 2 have the 
same speed)

fio was built today's github (fio-3.26).


Thanks.
Nakajima


