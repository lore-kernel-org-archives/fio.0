Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:56763 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbbA3Isd (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 30 Jan 2015 03:48:33 -0500
Received: by mail-wg0-f54.google.com with SMTP id b13so25484251wgh.13
        for <fio@vger.kernel.org>; Fri, 30 Jan 2015 00:48:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54C98E9A.5010500@huawei.com>
References: <54C98E9A.5010500@huawei.com>
Date: Fri, 30 Jan 2015 00:48:32 -0800
Message-ID: <CAB6=LfOaY-STQyyB_nm4Eu8GCnhSRVcQGDu_h2o6J2at0qZd3w@mail.gmail.com>
Subject: Re: Help: FIO testing problem on arm64
From: Philip Keogh <pkeogh@compusoftcs.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "majun (F)" <majun258@huawei.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Wed, Jan 28, 2015 at 5:36 PM, majun (F) <majun258@huawei.com> wrote:
> Hi All:
>         I met a problem while testing the ramdisk peformance using fio.
>         The platform is arm64 , fio version is 2.1.10.
>
>         The ramdisk is enabled on my platform , so there are dev/ram0 ...to dev/ram15 totall 16 ramdisk devices.
>         I tried to test these ramdisks performance uisng the script file list as below.
>
> #!/bin/bash
>...
>                                         fio --time_based ... --runtime=$runtime ... &
>                                 done
>                                 sleep $runtime
>                         done
>...
>         But the test result is not ok.
>         The error log is:
>...
>

Have you tried sleeping for slightly longer then the runtime passed to fio?

As a result of implementation details and the simple fact that sleep
isn't exact, nor is fio's runtime, a script not allowing a sufficient
buffer between backgrounded fio operations but intending to run
operations sequentially may step on itself.
