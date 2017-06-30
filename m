Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:35720 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751751AbdF3Cpg (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 29 Jun 2017 22:45:36 -0400
Received: by mail-ua0-f177.google.com with SMTP id j53so68046368uaa.2
        for <fio@vger.kernel.org>; Thu, 29 Jun 2017 19:45:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5965d266-6101-47dc-ec97-e7c8466293f2@dolby.com>
References: <ece2c605-f015-6479-2b3b-ad30f07b447c@dolby.com>
 <CY4PR10MB1477786895ADFF04303497739DD20@CY4PR10MB1477.namprd10.prod.outlook.com>
 <5965d266-6101-47dc-ec97-e7c8466293f2@dolby.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 30 Jun 2017 03:45:05 +0100
Message-ID: <CALjAwxhBN_ErQePyyM3emSB6PBuhm8cNZ69YiYCR8aK74n724Q@mail.gmail.com>
Subject: Re: Strange Uncorrectable Section Count Produced By Fio
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Forrest, Jon" <Jon.Forrest@dolby.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 29 June 2017 at 18:39, Forrest, Jon <nobozo@gmail.com> wrote:
>
> Running the fio job shown below seems to generate the expected
> i/o load, but it also caused the following output on the console:
>
> [...]
>
> WARNING: Your hard drive is failing
> Device: /dev/sdb [SAT], 37009733189632 Offline uncorrectable sectors
> WARNING: Your hard drive is failing
> Device: /dev/sdc [SAT], 54275501719552 Offline uncorrectable sectors
> WARNING: Your hard drive is failing
> Device: /dev/sdd [SAT], 71987946848256 Offline uncorrectable sectors
>
> On 6/29/2017 10:21 AM, Todd Lawall wrote:
>>
>> Correct me if I'm wrong everybody, but those look suspiciously like
>> errors coming from the kernel/driver rather than FIO.
>
> I agree but see below.
>
>> John, you could confirm this by looking for these messages in the output
>> of the
>> 'dmesg' command.   If they're from the driver, then there's further
>> questions for the authors of that code that you'd need to ask.
>
> Much to my surprise, 'dmesg' doesn't include those messages.
>
> Also, I received 12 email messages sent to 'root' from 'root' on that
> system with the same error messages, one message per disk.
>
> I hadn't thought these messages came from 'fio' directly, but
> I don't know where they come from. Whatever is producing them
> seems to be confused because the number of errors are incorrect.

That output looks like it comes from SMART monitoring of your disks
(i.e. you have a script regularly monitoring for changes in smartctl
output and sending the results to logwatch or emailing you). Further,
it looks like in your case smartctl doesn't know how to correctly
interpret the "Offline uncorrectable sectors" value - perhaps because
you're disks are "new" you need a more recent smartctl?

However, I'd be somewhat worried that the "Offline uncorrectable
sectors" are changing at all. It is one of the few values that has a
strong predictive power of a spinning disk being faulty (see
https://www.backblaze.com/blog/what-smart-stats-indicate-hard-drive-failures/
) but since you're on an SSD I don't know if it's predictive power is
as good.

-- 
Sitsofe | http://sucs.org/~sits/
