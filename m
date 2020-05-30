Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728349AbgE3Dai (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 29 May 2020 23:30:38 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EAFC08C5C9
        for <fio@vger.kernel.org>; Fri, 29 May 2020 20:30:38 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id h7so326288ooc.9
        for <fio@vger.kernel.org>; Fri, 29 May 2020 20:30:38 -0700 (PDT)
MIME-Version: 1.0
From: Zhengzhi Xiong <zhengzx@utexas.edu>
Date: Fri, 29 May 2020 20:30:25 -0700
Message-ID: <CAAVhzVOPZ+YdRoDhpVmynkMX06iY-vV7tTA=PK+eCgCLsz-ctg@mail.gmail.com>
Subject: FIO zonemode zbd with IO errors
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
I am using FIO3.19. I fully filled my zns device. I believe with
setting zonemode=zbd, FIO will reset the full zone before assign
writing command. But looks like I still got io_u error with
zonemode=zbd.

I will appreciate if you can provide any advice.

Thank you.

Best,
Zhengzhi

