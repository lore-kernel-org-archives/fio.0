Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:63800 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab2CWQIG convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 23 Mar 2012 12:08:06 -0400
Received: by qcqw6 with SMTP id w6so2099241qcq.19
        for <fio@vger.kernel.org>; Fri, 23 Mar 2012 09:08:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F6C2010.1070409@kernel.dk>
References: <CAKa9NmutL+L4GyYreo5_9wvCG8vASLJs=M1b+xThcL5xdYcK0w@mail.gmail.com>
 <4F6C2010.1070409@kernel.dk>
From: Steven Lang <tirea@google.com>
Date: Fri, 23 Mar 2012 09:07:45 -0700
Message-ID: <CAAUT-yMabveTyN=yuL8bUWGZpJGqw9EwHigAgqb1V8q-gLAALg@mail.gmail.com>
Subject: Re: fio terse output issue
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Wouldn't it be better to just move the final log_info("\n"); to the
end of the function?  With that patch, it would print the normal line,
then a new line with just ";description" on it.

On Fri, Mar 23, 2012 at 12:02 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 03/23/2012 01:47 AM, Vikram Seth wrote:
>> Hi Jens,
>>
>> I have seen that using 2.05 version of fio the terse output formatting
>> has an issue when there is a text description given in the test file.
>> There is no newline separating the description and the next job stats.
>> I have pasted the text at the end of this mail with description as
>> "Standard Performance test".
>>
>> I tried following patch and it seemed to work. Do you think it is fine
>> and if you can fix the issue ?
>
> I think it looks fine, I will apply it. Thanks!
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =EF=BF=BDhttp://vger.kernel.org/majordomo-info.html
