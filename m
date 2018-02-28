Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:40240 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbeB1HMG (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 28 Feb 2018 02:12:06 -0500
Received: by mail-ua0-f172.google.com with SMTP id c14so901801uak.7
        for <fio@vger.kernel.org>; Tue, 27 Feb 2018 23:12:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGfUJcHTNy4PgTNiGt8-xpYXwgyw59ud_12nLoGA3J9_9grJwg@mail.gmail.com>
References: <CAGfUJcHTNy4PgTNiGt8-xpYXwgyw59ud_12nLoGA3J9_9grJwg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 28 Feb 2018 07:11:33 +0000
Message-ID: <CALjAwxg8V5HUs--Qxbku1TOhXaBkJ--4zFrQgAMBE-YfvVwsPQ@mail.gmail.com>
Subject: Re: question regarding queue depths and workers
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jared Walton <jawalking@gmail.com>
Cc: fio <fio@vger.kernel.org>

On 28 February 2018 at 00:23, Jared Walton <jawalking@gmail.com> wrote:
> If I correctly understand how fio spawns workers then: it takes the
> given queue depth and splits it among workers such that a queue depth
> of 32 with 16 workers results in 16 workers each maintaining a queue
> depth of 2...

I'm afraid this is incorrect. If I have something like

[global]
filename=/dev/nullb0
iodepth=32
ioengine=libaio
direct=1

[worker]
numjobs=16
rw=read

Each worker is trying to achieve a depth of 32 so if they are all
running simultaneously etc. they will generate a total depth of 512 (32 * 16).

> But what happens when a queue depth of 16 is specified with 32 workers?

In this case each worker is trying to achieve a depth of 16 so if all 32
are running simultaneously etc. they will still generate a total depth
of 512.

-- 
Sitsofe | http://sucs.org/~sits/
