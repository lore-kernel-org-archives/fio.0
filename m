Return-Path: <fio-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.197]:57827 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727480AbeI0XCK (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Sep 2018 19:02:10 -0400
From: <eliezer@integritech.solutions>
References: <000001d455b9$6e4e6850$4aeb38f0$@integritech.solutions> <CALjAwxiUCAsmXC7xx4QLS+zfz0k6erdbgd89nYbJNp9KtfhruA@mail.gmail.com>
In-Reply-To: <CALjAwxiUCAsmXC7xx4QLS+zfz0k6erdbgd89nYbJNp9KtfhruA@mail.gmail.com>
Subject: RE: Resending: fio testing on S3 object storage
Date: Thu, 27 Sep 2018 11:43:00 -0500
Message-ID: <000901d45681$27887050$769950f0$@integritech.solutions>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-us
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 'Sitsofe Wheeler' <sitsofe@gmail.com>, 'Samuel Shapiro' <samuel.sh79@gmail.com>
Cc: 'fio' <fio@vger.kernel.org>

Thank you Sitsofe and Samuel for the response.

Per your suggestion, I installed the following packages on my RH 7.5:

openssl
openssl-devel
curl-devel

Then I downloaded the latest fio source and compiled it.

Now, I'm seeing the "http" engine listed:

# fio --enghelp
Available IO engines:
        cpuio
        mmap
        sync
        psync
        vsync
        pvsync
        pvsync2
        null
        net
        netsplice
        ftruncate
        filecreate
        posixaio
        falloc
        e4defrag
        splice
>>    http  <<
        mtd
        sg


Many thanks!

Do you have some examples of fio benchmark params for object storage that you could share?


Regards,
Eliezer


-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Sitsofe Wheeler
Sent: Thursday, September 27, 2018 8:18 AM
To: eliezer@integritech.solutions
Cc: fio
Subject: Re: Resending: fio testing on S3 object storage

Hi,

You
On Wed, 26 Sep 2018 at 17:54, <eliezer@integritech.solutions> wrote:
>
> It looks like I don’t have the "http" ioengine on my server:
>
> # fio --enghelp
> Available IO engines:
>         cpuio
>         mmap
>         sync
>         psync
>         vsync
>         pvsync
>         pvsync2
>         null
>         net
>         netsplice
>         ftruncate
>         libaio
>         rdma
>         posixaio
>         falloc
>         e4defrag
>         splice
>         rbd
>         mtd
>         pmemblk
>         dev-dax
>         sg
>         binject

You need to have the appropriate dependencies available when you go to
compile fio (you'll find that ./configure says that http is enabled).
I believe for the http engine you need the development libraries for
curl and openssl installed...

-- 
Sitsofe | http://sucs.org/~sits/


