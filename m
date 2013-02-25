Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:46105 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3BYGzg (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 25 Feb 2013 01:55:36 -0500
Received: by mail-vc0-f180.google.com with SMTP id fo13so1550775vcb.11
        for <fio@vger.kernel.org>; Sun, 24 Feb 2013 22:55:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACTzACXjqA8U8rX8_Da-7-HE-chhf=Y7251Km8Qkm+z=9Aqh4g@mail.gmail.com>
References: <CACTzACXjqA8U8rX8_Da-7-HE-chhf=Y7251Km8Qkm+z=9Aqh4g@mail.gmail.com>
Date: Mon, 25 Feb 2013 17:55:35 +1100
Message-ID: <CAKCZDg=vYbKRZkMNeeFA3thYBEQC0EnNPj12iaAHB00qFY07Hg@mail.gmail.com>
Subject: Re: FIO process priority issue
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: David N <android.wm.edu@gmail.com>
Cc: fio@vger.kernel.org

On 25 February 2013 16:48, David N <android.wm.edu@gmail.com> wrote:
> Hi,
>
> I'm trying to run a reader process and writer process and give higher
> priority to the reader.
> I ran into an issue below. Am I missing something?
>
> Thanks in advance for your inputs!
> David
>
> root@android:/sdcard/tmp # fio random-readwrite2-test.fio
> Bad option <prioclass=2>

Hi David,

It's because the Android NDK does not support I/O priorities.
Specifically, the bionic (Android's libc) side is missing.  Generally
speaking it's not too hard to get them going if you define the right
function prototypes and constants.  See os/os-android.h for some
examples.

    -- Aaron
