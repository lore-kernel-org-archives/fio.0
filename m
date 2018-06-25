Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([96.73.9.1]:44584 "EHLO muon.bluestop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752444AbeFYDNC (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 24 Jun 2018 23:13:02 -0400
Subject: Re: FIO build broken on FreeBSD 11.1
References: <4b983c90-e07f-cd1f-abcb-65e23be8a102@bluestop.org>
 <CAHndrBndTLseKwcSfNoYZR4vspEqg5CLOGMuJoYaBpTa-EV2sw@mail.gmail.com>
From: Rebecca Cran <rebecca@bluestop.org>
Message-ID: <2ea16a72-00b7-0ac5-2df8-6330c5198842@bluestop.org>
Date: Sun, 24 Jun 2018 21:13:01 -0600
MIME-Version: 1.0
In-Reply-To: <CAHndrBndTLseKwcSfNoYZR4vspEqg5CLOGMuJoYaBpTa-EV2sw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Cc: fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

On 06/24/18 21:04, Tomohiro Kusumi wrote:
> Rebecca Cran <rebecca@bluestop.org>:
>>
>> The FIO build seems to be broken on FreeBSD:
> 
> It compiles on my environment.

Thanks - I'd forgotten about my attempts at creating a cross build
environment for MinGW64: deleting the symlinks for gcc etc. in ~/bin
fixed things!

-- 
Rebecca
