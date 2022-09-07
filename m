Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 240C1C38145
	for <fio@archiver.kernel.org>; Wed,  7 Sep 2022 15:58:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiIGP6U (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 7 Sep 2022 11:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiIGP6T (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Sep 2022 11:58:19 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0F99D64A
        for <fio@vger.kernel.org>; Wed,  7 Sep 2022 08:58:17 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id w4so6973482qvp.2
        for <fio@vger.kernel.org>; Wed, 07 Sep 2022 08:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=OtoiggXnc1XPlSXMVoFEQbbFWi/t2W4xFVFJ6yy5FP0=;
        b=FGeJoBIXFCGDTX0tL+8zNBu01M3XrHO0y4T7Out7dSTT+WmcN9w83BdeAISILPOo3e
         8XmXD1sEwB0yf80/utRyrs0waDPBV65jofu/ap58mOi7uo8Fvz3czaXWGLS52pSxquIZ
         lbqHhd40DC4lrWeatG9IQND4FPm/1a5ucvtLUM2K5G4BDeGuukQaFjJpFAmb7BVSIJg+
         qXIRrcx0TQ2jqpjASWoaF5VLFT/rj4zTF48+6rXMx8yZHxCwFSES3yHvPHMwcOwODivd
         jTqe/0mprqnad1LVeaphEoXG8TrsZZLBtqZc0MI8r6OjjKgPOIwJmTGb6a+gLMIHS6yz
         Rvbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=OtoiggXnc1XPlSXMVoFEQbbFWi/t2W4xFVFJ6yy5FP0=;
        b=GJ3VSe8gmA4HKyj5LWn4dcvMoHyfmhGtOJgn9yaLyU3yCKN+8JJq6HdJD8WWcT+mif
         pv4FjP0Ux6a6S1xRs9cmKWRI6xybsJl9XUtsRlnMaTnK/cN0XDpAnhVUL3R2OlE/psIh
         4kINtRPvs52eHA5Oy44n0yjSYidvoinSkNKVhX2udW2Sv7mXsKm4/KM/jIZ9S3b4n4q7
         TKpTERJWWN7fvDWZwGjfmsEVES69Xh7Nsh/o7p0n2N2RpxjYQjHz8ymB/Fkn4E61VdGw
         GcEmQ12m5NxL0qG5YXjt1bmHn7U0WGeKEIYWooN5EcCyY2d5wIGlG9aWKP057iRpjU1T
         NVqg==
X-Gm-Message-State: ACgBeo0UBBM8DG1Vmyb+OTQvqVFEKbH7N/Yt85fSynLmk2kuX2gRno7X
        xEUFWAWtWTjlpnl5b7ub4E2vtZn0JIwhZH01UT7W73D9fh4=
X-Google-Smtp-Source: AA6agR5hrZi39hw8FhXrrva8LF+Yrz7/MzQtnHyD3KOvKY5vadK5J1rT9ppCMAd6pnDtzGj8ipEvzAmGWK/jDMavuO8=
X-Received: by 2002:ad4:5946:0:b0:477:42fd:6492 with SMTP id
 eo6-20020ad45946000000b0047742fd6492mr3784321qvb.88.1662566295970; Wed, 07
 Sep 2022 08:58:15 -0700 (PDT)
MIME-Version: 1.0
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Wed, 7 Sep 2022 10:58:04 -0500
Message-ID: <CADqNVTpA4uX9rqBs9vCjvBuPp4=f9yYmrEyDuECAO2JySp907Q@mail.gmail.com>
Subject: Best practices for handling drive failures during a run?
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I was wondering if there were any recommendations/suggestions on
handling drive failures during a fio run. I hit one yesterday with a
60 second mixed use test on an SSD. 51 seconds in, the drive basically
stopped responding. (A separate program that periodically calls
smartctl to get drive state also showed something was up, as data like
temperature was missing.)

At 107 seconds, a read completed, and fio exited.

It made me wonder what would have happened if the test was not time
limited - e.g., a full drive write. Would it have just hung, waiting
forever? Or would the OS eventually get back to fio and tell it the
submitted operations have failed and fio would exit?

Any ideas on ways to test the behavior, or areas of the code to look at?

I'm basically looking for input on how to make sure fio does not hang
in such situations. And even better would be if I could get fio to
return an error if it does happen - I could see the controls for
reporting error being configurable - e.g., if an operation doesn't
return for N seconds, stop the job and return an error. I'm happy to
work on implementing stuff to help with this, and wanted to see where
things currently are at and what others thought about the general
issue.

Thanks,
Nick
