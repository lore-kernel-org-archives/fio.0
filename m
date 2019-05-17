Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf1-f45.google.com ([209.85.167.45]:40217 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729202AbfEQPTM (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 17 May 2019 11:19:12 -0400
Received: by mail-lf1-f45.google.com with SMTP id h13so5609552lfc.7
        for <fio@vger.kernel.org>; Fri, 17 May 2019 08:19:11 -0700 (PDT)
MIME-Version: 1.0
From: "Manu K.S." <cse.manuks@gmail.com>
Date: Fri, 17 May 2019 20:48:58 +0530
Message-ID: <CA+=P2MuECGCj+zdvP-=3DfPD71VyYHX1RoOxCCDz2Uea=ZL9_g@mail.gmail.com>
Subject: How is numjobs & iodepth related?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi, what will be the iodepth for each job with below 3 commands?

COMMAND 1
-----------------
fio --name=fiotest --filename=/dev/sdb --rw=read --numjobs=1
--iodepth=4 --size=1G --bs=4k --runtime=120 --time_based

COMMAND 2
-------------------
fio --name=fiotest --filename=/dev/sdb --rw=read --numjobs=2
--iodepth=4 --size=1G --bs=4k --runtime=120 --time_based

COMMAND 3
-------------------
fio --name=fiotest --filename=/dev/sdb:/dev/sdc --rw=read --numjobs=2
--iodepth=4 --size=1G --bs=4k --runtime=120 --time_based


--
Cheers
Manu K S

