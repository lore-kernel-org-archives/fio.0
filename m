Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <CAEUMAOdm1Ok0Wz6Tgh6ppveeYmDgHYPCHXT-KX2eU7pLBF03kQ@mail.gmail.com>
 <971767c6-655e-e6d9-f419-8cc1f7b6dbd4@kernel.dk>
In-Reply-To: <971767c6-655e-e6d9-f419-8cc1f7b6dbd4@kernel.dk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 29 Nov 2019 08:07:09 +0000
Message-ID: <CALjAwxhq+uLqJZbbzqJUTUuah4ijdwKvHo+Qhfsxoo55yxei8g@mail.gmail.com>
Subject: Re: How to cross compile fio for Android
Content-Type: text/plain; charset="UTF-8"
To: Mao Chenxi <chenxi.mao2013@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On Thu, 28 Nov 2019 at 00:19, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 11/27/19 5:03 PM, Mao Chenxi wrote:
> > Hi Axboe:
> >
> > Sorry to bother you, I would like to inverage latest fio on android.
> > I saw the android should be supported by fio by default.
> > But I didn't compile it successfully.
> > Would you please let me know how to build a fio for android?

Assuming you have a working Android toolchain (getting that is beyond
the scope of this list) you can use
UNAME=Android CROSS_COMPILE=<path/to/toolchain/bin/arm-linux-androideabi-
CC=path/to/toolchain/bin/arm-linux-androideabi-clang ./configure
and then the usual make should work (you can see
https://www.spinics.net/lists/fio/msg01604.html for a different line).


--
Sitsofe | http://sucs.org/~sits/

