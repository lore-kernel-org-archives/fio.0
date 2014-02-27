Return-Path: <axboe@kernel.dk>
Message-ID: <530E81F6.7070305@kernel.dk>
Date: Wed, 26 Feb 2014 16:08:22 -0800
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: cpus_allowed per thread behavior
References: <94D0CD8314A33A4D9D801C0FE68B4029548AB930@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029548AB930@G9W0745.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-02-26 15:54, Elliott, Robert (Server Storage) wrote:
> fio seems to assign the same cpus_allowed/cpumask value to all threads.
 > I think this allows the OS to move the threads around those CPUs.

Correct. As long as the number of cpus in the mask is equal to (or 
larger than) the number of jobs within that group, the OS is free to 
place them wherever it wants. In practice, unless the CPU scheduling is 
horribly broken, they tend to "stick" for most intents and purposes.

> In comparison, iometer assigns its worker threads to specific CPUs
 > within the cpumask in round-robin manner.  Would that be worth adding
 > to fio, perhaps with an option like cpus_allowed_policy=roundrobin?

Sure, we could add that feature. You can get the same setup now, if you 
"unroll" the job section, but that might not always be practical. How 
about cpus_allowed_policy, with 'shared' being the existing (and 
default) behavior and 'split' being each thread grabbing one of the CPUs?

-- 
Jens Axboe


