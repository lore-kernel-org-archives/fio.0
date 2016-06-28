Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:35080 "EHLO
	mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbcF1FQk (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 28 Jun 2016 01:16:40 -0400
Received: by mail-vk0-f48.google.com with SMTP id j2so7460022vkg.2
        for <fio@vger.kernel.org>; Mon, 27 Jun 2016 22:16:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOkRmkmnoHqBoKP2VYiY9LLJYfADK6moZdK_t1VOedDd670Aeg@mail.gmail.com>
References: <CAOkRmkmnoHqBoKP2VYiY9LLJYfADK6moZdK_t1VOedDd670Aeg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 28 Jun 2016 06:16:39 +0100
Message-ID: <CALjAwxhCyuRf-JO8P3Cm+Emk7E_VXBqN1f+4+QhqHpgd6LHHVA@mail.gmail.com>
Subject: Re: Compression options in fio
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Srinath Krishna Ananthakrishnan <ska@datera.io>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 27 June 2016 at 21:41, Srinath Krishna Ananthakrishnan <ska@datera.io> wrote:
>
> [small_write]
> rw=rw
> blocksize=4k
> size=100M
> verify=crc32c-intel
> buffer_compress_percentage=50
> buffer_pattern="abcd"
>
> With this, I don't see fio generating compressible data with the
> pattern and still reverts to generating random data. Anything I'm
> missing?

You're forcing the pattern of data that must be used via
buffer_pattern so you aren't you taking away the ability for fio to
vary the data? Do you get a different result if you don't specify
buffer_pattern ?

-- 
Sitsofe | http://sucs.org/~sits/
