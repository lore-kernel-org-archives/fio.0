Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:36841 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752218AbdGAI6B (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 1 Jul 2017 04:58:01 -0400
Received: by mail-ua0-f176.google.com with SMTP id g40so87518367uaa.3
        for <fio@vger.kernel.org>; Sat, 01 Jul 2017 01:57:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAO5fCYuoONsRSYaTgausucKNbSO5AvkXvHLDJp20EOsMm7GUhQ@mail.gmail.com>
References: <CAO5fCYu2OhNo_FbwjGVk0rBZMpMx1VUn8WPppc+rBVr10nAEmg@mail.gmail.com>
 <CALjAwxgu_fpRz_Fou-WX4ER-c6jVdTwkc=guUHNwQcswryuSrg@mail.gmail.com>
 <CAO5fCYutXku8UKOy6r3FaeL_mMQoPmdscWMJsQxeZRM-Dh35qQ@mail.gmail.com>
 <CALjAwxhoX6TvTjpMeyisCst1wZaJQ_iohD1k+4DTw_-+KNk-yA@mail.gmail.com> <CAO5fCYuoONsRSYaTgausucKNbSO5AvkXvHLDJp20EOsMm7GUhQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 1 Jul 2017 09:57:25 +0100
Message-ID: <CALjAwxjP7kxSpetgS1WmdyZXEs0rwmxNAP1mERrboXgoyGs+CQ@mail.gmail.com>
Subject: Re: --minimal does not work in client/server mode
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Nisha Miller <nisha43222@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I'm guessing because I'm not familiar with the code in question:
Over in server.c (e.g.
https://github.com/axboe/fio/blob/a2c95580b468a1ddd72ecb5532aca7d94f6efa5b/server.c#L986
) you will need to add a new command (e.g. FIO_NET_CMD_SEND_STATUS).
You will need to have the client send this command to the server
periodically when the status interval times out (e.g.
https://github.com/axboe/fio/blob/a2c95580b468a1ddd72ecb5532aca7d94f6efa5b/client.c#L1929
) presumably by adding something like request_client_statuses that
does has timing logic similar to that in check_for_running_stats
https://github.com/axboe/fio/blob/b2f4b559a3bc69c384f6c83ee7d8efca7712adc8/stat.c#L1970
. That's the easy part...

When the server receives that command you need to actually summarise
the appropriate stats and send them back to the client. Hopefully the
server fio has been keeping a running cumulative totals somewhere so
you can just look at those and send them back without having to do
further calculation (regular fio seems to do the heavy lifting in a
helper thread that runs __show_running_run_stats -
https://github.com/axboe/fio/blob/b2f4b559a3bc69c384f6c83ee7d8efca7712adc8/stat.c#L1878
).

A drawback with the approach I'm outlining is that each server will
send stats back to the client so the client may print stats info for
different servers at different offsets to others but I think that
simplifies this task.

Good luck!

On 1 July 2017 at 01:05, Nisha Miller <nisha43222@gmail.com> wrote:
> If you can summarize what needs to be done to add this new command, I
> can have a go at it.
>
> On Fri, Jun 30, 2017 at 4:46 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>
>> You're right - that patch doesn't solve the problem. Looking closer,
>> the way that client/server mode operates suggests you'd need to add a
>> brand new client/server command to arrange for each client to send the
>> cumulative information you're after to the server so it can print it
>> out. If so that work looks more involved than I have spare time for...
>>
>> On 1 July 2017 at 00:06, Nisha Miller <nisha43222@gmail.com> wrote:
>>> Sorry, my previous reply was a bit confusing.
>>>
>>> I made the changes to client.c as per the patch. But that did not
>>> solve the problem. I still get just one terse output at the end of the
>>> test.

-- 
Sitsofe | http://sucs.org/~sits/
