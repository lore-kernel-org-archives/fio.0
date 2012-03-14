Return-Path: <dehrenberg@google.com>
MIME-Version: 1.0
Date: Tue, 13 Mar 2012 19:13:52 -0700
Message-ID: <CAAK6Zt1gYYr4qoUQPnMBvNWzD7wV3kkKqfrFMp5uJatr-tC2+A@mail.gmail.com>
Subject: Parsing numbers and arithmetic expressions in fio
From: Daniel Ehrenberg <dehrenberg@google.com>
Content-Type: text/plain; charset=ISO-8859-1
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Nauman Rafique <nauman@google.com>, Eric Gouriou <egouriou@google.com>
List-ID: <fio@vger.kernel.org>

Hi Jens,

I'm trying to write an fio control file which will have several
threads, each writing to disjoint portions of a device. The size of
the portion of the device that the thread controls is determined by an
environment variable, for example "export SIZE=1g". The control file
looks something like this:

[global]
size=${SIZE}
filename=/dev/my-device

[job1]
offset=0

[job2]
offset=${SIZE}

[job3]
offset=2*${SIZE}

Unfortunately, this doesn't work with the current version of fio. It
appears that arithmetic expressions are only evaluated when a keyword
($pagesize, $mb_memory or $ncpus) is included. Further, the
expressions are evaluated by bc, which wouldn't understand "1g", so it
wouldn't work to just add a call to bc_calc in str_to_decimal.

What's the recommended way to do this? Alternatively, what do you
think would be the minimal thing to add to fio to achieve this effect?
One option is to add a new set of fio options to set up this
particular scenario--offsets that increment by an offset.
Alternatively, a mechanism to make new keywords globally would work,
if I could just make the size a keyword (or maybe all options could
implicitly be keywords?). What do you think?

Thanks,
Dan

