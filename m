Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:34630 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752746AbdDJUbR (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 10 Apr 2017 16:31:17 -0400
Received: by mail-vk0-f53.google.com with SMTP id z204so102521793vkd.1
        for <fio@vger.kernel.org>; Mon, 10 Apr 2017 13:31:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <72a0d7083a3e46b4a4369c19d73c62fc@bowex36b.micron.com>
References: <72a0d7083a3e46b4a4369c19d73c62fc@bowex36b.micron.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 10 Apr 2017 21:30:46 +0100
Message-ID: <CALjAwxgBDhiG2fftHGyDJUhEn=CAVGN_YsykttSbk-NoTUXHWw@mail.gmail.com>
Subject: Re: Adding IO engine
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Deyoung Hong (dhong)" <dhong@micron.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 10 April 2017 at 18:45, Deyoung Hong (dhong) <dhong@micron.com> wrote:
>
> I have a couple basic questions:
>
> 1)  If I want to submit a new IO engine with fio and it has a dependency =
on an external library, how does that work when fio is compiled?  Please al=
so point me to info how to submit a new IO engine to be packaged with fio?

Normally you check for the dependencies in ./configure and only output
a symbol if the requirements for compiling a test program are all
satisfied. A common trend is to add a --disable-* flag to ensure your
engine is not built even if all its dependencies are available. You
can then check for the symbol in a variety of places in the code and
in the Makefile to decide what to build and when. When submitting a
new engine it is also important to submit documentation about the
engine to at least the HOWTO and include an example jobfile that
demonstrates how to use the IO engine. An example of a recently merged
IO engine can be found over on https://github.com/axboe/fio/pull/243 .
Other IO engines that aren't that old are engines/pmemblk.c and
engines/dev-dax.c ,

> 2)  I've seen cases where the ->iomem_alloc() function (i.e. for a custom=
 IO engine) is invoked first by fio before ->get_file_size() or ->setup(). =
 This causes an issue since IO memory allocation can have dependency on cer=
tain initialization (for the custom IO engine) that is done in ->get_file_s=
ize().   I just wonder if that's an fio bug or how it should be?   My curre=
nt work around is to check in ->iomem_alloc() each time and do initializion=
 first if has not.

Perhaps you could do it in ->io_u_init() ?

--=20
Sitsofe | http://sucs.org/~sits/
