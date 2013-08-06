Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:33069 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab3HFLwU (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 6 Aug 2013 07:52:20 -0400
Received: by mail-ob0-f182.google.com with SMTP id wo10so562010obc.27
        for <fio@vger.kernel.org>; Tue, 06 Aug 2013 04:52:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5200DF76.1020904@enovance.com>
References: <CAJqT0iwmEvv5RXseLs+9XePax8wefj7xa9gdpwdfNZqzvQFEQQ@mail.gmail.com>
	<5200DF76.1020904@enovance.com>
Date: Tue, 6 Aug 2013 17:22:19 +0530
Message-ID: <CAJqT0iwDMhF=MzMgNxBvS6ML86MLHzo5ZU-gJztj1iaNrTEKLw@mail.gmail.com>
Subject: Re: Help : Facing this when i trigger FIO from command line :"fio:
 file hash not empty on exit"
From: sampath rapaka <sampath.rapaka@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan Velu <erwan@enovance.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Tue, Aug 6, 2013 at 5:05 PM, Erwan Velu <erwan@enovance.com> wrote:
> On 06/08/2013 13:12, sampath rapaka wrote:
>>
>> There is something wrong in the command I have run ?
>>
> Can you mention the version of fio you are using ?
>
> Can you double check you didn't had an OOM message from the kernel ?
fio --version
fio-2.0.15

I have not seen any Issues with Memory. I had run other fio test from
config file, It went smoothly.
