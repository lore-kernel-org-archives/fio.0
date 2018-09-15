Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vs1-f43.google.com ([209.85.217.43]:42662 "EHLO
        mail-vs1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbeIOMDj (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 15 Sep 2018 08:03:39 -0400
Received: by mail-vs1-f43.google.com with SMTP id s188-v6so1216850vss.9
        for <fio@vger.kernel.org>; Fri, 14 Sep 2018 23:45:46 -0700 (PDT)
MIME-Version: 1.0
References: <MWHPR04MB03200B9A3B77890750357EB78F310@MWHPR04MB0320.namprd04.prod.outlook.com>
 <CALjAwxguL+iPXpBPG0N4DWyR5ShO1=Wtt9RyyGiRgtSp-qMi7A@mail.gmail.com>
In-Reply-To: <CALjAwxguL+iPXpBPG0N4DWyR5ShO1=Wtt9RyyGiRgtSp-qMi7A@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 15 Sep 2018 07:45:19 +0100
Message-ID: <CALjAwxg3kDAKRv6zbhpz+KWkhPdjxPcNg-eoLHL0HRPFhxHvrQ@mail.gmail.com>
Subject: Re: Windows make errors on http
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: fio <fio@vger.kernel.org>

On Wed, 22 Aug 2018 at 21:38, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> Hi,
>
> On Tue, 21 Aug 2018 at 23:07, Jeff Furlong <jeff.furlong@wdc.com> wrote:
>>
>> Hi All,
>> It seems the latest git is broken for Windows builds:
>>
>> engines/http.o: In function 'fio_http_cleanup':
>> http.c:438: undefined reference to '__imp_curl_easy_cleanup'
>> ...
>
>
> I wonder how this managed to sneak by CI (https://ci.appveyor.com/project=
/axboe/fio/build/1.0.811/job/1hhta2403gwjobna )? Just to check: if you do a=
 make clean; ./configure && make you still get the same error? Does configu=
re say the "http engine" is enabled and do you have libcurl headers install=
ed under Cygwin?

I've had a chance to dig into this over on
https://github.com/axboe/fio/issues/683 . Does the pull request
mentioned there help?

--=20
Sitsofe | http://sucs.org/~sits/

