Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:35017 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751761AbdF3XG0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 30 Jun 2017 19:06:26 -0400
Received: by mail-io0-f176.google.com with SMTP id h134so31688265iof.2
        for <fio@vger.kernel.org>; Fri, 30 Jun 2017 16:06:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxgu_fpRz_Fou-WX4ER-c6jVdTwkc=guUHNwQcswryuSrg@mail.gmail.com>
References: <CAO5fCYu2OhNo_FbwjGVk0rBZMpMx1VUn8WPppc+rBVr10nAEmg@mail.gmail.com>
 <CALjAwxgu_fpRz_Fou-WX4ER-c6jVdTwkc=guUHNwQcswryuSrg@mail.gmail.com>
From: Nisha Miller <nisha43222@gmail.com>
Date: Fri, 30 Jun 2017 16:06:24 -0700
Message-ID: <CAO5fCYutXku8UKOy6r3FaeL_mMQoPmdscWMJsQxeZRM-Dh35qQ@mail.gmail.com>
Subject: Re: --minimal does not work in client/server mode
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Sorry, my previous reply was a bit confusing.

I made the changes to client.c as per the patch. But that did not
solve the problem. I still get just one terse output at the end of the
test.

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
