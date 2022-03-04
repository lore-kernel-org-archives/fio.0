Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EACCC433F5
	for <fio@archiver.kernel.org>; Fri,  4 Mar 2022 18:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241558AbiCDSNJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 4 Mar 2022 13:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241563AbiCDSNI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 4 Mar 2022 13:13:08 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F9A1D21CE
        for <fio@vger.kernel.org>; Fri,  4 Mar 2022 10:12:13 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id d84so7062506qke.8
        for <fio@vger.kernel.org>; Fri, 04 Mar 2022 10:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1+9NXGMwsKbK4aysXxT01a3KrQpKXy8tly1tazmqVN8=;
        b=ZFSKae/bxK75GPnEV4CcCjqLUbtKAnRF5aftICB46FkrY1hzA7psBhPLZ/ImRV0wpe
         QlkcxWZz8ekQaj8YuOwIK+ep3TN6JuyvhDPNd95Sfsn2PZq/YkvUWsqUsuHpFt+FHXdM
         RHfsJsEHb9hipoaYZEcUq5pNE8deylDewadzknO2Ty5N0M9IV1+tfuj3TE/8JKSvauTw
         5pnZKjNG7n0inK6WNphCvDSaXg3JASJqWI11CJIBuRZ5D6giQSp73B1LajQwjbaIgXX7
         8bU7GqK8fOqYPLpXMlxWFcf0B9Lqv/v6nhxgubkFHqjBtsniFRoAoxv4U/6lYPq/3GOO
         phPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1+9NXGMwsKbK4aysXxT01a3KrQpKXy8tly1tazmqVN8=;
        b=vyPxlNNvGDI/fKXTkwV7IRALW6nU5D4+DubnVa87QkxFGjXbriLo+frto1dNByZl3q
         Xx27MZU1yOdKsQ7yk4qfQIGTqCFwj1CiSKeNYqczsZIRh+w8uaR/pzvOYRCEnu9s2GDJ
         4B0/HNJs6bqaLWr65iNlsDnJXnqbuXfcmCK4XGIuaYA8v93mzXRmgnyCID2enmgDxjNg
         B7OV5QiWP1HWQqp0sZKaKzgPr890vJuxtQzu6OxwWcNJvrvvCwT8iaJ48UCtAW9Yflq7
         a9R1m7CCR+zQow+rCMNq0KP02fQjs6E8o3JtdNU3CiZRNfRQHipsNRkztpO2X0lXjDAa
         q6BQ==
X-Gm-Message-State: AOAM531YgTa6M8HMmjbTo84djqIXyY+KvoSK7PD1yvqE3R9jsvV5cBnj
        jHKg6oSs3PlZHkbPV8fYtAnKXOTC5sCQsP/wSBYh/UIYq70=
X-Google-Smtp-Source: ABdhPJzMJcIi7x74yowztEdExlfausLQfV9MF1nDd4q0HEF+7+pAOcIs4QX2nKUzFwhIDQZ7+5RTGxivI2n+3pxBf6w=
X-Received: by 2002:a37:4649:0:b0:47e:cf47:48af with SMTP id
 t70-20020a374649000000b0047ecf4748afmr3456455qka.605.1646417532793; Fri, 04
 Mar 2022 10:12:12 -0800 (PST)
MIME-Version: 1.0
References: <CGME20220224200742uscas1p144ff2f87331ec864d2aaac92459b0c44@uscas1p1.samsung.com>
 <CADqNVTqmWV8MiFZ6x8N4u8Poefxb9jRbpLkH03w7VPoFzEixUQ@mail.gmail.com>
 <dd8cee13d295483e9be4e1a375823a3a@samsung.com> <CADqNVTqz-458F0T8dpFq=0R1eGnaCmYWgyf+eURhYhX2pVz8sw@mail.gmail.com>
 <82afb384ca0a4dd591b3857e6089e7fe@samsung.com>
In-Reply-To: <82afb384ca0a4dd591b3857e6089e7fe@samsung.com>
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Fri, 4 Mar 2022 12:12:01 -0600
Message-ID: <CADqNVTqJxwrgfbVU5LDWmJ1hdin_YUCGJkzUkFN9eYMqPhnAyw@mail.gmail.com>
Subject: Re: Not logging zero entry intervals when using --log_avg_msec seems problematic
To:     Vincent Fu <vincent.fu@samsung.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Mar 3, 2022 at 9:00 AM Vincent Fu <vincent.fu@samsung.com> wrote:
> helper_thread.c:helper_thread_main() handles logging, steadystate, signal=
s, status_interval, and disk utilization measurements. If multiple of these=
 features are active then there may be small deviations in the logging time=
 intervals.
>
> For missing final log entries, what happens is that the helper thread rec=
eives an exit notification (A_EXIT) and then stops checking its other respo=
nsibilities. It would be reasonable to make one final call to the logging c=
ode before exiting the helper thread but there might need to be some guards=
 to make sure the logging code does not try to access threads that have alr=
eady been torn down.

Thanks. I'm wondering though if it might make more sense for
bandwidth/IOPS logging to happen the same way latency logging does.
(Latency logging is always "driven" via calls in account_io_completion
in io_u.c .Bandwidth and IOPS logging are *not* driven this way for
interval logging, but only for full per I/O  ("per unit") logging.)

Latency logging does *not* have the inconsistent interval size and
missing final log entries issues. I get that the bandwidth/IOPS
logging is leveraging the same code as the live status updates, but as
far as I can tell, that is also why it has the problems that latency
logging does not.

For now I've just fallen back to not using the log intervals and using
full per unit logs, and then post-processing them. I'd still like to
use and improve the log interval features in the future, but I've
spent a good bit of time diving into them; I'm not confident I could
get them working the way I'd like/expect fast enough for my more
immediate needs.

Thanks,
Nick
