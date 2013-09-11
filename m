Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:57989 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab3IKSpL convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 11 Sep 2013 14:45:11 -0400
Received: by mail-la0-f43.google.com with SMTP id ep20so7700649lab.2
        for <fio@vger.kernel.org>; Wed, 11 Sep 2013 11:45:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5230B215.5060205@enovance.com>
References: <CABFR9T2g8oBJNNLjUXqvy4k8rdCuq=N_Hrjzd5up6jC0QYN-+g@mail.gmail.com>
	<5230B215.5060205@enovance.com>
Date: Wed, 11 Sep 2013 14:45:09 -0400
Message-ID: <CABFR9T2YLDJ8p9nQfY6Puob4yxoTPcKYHhHKULo+8khHjnW_tg@mail.gmail.com>
Subject: Re: genfio - feature request(s) and "bug" report
From: Roger Sibert <roger_sibert@xyratex.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>
Cc: FIO <fio@vger.kernel.org>

Most of my work is in Linux but my problem so much isnt the OS as it
is dealing with a comma.  I guess the use case would be having the
file name stored in a csv, the commas would require some sort of
encapsulation or escape sequence.

Thanks,
Roger



On Wed, Sep 11, 2013 at 2:10 PM, Erwan Velu <erwan@enovance.com> wrote:
> Le 11/09/2013 16:18, Roger Sibert a =EF=BF=BDcrit :
>> From an earlier thread the logging feature I was using was adjusted to
>> better support/handle genfio so I was looking at that and had a small
>> set of feature requests for it along with a minor bug fix for the next
>> time someones updated the file.
> Thanks for considering improving my tool :)
>>
>> Feature Request:  Add a flag to enable/disable gathering of latency
>> logs and add the ability to gather latency logs.
> I'll look at it.
>>
>> Feature Request:  Add a flag or modify the code to not use "," in the
>> filename.  Perhaps use "_" instead?
> What is the really problem with "," ? Is that badly supported on your os ?
> If so which one ?
>>
>> The bug really is just a misspelling, anoter vs another
>>
> I'll have a look thanks.
>
> Thanks for your time,
> Erwan
