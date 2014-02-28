Return-Path: <Elliott@hp.com>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: cpus_allowed per thread behavior
Date: Fri, 28 Feb 2014 22:35:49 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029548AC58C@G9W0745.americas.hpqcorp.net>
References: <94D0CD8314A33A4D9D801C0FE68B4029548AB930@G9W0745.americas.hpqcorp.net>
 <530E81F6.7070305@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B4029548AB970@G9W0745.americas.hpqcorp.net>
 <530F719B.4020205@kernel.dk>
In-Reply-To: <530F719B.4020205@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

FYI, with the old cpus_allowed_policy=3Dshared mode, the fio threads are in=
deed moving around quite a lot on linux.

Printing the thread or process ID (LWP from ps), current CPU (PSR from ps),=
 and the thread affinity mask (from taskset --pid) for each thread while ru=
nning with the old policy:
11429 currently on 9: pid 11429's current affinity mask: fff
11430 currently on 8: pid 11430's current affinity mask: fff
11432 currently on 5: pid 11432's current affinity mask: ff
11433 currently on 1: pid 11433's current affinity mask: ff
11434 currently on 2: pid 11434's current affinity mask: ff
11435 currently on 6: pid 11435's current affinity mask: ff
11436 currently on 4: pid 11436's current affinity mask: ff
11437 currently on 3: pid 11437's current affinity mask: ff
11438 currently on 7: pid 11438's current affinity mask: ff
11439 currently on 0: pid 11439's current affinity mask: ff

11429 currently on 9: pid 11429's current affinity mask: fff
11430 currently on 8: pid 11430's current affinity mask: fff
11432 currently on 3: pid 11432's current affinity mask: ff
11433 currently on 6: pid 11433's current affinity mask: ff
11434 currently on 1: pid 11434's current affinity mask: ff
11435 currently on 7: pid 11435's current affinity mask: ff
11436 currently on 4: pid 11436's current affinity mask: ff
11437 currently on 2: pid 11437's current affinity mask: ff
11438 currently on 0: pid 11438's current affinity mask: ff
11439 currently on 5: pid 11439's current affinity mask: ff

11429 currently on 9: pid 11429's current affinity mask: fff
11430 currently on 8: pid 11430's current affinity mask: fff
11432 currently on 2: pid 11432's current affinity mask: ff
11433 currently on 4: pid 11433's current affinity mask: ff
11434 currently on 7: pid 11434's current affinity mask: ff
11435 currently on 0: pid 11435's current affinity mask: ff
11436 currently on 1: pid 11436's current affinity mask: ff
11437 currently on 5: pid 11437's current affinity mask: ff
11438 currently on 3: pid 11438's current affinity mask: ff
11439 currently on 6: pid 11439's current affinity mask: ff

With the new cpus_allowed_policy=3Dsplit they stay put:
11649 currently on 2: pid 11649's current affinity mask: fff
11650 currently on 9: pid 11650's current affinity mask: fff
11653 currently on 0: pid 11653's current affinity mask: 1
11654 currently on 1: pid 11654's current affinity mask: 2
11655 currently on 2: pid 11655's current affinity mask: 4
11656 currently on 3: pid 11656's current affinity mask: 8
11657 currently on 4: pid 11657's current affinity mask: 10
11658 currently on 5: pid 11658's current affinity mask: 20
11659 currently on 6: pid 11659's current affinity mask: 40
11660 currently on 7: pid 11660's current affinity mask: 80

11649 currently on 10: pid 11649's current affinity mask: fff
11650 currently on 9: pid 11650's current affinity mask: fff
11653 currently on 0: pid 11653's current affinity mask: 1
11654 currently on 1: pid 11654's current affinity mask: 2
11655 currently on 2: pid 11655's current affinity mask: 4
11656 currently on 3: pid 11656's current affinity mask: 8
11657 currently on 4: pid 11657's current affinity mask: 10
11658 currently on 5: pid 11658's current affinity mask: 20
11659 currently on 6: pid 11659's current affinity mask: 40
11660 currently on 7: pid 11660's current affinity mask: 80

On one particular test, this repeatedly boosts 810K IOPS to 820K IOPS.

---
Rob Elliott    HP Server Storage


