Return-Path: <axboe@kernel.dk>
Message-ID: <552ED1E4.2020705@kernel.dk>
Date: Wed, 15 Apr 2015 15:02:28 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH 2/7] Add new writetrim rw= mode for trims preceding writes
References: <1429052300-9822-1-git-send-email-dehrenberg@chromium.org>	<1429052300-9822-3-git-send-email-dehrenberg@chromium.org>	<552DB434.2060709@kernel.dk>	<CAAK6Zt27UwQrKiqLf_DEAsUsMKrUYPSdSASBoE0q-yQ8wizwMg@mail.gmail.com>	<552EBC50.6060901@kernel.dk> <CAAK6Zt2sFu3ehYD9NHBYqXt-KrX1z4OAm4=kY73qwzMK-K-Fng@mail.gmail.com>
In-Reply-To: <CAAK6Zt2sFu3ehYD9NHBYqXt-KrX1z4OAm4=kY73qwzMK-K-Fng@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Daniel Ehrenberg <dehrenberg@google.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Gwendal Grignou <gwendal@chromium.org>
List-ID: <fio@vger.kernel.org>

On 04/15/2015 02:28 PM, Daniel Ehrenberg wrote:
> Other changes were not really core, just these little things:
> - I deleted " (Linux block devices only)" from the description of the
> trim and randtrim modes
> - I copied the trim and randtrim docs into the HOWTO from the manpage
>
> Your description of trimwrite sounds good to me.

OK, close enough I think. As usual, feel free to send updates, of course.

-- 
Jens Axboe


