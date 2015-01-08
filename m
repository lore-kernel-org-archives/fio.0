Return-Path: <haghdoost@gmail.com>
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295A7299C7@G9W0745.americas.hpqcorp.net>
References: <54ADC21F.10207@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295A7299C7@G9W0745.americas.hpqcorp.net>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Thu, 8 Jan 2015 13:01:08 -0600
Message-ID: <CAB-428nTgzsdZEqX03dsrr-1PgCH3X1YgJByXVT3tjn8QtgzFg@mail.gmail.com>
Subject: Re: Non-uniform randomness with drifting
Content-Type: text/plain; charset=ISO-8859-1
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Thu, Jan 8, 2015 at 10:59 AM, Elliott, Robert (Server Storage)
<Elliott@hp.com> wrote:
> The new random_drift feature changes spatial locality over time (where
> time means % of data that has been accessed), so it provides some
> correlation control, but doesn't provide full temporal locality
> control.

Just to clarify, the temporal locality control that you are referring
to is more like burst control. You are not interested in a fixed IO
generation rate and interested to have dynamic IO rate changes. Is
that correct ?

