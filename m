Return-Path: <Elliott@hp.com>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: cpus_allowed per thread behavior
Date: Thu, 27 Feb 2014 01:12:48 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029548AB970@G9W0745.americas.hpqcorp.net>
References: <94D0CD8314A33A4D9D801C0FE68B4029548AB930@G9W0745.americas.hpqcorp.net>
 <530E81F6.7070305@kernel.dk>
In-Reply-To: <530E81F6.7070305@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Wednesday, 26 February, 2014 6:08 PM
> To: Elliott, Robert (Server Storage); fio@vger.kernel.org
> Subject: Re: cpus_allowed per thread behavior
>=20
> On 2014-02-26 15:54, Elliott, Robert (Server Storage) wrote:
> > fio seems to assign the same cpus_allowed/cpumask value to all threads.
>  > I think this allows the OS to move the threads around those CPUs.
>=20
> Correct. As long as the number of cpus in the mask is equal to (or
> larger than) the number of jobs within that group, the OS is free to
> place them wherever it wants. In practice, unless the CPU scheduling is
> horribly broken, they tend to "stick" for most intents and purposes.
>=20
> > In comparison, iometer assigns its worker threads to specific CPUs
>  > within the cpumask in round-robin manner.  Would that be worth adding
>  > to fio, perhaps with an option like cpus_allowed_policy=3Droundrobin?
>=20
> Sure, we could add that feature. You can get the same setup now, if you
> "unroll" the job section, but that might not always be practical. How
> about cpus_allowed_policy, with 'shared' being the existing (and
> default) behavior and 'split' being each thread grabbing one of the CPUs?

Perhaps NUMA and hyperthreading aware allocation policies would=20
also be useful?

I don't know how consistent hyperthread CPU numbering is across
systems.  On some servers I've tried, linux assigns 0-5 to the main=20
cores and 6-11 to the hyperthreaded siblings, while Windows assigns=20
0,2,4,6,8,10 to the main cores and 1,3,5,7,9,11 to their=20
hyperthreaded siblings. =20

Intel's OpenMP library offers two thread affinity types that might
be worth simulating:
COMPACT: pack them tightly
	foreach (node)
		foreach (core in the node)
			foreach (hyperthreaded sibling)

SCATTER: spread across all the cores
	foreach (hyperthreaded sibling)
		foreach (core sharing a node)
			foreach (node)

We could try:
cpus_allowed_policy=3Dshared
cpus_allowed_policy=3Dsplit  (round-robin, don't care how the
CPU IDs were assigned)
cpus_allowed_policy=3Dcompact (NUMA/HT aware)
cpus_allowed_policy=3Dscatter (NUMA/HT aware)



> --
> Jens Axboe


