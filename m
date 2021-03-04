Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbhCDC3l (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 3 Mar 2021 21:29:41 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7A5C06175F
        for <fio@vger.kernel.org>; Wed,  3 Mar 2021 18:28:55 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id b10so26840485ybn.3
        for <fio@vger.kernel.org>; Wed, 03 Mar 2021 18:28:55 -0800 (PST)
MIME-Version: 1.0
From: RN Deglin <rndeglin@gmail.com>
Date: Wed, 3 Mar 2021 18:28:44 -0800
Message-ID: <CAAF4gz3-yWGDqVGkRWNNcV4jDDZJpc9NHRBfUegS9q_8uNU5YA@mail.gmail.com>
Subject: adapting fio to measure non-R/W workloads
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I have a need to measure workloads involving SCSI VERIFY and WRITE
SAME commands, for direct comparison with fio READ and WRITE
workloads. Has anyone ever modified fio to do this? If so, is source
available? If not, is anyone interested in doing this?

I have not found any other tools that can do this.

Thanks.

