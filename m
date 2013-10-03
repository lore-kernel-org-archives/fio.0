Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:65325 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab3JCVJn convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 3 Oct 2013 17:09:43 -0400
Received: by mail-lb0-f171.google.com with SMTP id u14so2557392lbd.16
        for <fio@vger.kernel.org>; Thu, 03 Oct 2013 14:09:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131003204206.GA28048@highx.de>
References: <CAAAK+WW66DdYt2JEG+2K42vWzczn38xtnh5WK-1x97zFbdkyqg@mail.gmail.com>
 <20131003204206.GA28048@highx.de>
From: "Brian L." <brianclam@gmail.com>
Date: Thu, 3 Oct 2013 14:09:21 -0700
Message-ID: <CAAAK+WXf8okat6b91cxMZfYfSA5hEtH6et9pV_Eb=NPddOLVpA@mail.gmail.com>
Subject: Re: precondition ssd drives w/ fio
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Juergen Salk <juergen.salk@gmx.de>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Thank you all for the response.  I found ssd-steadystate.fio in the tarball.

Brian

Brian L.


On Thu, Oct 3, 2013 at 1:42 PM, Juergen Salk <juergen.salk@gmx.de> wrote:
> * Brian L. <brianclam@gmail.com> [131003 12:31]:
>
>> For benchmarking SSD drives, I was told that we should precondition
>> our drives to get more accurate real world reading.
>>
>> I was wondering if anyone is using fio itself to precondition ssd
>> drives or use a different script to populate random data on the
>> drives?
>
> Yes I did. The fio source tarball comes with a number of sample
> job files including `ssd-steadystate.fio=EF=BF=BD, which might be
> useful for preconditioning of ssd devices.
>
> Regards,
>
> Juergen
>
> --
> GPG A997BA7A | 87FC DA31 5F00 C885 0DC3  E28F BD0D 4B33 A997 BA7A
