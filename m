Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua1-f48.google.com ([209.85.222.48]:41221 "EHLO
        mail-ua1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727564AbeKHBJe (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Nov 2018 20:09:34 -0500
Received: by mail-ua1-f48.google.com with SMTP id o17so5991559uad.8
        for <fio@vger.kernel.org>; Wed, 07 Nov 2018 07:38:41 -0800 (PST)
MIME-Version: 1.0
References: <09b20693-8e0c-2ca9-97b3-51674177f19c@willer.it>
 <AT5PR8401MB116955F32C7A59FB0494F505ABF70@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <a26c6cc6-3efe-cbf8-37c7-f52672179b79@willer.it> <MWHPR04MB03204694EB4A9074B9D5A4228FCD0@MWHPR04MB0320.namprd04.prod.outlook.com>
 <38550f9e-63ba-cfc4-d8eb-5314d0647fd9@willer.it>
In-Reply-To: <38550f9e-63ba-cfc4-d8eb-5314d0647fd9@willer.it>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 7 Nov 2018 15:38:14 +0000
Message-ID: <CALjAwxh=CDGp6agq=7hisWvAJfGWKH9mpjQDq=FUb-VpJXS+6A@mail.gmail.com>
Subject: Re: rand-read: increasing iodepth makes throughput drop
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: federico@willer.it
Cc: Jeff Furlong <jeff.furlong@wdc.com>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, fio <fio@vger.kernel.org>, Paolo Valente <paolo.valente@linaro.org>, mark.brown@linaro.org, linus.walleij@linaro.org, ulf.hansson@linaro.org

On Wed, 7 Nov 2018 at 11:09, Federico Motta <federico@willer.it> wrote:
>
> Hi,
>
> On 10/31/18 6:31 PM, Jeff Furlong wrote:
> >> Is it normal that the sum of these percentages is not 100 but it is around 133?
> > Looks like you're running fio 3.9.  There was a recent patch, after the 3.11 release, to resolve.  Try the latest from git.
> >
> Thank you, the script I wrote to keep my fio updated to the latest
> git-tag was missing a "--version-sort" :(
>
> With fio-3.12 the sum is 100 as expected.
>
>
> On 10/31/18 3:19 PM, Federico Motta wrote:
> ...
> > Is it possible to ask fio a measure of "how much device internal
> queues are filled"?
> > If yes, with which option(s)?
> > If not, do you know some other tools or procedures which can tell us that?
>
> Does somebody has ideas about that ^  ?

I think fio will report something similar back on Linux when it is
able to work it out - see the "And finally, the disk statistics are
printed" section over in
https://fio.readthedocs.io/en/latest/fio_doc.html#interpreting-the-output
. The util percentage might be as good as it gets (i.e. a device that
can take more I/Os will have a low percentage). I think iostat
produces similar output to that too...

-- 
Sitsofe | http://sucs.org/~sits/

