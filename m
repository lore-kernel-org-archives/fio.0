Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727441AbgIPRuc (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 16 Sep 2020 13:50:32 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7233C06174A
        for <fio@vger.kernel.org>; Wed, 16 Sep 2020 10:50:23 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id v20so4081571oiv.3
        for <fio@vger.kernel.org>; Wed, 16 Sep 2020 10:50:23 -0700 (PDT)
MIME-Version: 1.0
From: Frank Ritchie <frankaritchie@gmail.com>
Date: Wed, 16 Sep 2020 13:50:12 -0400
Message-ID: <CAMuVLDNiDM7uA-2H_GiRZSPT2iho=kVTzg_5G9cdttNp_5nb6w@mail.gmail.com>
Subject: client/server mode error handling
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi all,

I am looking for documentation on how fio handles unavailable servers
in client/server mode. For instance, if I start a client specifying 10
servers to run tests on and only 5 are immediately available will fio
retry, block, fail, etc? Is the behavior configurable?

Thanks,
Frank

