Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:38011 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753012AbdF3V7s (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 30 Jun 2017 17:59:48 -0400
Received: by mail-it0-f50.google.com with SMTP id k192so31614291ith.1
        for <fio@vger.kernel.org>; Fri, 30 Jun 2017 14:59:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxgu_fpRz_Fou-WX4ER-c6jVdTwkc=guUHNwQcswryuSrg@mail.gmail.com>
References: <CAO5fCYu2OhNo_FbwjGVk0rBZMpMx1VUn8WPppc+rBVr10nAEmg@mail.gmail.com>
 <CALjAwxgu_fpRz_Fou-WX4ER-c6jVdTwkc=guUHNwQcswryuSrg@mail.gmail.com>
From: Nisha Miller <nisha43222@gmail.com>
Date: Fri, 30 Jun 2017 14:59:47 -0700
Message-ID: <CAO5fCYsHUfe=VOmds0DRGWBJCuCriqubKfdWG09aqX36fLxDDg@mail.gmail.com>
Subject: Re: --minimal does not work in client/server mode
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Sitsofe,

I made the change to client.c but it did not help?

thanks
Nisha

On Thu, Jun 29, 2017 at 8:17 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> On 30 June 2017 at 00:51, Nisha Miller <nisha43222@gmail.com> wrote:
>>
>> When running fio locally, --minimal --status-interval=1 works fine.
>> Terse output is dumped once a second.
>>
>> When I run fio remotely like this:
>>
>> fio <jobfile> --client=10.10.1.165,55555 --minimal --status-interval=1
>>
>> fio dumps normal output once a second and at the end of the test it
>> dumps terse output just once. I've tried this using fio version 2.12
>> and 2.20. Both have the same issue.
>>
>> I see others have faced the same problems, but I don't see any solutions.
>>
>> Can anyone help me?
>
> Does applying https://github.com/sitsofe/fio/commit/bd5dc65b5b89b5c179f9c2ac1e0b72640d166ed9
> (see https://github.com/sitsofe/fio/commit/bd5dc65b5b89b5c179f9c2ac1e0b72640d166ed9.patch
> for the same thing in patch form) help? If so I'll ask Jens to pull it
> via https://github.com/sitsofe/fio/tree/client_status_interval .
>
> --
> Sitsofe | http://sucs.org/~sits/
