Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87760C433EF
	for <fio@archiver.kernel.org>; Wed, 15 Jun 2022 17:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353642AbiFORvq (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 15 Jun 2022 13:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358093AbiFORvo (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Jun 2022 13:51:44 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FAE541BE
        for <fio@vger.kernel.org>; Wed, 15 Jun 2022 10:51:40 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id c144so9278233qkg.11
        for <fio@vger.kernel.org>; Wed, 15 Jun 2022 10:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AJyaVAIF09cB3konq1S5Za8RVq5QpuSl4nAlA8AAJYU=;
        b=Sy2++42OVMyL5aidIG4Lxau9IhVVzZl1qgF3aBp9i9IaztEmAxxSdTXMgMXEyO1Xwh
         hzToSKGt5elHnoUbhd7U81YcnoNjqhpCXsTIQ91mh/hOdj2CyVFdR34K6ezKc/762z+A
         RoWNc8/mj7Yzo8NJv7N4jBpsHDxtAG8sdU3QFXNFAsKEOIFvXMJnDHYbU4LWcLrxCitL
         s1oBLfUCso26Lmkz4dLQC+IJRDmJMB9yerHkbhwG8I1/XM//jxU+wGPbgcBOP7lXVaab
         cUKsW9RVBBFPymSkJ0BAa3VrhO2ERcQyzHv49bwVYXWftNRQ5r09ennOv65T6YaCf/yp
         iWMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AJyaVAIF09cB3konq1S5Za8RVq5QpuSl4nAlA8AAJYU=;
        b=w6Nl6R81WEZswjC/LvCvVY1WZuHjhb/O/sQDEnEy7z3SZRPxCq6zZFo23IKYibZOe/
         L3kti2YXWtNOAUyAfy2UyDlcJ1z4aAvkpG7bBT++M+hbRJPzl3vXJ6uxQmMfaMlTfD8I
         ldKNbkWG5LdcpR2ovK1tGzrXBzBaddDdE/76Nun/NhOcAa9I53NF0nzt0DKPfzqzRmwL
         m9gdf1NAuSdf1IZtu/oSTSWqox62628VX51i4Cr9eQjZCkk5nYNvKHMLo91If4pCYebw
         2WCauQ93rMhxWwc9FKG5ntjGWzifZM1mUN2OmMP+EDo1csA4+jTrenOuG2T2D5GvpV5M
         GxMg==
X-Gm-Message-State: AJIora/3OqqB1PdhSKWzC2HiNBESVDgq7iMi5uXDgsSn4g+f2QbXS/t2
        V+brsJzJsexqmPzf4/Tgl14zB3UqQXumBzECGuyJhx7iw3w=
X-Google-Smtp-Source: AGRyM1stQw66xirEbWrpB/9HnL6ujR4ahZDvhyWTVzJTdtCAygmISogNFXO9U0/QfoGXRPxJR7Yqo1b6mF1yfcPoJrg=
X-Received: by 2002:a37:e202:0:b0:6a6:ab87:113d with SMTP id
 g2-20020a37e202000000b006a6ab87113dmr679334qki.605.1655315499974; Wed, 15 Jun
 2022 10:51:39 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20220614155830uscas1p15aaa5d3bc8eec3da42c78a48520c6dd9@uscas1p1.samsung.com>
 <20220614155822.307771-1-vincent.fu@samsung.com> <20220614155822.307771-3-vincent.fu@samsung.com>
 <CADqNVTpODU3u5siLtvDT8jCBGUZtprMSVi2eqaM9VRbWJ_DuCw@mail.gmail.com> <fbe6eea8b6134e92b52a78af25a1fc94@samsung.com>
In-Reply-To: <fbe6eea8b6134e92b52a78af25a1fc94@samsung.com>
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Wed, 15 Jun 2022 12:51:28 -0500
Message-ID: <CADqNVTpZ03kdKj5ZOpgzkvOk2sfjHbcBTXJap3apKGii31Xgew@mail.gmail.com>
Subject: Re: [PATCH 2/5] ioengines: don't record issue_time if ioengines
 already do it
To:     Vincent Fu <vincent.fu@samsung.com>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, Jun 15, 2022 at 12:06 PM Vincent Fu <vincent.fu@samsung.com> wrote:
>
> > -----Original Message-----
> > From: Nick Neumann [mailto:nick@pcpartpicker.com]
> > Sent: Wednesday, June 15, 2022 11:27 AM
> > To: Vincent Fu <vincent.fu@samsung.com>
> > Cc: axboe@kernel.dk; fio@vger.kernel.org
> > Subject: Re: [PATCH 2/5] ioengines: don't record issue_time if ioengines
> > already do it
> >
> > On Tue, Jun 14, 2022 at 10:59 AM Vincent Fu <vincent.fu@samsung.com>
> > wrote:
> > >
> > > io_uring, io_uring_cmd, and libaio record issue_time inside the
> > ioengine
> > > code when their commit functions are called. So we don't need to
> > record
> > > issue_time again for these ioengines in td_io_queue.
> > >
> > > If we do fill issue_time twice, then mean(slat) + mean(clat) !=
> > > mean(lat):
> >
> > I'm a little bit confused though why not recording issue_time again in
> > td_io_queue is considered the right fix. By having some ioengines that
> > record issue_time in their commit functions, and others that do not
> > (and thus have it recorded in td_io_queue), comparing clat between two
> > different engines isn't an apples-to-apples comparison. An ioengine
> > that does not record issue_time in its commit gets a "discount" of
> > sorts in its measured clat, since its issue_time is not recorded until
> > later. Does that make sense, or am I missing something? (Has been a
> > few months since I've been in the code in detail, so that's possible.)
>
> You make a good point and I'm glad you brought this up for discussion.
>
> We currently have three latency pathways for async ioengines:
>
> (1) async w/o commit: record issue_time in td_io_queue after queue
> (2) async w/commit that *does not* record issue_time: records issue_time in
> td_io_queue after queue (slat not reported)
> (3) async w/commit that *does* record issue_time: issue_time recorded in
> both td_io_queue and commit
>
> I think the right long-term solution is to make the ioengines in (2) conform to
> (1) or (3). Then we can have fair comparisons. But what 'queue' and 'commit'
> mean for them doesn't completely match what the two mean for libaio and
> io_uring.
>
> For libaio and io_uring 'queue' prepares an IO and 'commit' actually sends it
> to the OS. So it's appropriate to record issue_time after commit. But, for
> example, take a look at the nfs ioengine's commit:
>
> https://github.com/axboe/fio/blob/master/engines/nfs.c#L285
>
> nfs isn't doing what libaio and io_uring are doing with commit.
>
> There are four ioengines that fall into category (2): ime_aio, nfs, null, and
> cpp_null. It would take some time to test the changes but probably it would be
> straightforward to make nfs conform to (1) and {null, cpp_null} conform to (3)
> but I have no idea about ime_aio.
>
> I think the current patch is an improvement over what we currently have.  Plus
> it really bothers me that mean(slat) + mean(clat) != mean(lat) and this
> resolves that issue.  If someone comes along to fix everything up then we can
> get rid of FIO_ASYNCIO_SETS_ISSUE_TIME and instead of td_io_queue checking for
> that flag before setting issue_time it can instead check for the presence of a
> commit hook.

Thanks for the detailed explanation. I actually read your blog post
about how fio measures latency too, and that was quite helpful as
well.

You've definitely convinced me that your change is an improvement, and
that there isn't necessarily a one-size-fits-all solution because the
different engines do different kinds of things in commit.

The fact that, before your change, mean(slat)+mean(clat) != mean(lat)
is very surprising. I (and I imagine many others) just assumed it was,
and it definitely should be, especially with libaio and io_uring,
which I imagine are the main async engines used to test raw ssd
performance. I'm glad you caught that the sum was not equal to the
total, and grateful you figured out why and fixed it. Thanks again.
