Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20716C433F5
	for <fio@archiver.kernel.org>; Wed, 26 Jan 2022 23:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiAZXIQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 26 Jan 2022 18:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiAZXIQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Jan 2022 18:08:16 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFDFC06161C
        for <fio@vger.kernel.org>; Wed, 26 Jan 2022 15:08:16 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id k4so1262667qvt.6
        for <fio@vger.kernel.org>; Wed, 26 Jan 2022 15:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=eVmsqr96s7oBfdh4A90VSc3zTFjtmDO6JN521w2bWoU=;
        b=l1E4pbXDdfvjlkI1wtveqwRqsRJjG5ayD7z1aL5N8hEDhwbLNtqr8tPrHZn3uHfVTw
         ZUa+U6ioDsN7T/7TayxyO+X8tBOgVLrzw/uwrD7jJq1LE7+1A1CPLocoVzRrIg24p9rk
         5g3LKBoXQoTA/Wwte3olsvamSCkrH9N4hRdWnuu7w2hPD6MFrWWe6/l2J/ALvHcy45S/
         EqWQv0umDagZW9HphVvvQ1A7tKUEWmNO3Rg7Be8pDqpwjfTznaIQh300XqKAFit6WFd3
         no46o+l/gLi8Zq8IU2EPw08SK+F6GzOAuuFm/MDeh6IOTa6axE+dXt6YiV4uuallb0UE
         LU+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=eVmsqr96s7oBfdh4A90VSc3zTFjtmDO6JN521w2bWoU=;
        b=TtaaNbcsUDtrchuXKzZxIwwzO8JcKs7ynC6M1WvcTPS3wG79s01xpjiFlTuYQHE0pG
         0gwepOGgy/eXk4UU5g52GYGjIXeuKKmGYbJrZYH+G/EQ6UO1Hhg3+f4HiQmlsENuynE4
         xM941YAMbMCK7/PYO6+PzMjm8bV+nAJsRovDiyf3lVdwgLKTEU56sM1iWeNVv1RNHR4y
         ftYLlMuioptUHIIc7C2gCOjLaif1N0qsOWOQpMoyRStwzcaYE0LjSxrfEmCj68jIuzZl
         sp2at11DcNrmb0F83bZ33qyuwbDonppNKnAVxiUvr/c4/k4daADaenCLKGiOT2S7210S
         IwOQ==
X-Gm-Message-State: AOAM533YzIJn/RXKt7oczMqYZHuSW4Q+KcqydOA7msyk9zJor11hz2TV
        GRiqmy15WRjSB3odP3OPxFhsC1cQT1w+7vmTkCCwaG6HJh8=
X-Google-Smtp-Source: ABdhPJzwSMRV5MTmlKhGpgCrufssn/ssOP7qVjFbPbLb+qLewmK/f2rOtvvxQnPCmIsPrkRUC3A5/UOArsw4XyY/4kw=
X-Received: by 2002:ad4:5cae:: with SMTP id q14mr1208706qvh.19.1643238494873;
 Wed, 26 Jan 2022 15:08:14 -0800 (PST)
MIME-Version: 1.0
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Wed, 26 Jan 2022 17:08:03 -0600
Message-ID: <CADqNVTpfbX2WiuzUxap5iOEaBJV0H7nup7b78acd9BAin4DAfA@mail.gmail.com>
Subject: A fio job that just waits?
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Is there a clean way to create a fio job that just waits for a fixed
time period? I'm fairly new to fio, and want a delay between two
consecutive jobs. I use "wait_for" to serialize as needed, and
expected "startdelay" to allow me to put the desired delay between the
two. But it looks like the startdelay for a job begins when fio starts
and not when the job referenced in a "wait_for" finishes.

I can play games with a job with a very low bandwidth limit (e.g.
1B/s) and "runtime" and "time_based", but it feels hacky.

Am I thinking about how to get a delay between two jobs wrong? Is
there a better way? I realize I could just run fio multiple times with
command line delays between the runs, but I'd like the results of the
runs to share the same time basis and output/log files.

Thanks,
Nick
