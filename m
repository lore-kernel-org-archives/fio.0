Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgJaRWJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 31 Oct 2020 13:22:09 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18D8C0617A6
        for <fio@vger.kernel.org>; Sat, 31 Oct 2020 10:22:07 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id g25so9099624edm.6
        for <fio@vger.kernel.org>; Sat, 31 Oct 2020 10:22:07 -0700 (PDT)
MIME-Version: 1.0
References: <CADcL3SAgfT0Cy4FAgj2YK2xH7Egogc5QKR_7Eg6b7OuuwVczTw@mail.gmail.com>
In-Reply-To: <CADcL3SAgfT0Cy4FAgj2YK2xH7Egogc5QKR_7Eg6b7OuuwVczTw@mail.gmail.com>
From: Brian Wengel <m40636067@gmail.com>
Date: Sat, 31 Oct 2020 18:21:52 +0100
Message-ID: <CADcL3SCAnDGP+3rPgL8ZT3UK6UGs-Ee-XGVXtG-G6XZMjSHkGQ@mail.gmail.com>
Subject: Fwd: Getting eta-status-line to the output file?
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I would very much like to get the status-line I get from
"--eta-newline=1s" written to the output file. Is that possible (or
just something similar)?

I'm interested in the sub-results of bandwidth and IOPS during the job.
There might be an option for that but couldn't find it?

