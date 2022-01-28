Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC88C433EF
	for <fio@archiver.kernel.org>; Fri, 28 Jan 2022 17:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350413AbiA1RDH (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Jan 2022 12:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350398AbiA1RDG (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Jan 2022 12:03:06 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE27C061714
        for <fio@vger.kernel.org>; Fri, 28 Jan 2022 09:03:06 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id r14so5697344qtt.5
        for <fio@vger.kernel.org>; Fri, 28 Jan 2022 09:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MaLIIvZ3h7UT61Mz3lB/8f10kuHHiTG/ZAvdsSLzlQY=;
        b=Pt6AOthz2+lnNi3rAxta6mKNx6gjkoxZLsmtx0JxBQN9gp07G3/ZQW+2aUC41Zz7LC
         kXAgq7prz+f1h7CzbwLKj139bz+6heLZBN/84IHFR5fstkBKFR4Te0/XfJS12pfDnRz8
         YhuI1umBF/TexeMiQaVYCjYA+EQEqFiyko90i24F7FFtF2qNsmUUppDA1IuywaCNP2sk
         0wjvp3L+MxpdRshOXvnlPGf4eFPKvNLxy3lel9ZtjFkgUVLMhl1jsbirfvHJz6rPLAiU
         icHKeRI6YvI5+D+P4NdIPGguVBBWD0y2/2rp1bnUq7mcbxbMhOjQQxpjoZIEfuu+a3ws
         RICA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MaLIIvZ3h7UT61Mz3lB/8f10kuHHiTG/ZAvdsSLzlQY=;
        b=ZGJzXPrjPbRs5Fme3YWzmvGSY0hfVW2q0xvdVnkvktQdA84MhvwHwJlgkkDv8kD6aF
         /Unb+SeyMP8vYUGVbvXcdXbA/5XV2PVCB/2xLfYJvBeqmAB6aO34RKby8n+82CbyXVZB
         1NzAW+9pEeAKQ4AlNfw10aRSBilmr0cnM3uSUIXHhgHS4na9PPHTvjyFGpHA+IhrtuNg
         FY0IMEEZraI8Bfiayi2ekU/kGcG5FjsVn2mZyK1+MtIBDslLFft27WETec6dCBmL9Mqx
         a6eJVNmr+blBXuP//wXWZtG9WJn0gTn4J8CVlIVbtiVDEhH3EvtBwbCLJtl0pvHTZgnB
         cTqA==
X-Gm-Message-State: AOAM531COLhd3glIv4ESm3v1T9oAeBa/ahN1mWKclp82Vap8ltlHaP5O
        o3RMcdj7vlkamV9yh131DOiDqr7qC/9g8VU87dXd6T5QJD6nmw==
X-Google-Smtp-Source: ABdhPJxBRqISkpxeNjseyW8X06x0Ms9sfOIDjUhGOnifHY0lpaurfCInhrDD7jEsZUbL2liXWxlHJI/UEjY36nYEgcQ=
X-Received: by 2002:ac8:7f09:: with SMTP id f9mr1953405qtk.143.1643389385731;
 Fri, 28 Jan 2022 09:03:05 -0800 (PST)
MIME-Version: 1.0
References: <CADqNVTpfbX2WiuzUxap5iOEaBJV0H7nup7b78acd9BAin4DAfA@mail.gmail.com>
 <83721719-aeb7-2a64-2cd2-ccc9b5b2113e@opensource.wdc.com>
In-Reply-To: <83721719-aeb7-2a64-2cd2-ccc9b5b2113e@opensource.wdc.com>
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Fri, 28 Jan 2022 11:02:54 -0600
Message-ID: <CADqNVToqmzWAkkxJxe4r9M05H6ZcYRffG5pvdiHUuERMS8ojkw@mail.gmail.com>
Subject: Re: A fio job that just waits?
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, Jan 26, 2022 at 5:41 PM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
> The job that needs to be started after a delay should have both wait_for and
> startdelay options. That should work.

So that's what I expected and hoped. But it doesn't seem to work that
way. For example, I tried this:

time sudo fio --ioengine=libaio --direct=1 --filename=/dev/nvme1n1
--rw=write --iodepth=16 --bs=128k --name=job1 --size=15GB
--runtime=10s --time_based --name=job2 -size=15GB --runtime=10s
--time_based --wait_for=job1 --startdelay=5s

The first job runs for 10 seconds writing. The second job does the
same but both waiting for job1 to complete, and with a startdelay of
5s. So I would expect the total command to take about 25 seconds = 10s
job 1 + 5s startdelay for job2 + 10s job2 . But instead the startdelay
appears to begin counting when fio begins, not when job2 becomes
eligible to run due to job1 completion. The output for the runtime of
the command above is 20.760s, with the second job starting immediately
when job1 completes.
