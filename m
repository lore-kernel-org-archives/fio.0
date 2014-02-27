Return-Path: <axboe@kernel.dk>
Message-ID: <530F719B.4020205@kernel.dk>
Date: Thu, 27 Feb 2014 09:10:51 -0800
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: cpus_allowed per thread behavior
References: <94D0CD8314A33A4D9D801C0FE68B4029548AB930@G9W0745.americas.hpqcorp.net> <530E81F6.7070305@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B4029548AB970@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029548AB970@G9W0745.americas.hpqcorp.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-02-26 17:12, Elliott, Robert (Server Storage) wrote:
>> -----Original Message-----
>> From: Jens Axboe [mailto:axboe@kernel.dk]
>> Sent: Wednesday, 26 February, 2014 6:08 PM
>> To: Elliott, Robert (Server Storage); fio@vger.kernel.org
>> Subject: Re: cpus_allowed per thread behavior
>>
>> On 2014-02-26 15:54, Elliott, Robert (Server Storage) wrote:
>>> fio seems to assign the same cpus_allowed/cpumask value to all threads.
>>   > I think this allows the OS to move the threads around those CPUs.
>>
>> Correct. As long as the number of cpus in the mask is equal to (or
>> larger than) the number of jobs within that group, the OS is free to
>> place them wherever it wants. In practice, unless the CPU scheduling is
>> horribly broken, they tend to "stick" for most intents and purposes.
>>
>>> In comparison, iometer assigns its worker threads to specific CPUs
>>   > within the cpumask in round-robin manner.  Would that be worth adding
>>   > to fio, perhaps with an option like cpus_allowed_policy=roundrobin?
>>
>> Sure, we could add that feature. You can get the same setup now, if you
>> "unroll" the job section, but that might not always be practical. How
>> about cpus_allowed_policy, with 'shared' being the existing (and
>> default) behavior and 'split' being each thread grabbing one of the CPUs?
>
> Perhaps NUMA and hyperthreading aware allocation policies would
> also be useful?
>
> I don't know how consistent hyperthread CPU numbering is across
> systems.  On some servers I've tried, linux assigns 0-5 to the main
> cores and 6-11 to the hyperthreaded siblings, while Windows assigns
> 0,2,4,6,8,10 to the main cores and 1,3,5,7,9,11 to their
> hyperthreaded siblings.

Linux follows the firmware on that, at least as far as I know. I've seen 
machines renumber when getting a new firmware, going from the second 
scheme you list to the first. But for the below, we cannot assume any of 
them, on some machines you also have > 2 threads per core. So the 
topology would have to be queried.
>
> Intel's OpenMP library offers two thread affinity types that might
> be worth simulating:
> COMPACT: pack them tightly
> 	foreach (node)
> 		foreach (core in the node)
> 			foreach (hyperthreaded sibling)
>
> SCATTER: spread across all the cores
> 	foreach (hyperthreaded sibling)
> 		foreach (core sharing a node)
> 			foreach (node)
>
> We could try:
> cpus_allowed_policy=shared
> cpus_allowed_policy=split  (round-robin, don't care how the
> CPU IDs were assigned)
> cpus_allowed_policy=compact (NUMA/HT aware)
> cpus_allowed_policy=scatter (NUMA/HT aware)

That would definitely be useful, but also requires writing the code to 
understand the topology of the machine.

-- 
Jens Axboe


