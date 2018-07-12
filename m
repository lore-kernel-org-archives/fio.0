Return-Path: <axboe@kernel.dk>
Subject: Re: fio serialize across jobs
References: <MWHPR04MB0320ED986E73B1E9994929B38F470@MWHPR04MB0320.namprd04.prod.outlook.com>
 <CALjAwxiTqn3U2vnOOCV1CZ3BkzXQ_KUaHK3wjw1WsbT5zg33rg@mail.gmail.com>
 <MWHPR04MB0320201F570BDAC2EB3A46DD8F440@MWHPR04MB0320.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <48d5448e-de1b-09cd-1abf-6549e65fd097@kernel.dk>
Date: Thu, 12 Jul 2018 11:13:01 -0600
MIME-Version: 1.0
In-Reply-To: <MWHPR04MB0320201F570BDAC2EB3A46DD8F440@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: Jeff Furlong <jeff.furlong@wdc.com>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

General comments on this... Fio does have a notion of having multiple
workers per state, most notably for the offload IO model (io_submit_mode).
That would make ethe most sense to utilize for something like this,
rather than having independent jobs that need to share basically everything.
You end up with a rather large rework, only to arrive at what the offload
IO model can already do.


On 7/9/18 11:58 AM, Jeff Furlong wrote:
> What if we limited the jobs to 2 and limited the second job's QD to 1?  Might that limit the locking overhead?
> 
> Regards,
> Jeff
> 
> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com] 
> Sent: Friday, July 6, 2018 9:23 PM
> To: Jeff Furlong <jeff.furlong@wdc.com>
> Cc: fio@vger.kernel.org
> Subject: Re: fio serialize across jobs
> 
> Hi,
> 
> On 6 July 2018 at 23:14, Jeff Furlong <jeff.furlong@wdc.com> wrote:
>> Hi All,
>> Back in commit 997b5680d139ce82c2034ba3a0d602cfd778b89b "fio: add serialize_overlap option" the feature was added to prevent write/trim race conditions within the queue.  Can this feature be applied to multiple jobs?  Consider:
>>
>> fio --ioengine=libaio --direct=1  --filename=/dev/nvme0n1 --time_based 
>> --name=test1 --rw=randwrite --runtime=5s --name=test2 --rw=randwrite 
>> --runtime=5s --serialize_overlap=1
>>
>> Would we have to call in_flight_overlap() in a loop with all thread data pointers?
> 
> It would be a be more work (the original serialize_overlap was fiddly to make correct but was easy to get going) but I can see why you might want what you describe. The big problem is that I can't see how you can do it without introducing a large amount of locking into the fio's I/O path. I think this would also border on a feature that diskspd has where multiple threads can do I/O to a single file but they all share a randommap...
> 
> --
> Sitsofe | http://sucs.org/~sits/
> N�����r��y���b�X��ǧv�^�)޺{.n�+���������ܨ}���Ơz�&j:+v�������zZ+��+zf���h���~����i���z��w���?����&�)ߢfl===
> 


-- 
Jens Axboe


