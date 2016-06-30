Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:35629 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbcF3R6R (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 30 Jun 2016 13:58:17 -0400
Received: by mail-lf0-f51.google.com with SMTP id l188so61006643lfe.2
        for <fio@vger.kernel.org>; Thu, 30 Jun 2016 10:58:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxhCyuRf-JO8P3Cm+Emk7E_VXBqN1f+4+QhqHpgd6LHHVA@mail.gmail.com>
References: <CAOkRmkmnoHqBoKP2VYiY9LLJYfADK6moZdK_t1VOedDd670Aeg@mail.gmail.com>
 <CALjAwxhCyuRf-JO8P3Cm+Emk7E_VXBqN1f+4+QhqHpgd6LHHVA@mail.gmail.com>
From: Srinath Krishna Ananthakrishnan <ska@datera.io>
Date: Thu, 30 Jun 2016 10:58:00 -0700
Message-ID: <CAOkRmkkeB8b7338VtNCeOAuKmaHfdFi7tFD0Czox3T1nDRu4Gw@mail.gmail.com>
Subject: Re: Compression options in fio
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

I don't want fio to vary the data and need it to be more deterministic.

After playing with it for quite some time, I have the following
(inconclusive) theory.

1. If no verify options are set, fio generates
buffer_compress_percentage worth of compressible data per block size.
Compressible data is always zeroed out.
2. With verify options, fio generates buffer_compress_percentage worth
of compressible data (zeroes) for some blocks but there are these
bunch of blocks from time to time that contain purely random data.

From the manual, verify options add additional meta data to the header
of every block for verification but I'm not sure why some blocks turn
out to be completely random with this setting on. I tried multiple
verify hashes with the same result.

With either of the cases, I don't seem to get the buffer_pattern
setting working.


Thanks,
Srinath


On Mon, Jun 27, 2016 at 10:16 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> On 27 June 2016 at 21:41, Srinath Krishna Ananthakrishnan <ska@datera.io> wrote:
>>
>> [small_write]
>> rw=rw
>> blocksize=4k
>> size=100M
>> verify=crc32c-intel
>> buffer_compress_percentage=50
>> buffer_pattern="abcd"
>>
>> With this, I don't see fio generating compressible data with the
>> pattern and still reverts to generating random data. Anything I'm
>> missing?
>
> You're forcing the pattern of data that must be used via
> buffer_pattern so you aren't you taking away the ability for fio to
> vary the data? Do you get a different result if you don't specify
> buffer_pattern ?
>
> --
> Sitsofe | http://sucs.org/~sits/
