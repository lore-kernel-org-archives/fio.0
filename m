Return-Path: <fio-owner@vger.kernel.org>
Received: from dish-sg.nttdocomo.co.jp ([202.19.227.74]:31396 "EHLO
        dish-sg.nttdocomo.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240558AbhDMGTr (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Apr 2021 02:19:47 -0400
Received: from zssg-mailmd102.ddreams.local (zssg-mailmd900.ddreams.local [10.160.172.63])
        by zssg-mailou104.ddreams.local (Postfix) with ESMTP id C5A1D120112
        for <fio@vger.kernel.org>; Tue, 13 Apr 2021 15:14:12 +0900 (JST)
Received: from t113sg-mailcc12.ddreams.local
 (t113sg-mailcc12.ddreams.local [100.66.13.87]) by zssg-mailmd102.ddreams.local
 (dDREAMS) with ESMTP id <0QRH00F49NZNPL40@dDREAMS> for fio@vger.kernel.org;
 Tue, 13 Apr 2021 15:14:11 +0900 (JST)
Received: from t113sg-mailcc12 (localhost [127.0.0.1])
 by t113sg-mailcc12.ddreams.local (unknown) with SMTP id 13D6EB8q031104 for
 <fio@vger.kernel.org>; Tue, 13 Apr 2021 15:14:11 +0900
Received: from zssg-mailmf103.ddreams.local (unknown [127.0.0.1])
        by zssg-mailmf103.ddreams.local (Postfix) with ESMTP id 100127E603B     for
 <fio@vger.kernel.org>; Tue, 13 Apr 2021 15:13:56 +0900 (JST)
Received: from zssg-mailmf103.ddreams.local (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C7598E6071    for <fio@vger.kernel.org>; Tue,
 13 Apr 2021 15:13:56 +0900 (JST)
Received: from localhost (unknown [127.0.0.1])  by IMSVA (Postfix)
 with SMTP id 0B5C78E6075       for <fio@vger.kernel.org>; Tue,
 13 Apr 2021 15:13:56 +0900 (JST)
Received: from zssg-mailmf103.ddreams.local (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD5668E6054    for <fio@vger.kernel.org>; Tue,
 13 Apr 2021 15:13:54 +0900 (JST)
Received: from zssg-mailua102.ddreams.local (unknown [10.160.172.62])
        by zssg-mailmf103.ddreams.local (Postfix)
 with ESMTP     for <fio@vger.kernel.org>; Tue, 13 Apr 2021 15:13:54 +0900 (JST)
Received: from [10.132.13.182] (unknown [10.160.179.1])
 by zssg-mailua102.ddreams.local (dDREAMS)
 with ESMTPA id <0QRH00B1DNYY56E0@dDREAMS> for fio@vger.kernel.org; Tue,
 13 Apr 2021 15:13:47 +0900 (JST)
From: Nakajima Akira <nakajima.akira@nttcom.co.jp>
Subject: [Question] Sequential mesuaring and filename option
Message-id: <059fa98d-9088-5daa-834e-5c87d60bb836@nttcom.co.jp_1>
Date: Tue, 13 Apr 2021 15:13:46 +0900
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed
Content-language: en-US
Content-transfer-encoding: 7bit
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi.

I'm using fio for the first time. Sorry for the basic question.

On RHEL 8.3
# fio -filename=/mnt/testfile -direct=1 -ioengine=libaio -rw=write 
-bs=1m -size=5G -numjobs=1 -runtime=60 -group_reporting -name=test
IOPS=366, BW=366MiB/s

But when -numjobs=10
IOPS=3358, BW=3358MiB/s
This is 5 times faster than the physical speed of the HDD I am using 
(600MB/s).
Similar results are obtained with Sequential write.
Random read/write is fine.(Results are within 600MB/s)

https://fio.readthedocs.io/en/latest/fio_man.html#target-file-device
I refer above and use -directory=/mnt/testdir instead of -filename gave 
good results.

Am I using the -filename option incorrectly?

I confirmed this with the following ver.
fio-3.26(build from git), fio-3.19-3.el8, fio-3.1-1.el7


Thanks.
Nakajima.


