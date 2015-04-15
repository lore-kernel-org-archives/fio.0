Return-Path: <dehrenberg@google.com>
MIME-Version: 1.0
In-Reply-To: <552EBC50.6060901@kernel.dk>
References: <1429052300-9822-1-git-send-email-dehrenberg@chromium.org>
	<1429052300-9822-3-git-send-email-dehrenberg@chromium.org>
	<552DB434.2060709@kernel.dk>
	<CAAK6Zt27UwQrKiqLf_DEAsUsMKrUYPSdSASBoE0q-yQ8wizwMg@mail.gmail.com>
	<552EBC50.6060901@kernel.dk>
Date: Wed, 15 Apr 2015 13:28:58 -0700
Message-ID: <CAAK6Zt2sFu3ehYD9NHBYqXt-KrX1z4OAm4=kY73qwzMK-K-Fng@mail.gmail.com>
Subject: Re: [PATCH 2/7] Add new writetrim rw= mode for trims preceding writes
From: Daniel Ehrenberg <dehrenberg@google.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Gwendal Grignou <gwendal@chromium.org>
List-ID: <fio@vger.kernel.org>

Other changes were not really core, just these little things:
- I deleted " (Linux block devices only)" from the description of the
trim and randtrim modes
- I copied the trim and randtrim docs into the HOWTO from the manpage

Your description of trimwrite sounds good to me.

On Wed, Apr 15, 2015 at 12:30 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 04/15/2015 11:49 AM, Daniel Ehrenberg wrote:
>>
>> Thanks for the quick feedback. This should be fixed in v2. What do you
>> think?
>
>
> I didn't find any other issues in the previous posting, so I added the doc
> bits and changed the writetrim to trimwrite. Any other differences between
> master and your v2 posting? If so, separate them out and send it in and I'll
> get it applied.
>
> --
> Jens Axboe
>

