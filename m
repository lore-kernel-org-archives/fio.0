Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:33310 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbdGAAFB (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 30 Jun 2017 20:05:01 -0400
Received: by mail-io0-f169.google.com with SMTP id h64so32038011iod.0
        for <fio@vger.kernel.org>; Fri, 30 Jun 2017 17:05:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxhoX6TvTjpMeyisCst1wZaJQ_iohD1k+4DTw_-+KNk-yA@mail.gmail.com>
References: <CAO5fCYu2OhNo_FbwjGVk0rBZMpMx1VUn8WPppc+rBVr10nAEmg@mail.gmail.com>
 <CALjAwxgu_fpRz_Fou-WX4ER-c6jVdTwkc=guUHNwQcswryuSrg@mail.gmail.com>
 <CAO5fCYutXku8UKOy6r3FaeL_mMQoPmdscWMJsQxeZRM-Dh35qQ@mail.gmail.com> <CALjAwxhoX6TvTjpMeyisCst1wZaJQ_iohD1k+4DTw_-+KNk-yA@mail.gmail.com>
From: Nisha Miller <nisha43222@gmail.com>
Date: Fri, 30 Jun 2017 17:05:00 -0700
Message-ID: <CAO5fCYuoONsRSYaTgausucKNbSO5AvkXvHLDJp20EOsMm7GUhQ@mail.gmail.com>
Subject: Re: --minimal does not work in client/server mode
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

If you can summarize what needs to be done to add this new command, I
can have a go at it.

thanks


On Fri, Jun 30, 2017 at 4:46 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> Hi,
>
> On 1 July 2017 at 00:06, Nisha Miller <nisha43222@gmail.com> wrote:
>> Sorry, my previous reply was a bit confusing.
>>
>> I made the changes to client.c as per the patch. But that did not
>> solve the problem. I still get just one terse output at the end of the
>> test.
>
> You're right - that patch doesn't solve the problem. Looking closer,
> the way that client/server mode operates suggests you'd need to add a
> brand new client/server command to arrange for each client to send the
> cumulative information you're after to the server so it can print it
> out. If so that work looks more involved than I have spare time for...
>
> --
> Sitsofe | http://sucs.org/~sits/
