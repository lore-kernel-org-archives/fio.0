Return-Path: <grundler@google.com>
MIME-Version: 1.0
Date: Wed, 31 Jul 2013 13:32:38 -0700
Message-ID: <CANEJEGsMAS3uYtQx04bq8mPcdnhtXaVwg=vS=TgcY97d2kQeqw@mail.gmail.com>
Subject: FIO and Storage Data Integrity testing
From: Grant Grundler <grundler@google.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Juan Casse <jcasse@google.com>, FIO_list <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi Jens!

My summer intern (Juan Casse) is working on a data integrity/retention
test and has the first prototype running. (Juan might follow up with a
gerrit code review for the first cut)

The goals of this data integrity test:
o GPL implementation I can give to storage vendors as part of HW Qual test
o verify data written to storage is available and correct
o log writes (save a map) so we can repeatedly verify writes at a
later date (weeks or months later)
o provide some "bread crumbs" for debugging when data is NOT correct.
   (Not available typically will result in reported errors)
o work on any block storage device (ie no knowledge of specific device
geometry or flash vs magnetic vs optical or removable vs built-in -
some 'workloads' might be geared for specific types of storage)

o specify workload the same way fio does (multi-threaded, async,
random vs seq, read vs write mix, etc)
o collect same performance statistics that fio does (latency
histograms in particular)
o be done in < 6 weeks by a full time intern. :)

It seems like he should be doing something with fio.  I saw this query
in the Fio mailing list archive but didn't see a response:
   http://www.spinics.net/lists/fio/msg01933.html

Since these are destructive tests, I expect the primary target
"audience" is anyone working on Storage HW or wants to confirm Storage
HW is operating correctly before deploying $$$ worth of HW.

Questions:
1) You know anyone else developing data integrity/retention testing with fio?

2) Other good open source data integrity test I should know about?
Both Juan and I looked and didn't find anything better than
"badblocks". As a first exercise, Juan has written an autotest for
badblocks on ChromeOS:
   https://gerrit.chromium.org/gerrit/#/c/61786/

3) You have a preference on how this might be implemented if (a) we
used code from OR (b) integrated this functionality into fio?

(2) is probably a longer answer - refactor vs integrate is a good
first answer for now. :)

thanks,
grant

