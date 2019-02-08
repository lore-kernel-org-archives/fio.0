Return-Path: <fio-owner@vger.kernel.org>
Received: from forward501o.mail.yandex.net ([37.140.190.203]:56822 "EHLO
        forward501o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726230AbfBHLn5 (ORCPT
        <rfc822;fio@vger.kernel.org>); Fri, 8 Feb 2019 06:43:57 -0500
From: =?utf-8?B?0J/RgNC+0YXQvtGA0L7QsiDQkNC70LXQutGB0LDQvdC00YA=?= 
        <cauhuk@yandex.ru>
In-Reply-To: <CALjAwxg6-AJdvC3YJ0Nc8=BM31ZDa_nNBXG0_X+pOxN7R_FO2g@mail.gmail.com>
References: <48713691549531283@myt6-fe24916a5562.qloud-c.yandex.net> <CALjAwxg6-AJdvC3YJ0Nc8=BM31ZDa_nNBXG0_X+pOxN7R_FO2g@mail.gmail.com>
Subject: Re: slash problem windows
MIME-Version: 1.0
Date: Fri, 08 Feb 2019 14:36:21 +0300
Message-Id: <23524881549625781@sas2-a1efad875d04.qloud-c.yandex.net>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi, yep, i read this and did it, but have trouble and now i know why: Rules of windows  for NFS files: write, read - ok; rewrite - not acess) And readwrite operation worked only first cycle.
At first I thought that is problem with path, but not. 
Thank you for your answer and good program and goodluck!

07.02.2019, 21:06, "Sitsofe Wheeler" <sitsofe@gmail.com>:
> Hi there,
>
> On Thu, 7 Feb 2019 at 09:21, Прохоров Александр <cauhuk@yandex.ru> wrote:
>>  Hello!
>>  3) verison: fio-3.12 (exe, download from bluestop)
>>  2) Environment: Windows 10 professional x64 ver 1803
>>  4) steps to reproduce:
>>  4.1) download and unzip folder (path C: \ fio-3.12-x64)
>>  4.2) creat test "readi.fio" with text:
>>  [global]
>>  ioengine = windowsaio
>>  rw = readwrite
>>  size = 1g
>>  directory = I \: \
>>  thread = 1
>>  [trivial-readwrite-1g]
>>  4.3) launch test from powershell or cmd
>>  FIO created file, but after:
>>  trivial-readwrite-1g: Laying out IO file (1 file / 1024MiB)
>>  windowsaio: failed to open file "I: \ trivial-readwrite-1g.0.0"
>>  trivial-readwrite-1g: No I / O performed by windowsaio, perhaps try - debug = io option for details?
>>
>>  1) What i think about: it’s in windowsaio with the READWRITE command. Write operation or read operation are sucess. But reading after writing catch trouble with windows path slash
>>  Path with folders is failed too : directory = I\:\s\ -> windowsaio: failed to open file "I:\s/trivial-readwrite-1g.0.0"
>
> Have you seen the information in fio manual? There's a copy of it over
> on https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-filename
> ...
>
> --
> Sitsofe | http://sucs.org/~sits/

-- 


